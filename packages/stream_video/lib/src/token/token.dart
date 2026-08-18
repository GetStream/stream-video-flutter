import 'package:stream_core/stream_core.dart';

import '../errors/video_error_composer.dart';
import '../models/models.dart';

/// A function which can be used to request a Stream Video API token from your
/// own backend server
typedef GuestTokenLoader = Future<String> Function(UserInfo user);

/// A function which can be used to request a Stream Video API token from your
/// own backend server.
/// Function requires a single [userId].
typedef TokenLoader = Future<String> Function(String userId);

/// Result-based convenience wrappers around [TokenManager], bridging its
/// throwing API to the [Result] flow used across the Video SDK.
extension TokenManagerResultExtension on TokenManager {
  /// Refreshes the cached token by loading a new one from the provider.
  Future<UserToken> refreshToken() {
    expireToken(); // Clear the cached token
    return getToken(); // Load a new token from the provider
  }

  /// Returns the token as a [Result], composing any thrown error into a
  /// [Result.failure].
  Future<Result<UserToken>> getTokenAsResult() async {
    try {
      return Result.success(await getToken());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Refreshes the token and returns it as a [Result], composing any thrown
  /// error into a [Result.failure].
  Future<Result<UserToken>> refreshTokenAsResult() async {
    try {
      return Result.success(await refreshToken());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }
}
