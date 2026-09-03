import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart'
    show StreamDioException, StreamDioExceptionExtension;
import 'package:stream_video/open_api/video/coordinator/api.dart';
import 'package:stream_video/src/errors/video_error.dart';
import 'package:stream_video/src/errors/video_error_composer.dart';

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
    exception: error.toClientException(),
    requestOptions: error.requestOptions,
    response: error.response,
    type: error.type,
    message: error.message,
  );
}

void main() {
  group('VideoErrors.compose', () {
    test('unwraps a coordinator HTTP error into a StreamApiError', () {
      final dioError = DioException(
        requestOptions: _requestOptions,
        message: 'dio boilerplate about status code 403',
        response: Response(
          requestOptions: _requestOptions,
          statusCode: 403,
          data: _errorBody(403, 17, "You don't have permission to join"),
        ),
      );

      final error = VideoErrors.compose(_intercepted(dioError));

      // Without this the cause stays a transport exception, so the retry
      // manager cannot tell a 403 from a retryable failure — and the server's
      // reason never reaches the log.
      expect(error, isA<VideoErrorWithCause>());
      final cause = (error as VideoErrorWithCause).cause;
      expect(cause, isA<StreamApiError>());
      expect((cause as StreamApiError).statusCode, 403);
      expect(cause.code, 17);
      expect(error.message, "You don't have permission to join");
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

      final error = VideoErrors.compose(_intercepted(dioError));

      final cause = (error as VideoErrorWithCause).cause;
      expect(cause, isA<StreamApiError>());
      expect((cause as StreamApiError).statusCode, 401);
      expect(error.message, 'token expired');
    });

    test('keeps the transport exception when there is no API error', () {
      final dioError = DioException(
        requestOptions: _requestOptions,
        type: DioExceptionType.connectionTimeout,
        message: 'connection timed out',
      );

      final error = VideoErrors.compose(_intercepted(dioError));

      expect((error as VideoErrorWithCause).cause, isA<DioException>());
      expect(error.message, 'connection timed out');
    });
  });
}
