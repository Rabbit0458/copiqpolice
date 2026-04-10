// lib/services/subscription_service.dart
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// ─────────────────────────────────────────────────────────────
///  COP’IQ — Subscription & Free Quota (Realtime + Polling + Gate)
///  Tables:
///   - subscription_payement (user_id, plan, status, valid_until, updated_at)
///   - free_weekly_usage (user_id, window_start, used)
///
///  RPC:
///   - is_user_premium(p_user_id uuid) -> bool
///   - consume_free_request() -> json (allowed, remaining, resets_at, premium, reason)
/// ─────────────────────────────────────────────────────────────

class FreeQuota {
  /// Nombre de requêtes consommées dans la fenêtre
  final int used;

  /// Limite gratuite (ex: 10)
  final int limit;

  /// Date de référence “backend” (si ta table l’utilise)
  final DateTime windowStart;

  /// Dernière consommation réelle (updated_at). C’est ça qui pilote la reset en UI.
  final DateTime lastUsedAt;

  /// Date/heure de réinitialisation calculée (lastUsedAt + 7 jours)
  final DateTime resetsAt;

  const FreeQuota({
    required this.used,
    required this.limit,
    required this.windowStart,
    required this.lastUsedAt,
    required this.resetsAt,
  });

  int get remaining => (limit - used).clamp(0, limit);

  static const Duration windowDuration = Duration(days: 7);

  static DateTime? _parseTs(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }

  /// Normalise l’état : si la date de reset est passée, on affiche comme si c’était reset.
  /// (Le vrai reset côté DB se fera au prochain consume, mais l’UI reste cohérente.)
  static FreeQuota normalize(FreeQuota q) {
    final now = DateTime.now().toUtc();
    if (now.isAfter(q.resetsAt)) {
      final base = now;
      return FreeQuota(
        used: 0,
        limit: q.limit,
        windowStart: base,
        lastUsedAt: base,
        resetsAt: base.add(windowDuration),
      );
    }
    return q;
  }

  /// Construit depuis une row Supabase.
  /// ⚠️ Important : il faut SELECT updated_at dans fetchFreeQuota().
  factory FreeQuota.fromRow(Map<String, dynamic> row, {int limit = 10}) {
    final now = DateTime.now().toUtc();

    final windowStart = _parseTs(row['window_start'])?.toUtc() ?? now;

    final used = (row['used'] is num) ? (row['used'] as num).toInt() : 0;

    // ✅ Base de reset = updated_at (dernière requête)
    // Fallback si absent : window_start
    final lastUsedAt = _parseTs(row['updated_at'])?.toUtc() ?? windowStart;

    final resetsAt = lastUsedAt.add(windowDuration);

    return normalize(
      FreeQuota(
        used: used,
        limit: limit,
        windowStart: windowStart,
        lastUsedAt: lastUsedAt,
        resetsAt: resetsAt,
      ),
    );
  }

  /// Etat fresh (utilisé si aucune row en DB)
  static FreeQuota fresh({int limit = 10}) {
    final now = DateTime.now().toUtc();
    return FreeQuota(
      used: 0,
      limit: limit,
      windowStart: now,
      lastUsedAt: now,
      resetsAt: now.add(windowDuration),
    );
  }

  @override
  String toString() {
    return 'FreeQuota(used=$used, limit=$limit, remaining=$remaining, '
        'windowStart=$windowStart, lastUsedAt=$lastUsedAt, resetsAt=$resetsAt)';
  }
}

class SubscriptionState {
  final bool isPremium;
  final FreeQuota? quota; // null = not loaded yet
  final DateTime? lastRefreshedAt;
  final Object? lastError;

  const SubscriptionState({
    required this.isPremium,
    this.quota,
    this.lastRefreshedAt,
    this.lastError,
  });

  bool get isLocked => !isPremium && (quota?.remaining ?? 999) <= 0;

  int? get remaining => quota?.remaining;
  DateTime? get resetsAt => quota?.resetsAt;

  SubscriptionState copyWith({
    bool? isPremium,
    FreeQuota? quota,
    bool setQuotaNull = false,
    DateTime? lastRefreshedAt,
    Object? lastError,
    bool clearLastError = false,
  }) {
    return SubscriptionState(
      isPremium: isPremium ?? this.isPremium,
      quota: setQuotaNull ? null : (quota ?? this.quota),
      lastRefreshedAt: lastRefreshedAt ?? this.lastRefreshedAt,
      lastError: clearLastError ? null : (lastError ?? this.lastError),
    );
  }

  static const initial = SubscriptionState(isPremium: false);
}

class ConsumeResult {
  final bool allowed;
  final bool premium;
  final int? remaining;
  final DateTime? resetsAt;
  final String? reason;

