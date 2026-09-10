import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart'
    show
        DioExceptionMapping,
        StreamApiException,
        StreamDioException,
        StreamNetworkException;
import 'package:stream_video/open_api/video/coordinator/api.dart';
import 'package:stream_video/src/errors/stream_video_exception.dart';
import 'package:stream_video/src/errors/stream_video_exception_composer.dart';

final _requestOptions = RequestOptions(path: '/video/call/default/x/join');

/// The wire form of a coordinator HTTP error: the error object *is* the body.
Map<String, dynamic> _errorBody(int statusCode, int code, String message) {
  return {
    'code': code,
    'details': <int>[],
    'duration': '1ms',
    'message': message,
    'more_info': 'https://getstream.io/docs',
    'StatusCode': statusCode,
  };
}

/// Wraps [error] the way `ApiErrorInterceptor` does, so what reaches the
/// composer is shaped as it is inside the HTTP client.
StreamDioException _intercepted(DioException error) {
  return StreamDioException(
    exception: error.toStreamException(),
    requestOptions: error.requestOptions,
    response: error.response,
    type: error.type,
    message: error.message,
  );
}

void main() {
  group('StreamVideoExceptions.compose', () {
    test('exposes a coordinator HTTP error through the accessors', () {
      final dioError = DioException(
        requestOptions: _requestOptions,
        message: 'dio boilerplate about status code 403',
        response: Response(
          requestOptions: _requestOptions,
          statusCode: 403,
          data: _errorBody(403, 17, "You don't have permission to join"),
        ),
      );

      final error = StreamVideoExceptions.compose(_intercepted(dioError));

      // Without this the failure looks like a transport error, so the retry
      // manager cannot tell a 403 from a retryable one — and the server's
      // reason never reaches the log.
      expect(error, isA<StreamVideoExceptionWithCause>());
      expect(error.apiStatusCode, 403);
      expect(error.apiErrorCode, 17);
      expect(error.message, "You don't have permission to join");
      // The parsed payload stays reachable for anything that wants it whole.
      expect(error.apiError?.statusCode, 403);
    });

    test('still unwraps the enveloped form', () {
      final dioError = DioException(
        requestOptions: _requestOptions,
        response: Response(
          requestOptions: _requestOptions,
          statusCode: 401,
          data: {'error': _errorBody(401, 40, 'token expired')},
        ),
      );

      final error = StreamVideoExceptions.compose(_intercepted(dioError));

      expect(error.apiStatusCode, 401);
      expect(error.apiErrorCode, 40);
      expect(error.message, 'token expired');
      expect(error.apiError?.statusCode, 401);
    });

    // Every coordinator call runs through `runApiSafely`, which fails with a
    // `StreamException` rather than a `DioException`. Without unwrapping it the
    // cause stays a `StreamApiException`, and every `cause is StreamApiError`
    // check in the SDK — the retry manager's, the join path's — goes blind.
    test('keeps what a StreamApiException carries', () {
      final apiError = StreamApiError.fromJson(
        _errorBody(403, 17, "You don't have permission to join"),
      );

      final error = StreamVideoExceptions.compose(
        StreamApiException.fromApiError(apiError),
      );

      expect(error.apiStatusCode, 403);
      expect(error.apiErrorCode, 17);
      expect(error.apiError, apiError);
      expect(error.message, "You don't have permission to join");
    });

    // The server's `Retry-After` is the only thing that knows when a rate
    // limit lifts. Unwrapping the failure to its payload used to drop it,
    // because the payload has no field for it.
    test('keeps the retry hint the server sent', () {
      final dioError = DioException(
        requestOptions: _requestOptions,
        response: Response(
          requestOptions: _requestOptions,
          statusCode: 429,
          headers: Headers.fromMap({
            'retry-after': ['7'],
          }),
          data: _errorBody(429, 9, 'too many requests'),
        ),
      );

      final error = StreamVideoExceptions.compose(_intercepted(dioError));

      expect(error.apiStatusCode, 429);
      expect(error.retryAfter, const Duration(seconds: 7));
    });

    test('reports no retry hint when the server sent none', () {
      final dioError = DioException(
        requestOptions: _requestOptions,
        response: Response(
          requestOptions: _requestOptions,
          statusCode: 429,
          data: _errorBody(429, 9, 'too many requests'),
        ),
      );

      final error = StreamVideoExceptions.compose(_intercepted(dioError));

      expect(error.retryAfter, isNull);
    });

    test('keeps a StreamException that carries no payload', () {
      final error = StreamVideoExceptions.compose(
        const StreamNetworkException(message: 'the connection dropped'),
      );

      final cause = (error as StreamVideoExceptionWithCause).cause;
      expect(cause, isA<StreamNetworkException>());
      expect(error.message, 'the connection dropped');
    });

    test('keeps the transport failure when there is no API error', () {
      final dioError = DioException(
        requestOptions: _requestOptions,
        type: DioExceptionType.connectionTimeout,
        message: 'connection timed out',
      );

      final error = StreamVideoExceptions.compose(_intercepted(dioError));

      // A failure that never reached a server verdict stays a transport
      // failure, so the retry manager keeps treating it as retryable.
      final cause = (error as StreamVideoExceptionWithCause).cause;
      expect(cause, isA<StreamNetworkException>());
      expect((cause as StreamNetworkException).isTimeout, isTrue);
      // The Dio failure it was mapped from stays reachable underneath.
      expect(cause.cause, isA<DioException>());
    });
  });

  // Keeping the mapped exception as the cause means `toString()` would print
  // that exception's own cause chain, whose bottom is a Dio exception that
  // embeds a stack trace. The cause is rendered as a one-line summary instead,
  // so the chain cannot leak into logs or into uploaded traces.
  group('StreamVideoException.toString', () {
    test('summarises the cause instead of unrolling its chain', () {
      final apiError = StreamApiError.fromJson(
        _errorBody(403, 17, 'no permission'),
      );
      final error = StreamVideoExceptionWithCause(
        message: apiError.message,
        cause: StreamApiException.fromApiError(
          apiError,
          cause: DioException(
            requestOptions: _requestOptions,
            message: 'dio boilerplate about status code 403',
          ),
        ),
      );

      final rendered = error.toString();

      // The facts a reader needs are all there.
      expect(rendered, contains('403'));
      expect(rendered, contains('17'));
      expect(rendered, contains('no permission'));
      // The nested Dio exception and its chain are not.
      expect(rendered, isNot(contains('DioException')));
      expect(rendered, isNot(contains('caused by')));
      expect(rendered.length, lessThan(200));
    });
  });
}
