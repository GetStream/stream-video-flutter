import 'package:stream_core/stream_core.dart';

import '../errors/video_error_composer.dart';
import '../models/models.dart';
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

/// Builds the token provider for a [UserType.regular] or [UserType.anonymous]
/// [user] from the [userToken] and [tokenLoader] combination.
///
/// Guests have no provider until the server assigns their identity: their
/// manager starts as [TokenManager.unconfigured] and is configured by
/// [establishGuestSession] once the guest is created.
TokenProvider buildTokenProvider(
  User user, {
  String? userToken,
  TokenLoader? tokenLoader,
}) {
  return switch (user.type) {
    UserType.regular => _regularTokenProvider(userToken, tokenLoader),
    // An anonymous token may carry a caller-supplied JWT (e.g. a
    // call-restricted token granting access to a closed livestream). Its
    // `user_id` claim must be [User.anonymousUserId].
    UserType.anonymous => TokenProvider.static(
      UserToken.anonymous(rawValue: userToken ?? ''),
    ),
    UserType.guest => throw ArgumentError(
      'Guest users have no token provider until the server assigns their '
      'identity — use establishGuestSession',
    ),
  };
}

/// Creates the server-side guest for [user] and points [tokenManager] at the
/// assigned identity, loading tokens from a static provider holding the
/// guest's access token. Guest tokens use a static provider and can't be refreshed.
///
/// [onGuestUserUpdated] receives the server-assigned guest user.
Future<Result<UserToken>> establishGuestSession({
  required TokenManager tokenManager,
  required User user,
  required GuestUserCreator createGuest,
  required void Function(User updatedUser) onGuestUserUpdated,
}) async {
  final result = await createGuest(
    id: user.id,
    name: user.originalName,
    image: user.image,
    custom: {
      for (final MapEntry(:key, :value) in user.custom.entries)
        if (value != null) key: value,
    },
  );

  if (result is! Success<GuestCreatedData>) return result as Failure;

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

  try {
    final token = UserToken(result.data.accessToken);
    tokenManager.setTokenProvider(
      token.userId,
      tokenProvider: TokenProvider.static(token),
    );
    return Result.success(token);
  } catch (e, stk) {
    return Result.failure(VideoErrors.compose(e, stk));
  }
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
