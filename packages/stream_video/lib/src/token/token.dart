import 'package:stream_core/stream_core.dart';

import '../errors/video_error_composer.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/models.dart';

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
  }) : _initialToken = initialToken,
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
      final userToken = await loader.call(userId).then(UserToken.new);
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