  const ConsumeResult({
    required this.allowed,
    required this.premium,
    this.remaining,
    this.resetsAt,
    this.reason,
  });
}

/// ─────────────────────────────────────────────────────────────
///  SubscriptionService (Source of truth runtime)
/// ─────────────────────────────────────────────────────────────
class SubscriptionService {
  SubscriptionService._();
  static final SubscriptionService instance = SubscriptionService._();

  SupabaseClient get _sb => Supabase.instance.client;

  static const int freeLimit = 10;

  static const String kPremiumTable = 'subscription_payement';
  static const String kQuotaTable = 'free_weekly_usage';

  final ValueNotifier<SubscriptionState> state =
      ValueNotifier<SubscriptionState>(SubscriptionState.initial);

  bool _started = false;
  String? _boundUserId;

  RealtimeChannel? _premiumChannel;
  RealtimeChannel? _quotaChannel;
  StreamSubscription<AuthState>? _authSub;

  Timer? _pollTimer;
  Completer<void>? _refreshing;

  // Anti double-consume sur navigation
  String? _lastConsumedRoute;
  DateTime? _lastConsumedAt;

  bool get isHardLocked => state.value.isLocked;

  /// ✅ Boot: call once (ex: in MyApp.initState()).
  void startAutoSync({Duration pollingEvery = const Duration(seconds: 20)}) {
    if (_started) {
      _SubLog.w('auto_sync:already_started');
      return;
    }
    _started = true;

    _SubLog.ok('auto_sync:start');

    // auth listener
    _authSub = _sb.auth.onAuthStateChange.listen((evt) async {
      final e = evt.event;
      final u = evt.session?.user ?? _sb.auth.currentUser;

      _SubLog.i('auth_event', {'event': e.name, 'uid': u?.id});

      switch (e) {
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.userUpdated:
        case AuthChangeEvent.tokenRefreshed:
          await _rebindForUser(u?.id);
          await refresh(force: true, withQuota: true);
          break;

        case AuthChangeEvent.signedOut:
          await _rebindForUser(null);
          state.value = SubscriptionState.initial;
          break;

        default:
          break;
      }
    });

    // bind current user if any
    _rebindForUser(_sb.auth.currentUser?.id);

    // Polling fallback (anti realtime freeze)
    _pollTimer = Timer.periodic(pollingEvery, (_) async {
      if (!_started) return;
      if (_sb.auth.currentUser == null) return;
      try {
        await refresh(force: false, withQuota: true);
        _SubLog.d('poll:refresh_ok');
      } catch (e) {
        _SubLog.err('poll:refresh_failed', e);
      }
    });
  }

  Future<void> stopAutoSync() async {
    if (!_started) return;
    _started = false;

    _SubLog.w('auto_sync:stop');

    await _authSub?.cancel();
    _authSub = null;

    _pollTimer?.cancel();
    _pollTimer = null;

    await _unbindRealtime();
    _boundUserId = null;
  }

  /// ✅ Called by NavigatorObserver to auto-consume on quiz routes.
  Future<void> onRoutePushed(String? routeName) async {
    if (routeName == null || routeName.isEmpty) return;

    // Rules: only quiz routes consume
    final isQuiz =
        routeName.contains('/quiz') ||
        routeName.contains('/gpx_exam') ||
        routeName.contains('/pa_exam') ||
        routeName.contains('quiz_');

    if (!isQuiz) return;

    // Premium user -> no consume
    await refresh(force: false, withQuota: true);
    if (state.value.isPremium) return;

    // Locked -> do not consume
    if (state.value.isLocked) return;

    // Anti-double-consume safety
    final now = DateTime.now();
    if (_lastConsumedRoute == routeName &&
        _lastConsumedAt != null &&
        now.difference(_lastConsumedAt!) < const Duration(seconds: 3)) {
      return;
    }

    _lastConsumedRoute = routeName;
    _lastConsumedAt = now;

    _SubLog.i('route_quiz_detected', {'route': routeName});
    await consumeFreeRequest();
  }

  /// ---------- Premium ----------
  Future<bool> _fetchIsPremium() async {
    final user = _sb.auth.currentUser;
    if (user == null) return false;

    final res = await _sb.rpc(
      'is_user_premium',
      params: {'p_user_id': user.id},
    );
    final premium = res == true;

    _SubLog.d('rpc:is_user_premium', {'premium': premium});
    return premium;
  }

  /// ---------- Quota ----------
  Future<FreeQuota?> fetchFreeQuota() async {
    final user = _sb.auth.currentUser;
    if (user == null) return null;

    final row = await _sb
        .from(kQuotaTable)
        .select('user_id, window_start, used, updated_at') // ✅ + updated_at
        .eq('user_id', user.id)
        .maybeSingle();

    if (row == null) {
      _SubLog.d('quota:no_row -> fresh');
      return FreeQuota.fresh(limit: freeLimit);
    }

    return FreeQuota.fromRow(row, limit: freeLimit);
  }

