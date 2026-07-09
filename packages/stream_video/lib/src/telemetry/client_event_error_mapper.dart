import 'dart:async';

import 'package:dio/dio.dart';

import '../errors/video_error.dart';
import '../sfu/data/models/sfu_error.dart';
import 'client_event_types.dart';

/// Maps thrown SDK errors to the spec's standard failure codes.
class ClientEventErrorMapper {
  const ClientEventErrorMapper();

  ClientEventFailure map(Object? error) {
    final cause = error is VideoErrorWithCause ? error.cause : error;

    if (cause is SfuError) {
      return ClientEventFailure(
        ClientEventStandardCode.sfuError,
        '${cause.code.name}: ${cause.message}',
      );
    }

    if (cause is TimeoutException) {
      return ClientEventFailure.requestTimeout(
        cause.message ?? 'Request timed out',
      );
    }

    if (cause is DioException) {
      final status = cause.response?.statusCode;
      if (status != null) {
        return ClientEventFailure(
          ClientEventStandardCode.serverError,
          'HTTP $status: ${cause.message ?? cause.type.name}',
        );
      }
      // No response: distinguish timeout from a connectivity failure.
      switch (cause.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ClientEventFailure.requestTimeout(
            cause.message ?? 'Request timed out',
          );
        case DioExceptionType.connectionError:
          return const ClientEventFailure(
            ClientEventStandardCode.networkOffline,
            'Device offline',
          );
        default:
          break;
      }
    }

    if (cause != null && _looksOffline(cause)) {
      return const ClientEventFailure(
        ClientEventStandardCode.networkOffline,
        'Device offline',
      );
    }

    final reason = error is VideoError
        ? error.message
        : (error?.toString() ?? 'Unknown error');
    return ClientEventFailure(ClientEventStandardCode.serverError, reason);
  }

  /// Whether [cause] looks like a device-offline / no-route failure.
  bool _looksOffline(Object cause) {
    final message = cause.toString().toLowerCase();
    return message.contains('failed host lookup') ||
        message.contains('network is unreachable') ||
        message.contains('no address associated with hostname') ||
        message.contains('software caused connection abort') ||
        message.contains('connection refused') ||
        message.contains('no internet');
  }
}
