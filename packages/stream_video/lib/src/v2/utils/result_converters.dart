import 'package:stream_video/src/v2/errors/video_error_composer.dart';
import 'package:stream_video/src/v2/utils/result.dart';

/// [Result] builder extensions.
extension ResultBuilder<T> on T {
  /// TODO
  Result<T> toSuccess() {
    return Success(this);
  }

  /// TODO
  Failure toFailure([StackTrace? stackTrace]) {
    return Failure(VideoErrors.compose(this, stackTrace));
  }
}

/// [Future] extensions for [Result] class.
extension ResultAsFuture<T> on Result<T> {
  /// TODO
  Future<Result<T>> toFuture() {
    return Future.value(this);
  }
}
