import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/token/token_source.dart';
import 'package:stream_video/stream_video.dart';

/// Builds an unsigned JWT with the given [userId] claim, sufficient for
/// [UserToken]'s unverified parsing.
String _fakeJwt(String userId) {
  String encode(Map<String, dynamic> json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  final header = encode({'alg': 'HS256', 'typ': 'JWT'});
  final payload = encode({'user_id': userId});
  final signature = encode({'sig': 'fake'});
  return '$header.$payload.$signature';
}

void main() {
  group('TokenSource', () {
    group('identity known up front', () {
      test('serves the manager token', () async {
        final token = UserToken(_fakeJwt('user-1'));
        final tokens = TokenSource(
          TokenManager(
            userId: 'user-1',
            tokenProvider: TokenProvider.static(token),
          ),
        );

        expect((await tokens.getToken()).getDataOrNull(), token);
        expect((await tokens.refreshToken()).getDataOrNull(), token);
        expect(tokens.usesStaticProvider, isTrue);
      });

      test('reports the manager failure when it has no identity', () async {
        // Nothing to establish an identity with, so the manager's own error is
        // what the caller sees rather than an invented one.
        final tokens = TokenSource(TokenManager.unconfigured());

        expect(await tokens.getToken(), isA<Failure>());
      });
    });

    group('identity established on demand', () {
      late TokenManager manager;
      late UserToken guestToken;
      late int establishCalls;
      late Completer<void> establishGate;

      /// Stands in for `establishGuestSession`: configures [manager] with the
      /// server-assigned identity once the gate opens.
      Future<Result<UserToken>> establish() async {
        establishCalls++;
        await establishGate.future;
        manager.setTokenProvider(
          guestToken.userId,
          tokenProvider: TokenProvider.static(guestToken),
        );
        return Result.success(guestToken);
      }

      setUp(() {
        manager = TokenManager.unconfigured();
        guestToken = UserToken(_fakeJwt('server-guest-1'));
        establishCalls = 0;
        establishGate = Completer<void>()..complete();
      });

      test('establishes on the first token request, then serves it', () async {
        final tokens = TokenSource(manager, establishSession: establish);

        expect((await tokens.getToken()).getDataOrNull(), guestToken);
        expect((await tokens.getToken()).getDataOrNull(), guestToken);
        expect(establishCalls, 1);
      });

      test('a refresh establishes rather than refreshing nothing', () async {
        final tokens = TokenSource(manager, establishSession: establish);

        expect((await tokens.refreshToken()).getDataOrNull(), guestToken);
        expect(establishCalls, 1);
      });

      test('concurrent callers share one establishment', () async {
        establishGate = Completer<void>();
        final tokens = TokenSource(manager, establishSession: establish);

        final pending = [
          tokens.getToken(),
          tokens.getToken(),
          tokens.refreshToken(),
        ];
        establishGate.complete();
        final results = await Future.wait(pending);

        expect(
          results.map((it) => it.getDataOrNull()),
          everyElement(guestToken),
        );
        // One exchange, so a second caller cannot mint a session of its own.
        expect(establishCalls, 1);
      });

      test('a failure is not sticky — the next caller retries', () async {
        var fail = true;
        final tokens = TokenSource(
          manager,
          establishSession: () {
            if (fail) {
              establishCalls++;
              return Future.value(failureWithError<UserToken>('nope'));
            }
            return establish();
          },
        );

        expect(await tokens.getToken(), isA<Failure>());
        fail = false;
        expect((await tokens.getToken()).getDataOrNull(), guestToken);
        expect(establishCalls, 2);
      });
    });
  });
}
