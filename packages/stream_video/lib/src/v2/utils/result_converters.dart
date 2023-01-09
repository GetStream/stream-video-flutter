import 'package:stream_video/src/v2/errors/video_error_composer.dart';
import 'package:stream_video/src/v2/utils/result.dart';

/// [Result] builder extensions.
extension ResultBuilder<T> on T {
  /// TODO
  Result<T> asSuccess() {
    return Success(this);
  }

  /// TODO
  Result<Never> asFailure([StackTrace? stackTrace]) {
    return Failure(VideoErrors.compose(this, stackTrace));
  }
}

/// [Future] extensions for [Result] class.
extension ResultAsFuture<T> on Result<T> {
  /// TODO
  Future<Result<T>> asFuture() {
    return Future.value(this);
  }
}
