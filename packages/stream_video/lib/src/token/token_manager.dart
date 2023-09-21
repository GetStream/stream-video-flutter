import 'package:async/async.dart' as async;
import 'package:meta/meta.dart';

import '../../stream_video.dart';
import '../utils/cancelable_operation.dart';
import '../utils/future.dart';

const _emptyUserId = 'stream:none';

/// Handles common token operations
@internal
class TokenManager {
  /// Initialize a new token manager
  TokenManager();

  final _logger = taggedLogger(tag: 'SV:TokenManager');

  String _userId = _emptyUserId;

  TokenProvider _provider = _StubTokenProvider();

  UserToken? _token;

  /// User id to which this TokenManager is configured to
  String get userId => _userId;

  /// Sets a token provider
  Future<Result<UserToken>> setTokenProvider(
    String userId, {
    required TokenProvider tokenProvider,
  }) async {
    _logger.d(() => '[setProvider] userId: $userId, provider: $tokenProvider');
    _userId = userId;
    _provider = tokenProvider;
    return getToken();
  }

  async.CancelableOperation<Result<UserToken>>? _provideToken;

  /// Returns the token refreshing the existing one if [refresh] is true
  Future<Result<UserToken>> getToken({bool refresh = false}) async {
    _logger.d(() => '[getToken] refresh: $refresh, _token: $_token');
    if (refresh || _token == null) {
      final result = await provideToken();
      _logger.v(() => '[getToken] completed: $result');
      if (result is! Success<UserToken>) {
        return result;
      }
      _token = result.data;
    }
    return Result.success(_token!);
  }

  Future<Result<UserToken>> provideToken() async {
    if (_provideToken == null) {
      _logger.d(() => '[provideToken] _userId: $_userId');
      _provideToken = _provider.getToken(_userId).asCancelable();
    }
    return _provideToken!.valueOrDefault(
      Result.error('provideToken was cancelled'),
    );
  }

  /// Returns the token refreshing the existing one.
  Future<Result<UserToken>> refreshToken() {
    _logger.d(() => '[refreshToken] no args');
    return getToken(refresh: true);
  }

  /// Resets the token manager
  void reset() {
    _logger.d(() => '[reset] no args');
    _provideToken?.cancel();
    _userId = _emptyUserId;
    _provider = _StubTokenProvider();
    _token = null;
  }
}

class _StubTokenProvider implements TokenProvider {
  factory _StubTokenProvider() {
    return _instance;
  }

  const _StubTokenProvider._();

  static const _StubTokenProvider _instance = _StubTokenProvider._();

  @override
  bool get isStatic => true;

  @override
  Future<Result<UserToken>> getToken(String userId) async {
    return Result.error('StubTokenProvider is unable to provide a real token');
  }

  @override
  set onTokenUpdated(OnTokenUpdated onTokenUpdated) {
    /* no-op */
  }
}

class AnonymousTokenProvider implements TokenProvider {
  factory AnonymousTokenProvider() {
    return _instance;
  }

  const AnonymousTokenProvider._();

  static const AnonymousTokenProvider _instance = AnonymousTokenProvider._();

  @override
  bool get isStatic => false;

  @override
  Future<Result<UserToken>> getToken(String userId) async {
    return Result.success(UserToken.anonymous(userId: userId));
  }

  @override
  set onTokenUpdated(OnTokenUpdated onTokenUpdated) {
    /* no-op */
  }
}
