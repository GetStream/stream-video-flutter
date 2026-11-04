import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart' show StreamException;

import 'transport_failure.dart'
    if (dart.library.io) 'transport_failure_io.dart';

const _coordinatorRequestKey = 'stream_video.coordinator_request';

/// The `extra` that marks every request a client sends as a coordinator
/// request, whose failures [describeRequestFailure] names.
///
/// Set on the client's `BaseOptions`. A request sent without it, such as the
/// token provider's, is left unnamed.
@internal
Map<String, Object?> coordinatorRequestExtra() => {
  _coordinatorRequestKey: true,
};

/// Whether a request is one [coordinatorRequestExtra] marked.
@internal
extension CoordinatorRequestOptions on RequestOptions {
  /// Whether this request was sent by a coordinator client.
  bool get isCoordinatorRequest => extra[_coordinatorRequestKey] == true;
}

/// The query parameters that identify a request without carrying a
/// credential.
///
/// Everything else is left out, `api_key` among it.
const _diagnosticQueryParameters = {
  'call_session_id',
  'connection_id',
  'session_id',
  'sfu_id',
};

/// [message] with the coordinator request that failed in front of it, or
/// [message] alone for a request that was not one.
///
/// An answer from the server reads
/// `HTTP 404 POST video.stream-io-api.com/api/v2/video/call/default/123/join?connection_id=abc failed: Not Found`,
/// and a failure that never got one
/// `POST video.stream-io-api.com/api/v2/video/call/default/123/join failed: DNS lookup failed — Failed host lookup: 'video.stream-io-api.com' (nodename nor servname provided)`.
///
/// Only the message gains the context. Whatever the failure is classified as —
/// its status, its code, whether it may be retried — is read elsewhere and
/// left alone.
@internal
String describeRequestFailure(DioException exception, String message) {
  final options = exception.requestOptions;
  if (!options.isCoordinatorRequest) return message;

  final request = _describeRequest(options);

  // Only a timeout or a cancellation outranks a response that came with it,
  // the order stream_core classifies them in.
  final isTimeoutOrCancel = switch (exception.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.cancel => true,
    _ => false,
  };
  if (exception.response case final response? when !isTimeoutOrCancel) {
    final status = switch (response.statusCode) {
      final statusCode? => 'HTTP $statusCode ',
      null => '',
    };
    return '$status$request failed: $message';
  }

  return '$request failed: ${_transportFailureOf(exception) ?? message}';
}

/// `METHOD host/path?query` for [options], keeping only the query parameters
/// in [_diagnosticQueryParameters].
///
/// Headers are never read, so neither is the token they carry.
String _describeRequest(RequestOptions options) {
  final uri = options.uri;
  final diagnostic = {
    for (final MapEntry(:key, :value) in uri.queryParametersAll.entries)
      if (_diagnosticQueryParameters.contains(key)) key: value,
  };
  final query = diagnostic.isEmpty
      ? ''
      : '?${Uri(queryParameters: diagnostic).query}';

  return '${options.method} ${uri.host}${uri.path}$query';
}

/// The transport reason for [exception]'s type, or `null` when the type
/// carries none: the answer was read, or the platform error can't be.
String? _transportFailureOf(DioException exception) {
  return switch (exception.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => 'request timed out',
    DioExceptionType.cancel => 'request cancelled',
    DioExceptionType.badCertificate => 'TLS connection failed',
    // The platform error underneath says more when it can be read; on the web
    // there is none, only Dio's account that the connection failed.
    DioExceptionType.connectionError =>
      platformTransportFailureOf(_platformErrorOf(exception)) ??
          'connection failed',
    // Dio reports a failed TLS handshake, among others, as unknown.
    DioExceptionType.unknown => platformTransportFailureOf(
      _platformErrorOf(exception),
    ),
    // The answer arrived; reading it is what failed or ran out of time.
    DioExceptionType.badResponse || DioExceptionType.transformTimeout => null,
  };
}

/// The error the platform raised under [exception].
///
/// Once `ApiErrorInterceptor` has mapped a failure, its `error` is the Stream
/// exception, and what the platform raised sits on the Dio exception that one
/// was mapped from. Only a coordinator request's is unwrapped: a token that
/// could not be fetched also arrives as a Stream exception over a Dio one,
/// but that Dio exception is the app's own request, and its failure is not
/// this request's transport failing.
Object? _platformErrorOf(DioException exception) {
  return switch (exception.error) {
    StreamException(cause: final DioException mapped)
        when mapped.requestOptions.isCoordinatorRequest =>
      mapped.error,
    final error => error,
  };
}
