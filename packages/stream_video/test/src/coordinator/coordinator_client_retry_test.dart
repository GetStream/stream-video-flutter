import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/open_api/video/coordinator/api.dart';
import 'package:stream_video/src/coordinator/coordinator_client.dart';
import 'package:stream_video/src/coordinator/retry/coordinator_client_retry.dart';
import 'package:stream_video/src/errors/video_error.dart';
import 'package:stream_video/src/retry/retry_policy.dart';
import 'package:stream_video/src/token/token_source.dart';
import 'package:stream_video/src/utils/result.dart';

class MockCoordinatorClient extends Mock implements CoordinatorClient {}

class MockTokenSource extends Mock implements TokenSource {}

/// A [RetryPolicy] with no backoff delay for fast tests.
const _noDelayPolicy = RetryPolicy(
  config: RetryConfig(rpcMaxRetries: 3),
  backoff: _zeroBackoff,
);

Duration _zeroBackoff(RetryConfig config, int retryAttempt) => Duration.zero;

/// Helper to create a [Result.failure] wrapping an [StreamApiError] with the
/// given [statusCode].
Result<T> _httpError<T>(int statusCode, [String message = '']) {
  return Result.failure(
    VideoErrorWithCause(
      message: message,
      cause: StreamApiError(
        code: statusCode,
        details: const [],
        duration: '',
        message: message,
        moreInfo: '',
        statusCode: statusCode,
      ),
    ),
  );
}

void main() {
  group('CoordinatorClientRetry loadGuest', () {
    late MockCoordinatorClient delegate;
    late MockTokenSource tokenSource;
    late CoordinatorClientRetry client;

    setUp(() {
      delegate = MockCoordinatorClient();
      tokenSource = MockTokenSource();
      client = CoordinatorClientRetry(
        delegate: delegate,
        retryPolicy: _noDelayPolicy,
        tokenSource: tokenSource,
      );
    });

    test('never consults the token source on 401', () async {
      // Guest creation authenticates with its own anonymous token, and it is
      // the call that establishes the session — a token refresh here would ask
      // the session manager for the very token this call is fetching.
      var callCount = 0;
      when(
        () => delegate.loadGuest(
          id: any(named: 'id'),
          name: any(named: 'name'),
          image: any(named: 'image'),
          custom: any(named: 'custom'),
        ),
      ).thenAnswer((_) async {
        callCount++;
        return _httpError(401, 'Unauthorized');
      });

      final result = await client.loadGuest(id: 'guest-1');

      expect(result.isFailure, isTrue);
      // 401 stays retryable through the normal retry budget.
      expect(callCount, 3);
      verifyZeroInteractions(tokenSource);
    });
  });
}
