import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:jose/jose.dart';

import '../../stream_video.dart';
import '../errors/video_error_composer.dart';

/// A function which can be used to request a Stream Video API token from your
/// own backend server
typedef GuestTokenProvider = Future<String> Function(UserInfo user);

/// A function which can be used to request a Stream Video API token from your
/// own backend server.
/// Function requires a single [userId].
typedef TokenLoader = Future<String> Function(String userId);

typedef OnTokenUpdated = Future<void> Function(UserToken token);

abstract class TokenProvider {
  const TokenProvider();

  factory TokenProvider.static(UserToken token) {
    return _StaticProvider(token);
  }

  factory TokenProvider.dynamic(
    TokenLoader loader, [
    OnTokenUpdated? onTokenUpdated,
  ]) {
    return _DynamicProvider(loader, onTokenUpdated: onTokenUpdated);
  }

  Future<Result<UserToken>> getToken(String userId);

  bool get isStatic;

  set onTokenUpdated(OnTokenUpdated onTokenUpdated);
}

class _StaticProvider implements TokenProvider {
  _StaticProvider(this.token);

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
    OnTokenUpdated? onTokenUpdated,
  }) : _onTokenUpdated = onTokenUpdated;

  final _logger = taggedLogger(tag: 'SV:DynamicToken');

  final TokenLoader loader;

  OnTokenUpdated? _onTokenUpdated;

  @override
  bool get isStatic => false;

  @override
  Future<Result<UserToken>> getToken(String userId) async {
    try {
      _logger.d(() => '[loadToken] userId: $userId');
      final token = await loader.call(userId);
      _logger.v(() => '[loadToken] completed: $token');
      var userToken = UserToken.fromRawValue(token);
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
    required this.rawValue,
    required this.userId,
    required this.authType,
  });

  /// The token that can be used when user is unknown.
  /// Is used by `anonymous` token provider.
  factory UserToken.anonymous({String? userId}) => UserToken._(
        rawValue: '',
        userId: userId ?? randomId(),
        authType: AuthType.anonymous,
      );

  /// Creates a [UserToken] instance from the provided [rawValue] if it's valid.
  factory UserToken.fromRawValue(String rawValue) {
    final jwtBody = JsonWebToken.unverified(rawValue);
    final userId = jwtBody.claims.getTyped<String>('user_id');
    assert(
      userId != null,
      'Invalid `token`, It should contain `user_id`',
    );
    return UserToken._(
      rawValue: rawValue,
      userId: userId!,
      authType: AuthType.jwt,
    );
  }

  /// The token which designed to be used for guest users.
  static Future<UserToken> guest(
      UserInfo user, GuestTokenProvider provider) async {
    final rawToken = await provider(user);
    return UserToken.fromRawValue(rawToken);
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

const _alphabet =
    'ModuleSymbhasOwnPr-0123456789ABCDEFGHNRVfgctiUvz_KqYTJkLxpZXIjQW';

/// Generates a random String id
/// Adopted from: https://github.com/ai/nanoid/blob/main/non-secure/index.js
String randomId({int size = 21}) {
  var id = '';
  for (var i = 0; i < size; i++) {
    id += _alphabet[(Random().nextDouble() * 64).floor() | 0];
  }
  return id;
}
