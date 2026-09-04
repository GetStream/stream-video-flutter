import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/token/token_provider_factory.dart';
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

GuestCreatedData _guestData(
  String id, {
  String? name,
  String? image,
  String? accessToken,
}) {
  return GuestCreatedData(
    accessToken: accessToken ?? _fakeJwt(id),
    duration: '10ms',
    user: UserResponseData(
      id: id,
      role: 'guest',
      name: name,
      image: image,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    ),
  );
}

/// A [GuestUserCreator] returning [result], recording invocations.
class _FakeGuestCreator {
  _FakeGuestCreator(this.result);

  final Result<GuestCreatedData> result;
  final calls = <Map<String, Object?>>[];

  Future<Result<GuestCreatedData>> call({
    required String id,
    String? name,
    String? image,
    required Map<String, Object> custom,
  }) async {
    calls.add({'id': id, 'name': name, 'image': image, 'custom': custom});
    return result;
  }
}

void main() {
  group('buildTokenProvider', () {
    group('regular user', () {
      TokenProvider build({String? userToken, TokenLoader? tokenLoader}) {
        return buildTokenProvider(
          const User(id: 'user-1'),
          userToken: userToken,
          tokenLoader: tokenLoader,
        );
      }

      test('throws when neither userToken nor tokenLoader is set', () {
        expect(build, throwsArgumentError);
      });

      test('uses a static provider when only userToken is set', () async {
        final rawToken = _fakeJwt('user-1');
        final provider = build(userToken: rawToken);

        final token = await provider.loadToken('user-1');

        expect(provider, isA<StaticTokenProvider>());
        expect(token.rawValue, rawToken);
        expect(token.userId, 'user-1');
      });

      test('uses a dynamic provider when only tokenLoader is set', () async {
        final loadedUserIds = <String>[];
        final provider = build(
          tokenLoader: (userId) async {
            loadedUserIds.add(userId);
            return _fakeJwt(userId);
          },
        );

        final token = await provider.loadToken('user-1');

        expect(loadedUserIds, ['user-1']);
        expect(token.userId, 'user-1');
        expect(token.authType, AuthType.jwt);
      });

      test(
        'serves userToken on the first load, then hands off to tokenLoader',
        () async {
          final initialToken = _fakeJwt('user-1');
          final loaderToken = _fakeJwt('user-1');
          var loaderCalls = 0;
          final provider = build(
            userToken: initialToken,
            tokenLoader: (userId) async {
              loaderCalls++;
              return loaderToken;
            },
          );

          final first = await provider.loadToken('user-1');
          expect(first.rawValue, initialToken);
          expect(loaderCalls, 0);

          final second = await provider.loadToken('user-1');
          expect(second.rawValue, loaderToken);
          expect(loaderCalls, 1);
        },
      );
    });

    group('anonymous user', () {
      test('builds a static anonymous token', () async {
        final provider = buildTokenProvider(const User.anonymous());

        final token = await provider.loadToken(User.anonymousUserId);

        expect(token.authType, AuthType.anonymous);
        expect(token.userId, User.anonymousUserId);
        expect(token.rawValue, isEmpty);
      });

      test('passes a caller-supplied token through as the raw value', () async {
        final restrictedToken = _fakeJwt(User.anonymousUserId);
        final provider = buildTokenProvider(
          const User.anonymous(),
          userToken: restrictedToken,
        );

        final token = await provider.loadToken(User.anonymousUserId);

        expect(token.authType, AuthType.anonymous);
        expect(token.rawValue, restrictedToken);
      });
    });

    group('guest user', () {
      test('throws — guests are configured via establishGuestSession', () {
        expect(
          () => buildTokenProvider(const User.guest('local-guest')),
          throwsArgumentError,
        );
      });
    });
  });

  group('establishGuestSession', () {
    void noUserUpdate(User _) {}

    test('points the manager at the server-assigned identity', () async {
      final creator = _FakeGuestCreator(
        Result.success(_guestData('server-guest-1')),
      );
      final manager = TokenManager.unconfigured();

      final result = await establishGuestSession(
        tokenManager: manager,
        user: const User.guest('local-guest'),
        createGuest: creator.call,
        onGuestUserUpdated: noUserUpdate,
      );

      final token = result.getDataOrNull();
      expect(token, isNotNull);
      expect(token!.userId, 'server-guest-1');
      expect(manager.userId, 'server-guest-1');

      // The guards (RpcRetryManager, coordinator WS) key off this: the guest
      // token is fixed for the lifetime of the client.
      expect(manager.usesStaticProvider, isTrue);
      expect(await manager.getToken(), token);

      // Even an unguarded expire + reload serves the same token instead of
      // re-creating the guest.
      manager.expireToken();
      expect(await manager.getToken(), token);
      expect(creator.calls, hasLength(1));
    });

    test('passes profile fields, filtering null custom values', () async {
      final creator = _FakeGuestCreator(
        Result.success(_guestData('server-guest-1')),
      );

      await establishGuestSession(
        tokenManager: TokenManager.unconfigured(),
        user: const User(
          id: 'local-guest',
          name: 'Guest Name',
          image: 'https://image.url',
          type: UserType.guest,
          custom: {'color': 'green', 'empty': null},
        ),
        createGuest: creator.call,
        onGuestUserUpdated: noUserUpdate,
      );

      expect(creator.calls.single, {
        'id': 'local-guest',
        'name': 'Guest Name',
        'image': 'https://image.url',
        'custom': {'color': 'green'},
      });
    });

    test('notifies about the server-assigned guest user', () async {
      final creator = _FakeGuestCreator(
        Result.success(
          _guestData('server-guest-1', name: 'Server Name', image: 'img'),
        ),
      );
      User? updatedUser;

      await establishGuestSession(
        tokenManager: TokenManager.unconfigured(),
        user: const User.guest('local-guest'),
        createGuest: creator.call,
        onGuestUserUpdated: (user) => updatedUser = user,
      );

      expect(updatedUser?.id, 'server-guest-1');
      expect(updatedUser?.name, 'Server Name');
      expect(updatedUser?.image, 'img');
      expect(updatedUser?.type, UserType.guest);
    });

    test('caches the first token and notifies onTokenUpdated', () async {
      final creator = _FakeGuestCreator(
        Result.success(_guestData('server-guest-1')),
      );
      final updates = <UserToken>[];
      final manager = TokenManager.unconfigured(onTokenUpdated: updates.add);

      final result = await establishGuestSession(
        tokenManager: manager,
        user: const User.guest('local-guest'),
        createGuest: creator.call,
        onGuestUserUpdated: noUserUpdate,
      );

      // Served through the manager, so a guest's first token is cached and
      // announced like every other user's.
      expect(manager.peekToken(), result.getDataOrNull());
      expect(updates, [result.getDataOrNull()]);
    });

    test('rejects an unreadable token without handing it over', () async {
      final creator = _FakeGuestCreator(
        Result.success(_guestData('server-guest-1', accessToken: 'not-a-jwt')),
      );
      final manager = TokenManager.unconfigured();
      User? updatedUser;

      final result = await establishGuestSession(
        tokenManager: manager,
        user: const User.guest('local-guest'),
        createGuest: creator.call,
        onGuestUserUpdated: (user) => updatedUser = user,
      );

      expect(result, isA<Failure>());
      expect(manager.userId, isNull);
      // The client keeps the identity it asked for, so a retry creates the
      // guest it meant to instead of one for the server-assigned id.
      expect(updatedUser, isNull);
    });

    test('returns the failure and leaves the manager unconfigured', () async {
      final creator = _FakeGuestCreator(
        failureWithError('guest creation failed'),
      );
      final manager = TokenManager.unconfigured();

      final result = await establishGuestSession(
        tokenManager: manager,
        user: const User.guest('local-guest'),
        createGuest: creator.call,
        onGuestUserUpdated: noUserUpdate,
      );

      expect(result, isA<Failure>());
      expect((result as Failure).videoError, isA<VideoError>());
      expect(manager.userId, isNull);
    });
  });
}
