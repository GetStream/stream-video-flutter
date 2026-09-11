import 'dart:async';

import 'package:stream_core/stream_core.dart';

import '../errors/stream_video_exception.dart';
import '../sfu/data/models/sfu_error.dart';
import 'client_event_types.dart';

/// Maps thrown SDK errors to the spec's standard failure codes.
class ClientEventErrorMapper {
  const ClientEventErrorMapper();

  ClientEventFailure map(Object? error) {
    if (error is StreamVideoException) {
      // The SFU's own verdict is the most specific account of a failure.
      if (error.sfuError case final sfuError?) {
        return ClientEventFailure(
          ClientEventStandardCode.sfuError,
          '${sfuError.code.name}: ${sfuError.message}',
        );
      }

      if (error.streamException case final exception?) {
        return _fromStreamException(exception, error.message);
      }
    }

    // Something handed straight to the reporter, without going through this
    // SDK's error composition.
    if (StreamException.tryFrom(error) case final exception?) {
      return _fromStreamException(exception, exception.message);
    }

    final cause = error is StreamVideoException
        ? error.rawCause ?? error
        : error;

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

    final reason = error is StreamVideoException
        ? error.message
        : (error?.toString() ?? 'Unknown error');
    return ClientEventFailure(ClientEventStandardCode.serverError, reason);
  }

  /// Classifies a `stream_core` failure by the facts it carries.
  ///
  /// [reason] is what to report when the exception says no more than that
  /// something went wrong.
  ClientEventFailure _fromStreamException(
    StreamException exception,
    String reason,
  ) {
    return switch (exception) {
      // The request did not complete in time, which is not a verdict on it.
      StreamNetworkException(isTimeout: true) =>
        ClientEventFailure.requestTimeout(exception.message),

      // Nothing failed — the SDK stopped asking.
      StreamNetworkException(isCancelled: true) =>
        ClientEventFailure.clientAborted(exception.message),

      // Never reached a verdict: a dropped connection, no route to the host.
      StreamNetworkException() => const ClientEventFailure(
        ClientEventStandardCode.networkOffline,
        'Device offline',
      ),

      // A server answered, so report what it said. 408 is the server naming
      // the timeout the row above infers.
      StreamApiException(statusCode: 408) => ClientEventFailure.requestTimeout(
        exception.message,
      ),
      StreamApiException(:final statusCode) => ClientEventFailure(
        ClientEventStandardCode.serverError,
        'HTTP $statusCode: ${exception.message}',
      ),

      // Credentials, or a failure inside the SDK. Neither has a code of its
      // own in the spec.
      _ => ClientEventFailure(ClientEventStandardCode.serverError, reason),
    };
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
