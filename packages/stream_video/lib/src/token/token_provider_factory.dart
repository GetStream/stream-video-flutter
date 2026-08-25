import 'package:stream_core/stream_core.dart';

import '../models/models.dart';
import '../utils/result.dart';
import 'token.dart';

/// Creates a server-side guest user, returning its data and access token.
///
/// Internal to the SDK — this file is deliberately not exported from the
/// package barrel.
typedef GuestUserCreator =
    Future<Result<GuestCreatedData>> Function({
      required String id,
      String? name,
      String? image,
      required Map<String, Object> custom,
    });

/// A static provider holding a guest access token.
///
/// The server assigns guest ids, so the token's `user_id` claim intentionally
/// differs from the locally-requested id the [TokenManager] was created with.
class GuestTokenProvider extends StaticTokenProvider {
  /// Creates a static provider for the given guest [_token].
  const GuestTokenProvider(this._token) : super(_token);

  final UserToken _token;

  @override
  Future<UserToken> loadToken(String userId) async => _token;
}

/// Builds the token provider matching the [user] type from the [userToken]
/// and [tokenLoader] combination.
///
/// For [UserType.guest], [createGuest] creates the server-side guest user,
/// [onGuestUserUpdated] receives the server-assigned guest user, and
/// [onGuestTokenCreated] receives the guest access token once created — so
/// the caller can promote the [TokenManager]'s provider to a
/// [GuestTokenProvider], making `usesStaticProvider` report the guest token
/// for what it is: fixed for the lifetime of the client.
TokenProvider buildTokenProvider(
  User user, {
  String? userToken,
  TokenLoader? tokenLoader,
  required GuestUserCreator createGuest,
  required void Function(User updatedUser) onGuestUserUpdated,
  required void Function(UserToken guestToken) onGuestTokenCreated,
}) {
  // Once a guest is created, its access token is reused for the lifetime
  // of the client: creating a guest again would mint a new server-side
  // identity, so an expired guest token cannot be refreshed.
  UserToken? guestToken;

  return switch (user.type) {
    UserType.regular => _regularTokenProvider(userToken, tokenLoader),
    // An anonymous token may carry a caller-supplied JWT (e.g. a
    // call-restricted token granting access to a closed livestream).
    UserType.anonymous => TokenProvider.static(
      UserToken.anonymous(userId: user.id, rawValue: userToken ?? ''),
    ),
    UserType.guest => TokenProvider.dynamic((userId) async {
      final existingToken = guestToken;
      if (existingToken != null) return existingToken;

      final result = await createGuest(
        id: userId,
        name: user.originalName,
        image: user.image,
        custom: {
          for (final MapEntry(:key, :value) in user.custom.entries)
            if (value != null) key: value,
        },
      );
      if (result is! Success<GuestCreatedData>) {
        throw (result as Failure).videoError;
      }
      final updatedInfo = result.data.user.toUserInfo();
      onGuestUserUpdated(
        User(
          id: updatedInfo.id,
          name: updatedInfo.name.isEmpty ? null : updatedInfo.name,
          image: updatedInfo.image,
          role: updatedInfo.role,
          teams: updatedInfo.teams,
          custom: updatedInfo.extraData,
          type: user.type,
        ),
      );
      final token = UserToken(result.data.accessToken);
      guestToken = token;
      onGuestTokenCreated(token);
      return token;
    }),
  };
}

/// Builds the token provider for a regular user from the [userToken] and
/// [tokenLoader] combination.
TokenProvider _regularTokenProvider(
  String? userToken,
  TokenLoader? tokenLoader,
) {
  if (tokenLoader != null) {
    // When both are provided, the token is served on the first load and
    // the loader takes over once it expires.
    var initialToken = userToken?.let(UserToken.new);
    return TokenProvider.dynamic((userId) async {
      final token = initialToken;
      if (token != null) {
        initialToken = null;
        return token;
      }
      return UserToken(await tokenLoader(userId));
    });
  }
  if (userToken != null) {
    return TokenProvider.static(UserToken(userToken));
  }
  throw ArgumentError('Either `userToken` or `tokenLoader` must be set');
}
