import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stream_core/stream_core.dart'
    show DioExceptionMapping, StreamApiException, StreamException;
import 'package:tart/tart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../open_api/video/coordinator/api.dart';
import '../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../sfu/data/events/sfu_event_mapper_extensions.dart';
import '../sfu/data/models/sfu_error.dart';
import 'stream_video_exception.dart';

mixin StreamVideoExceptions {
  /// Composes [StreamVideoException] instance.
  static StreamVideoException compose(
    Object? exception, [
    StackTrace? stackTrace,
  ]) {
    if (exception is String) {
      return StreamVideoException(
        message: exception,
        stackTrace: stackTrace,
      );
    } else if (exception is sfu_models.Error) {
      return StreamVideoExceptionWithCause(
        message: exception.message,
        cause: SfuError(
          message: exception.message,
          code: exception.code.toDomain(),
          shouldRetry: exception.shouldRetry,
          reconnectStrategy: SfuReconnectionStrategy.unspecified,
        ),
        stackTrace: stackTrace,
      );
    } else if (exception is TwirpError) {
      return StreamVideoExceptionWithCause(
        message: exception.getMsg,
        cause: exception,
        stackTrace: stackTrace,
      );
    } else if (exception is WebSocketChannelException) {
      return StreamVideoExceptionWithCause(
        message: exception.message ?? exception.inner?.toString() ?? '',
        cause: exception,
        stackTrace: stackTrace,
      );
    } else if (exception is DioException) {
      final mapped = exception.toStreamException();
      final enveloped = _streamApiErrorOf(exception);

      final cause = switch (mapped) {
        StreamApiException(apiError: null, :final retryAfter)
            when enveloped != null =>
          StreamApiException.fromApiError(
            enveloped,
            retryAfter: retryAfter,
            cause: exception,
          ),
        _ => mapped,
      };

      return StreamVideoExceptionWithCause(
        message: cause.message,
        cause: cause,
        stackTrace: stackTrace ?? exception.stackTrace,
      );
    } else if (exception is StreamException) {
      return StreamVideoExceptionWithCause(
        message: exception.message,
        cause: exception,
        stackTrace: stackTrace,
      );
    } else if (exception is Exception) {
      return StreamVideoExceptionWithCause(
        message: exception.toString(),
        cause: exception,
        stackTrace: stackTrace,
      );
    } else {
      return StreamVideoException(
        message: 'Unexpected error: $exception',
        stackTrace: stackTrace,
      );
    }
  }

  /// Extracts a typed [StreamApiError] from the `{"error": ...}` envelope
  /// carried by a [DioException] response body, or `null` for a body that is
  /// not one — including the transport-level failures (timeouts, connection
  /// errors) that carry no payload at all.
  static StreamApiError? _streamApiErrorOf(DioException exception) {
    final data = exception.response?.data;

    Map<String, dynamic>? body;
    if (data is Map<String, dynamic>) {
      body = data;
    } else if (data is String && data.isNotEmpty) {
      try {
        body = json.decode(data) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }

    final errorObj = body?['error'];
    if (errorObj is! Map<String, dynamic>) return null;

    try {
      return StreamApiError.fromJson(errorObj);
    } catch (_) {
      return null;
    }
  }
}
