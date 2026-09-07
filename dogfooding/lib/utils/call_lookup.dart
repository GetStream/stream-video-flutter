// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Whether [call] already exists on the backend.
///
/// The lobby needs this before it offers anything: encryption is fixed when a
/// call is created, so the mode is only a choice for a call that does not
/// exist yet. For one that does, it is already decided and the lobby's job is
/// to say what it is.
///
/// A [Failure] means the lookup never got an answer. Callers must not read
/// that as "does not exist": creating over a call that is already running
/// would replace its settings — including its encryption mode — for everyone
/// already in it.
Future<Result<bool>> lookupCallExists(Call call) async {
  final lookup = await call.get();

  return lookup.fold(
    success: (_) => const Result.success(true),
    failure: (failure) =>
        _isNotFound(failure.error) ? const Result.success(false) : failure,
  );
}

/// The coordinator answers a lookup for a call that was never created with a
/// 404. Any other status is a real failure and says nothing about existence.
bool _isNotFound(VideoError error) {
  if (error is! VideoErrorWithCause) return false;

  final cause = error.cause;
  return cause is ApiException && cause.code == 404;
}
