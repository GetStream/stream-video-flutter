import 'package:tart/tart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../open_api/video/coordinator/api.dart';
import 'video_error.dart';

/// TODO
mixin VideoErrors {
  /// Composes [VideoError] instance.
  static VideoError compose(Object? exception, [StackTrace? stackTrace]) {
    if (exception is String) {
      return VideoError(
        message: exception,
        stackTrace: stackTrace,
      );
    } else if (exception is TwirpError) {
      return VideoErrorWithCause(
        message: exception.getMsg,
        cause: exception,
        stackTrace: stackTrace,
      );
    } else if (exception is WebSocketChannelException) {
      return VideoErrorWithCause(
        message: exception.message ?? exception.inner?.toString() ?? '',
        cause: exception,
        stackTrace: stackTrace,
      );
    } else if (exception is ApiException) {
      return VideoErrorWithCause(
        message: exception.message ?? exception.toString(),
        cause: exception,
        stackTrace: stackTrace,
      );
    } else if (exception is Exception) {
      return VideoErrorWithCause(
        message: exception.toString(),
        cause: exception,
        stackTrace: stackTrace,
      );
    } else {
      return VideoError(
        message: 'Unexpected error: $exception',
        stackTrace: stackTrace,
      );
    }
  }
}
