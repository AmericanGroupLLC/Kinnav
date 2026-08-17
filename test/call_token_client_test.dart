import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:kinnav/config/app_config.dart';
import 'package:kinnav/services/call_token_client.dart';

/// The token endpoint stands between the app and the RTC provider, and it is
/// the only place the App Certificate is used. These tests pin the contract
/// and, more importantly, the failure behaviour: a Safe Call that fails must
/// fail loudly and quickly, never hang or pretend to connect.
void main() {
  CallTokenClient clientReturning(
    int status,
    Object body, {
    void Function(http.Request)? onRequest,
  }) {
    return CallTokenClient(
      client: MockClient((req) async {
        onRequest?.call(req);
        return http.Response(
          body is String ? body : jsonEncode(body),
          status,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
  }

  group('CallTokenClient', () {
    test('posts the channel to the backend, not to the RTC provider', () async {
      http.Request? seen;
      final client = clientReturning(200, {
        'appId': 'agora-app-id',
        'channel': 'safe-call-42',
        'token': '007eJx…',
        'uid': 12345,
        'expiresAt': 1770000000,
      }, onRequest: (r) => seen = r);

      final token = await client.fetch(channel: 'safe-call-42');

      // Must hit Kinnav's own API — the App Certificate never leaves it.
      expect(seen!.url.toString(), startsWith(AppConfig.apiBaseUrl));
      expect(seen!.url.path, endsWith('/calls/token'));
      expect(seen!.method, 'POST');
      expect(jsonDecode(seen!.body)['channel'], 'safe-call-42');
      expect(jsonDecode(seen!.body)['role'], 'publisher');

      expect(token.appId, 'agora-app-id');
      expect(token.token, isNotEmpty);
      expect(token.uid, 12345);
    });

    test('accepts an expiry as unix seconds or as ISO-8601', () {
      final unix = CallToken.fromJson({
        'appId': 'a', 'channel': 'c', 'token': 't', 'uid': 1,
        'expiresAt': 1770000000,
      });
      final iso = CallToken.fromJson({
        'app_id': 'a', 'channel_name': 'c', 'token': 't', 'uid': 1,
        'expires_at': '2030-01-01T00:00:00Z',
      });
      expect(unix.expiresAt.isUtc, isTrue);
      expect(iso.expiresAt.year, 2030);
      // snake_case keys are read too, so a Python or Go backend needs no
      // special-casing on either side.
      expect(iso.appId, 'a');
    });

    test('treats a token as expired a minute early', () {
      final almost = CallToken(
        appId: 'a', channel: 'c', token: 't', uid: 1,
        expiresAt: DateTime.now().toUtc().add(const Duration(seconds: 30)),
      );
      final fine = CallToken(
        appId: 'a', channel: 'c', token: 't', uid: 1,
        expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 10)),
      );
      // Expiring mid-handshake fails the call at the worst possible moment.
      expect(almost.isExpired, isTrue);
      expect(fine.isExpired, isFalse);
    });

    test('surfaces the server error message when there is one', () async {
      final client = clientReturning(403, {'error': 'Not a member of that call'});
      await expectLater(
        client.fetch(channel: 'x'),
        throwsA(isA<CallTokenException>()
            .having((e) => e.message, 'message', 'Not a member of that call')
            .having((e) => e.statusCode, 'status', 403)),
      );
    });

    test('reports a plain status when the body carries no message', () async {
      final client = clientReturning(500, 'upstream exploded');
      await expectLater(
        client.fetch(channel: 'x'),
        throwsA(isA<CallTokenException>()
            .having((e) => e.message, 'message', contains('500'))),
      );
    });

    test('rejects a 200 that is missing the token or appId', () async {
      // A malformed success is more dangerous than an error: the app would
      // otherwise try to join a channel with an empty credential.
      final noToken = clientReturning(200, {'appId': 'a', 'channel': 'c'});
      await expectLater(noToken.fetch(channel: 'c'),
          throwsA(isA<CallTokenException>()));

      final noAppId = clientReturning(200, {'token': 't', 'channel': 'c'});
      await expectLater(noAppId.fetch(channel: 'c'),
          throwsA(isA<CallTokenException>()));
    });

    test('rejects a 200 that is not JSON', () async {
      final client = clientReturning(200, '<html>login</html>');
      await expectLater(client.fetch(channel: 'c'),
          throwsA(isA<CallTokenException>()));
    });

    test('fails fast instead of hanging when the server does not answer',
        () async {
      final client = CallTokenClient(
        client: MockClient((_) => Future.delayed(
            const Duration(seconds: 30), () => http.Response('{}', 200))),
      );
      await expectLater(
        client.fetch(channel: 'c', timeout: const Duration(milliseconds: 100)),
        throwsA(isA<CallTokenException>()
            .having((e) => e.message, 'message', contains('Could not reach'))),
      );
    });
  });
}
