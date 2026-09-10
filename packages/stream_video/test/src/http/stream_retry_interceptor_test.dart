import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/http/stream_auth_interceptor.dart';
import 'package:stream_video/src/http/stream_retry_interceptor.dart';
import 'package:stream_video/src/retry/retry_policy.dart';

/// Answers every request with [_response], counting the attempts.
class _CountingAdapter implements HttpClientAdapter {
  _CountingAdapter(this._response);

  final ResponseBody Function() _response;
  int attempts = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    attempts++;
    try {
      return _response();
    } on DioException catch (exception) {
      // Real Dio stamps the options it was called with onto the failure, and
      // the retry state travels in `options.extra`. A fake that dropped them
      // would restart the budget on every attempt.
      throw exception.copyWith(requestOptions: options);
    }
  }

  @override
  void close({bool force = false}) {}
}

final _json = {
  Headers.contentTypeHeader: [Headers.jsonContentType],
};

/// A refusal carrying the server's error payload.
ResponseBody _refused(
  int status, {
  int code = 4,
  bool? unrecoverable,
  Map<String, List<String>>? headers,
}) {
  return ResponseBody.fromString(
    jsonEncode({
      'code': code,
      'details': <int>[],
      'duration': '1ms',
      'message': 'refused',
      'more_info': '',
      'StatusCode': status,
      if (unrecoverable != null) 'unrecoverable': unrecoverable,
    }),
    status,
    headers: {..._json, ...?headers},
  );
}

/// A refusal from something that is not the Stream API — an edge or a proxy —
/// so there is a status but no payload to read a code from.
ResponseBody _bare(int status) =>
    ResponseBody.fromString('gateway says no', status);

Duration _noBackoff(RetryConfig config, int retryAttempt) => Duration.zero;