  /// ---------- Refresh ----------
  Future<void> refresh({bool force = false, bool withQuota = true}) async {
    if (_refreshing != null) return _refreshing!.future;

    final last = state.value.lastRefreshedAt;
    if (!force &&
        last != null &&
        DateTime.now().difference(last) < const Duration(seconds: 4)) {
      return;
    }

    _refreshing = Completer<void>();
    try {
      final isPremium = await _fetchIsPremium();
      FreeQuota? quota;
      if (withQuota) quota = await fetchFreeQuota();

      final newState = state.value.copyWith(
        isPremium: isPremium,
        quota: quota,
        lastRefreshedAt: DateTime.now(),
        clearLastError: true,
      );

      state.value = newState;

      _SubLog.ok('refresh:done', {
        'premium': newState.isPremium,
        'remaining': newState.quota?.remaining,
        'locked': newState.isLocked,
      });

      _refreshing!.complete();
    } catch (e) {
      _SubLog.err('refresh:failed', e);
      state.value = state.value.copyWith(
        lastError: e,
        lastRefreshedAt: DateTime.now(),
      );
      _refreshing!.complete();
    } finally {
      _refreshing = null;
    }
  }

  /// ---------- Consume ----------
  Future<ConsumeResult> consumeFreeRequest() async {
    final user = _sb.auth.currentUser;
    if (user == null) {
      _SubLog.w('consume:not_authenticated');
      return const ConsumeResult(
        allowed: false,
        premium: false,
        reason: 'not_authenticated',
      );
    }

    try {
      final raw = await _sb.rpc('consume_free_request');

      final Map<String, dynamic> json = (raw is Map)
          ? raw.map((k, v) => MapEntry(k.toString(), v))
          : <String, dynamic>{};

      DateTime? parseTs(dynamic v) {
        if (v == null) return null;
        if (v is DateTime) return v;
        return DateTime.tryParse(v.toString());
      }

      final result = ConsumeResult(
        allowed: json['allowed'] == true,
        premium: json['premium'] == true,
        remaining: (json['remaining'] is num)
            ? (json['remaining'] as num).toInt()
            : null,
        resetsAt: parseTs(json['resets_at']),
        reason: json['reason']?.toString(),
      );

      _SubLog.ok('consume:rpc', {
        'allowed': result.allowed,
        'premium': result.premium,
        'remaining': result.remaining,
        'reason': result.reason,
      });

      await refresh(force: true, withQuota: true);
      return result;
    } catch (e) {
      _SubLog.err('consume:rpc_failed', e);
      state.value = state.value.copyWith(lastError: e);
      return ConsumeResult(
        allowed: false,
        premium: false,
        reason: 'rpc_error:$e',
      );
    }
  }

  /// ---------- Guard UI ----------
  Future<bool> guardAppAccess(BuildContext context) async {
    await refresh(force: true, withQuota: true);

    if (state.value.isPremium) return true;

    final q = state.value.quota;
    if (q == null) return true;

    if (q.remaining > 0) return true;

    if (!context.mounted) return false;

    final resetsTxt = _fmtDate(q.resetsAt.toLocal());

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'quota_lock',
      barrierColor: Colors.black.withOpacity(0.55),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, __, ___) {
        final a = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return _QuotaLockDialog(
          animation: a,
          resetsText: resetsTxt,
          onLater: () => Navigator.of(context).pop(),
          onPremium: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/abonnement');
          },
        );
      },
    );

    return false;
  }

  // ---------- Internal helpers ----------
  String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final mi = d.minute.toString().padLeft(2, '0');
    return '$dd/$mm à $hh:$mi';
  }

  Future<void> _rebindForUser(String? uid) async {
    if (uid == _boundUserId) return;

    await _unbindRealtime();
    _boundUserId = uid;

    if (uid == null) {
      _SubLog.w('rebind:null_user');
      return;
    }

    _SubLog.ok('rebind:user', {'uid': uid});

    // Premium realtime
    _premiumChannel = _sb.channel('rt_premium_$uid');
    _premiumChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: kPremiumTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: uid,
          ),
          callback: (payload) async {
            _SubLog.i('rt:premium_changed', {'event': payload.eventType.name});
            await refresh(force: true, withQuota: true);
          },
        )
        .subscribe((status, [err]) {
          if (status == RealtimeSubscribeStatus.subscribed) {
            _SubLog.ok('rt:premium_subscribed');
          } else if (status == RealtimeSubscribeStatus.channelError) {
            _SubLog.err('rt:premium_subscribe_error', err ?? 'unknown');
          }
        });

    // Quota realtime
    _quotaChannel = _sb.channel('rt_quota_$uid');
    _quotaChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: kQuotaTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: uid,
          ),
          callback: (payload) async {
            _SubLog.i('rt:quota_changed', {'event': payload.eventType.name});
            await refresh(force: true, withQuota: true);
          },
        )
        .subscribe((status, [err]) {
          if (status == RealtimeSubscribeStatus.subscribed) {
            _SubLog.ok('rt:quota_subscribed');
          } else if (status == RealtimeSubscribeStatus.channelError) {
            _SubLog.err('rt:quota_subscribe_error', err ?? 'unknown');
          }
        });
  }

  Future<void> _unbindRealtime() async {
    if (_premiumChannel != null) {
      try {
        await _premiumChannel!.unsubscribe();
      } catch (_) {}
      _premiumChannel = null;
    }
    if (_quotaChannel != null) {
      try {
        await _quotaChannel!.unsubscribe();
      } catch (_) {}
      _quotaChannel = null;
    }
  }
}

