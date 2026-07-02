import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tart/tart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../open_api/video/coordinator/api.dart';
import '../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../sfu/data/events/sfu_event_mapper_extensions.dart';
import '../sfu/data/models/sfu_error.dart';
import 'video_error.dart';

mixin VideoErrors {
  /// Composes [VideoError] instance.
  static VideoError compose(Object? exception, [StackTrace? stackTrace]) {
    if (exception is String) {
      return VideoError(
        message: exception,
        stackTrace: stackTrace,
      );
    } else if (exception is sfu_models.Error) {
      return VideoErrorWithCause(
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
    } else if (exception is DioException) {
      final apiError = _streamApiErrorOf(exception);
      return VideoErrorWithCause(
        message: apiError?.message ?? exception.message ?? exception.toString(),
        cause: apiError ?? exception,
        stackTrace: stackTrace ?? exception.stackTrace,
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

  /// Extracts a typed [StreamApiError] from the Stream error envelope carried by
  /// a [DioException] response body, or `null` for transport-level failures
  /// (timeouts, connection errors) that have no parseable error payload.
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
