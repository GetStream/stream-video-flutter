import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart'
    show
        ApiErrorInterceptor,
        DioExceptionMapping,
        StreamApiException,
        StreamClientException,
        StreamCoreHttpClient,
        StreamDioException,
        StreamNetworkException;
import 'package:stream_video/open_api/video/coordinator/api.dart';
import 'package:stream_video/src/errors/request_failure_description.dart';
import 'package:stream_video/src/errors/stream_video_exception.dart';
import 'package:stream_video/src/errors/stream_video_exception_composer.dart';

final _requestOptions = RequestOptions(
  method: 'POST',
  baseUrl: 'https://video.stream-io-api.com',
  path: _path,
  queryParameters: {'api_key': 'api-key-secret', 'connection_id': 'conn-1'},
  headers: {'Authorization': 'user-token-secret'},
  extra: coordinatorRequestExtra(),
);

const _path = '/api/v2/video/call/default/x/join';
const _endpoint = 'POST video.stream-io-api.com$_path?connection_id=conn-1';

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
      expect(
        error.message,
        "HTTP 403 $_endpoint failed: You don't have permission to join",
      );
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
      expect(error.message, 'HTTP 401 $_endpoint failed: token expired');
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
      // Naming the request changes the message and nothing it is read by.
      expect(error.message, 'HTTP 429 $_endpoint failed: too many requests');
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

  // Without the request, "Not Found" or "the request timed out" leaves an
  // integrator guessing which of a dozen coordinator calls failed.
  group('names the coordinator request that failed', () {
    StreamVideoException compose(DioException error) =>
        StreamVideoExceptions.compose(_intercepted(error));

    for (final (statusCode, reason) in [
      (404, 'Not Found'),
      (503, 'Service Unavailable'),
    ]) {
      test('in an HTTP $statusCode a proxy answered with', () {
        final error = compose(
          DioException(
            requestOptions: _requestOptions,
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: _requestOptions,
              statusCode: statusCode,
              statusMessage: reason,
              data: '<html>$reason</html>',
            ),
          ),
        );

        expect(error.message, 'HTTP $statusCode $_endpoint failed: $reason');
        // Only the message changes; the verdict is read as before.
        expect(error.apiStatusCode, statusCode);
      });
    }

    test('keeps whether the server called the failure unrecoverable', () {
      final error = compose(
        DioException(
          requestOptions: _requestOptions,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: _requestOptions,
            statusCode: 400,
            data: {
              ..._errorBody(400, 4, 'bad request'),
              'unrecoverable': true,
            },
          ),
        ),
      );

      expect(error.message, 'HTTP 400 $_endpoint failed: bad request');
      expect(error.isUnrecoverable, isTrue);
      expect(error.apiErrorCode, 4);
    });

    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
    ]) {
      test('in a ${type.name}', () {
        final error = compose(
          DioException(
            requestOptions: _requestOptions,
            type: type,
            message: 'dio boilerplate about the timeout',
          ),
        );

        expect(error.message, '$_endpoint failed: request timed out');
        final cause = (error as StreamVideoExceptionWithCause).cause;
        expect((cause as StreamNetworkException).isTimeout, isTrue);
      });
    }

    // stream_core reads a timeout before a response, and so does this.
    test('in a timeout that came with a response', () {
      final error = compose(
        DioException(
          requestOptions: _requestOptions,
          type: DioExceptionType.receiveTimeout,
          response: Response(requestOptions: _requestOptions, statusCode: 200),
        ),
      );

      expect(error.message, '$_endpoint failed: request timed out');
    });

    test('in a cancellation', () {
      final error = compose(
        DioException.requestCancelled(
          requestOptions: _requestOptions,
          reason: 'left the call',
        ),
      );

      expect(error.message, '$_endpoint failed: request cancelled');
    });

    test('in a failed DNS lookup', () {
      final error = compose(
        DioException.connectionError(
          requestOptions: _requestOptions,
          reason: 'dio boilerplate',
          error: const SocketException(
            "Failed host lookup: 'video.stream-io-api.com'",
            osError: OSError('nodename nor servname provided', 8),
          ),
        ),
      );

      expect(
        error.message,
        '$_endpoint failed: DNS lookup failed — '
        "Failed host lookup: 'video.stream-io-api.com' "
        '(nodename nor servname provided)',
      );
    });

    test('in a refused connection', () {
      final error = compose(
        DioException.connectionError(
          requestOptions: _requestOptions,
          reason: 'dio boilerplate',
          error: const SocketException(
            'Connection refused',
            osError: OSError('Connection refused', 61),
          ),
        ),
      );

      expect(
        error.message,
        '$_endpoint failed: connection failed — Connection refused',
      );
    });

    // Dio reports a connection the peer reset mid-request as unknown.
    test('in a connection reset', () {
      final error = compose(
        DioException(
          requestOptions: _requestOptions,
          error: const SocketException(
            'Connection reset by peer',
            osError: OSError('Connection reset by peer', 54),
          ),
        ),
      );

      expect(
        error.message,
        '$_endpoint failed: connection failed — Connection reset by peer',
      );
    });

    test('in a connection closed before the response', () {
      final error = compose(
        DioException(
          requestOptions: _requestOptions,
          error: const HttpException(
            'Connection closed before full header was received',
          ),
        ),
      );

      expect(
        error.message,
        '$_endpoint failed: connection failed — '
        'Connection closed before full header was received',
      );
    });

    // The shape dart:io reports a refused certificate in: the reason is in
    // the OS error, behind a line break, and Dio files it as unknown.
    test('in a failed TLS handshake', () {
      final error = compose(
        DioException(
          requestOptions: _requestOptions,
          error: const HandshakeException(
            'Handshake error in client',
            OSError(
              '\n\tCERTIFICATE_VERIFY_FAILED: certificate has expired',
              1,
            ),
          ),
        ),
      );

      expect(
        error.message,
        '$_endpoint failed: TLS connection failed — Handshake error in client '
        '(CERTIFICATE_VERIFY_FAILED: certificate has expired)',
      );
    });

    test('in a certificate the app refused', () {
      final error = compose(
        DioException.badCertificate(requestOptions: _requestOptions),
      );

      expect(error.message, '$_endpoint failed: TLS connection failed');
    });

    test('in a connection error it cannot read further', () {
      final error = compose(
        DioException.connectionError(
          requestOptions: _requestOptions,
          reason: 'dio boilerplate',
        ),
      );

      expect(error.message, '$_endpoint failed: connection failed');
    });

    test('keeps the message of an exception an interceptor threw', () {
      final error = compose(
        DioException(
          requestOptions: _requestOptions,
          error: const StreamClientException(message: 'no token to sign with'),
        ),
      );

      expect(error.message, '$_endpoint failed: no token to sign with');
    });

    // A token provider's own request failing is why this request never left,
    // not this request's transport failing — and that request's host is the
    // app's, not the coordinator's.
    test('does not read a token fetch failure as its own', () {
      final tokenRequest = RequestOptions(
        baseUrl: 'https://my-backend.example',
        path: '/token',
      );

      final error = StreamVideoExceptions.compose(
        DioException(
          requestOptions: _requestOptions,
          error: StreamNetworkException(
            message: 'The token could not be fetched',
            cause: DioException.connectionError(
              requestOptions: tokenRequest,
              reason: 'dio boilerplate',
              error: const SocketException(
                "Failed host lookup: 'my-backend.example'",
              ),
            ),
          ),
        ),
      );

      expect(
        error.message,
        '$_endpoint failed: The token could not be fetched',
      );
    });

    test('leaves a request that is not the coordinator unnamed', () {
      final appRequest = RequestOptions(
        baseUrl: 'https://my-backend.example',
        path: '/token/user-secret-path',
      );

      final error = compose(
        DioException(
          requestOptions: appRequest,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: appRequest,
            statusCode: 500,
            statusMessage: 'Internal Server Error',
          ),
        ),
      );

      expect(error.message, 'Internal Server Error');
    });

    test('keeps the diagnostic query parameters and drops the rest', () {
      final options = RequestOptions(
        method: 'GET',
        baseUrl: 'https://video.stream-io-api.com',
        path: '/api/v2/video/call/default/x',
        queryParameters: {
          'api_key': 'api-key-secret',
          'call_session_id': 'session-1',
          'sfu_id': 'sfu-1',
          'user_id': 'user-1',
        },
        extra: coordinatorRequestExtra(),
      );

      final error = compose(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
        ),
      );

      const query = '?call_session_id=session-1&sfu_id=sfu-1';
      expect(
        error.message,
        'GET video.stream-io-api.com/api/v2/video/call/default/x$query '
        'failed: request timed out',
      );
    });

    test('never carries the API key, the token or credentials in the URL', () {
      final withUserInfo = RequestOptions(
        method: 'POST',
        baseUrl: 'https://user:url-password@video.stream-io-api.com',
        path: '/api/v2/video/call/default/x/join',
        queryParameters: {'api_key': 'api-key-secret'},
        extra: coordinatorRequestExtra(),
      );

      final errors = [
        compose(
          DioException(
            requestOptions: _requestOptions,
            type: DioExceptionType.connectionTimeout,
          ),
        ),
        compose(
          DioException(
            requestOptions: _requestOptions,
            response: Response(
              requestOptions: _requestOptions,
              statusCode: 403,
              data: _errorBody(403, 17, 'no permission'),
            ),
          ),
        ),
        compose(
          DioException(
            requestOptions: withUserInfo,
            type: DioExceptionType.connectionTimeout,
          ),
        ),
      ];

      for (final error in errors) {
        for (final rendered in [error.message, error.toString()]) {
          expect(rendered, isNot(contains('api-key-secret')));
          expect(rendered, isNot(contains('api_key')));
          expect(rendered, isNot(contains('user-token-secret')));
          expect(rendered, isNot(contains('url-password')));
        }
      }
    });

    // The shapes above are built by hand; these go through a client set up
    // the way the coordinator's is, so the marker, the query the request
    // gains and ApiErrorInterceptor's wrapping are the real ones.
    group('through a coordinator client', () {
      Future<StreamVideoException> failedPost(_Adapter adapter) async {
        final client = StreamCoreHttpClient(
          options: BaseOptions(
            baseUrl: 'https://video.stream-io-api.com',
            extra: coordinatorRequestExtra(),
          ),
          interceptors: [const ApiErrorInterceptor()],
          httpClientAdapter: adapter,
        );

        try {
          await client.post<Object?>(
            '/api/v2/video/call/default/x/join',
            queryParameters: {
              'api_key': 'api-key-secret',
              'connection_id': 'conn-1',
            },
            // What the generated API passes on every request.
            options: Options(extra: <String, dynamic>{}),
          );
        } on DioException catch (e, stk) {
          return StreamVideoExceptions.compose(e, stk);
        }
        fail('the request was expected to fail');
      }

      test('names a failed DNS lookup', () async {
        final error = await failedPost(
          _Adapter.throwing(
            const SocketException(
              "Failed host lookup: 'video.stream-io-api.com'",
            ),
          ),
        );

        expect(
          error.message,
          '$_endpoint failed: DNS lookup failed — '
          "Failed host lookup: 'video.stream-io-api.com'",
        );
      });

      test('names an HTTP error a proxy answered with', () async {
        final error = await failedPost(
          _Adapter.answering(502, '<html>Bad Gateway</html>'),
        );

        expect(error.message, startsWith('HTTP 502 $_endpoint failed: '));
        expect(error.apiStatusCode, 502);
      });
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

/// Answers every request the same way, without a network.
class _Adapter implements HttpClientAdapter {
  _Adapter.throwing(Exception this._error) : _statusCode = 0, _body = '';

  _Adapter.answering(this._statusCode, this._body) : _error = null;

  final Exception? _error;
  final int _statusCode;
  final String _body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (_error case final error?) throw error;
    return ResponseBody.fromString(_body, _statusCode);
  }

  @override
  void close({bool force = false}) {}
}