void main() {
  /// Sends one request through a client that always gets [response], returning
  /// how many attempts went out.
  Future<int> attemptsFor(
    ResponseBody Function() response, {
    RetryPolicy? policy,
    int rpcMaxRetries = 3,
  }) async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.invalid'));
    final adapter = _CountingAdapter(response);
    dio.httpClientAdapter = adapter;
    dio.interceptors.addAll([
      const ApiErrorInterceptor(),
      StreamRetryInterceptor(
        dio: dio,
        policy:
            policy ??
            RetryPolicy(
              config: RetryConfig(rpcMaxRetries: rpcMaxRetries),
              backoff: _noBackoff,
            ),
      ),
    ]);

    try {
      await dio.get<dynamic>('/x');
    } on DioException catch (_) {
      // The failure is the point; the attempt count is what is asserted.
    }
    return adapter.attempts;
  }

  group('honours the server verdict', () {
    test('stops on a 5xx the server marked unrecoverable', () async {
      // The status alone would have this retried.
      expect(await attemptsFor(() => _refused(500, unrecoverable: true)), 1);
    });

    test('retries a 5xx the server did not mark', () async {
      expect(await attemptsFor(() => _refused(500)), 3);
    });

    // `unrecoverable` is one-way: the backend declares it `omitempty`, so it is
    // either `true` or missing. A `false` leaves the status in charge.
    test('does not read a false verdict as permission to retry', () async {
      expect(await attemptsFor(() => _refused(400, unrecoverable: false)), 1);
      expect(await attemptsFor(() => _refused(500, unrecoverable: false)), 3);
    });

    test('falls back to the status when the server said nothing', () async {
      expect(await attemptsFor(() => _refused(400)), 1);
      expect(await attemptsFor(() => _refused(429)), 3);
      expect(await attemptsFor(() => _refused(408)), 3);
    });
  });

  // A verdict delivered without a parseable payload is still a verdict. Reading
  // the status only off the payload used to make these look like transport
  // failures, so a permission denial was retried like a timeout.
  group('reads a verdict that carried no payload', () {
    test('stops on a bare 4xx', () async {
      expect(await attemptsFor(() => _bare(403)), 1);
    });

    test('still retries a bare 5xx', () async {
      expect(await attemptsFor(() => _bare(503)), 3);
    });

    test('still retries the temporary 4xx statuses', () async {
      expect(await attemptsFor(() => _bare(408)), 3);
      expect(await attemptsFor(() => _bare(429)), 3);
    });
  });

  group('stops on refused credentials', () {
    test('stops on a refused token signature', () async {
      expect(
        await attemptsFor(
          () => _refused(401, code: StreamErrorCode.tokenSignatureInvalid),
        ),
        1,
      );
    });

    test('stops on an unknown API key', () async {
      expect(
        await attemptsFor(
          () => _refused(401, code: StreamErrorCode.apiKeyInvalid),
        ),
        1,
      );
    });

    // StreamAuthInterceptor owns this one: it replaces the token and retries
    // once. Retrying here would mint a fresh token per attempt.
    test('stops on an expired token', () async {
      expect(
        await attemptsFor(
          () => _refused(401, code: StreamErrorCode.tokenExpired),
        ),
        1,
      );
    });

    test(
      'retries a token that is not valid yet, waiting out the skew',
      () async {
        expect(
          await attemptsFor(
            () => _refused(401, code: StreamErrorCode.tokenNotValidYet),
          ),
          3,
        );
      },
    );
  });

  group('honours Retry-After', () {
    test('waits the wait the server named', () async {
      final started = DateTime.now();

      await attemptsFor(
        () => _refused(
          429,
          headers: const {
            'retry-after': ['1'],
          },
        ),
        policy: const RetryPolicy(
          config: RetryConfig(rpcMaxRetries: 2),
          backoff: _noBackoff,
        ),
      );

      // The backoff is zero, so anything approaching a second came from the
      // header.
      expect(
        DateTime.now().difference(started),
        greaterThan(const Duration(milliseconds: 900)),
      );
    });

    // Honouring a long wait per attempt would park one call for minutes. Past
    // the budget the answer is reported instead.
    test('stops rather than waiting past the budget', () async {
      final started = DateTime.now();

      final attempts = await attemptsFor(
        () => _refused(
          429,
          headers: const {
            'retry-after': ['600'],
          },
        ),
        policy: const RetryPolicy(
          config: RetryConfig(maxTotalRetryDelay: Duration(milliseconds: 150)),
          backoff: _noBackoff,
        ),
      );

      expect(
        attempts,
        1,
        reason: 'ten minutes does not fit the budget, so it is not waited out',
      );
      expect(
        DateTime.now().difference(started),
        lessThan(const Duration(seconds: 1)),
      );
    });

    // Several short waits are fine until they add up.
    test('spends the budget across attempts and then stops', () async {
      final attempts = await attemptsFor(
        () => _refused(
          429,
          headers: const {
            'retry-after': ['1'],
          },
        ),
        policy: const RetryPolicy(
          // The default attempt count is more than enough; the budget is what
          // stops this one. Room for two one-second waits, not four.
          config: RetryConfig(maxTotalRetryDelay: Duration(milliseconds: 2500)),
          backoff: _noBackoff,
        ),
      );

      expect(
        attempts,
        3,
        reason: 'two waits fit the budget, the third does not',
      );
    });

    test('uses the backoff when the server named no wait', () async {
      final started = DateTime.now();

      await attemptsFor(() => _refused(429), rpcMaxRetries: 2);

      expect(
        DateTime.now().difference(started),
        lessThan(const Duration(milliseconds: 900)),
      );
    });
  });

  // The retry table in stream_core's ERROR_LAYER.md is the authority here: a
  // failure is retried when it is about *the moment*, never when it is about
  // the request or the setup.
  group('separates a transport failure from an SDK one', () {
    test('retries a request that never reached a verdict', () async {
      expect(
        await attemptsFor(
          () => throw DioException(
            requestOptions: RequestOptions(path: '/x'),
            error: const StreamNetworkException(
              message: 'the request timed out before the server answered',
              isTimeout: true,
            ),
          ),
        ),
        3,
      );
    });

    // Credentials that could not be produced are about the setup, not the
    // moment. Injected directly, because the interceptor that produces one
    // rejects in `onRequest` and so never reaches this arm in the real chain —
    // the value is asserted here so it cannot drift if that ever changes.
    test('stops on credentials it could not produce', () async {
      expect(
        await attemptsFor(
          () => throw DioException(
            requestOptions: RequestOptions(path: '/x'),
            error: const StreamAuthenticationException(
              message: 'tokenProvider threw',
            ),
          ),
        ),
        1,
      );
    });

    // Wire data that would not decode produces the same bytes and the same
    // failure next time, so the budget goes unspent and the caller is told.
    test('stops on a failure inside the SDK', () async {
      expect(
        await attemptsFor(
          () => throw DioException(
            requestOptions: RequestOptions(path: '/x'),
            error: const StreamClientException(
              message: 'the response would not decode',
            ),
          ),
        ),
        1,
      );
    });
  });

  group('the whole budget belongs to one request', () {
    test('spends no more attempts than the policy allows', () async {
      expect(await attemptsFor(() => _refused(500), rpcMaxRetries: 1), 1);
      expect(await attemptsFor(() => _refused(500), rpcMaxRetries: 5), 5);
    });
  });

  // The two interceptors were only ever exercised apart, which hid the fact
  // that a signing failure never reaches this one: dio's
  // `RequestInterceptorHandler.reject` skips the following error interceptors
  // unless asked not to, and the auth interceptor does not ask.
  group('wired together with the auth interceptor', () {
    test('a request that could not be signed is not retried', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.invalid'));
      final adapter = _CountingAdapter(() => _bare(200));
      dio.httpClientAdapter = adapter;
      dio.interceptors.addAll([
        StreamAuthInterceptor(
          () => throw const StreamAuthenticationException(
            message: 'tokenProvider threw',
          ),
        ),
        const ApiErrorInterceptor(),
        StreamRetryInterceptor(
          dio: dio,
          policy: const RetryPolicy(backoff: _noBackoff),
        ),
      ]);

      StreamException? classified;
      try {
        await dio.get<dynamic>('/x');
      } on DioException catch (exception) {
        classified = exception.toStreamException();
      }

      expect(
        adapter.attempts,
        0,
        reason: 'the request never went out, so there was nothing to retry',
      );
      expect(classified, isA<StreamAuthenticationException>());
    });

    // The contrast: a refusal the server sent does reach the retry
    // interceptor, so the chain is wired up and the assertion above is not
    // passing for the wrong reason.
    test('a 5xx the server sent still is', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.invalid'));
      final adapter = _CountingAdapter(() => _refused(503));
      dio.httpClientAdapter = adapter;
      dio.interceptors.addAll([
        const StreamAuthInterceptor(UserToken.anonymous),
        const ApiErrorInterceptor(),
        StreamRetryInterceptor(
          dio: dio,
          policy: const RetryPolicy(
            config: RetryConfig(rpcMaxRetries: 3),
            backoff: _noBackoff,
          ),
        ),
      ]);

      try {
        await dio.get<dynamic>('/x');
      } on DioException catch (_) {
        // The attempt count is the assertion.
      }

      expect(adapter.attempts, 3);
    });
  });
}
