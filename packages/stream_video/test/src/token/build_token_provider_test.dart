import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/errors/video_error.dart';
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

GuestCreatedData _guestData(String id, {String? name, String? image}) {
  return GuestCreatedData(
    accessToken: _fakeJwt(id),
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
    void noUserUpdate(User _) {}

    group('regular user', () {
      TokenProvider build({String? userToken, TokenLoader? tokenLoader}) {
        return StreamVideo.buildTokenProvider(
          const User(id: 'user-1'),
          userToken: userToken,
          tokenLoader: tokenLoader,
          createGuest: _FakeGuestCreator(
            Result.success(_guestData('unused')),
          ).call,
          onGuestUserUpdated: noUserUpdate,
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
      test('builds a static anonymous token for the user id', () async {
        final provider = StreamVideo.buildTokenProvider(
          const User.anonymous(),
          createGuest: _FakeGuestCreator(
            Result.success(_guestData('unused')),
          ).call,
          onGuestUserUpdated: noUserUpdate,
        );

        final token = await provider.loadToken('!anon');

        expect(token.authType, AuthType.anonymous);
        expect(token.userId, '!anon');
        expect(token.rawValue, isEmpty);
      });

      test('passes a caller-supplied token through as the raw value', () async {
        final provider = StreamVideo.buildTokenProvider(
          const User.anonymous(),
          userToken: 'call-restricted-jwt',
          createGuest: _FakeGuestCreator(
            Result.success(_guestData('unused')),
          ).call,
          onGuestUserUpdated: noUserUpdate,
        );

        final token = await provider.loadToken('!anon');

        expect(token.authType, AuthType.anonymous);
        expect(token.rawValue, 'call-restricted-jwt');
      });
    });

    group('guest user', () {
      test('creates the guest once and reuses its token', () async {
        final creator = _FakeGuestCreator(
          Result.success(_guestData('server-guest-1')),
        );
        final provider = StreamVideo.buildTokenProvider(
          const User.guest('local-guest'),
          createGuest: creator.call,
          onGuestUserUpdated: noUserUpdate,
        );

        final first = await provider.loadToken('local-guest');
        final second = await provider.loadToken('local-guest');

        expect(creator.calls, hasLength(1));
        expect(first.userId, 'server-guest-1');
        expect(second, first);
      });

      test('passes profile fields, filtering null custom values', () async {
        final creator = _FakeGuestCreator(
          Result.success(_guestData('server-guest-1')),
        );
        final provider = StreamVideo.buildTokenProvider(
          const User(
            id: 'local-guest',
            name: 'Guest Name',
            image: 'https://image.url',
            type: UserType.guest,
            custom: {'color': 'green', 'empty': null},
          ),
          createGuest: creator.call,
          onGuestUserUpdated: noUserUpdate,
        );

        await provider.loadToken('local-guest');

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
        final provider = StreamVideo.buildTokenProvider(
          const User.guest('local-guest'),
          createGuest: creator.call,
          onGuestUserUpdated: (user) => updatedUser = user,
        );

        await provider.loadToken('local-guest');

        expect(updatedUser?.id, 'server-guest-1');
        expect(updatedUser?.name, 'Server Name');
        expect(updatedUser?.image, 'img');
        expect(updatedUser?.type, UserType.guest);
      });

      test('throws when guest creation fails', () {
        final creator = _FakeGuestCreator(
          failureWithError('guest creation failed'),
        );
        final provider = StreamVideo.buildTokenProvider(
          const User.guest('local-guest'),
          createGuest: creator.call,
          onGuestUserUpdated: noUserUpdate,
        );

        expect(
          () => provider.loadToken('local-guest'),
          throwsA(isA<VideoError>()),
        );
      });
    });
  });
}
