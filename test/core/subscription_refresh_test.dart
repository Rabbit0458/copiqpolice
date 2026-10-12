import 'dart:async';
import 'dart:convert';

import 'package:copiqpolice/core/services/entitlement_service.dart';
import 'package:copiqpolice/core/services/subscription_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> signIn(SupabaseClient client, String uid) async {
  final expiry = DateTime.now().add(const Duration(hours: 1));
  final payload = base64Url
      .encode(
        utf8.encode(
          jsonEncode({
            'sub': uid,
            'exp': expiry.millisecondsSinceEpoch ~/ 1000,
          }),
        ),
      )
      .replaceAll('=', '');
  await client.auth.recoverSession(
    jsonEncode({
      'access_token': 'e30.$payload.signature',
      'refresh_token': 'test-refresh',
      'token_type': 'bearer',
      'expires_in': 3600,
      'expires_at': expiry.millisecondsSinceEpoch ~/ 1000,
      'user': {
        'id': uid,
        'app_metadata': <String, dynamic>{},
        'user_metadata': <String, dynamic>{},
        'aud': 'authenticated',
        'created_at': '2026-01-01T00:00:00Z',
      },
    }),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SupabaseClient client;
  late Future<http.Response> Function(http.Request) respond;

  setUp(() {
    respond = (_) async => http.Response('false', 200);
    client = SupabaseClient(
      'https://subscription-test.invalid',
      'test-key',
      httpClient: MockClient((request) async {
        final response = await respond(request);
        return http.Response(
          response.body,
          response.statusCode,
          request: request,
          headers: {'content-type': 'application/json'},
        );
      }),
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
  });
  tearDown(() => client.dispose());

  test('quota reset follows window_start, not last usage', () {
    final start = DateTime.now().toUtc().subtract(const Duration(days: 2));
    final quota = FreeQuota.fromRow({
      'window_start': start.toIso8601String(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
      'used': 4,
    });
    expect(quota.resetsAt, start.add(const Duration(days: 7)));
    expect(quota.remaining, 6);
  });

  test('a failed premium check keeps ad eligibility uncertain', () async {
    await signIn(client, 'user-a');
    respond = (_) async => http.Response('{"message":"unavailable"}', 503);
    final service = SubscriptionService.forTesting(client);
    await service.refresh(withQuota: false);
    expect(service.state.value.isPremium, isFalse);
    expect(service.state.value.lastError, isNotNull);
    service.state.dispose();
  });

  test('late premium response cannot overwrite the new account', () async {
    await signIn(client, 'user-a');
    final first = Completer<http.Response>();
    final started = Completer<void>();
    var calls = 0;
    respond = (_) {
      calls++;
      if (calls == 1) {
        started.complete();
        return first.future;
      }
      return Future.value(http.Response('false', 200));
    };
    final service = SubscriptionService.forTesting(client);
    final oldRefresh = service.refresh(withQuota: false);
    await started.future;
    await signIn(client, 'user-b');
    await service.refresh(withQuota: false);
    first.complete(http.Response('true', 200));
    await oldRefresh;
    expect(service.state.value.isPremium, isFalse);
    expect(service.state.value.lastError, isNull);
    service.state.dispose();
  });

  test('forced entitlement refresh joins the same running request', () async {
    await signIn(client, 'user-a');
    final response = Completer<http.Response>();
    var calls = 0;
    respond = (_) {
      calls++;
      return response.future;
    };
    final service = EntitlementService.forTesting(client);
    final first = service.refresh();
    final second = service.refresh(force: true);
    response.complete(
      http.Response('{"authenticated":true,"premium":true}', 200),
    );
    final results = await Future.wait([first, second]);
    expect(calls, 1);
    expect(results.every((ent) => ent.premium), isTrue);
    service.state.dispose();
  });

  test(
    'late entitlement response cannot grant rights to a new account',
    () async {
      await signIn(client, 'user-a');
      final first = Completer<http.Response>();
      final started = Completer<void>();
      var calls = 0;
      respond = (_) {
        if (++calls == 1) {
          started.complete();
          return first.future;
        }
        return Future.value(
          http.Response('{"authenticated":true,"premium":false}', 200),
        );
      };
      final service = EntitlementService.forTesting(client);
      final oldRefresh = service.refresh();
      await started.future;
      await signIn(client, 'user-b');
      await service.refresh(force: true);
      first.complete(
        http.Response('{"authenticated":true,"premium":true}', 200),
      );
      expect((await oldRefresh).premium, isFalse);
      expect(service.state.value.premium, isFalse);
      service.state.dispose();
    },
  );
}