/// ─────────────────────────────────────────────────────────────
///  ANSI Logs
/// ─────────────────────────────────────────────────────────────
class _Ansi {
  static const rst = '\x1B[0m';
  static const green = '\x1B[32m';
  static const red = '\x1B[31m';
  static const yellow = '\x1B[33m';
  static const cyan = '\x1B[36m';
}

class _SubLog {
  static void ok(String tag, [Map<String, Object?>? ctx]) {
    // ignore: avoid_print
    print('${_Ansi.green}[SUB] ✅ $tag${_Ansi.rst}${_fmt(ctx)}');
  }

  static void err(String tag, Object err, [Map<String, Object?>? ctx]) {
    // ignore: avoid_print
    print('${_Ansi.red}[SUB] ❌ $tag → $err${_Ansi.rst}${_fmt(ctx)}');
  }

  static void w(String tag, [Map<String, Object?>? ctx]) {
    // ignore: avoid_print
    print('${_Ansi.yellow}[SUB] ⚠️ $tag${_Ansi.rst}${_fmt(ctx)}');
  }

  static void i(String tag, [Map<String, Object?>? ctx]) {
    // ignore: avoid_print
    print('${_Ansi.cyan}[SUB] ℹ️ $tag${_Ansi.rst}${_fmt(ctx)}');
  }

  static void d(String tag, [Map<String, Object?>? ctx]) {
    // ignore: avoid_print
    print('${_Ansi.cyan}[SUB] • $tag${_Ansi.rst}${_fmt(ctx)}');
  }

  static String _fmt(Map<String, Object?>? ctx) {
    if (ctx == null || ctx.isEmpty) return '';
    return '  ${ctx.entries.map((e) => '${e.key}=${e.value}').join('  ')}';
  }
}

/// ─────────────────────────────────────────────────────────────
///  Lock Dialog (identique à ton style premium)
/// ─────────────────────────────────────────────────────────────
class _QuotaLockDialog extends StatelessWidget {
  final Animation<double> animation;
  final String resetsText;
  final VoidCallback onLater;
  final VoidCallback onPremium;

  const _QuotaLockDialog({
    required this.animation,
    required this.resetsText,
    required this.onLater,
    required this.onPremium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surface = isDark ? const Color(0xFF111317) : Colors.white;
    final textMain = isDark ? Colors.white : const Color(0xFF0B0C0F);
    final textMuted = (isDark ? Colors.white : Colors.black).withOpacity(0.68);

    return SafeArea(
      child: Center(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            final t = animation.value;
            final scale = 0.98 + (0.02 * t);
            final opacity = t;

            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: Container(
                        width: 520,
                        decoration: BoxDecoration(
                          color: surface.withOpacity(isDark ? 0.92 : 0.95),
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: (isDark ? Colors.white : Colors.black)
                                .withOpacity(0.08),
                            width: 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 48,
                              offset: Offset(0, 22),
                              color: Color(0x44000000),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center, // ✅
                            children: [
                              // ✅ Header centré (plus de badge Premium)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lock_rounded,
                                    color: textMain.withOpacity(0.9),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Accès limité',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.2,
                                      color: textMain,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              Text(
                                'Vous avez atteint la limite hebdomadaire de 10 accès gratuits.',
                                textAlign: TextAlign.center, // ✅
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: textMuted,
                                  height: 1.35,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 14),

                              Text(
                                'Réinitialisation : $resetsText',
                                textAlign: TextAlign.center, // ✅
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: textMain.withOpacity(0.92),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),

                              const SizedBox(height: 18),

                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: onLater,
                                      child: const Text('Plus tard'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: onPremium,
                                      child: const Text('Voir Premium'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
