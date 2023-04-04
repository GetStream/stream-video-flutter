import '../../stream_video.dart';
import '../errors/video_error_composer.dart';
import 'token_manager.dart';

/// A function which can be used to request a Stream Video API token from your
/// own backend server
typedef GuestTokenProvider = Future<String> Function(UserInfo user);

/// Token designed to store the JWT and the user it is related to.
typedef UserToken = String;

/// A function which can be used to request a Stream Video API token from your
/// own backend server.
/// Function requires a single [userId].
typedef TokenLoader = Future<String> Function(String userId);

typedef OnTokenUpdated = Future<void> Function(UserToken token);

abstract class TokenProvider {
  const TokenProvider();

  factory TokenProvider.static(String token) {
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
    _logger.e(() => '[getToken] token($userId): $token');
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
      await _onTokenUpdated?.call(token);
      return Result.success(token);
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
