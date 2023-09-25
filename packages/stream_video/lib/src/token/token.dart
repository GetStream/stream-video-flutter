import 'package:equatable/equatable.dart';
import 'package:jose/jose.dart';

import '../../stream_video.dart';
import '../errors/video_error_composer.dart';
import '../utils/standard.dart';

/// A function which can be used to request a Stream Video API token from your
/// own backend server
typedef GuestTokenLoader = Future<String> Function(UserInfo user);

/// A function which can be used to request a Stream Video API token from your
/// own backend server.
/// Function requires a single [userId].
typedef TokenLoader = Future<String> Function(String userId);

typedef OnTokenUpdated = Future<void> Function(UserToken token);

abstract class TokenProvider {
  const TokenProvider();

  factory TokenProvider.from(
    UserToken? token,
    TokenLoader? loader, [
    OnTokenUpdated? onTokenUpdated,
  ]) {
    if (token != null && loader == null) {
      return TokenProvider.static(token, onTokenUpdated: onTokenUpdated);
    }
    if (loader != null) {
      return TokenProvider.dynamic(
        loader,
        initialToken: token,
        onTokenUpdated: onTokenUpdated,
      );
    }
    throw ArgumentError('Either `userToken` or `tokenProvider` must be set');
  }

  factory TokenProvider.static(
    UserToken token, {
    OnTokenUpdated? onTokenUpdated,
  }) {
    return _StaticProvider(token, onTokenUpdated: onTokenUpdated);
  }

  factory TokenProvider.dynamic(
    TokenLoader loader, {
    UserToken? initialToken,
    OnTokenUpdated? onTokenUpdated,
  }) {
    return _DynamicProvider(
      loader,
      initialToken: initialToken,
      onTokenUpdated: onTokenUpdated,
    );
  }

  Future<Result<UserToken>> getToken(String userId);

  bool get isStatic;

  set onTokenUpdated(OnTokenUpdated onTokenUpdated);
}

class _StaticProvider implements TokenProvider {
  _StaticProvider(this.token, {OnTokenUpdated? onTokenUpdated}) {
    _logger.d(() => '<init> token: $token');
    onTokenUpdated?.call(token);
  }

  final _logger = taggedLogger(tag: 'SV:StaticProvider');

  final UserToken token;

  @override
  Future<Result<UserToken>> getToken(String userId) async {
    _logger.v(() => '[getToken] token($userId): $token');
    return Result.success(token);
  }

  @override
  bool get isStatic => true;

  @override
  set onTokenUpdated(OnTokenUpdated onTokenUpdated) {
    /* no-op */
  }
}

class _DynamicProvider implements TokenProvider {
  _DynamicProvider(
    this.loader, {
    UserToken? initialToken,
    OnTokenUpdated? onTokenUpdated,
  })  : _initialToken = initialToken,
        _onTokenUpdated = onTokenUpdated;

  final _logger = taggedLogger(tag: 'SV:DynamicToken');

  final TokenLoader loader;

  UserToken? _initialToken;
  OnTokenUpdated? _onTokenUpdated;

  @override
  bool get isStatic => false;

  @override
  Future<Result<UserToken>> getToken(String userId) async {
    try {
      _logger.d(() => '[loadToken] userId: $userId');
      final initialToken = _initialToken;
      if (initialToken != null) {
        _logger.v(() => '[loadToken] return initial token: $initialToken');
        await _onTokenUpdated?.call(initialToken);
        return Result.success(initialToken).also((_) {
          _initialToken = null;
        });
      }
      final userToken = await loader.call(userId).then(UserToken.jwt);
      _logger.v(() => '[loadToken] completed: $userToken');
      await _onTokenUpdated?.call(userToken);
      return Result.success(userToken);
    } catch (e, stk) {
      _logger.e(() => '[loadToken] failed: $e; $stk');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  set onTokenUpdated(OnTokenUpdated onTokenUpdated) {
    _onTokenUpdated = onTokenUpdated;
  }
}

/// Authentication type
enum AuthType {
  /// JWT token
  jwt,

  /// Anonymous user
  anonymous,
}

/// Token designed to store the JWT and the user it is related to.
class UserToken extends Equatable {
  const UserToken._({
    required this.userId,
    required this.authType,
    this.rawValue = '',
  });

  /// The token that can be used when user is unknown.
  /// Is used by `anonymous` token provider.
  factory UserToken.anonymous({String userId = '!anon'}) => UserToken._(
        userId: userId,
        authType: AuthType.anonymous,
      );

  /// Creates a [UserToken] instance from the provided [rawValue] if it's valid.
  factory UserToken.jwt(String rawValue) {
    final jwtBody = JsonWebToken.unverified(rawValue);
    final userId = jwtBody.claims.getTyped<String>('user_id');
    assert(
      userId != null,
      'Invalid `token`, It should contain `user_id`',
    );
    return UserToken._(
      userId: userId!,
      authType: AuthType.jwt,
      rawValue: rawValue,
    );
  }

  /// Authentication type of this token
  final AuthType authType;

  /// String value of the token
  final String rawValue;

  /// User id associated with this token
  final String userId;

  @override
  List<Object?> get props => [authType, rawValue, userId];
}
