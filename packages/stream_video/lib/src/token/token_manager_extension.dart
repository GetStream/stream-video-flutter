import 'package:stream_core/stream_core.dart';

import '../errors/video_error_composer.dart';
import '../logger/impl/tagged_logger.dart';

final _logger = taggedLogger(tag: 'SV:TokenManager');

/// Result-based convenience wrappers around [TokenManager], bridging its
/// throwing API to the [Result] flow used across the Video SDK.
///
/// Internal to the SDK — this file is deliberately not exported from the
/// package barrel. Note that if [TokenManager] ever gains instance members
/// with these names, they will silently shadow this extension.
extension TokenManagerResultExtension on TokenManager {
  /// Discards the cached token and loads a fresh one from the provider.
  ///
  /// [TokenManager] serializes loads and only holds a cached token while no
  /// load is in flight, so the returned token is always the result of a
  /// provider fetch that started at or after this call — never the token that
  /// was just expired. Concurrent refreshes are therefore safe, though each
  /// one arriving after a completed refresh costs one more provider fetch.
  ///
  /// A provider that returns the same value on every load (a static token, or
  /// the memoized guest token) still yields that same token back.
  Future<UserToken> refreshToken() {
    expireToken();
    return getToken();
  }

  /// Returns the token as a [Result], composing any thrown error into a
  /// logged [Result.failure].
  Future<Result<UserToken>> getTokenAsResult() async {
    try {
      return Result.success(await getToken());
    } catch (e, stk) {
      _logger.e(() => '[getToken] failed: $e; $stk');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Refreshes the token and returns it as a [Result], composing any thrown
  /// error into a logged [Result.failure].
  Future<Result<UserToken>> refreshTokenAsResult() async {
    try {
      return Result.success(await refreshToken());
    } catch (e, stk) {
      _logger.e(() => '[refreshToken] failed: $e; $stk');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }
}
