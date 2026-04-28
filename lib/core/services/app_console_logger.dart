// lib/services/app_console_logger.dart
//
// 🚀 AppConsoleLogger v3.2 — Auto-version from Supabase
// - Récupère automatiquement la version depuis `public.app_meta` (key = 'app_version')
// - Console colorée + batching + flush + retry + hooks Flutter/Zone
// - Écrit dans `public.app_logs` avec enrichissement complet du contexte
//
// Dépendances :
//   supabase_flutter, device_info_plus

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AppConsoleLogger {
  AppConsoleLogger._();

  static SupabaseClient get _sb => Supabase.instance.client;

  // --- Contexte global
  static String screen = '';
  static String route = '';
  static String appEnv = 'production';
  static String appVersion = 'unknown';
  static String buildNumber = '1';
  static String sessionId = DateTime.now().millisecondsSinceEpoch.toString();

  // --- Device info
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static String _platform = 'unknown';
  static String _deviceModel = 'unknown';
  static String _osVersion = '';
  static bool _deviceLoaded = false;

  // --- Buffer
  static final List<_QueuedLog> _buffer = <_QueuedLog>[];
  static int _batchSize = 25;
  static int _maxBuffer = 500;
  static Duration _flushEvery = const Duration(seconds: 5);
  static Timer? _timer;
  static bool _flushing = false;
  static bool _initialized = false;

  static const int _maxRetries = 5;

  /// Initialise le logger
  static Future<void> init({
    String env = 'production',
    bool initHooks = true,
    int batchSize = 25,
    Duration flushEvery = const Duration(seconds: 5),
    int maxBuffer = 500,
  }) async {
    if (_initialized) return;
    _initialized = true;

    appEnv = env;
    _batchSize = batchSize;
    _flushEvery = flushEvery;
    _maxBuffer = maxBuffer;

    // Charge les infos device
    unawaited(_loadDeviceInfo());

    // Charge la version d'app depuis Supabase
    unawaited(_loadAppVersionFromMeta());

    // Timer de flush
    _timer?.cancel();
    _timer = Timer.periodic(_flushEvery, (_) => _flush());

    if (initHooks) _installErrorHooks();

    unawaited(info('logger:init', message: 'v3.2 ready (auto-version)'));
  }

  /// Lecture automatique de la version dans `public.app_meta`
  static Future<void> _loadAppVersionFromMeta() async {
    try {
      final res = await _sb
          .from('app_meta')
          .select('value')
          .eq('key', 'app_version')
          .maybeSingle();
      if (res != null && res['value'] != null) {
        appVersion = res['value'].toString();
      } else {
        appVersion = 'unknown';
      }
      _printColored('[COP’IQ][LOGGER] app_version = $appVersion', _Ansi.cyan);
    } catch (e) {
      _printColored(
        '[COP’IQ][LOGGER] failed to load app_version: $e',
        _Ansi.yellow,
      );
    }
  }

  /// Contexte d’écran
  static void setScreenContext({
    required String screenName,
    String? routeName,
  }) {
    screen = screenName;
    if (routeName != null) route = routeName;
  }

  // --------------------------- API ---------------------------------

  static Future<void> debug(
    String event, {
    String? message,
    Map<String, dynamic>? context,
  }) => _log(level: 'debug', event: event, message: message, context: context);

  static Future<void> info(
    String event, {
    String? message,
    Map<String, dynamic>? context,
  }) => _log(level: 'info', event: event, message: message, context: context);

  static Future<void> success(
    String event, {
    String? message,
    Map<String, dynamic>? context,
  }) =>
      _log(level: 'success', event: event, message: message, context: context);

  static Future<void> warn(
    String event, {
    String? message,
    Map<String, dynamic>? context,
  }) => _log(level: 'warn', event: event, message: message, context: context);

  static Future<void> error(
    String event, {
    String? message,
    Object? err,
    StackTrace? stack,
    Map<String, dynamic>? context,
  }) => _log(
    level: 'error',
    event: event,
    message: message,
    context: context,
    errorObj: {
      if (err != null) 'message': err.toString(),
      if (stack != null) 'stack': stack.toString(),
    },
  );

  static Future<void> flush() => _flush();

  // --------------------------- Impl interne ------------------------

  static Future<void> _log({
    required String level,
    required String event,
    String? message,
    Map<String, dynamic>? context,
    Map<String, dynamic>? errorObj,
  }) async {
    _printColored(
      '[COP’IQ][$level][$event] ${message ?? ''} ${context != null ? jsonEncode(context) : ''}',
      _ansiFor(level),
    );

    if (!_deviceLoaded) {
      try {
        await _loadDeviceInfo();
      } catch (_) {}
    }

    final entry = _buildRow(
      level: level,
      event: event,
      message: message,
      context: context,
      errorObj: errorObj,
    );

    _enqueue(entry);

    if (_buffer.length >= _batchSize) unawaited(_flush());
  }

  static Map<String, dynamic> _buildRow({
    required String level,
    required String event,
    String? message,
    Map<String, dynamic>? context,
    Map<String, dynamic>? errorObj,
  }) {
    final user = _sb.auth.currentUser?.id;
    return {
      'level': level.toUpperCase(),
      'message': message ?? '',
      'event': event,
      'user_id': user,
      'screen': screen,
      'route': route,
      'session_id': sessionId,
      'app_version': appVersion,
      'build_number': buildNumber,
      'platform': _platform,
      'os_version': _osVersion,
      'device_model': _deviceModel,
      'sdk_version': 'flutter',
      'app_env': appEnv,
      'context_json': context,
      'error_json': errorObj,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  static void _enqueue(Map<String, dynamic> row) {
    if (_buffer.length >= _maxBuffer) {
      _buffer.removeAt(0);
    }
    _buffer.add(_QueuedLog(row));
  }

  static Future<void> _flush() async {
    if (_flushing || _buffer.isEmpty) return;
    _flushing = true;

    try {
      final batch = _buffer.take(_batchSize).toList();
      final payload = batch.map((e) => e.row).toList();
      await _sb.from('app_logs').insert(payload);
      _buffer.removeWhere((q) => batch.contains(q));
    } catch (e) {
      _printColored('[COP’IQ][LOGGER] flush failed: $e', _Ansi.yellow);
    } finally {
      _flushing = false;
    }
  }

  static Future<void> _loadDeviceInfo() async {
    try {
      final info = await _deviceInfo.deviceInfo;
      if (info is AndroidDeviceInfo) {
        _platform = 'android';
        _deviceModel = '${info.manufacturer ?? 'Android'} ${info.model ?? ''}'
            .trim();
        _osVersion = 'SDK ${info.version.sdkInt}';
      } else if (info is IosDeviceInfo) {
        _platform = 'ios';
        _deviceModel = info.utsname.machine ?? 'iPhone/iPad';
        _osVersion = info.systemVersion ?? '';
      } else if (info is WebBrowserInfo) {
        _platform = 'web';
        final name = describeEnum(info.browserName);
        _deviceModel = 'Browser: $name';
        _osVersion = '${info.appVersion ?? ''}';
      }
    } catch (_) {
      _platform = kIsWeb ? 'web' : 'unknown';
      _deviceModel = 'Unidentified device';
      _osVersion = '';
    } finally {
      _deviceLoaded = true;
    }
  }

  static void _installErrorHooks() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      error(
        'flutter_error',
        message: details.exceptionAsString(),
        err: details.exception,
        stack: details.stack,
        context: {
          'library': details.library,
          'info': details.informationCollector
              ?.call()
              .map((e) => e.toDescription())
              .toList(),
        },
      );
    };
    runZonedGuarded(() {}, (err, stack) {
      error('zone_error', message: err.toString(), err: err, stack: stack);
    });
  }

  static void _printColored(String text, String color) {
    // ignore: avoid_print
    print('$color$text${_Ansi.reset}');
  }

  static String _ansiFor(String level) {
    switch (level.toLowerCase()) {
      case 'success':
        return _Ansi.green;
      case 'info':
        return _Ansi.cyan;
      case 'warn':
        return _Ansi.yellow;
      case 'error':
        return _Ansi.red;
      case 'debug':
      default:
        return _Ansi.grey;
    }
  }
}

class _QueuedLog {
  _QueuedLog(this.row);
  final Map<String, dynamic> row;
}

class _Ansi {
  static const reset = '\x1B[0m';
  static const grey = '\x1B[90m';
  static const red = '\x1B[31m';
  static const green = '\x1B[32m';
  static const yellow = '\x1B[33m';
  static const cyan = '\x1B[36m';
}
