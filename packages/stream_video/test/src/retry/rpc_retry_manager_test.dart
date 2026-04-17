import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/open_api/video/coordinator/api.dart';
import 'package:stream_video/src/errors/video_error.dart';
import 'package:stream_video/src/retry/retry_manager.dart';
import 'package:stream_video/src/retry/retry_policy.dart';
import 'package:stream_video/src/token/token.dart';
import 'package:stream_video/src/token/token_manager.dart';
import 'package:stream_video/src/utils/result.dart';

class MockTokenManager extends Mock implements TokenManager {}

/// A [RetryPolicy] with no backoff delay for fast tests.
const _noDelayPolicy = RetryPolicy(
  config: RetryConfig(rpcMaxRetries: 3),
  backoff: _zeroBackoff,
);

Duration _zeroBackoff(RetryConfig config, int retryAttempt) => Duration.zero;

/// Helper to create a [Result.failure] wrapping an [ApiException] with the
/// given [statusCode].
Result<T> _httpError<T>(int statusCode, [String message = '']) {
  return Result.failure(
    VideoErrorWithCause(
      message: message,
      cause: ApiException(statusCode, message),
    ),
  );
}

final _token = UserToken.anonymous();

void main() {
  group('RpcRetryManager auth retry', () {
    late MockTokenManager tokenManager;

    setUp(() {
      tokenManager = MockTokenManager();
    });

    test('refreshes token and retries on 401', () async {
      var callCount = 0;

      when(() => tokenManager.refreshToken()).thenAnswer(
        (_) async => Result.success(_token),
      );

      final manager = RpcRetryManager(
        _noDelayPolicy,
        tokenManager: tokenManager,
      );

      final result = await manager.execute(() async {
        callCount++;
        if (callCount == 1) {
          return _httpError<String>(401, 'Unauthorized');
        }
        return const Result.success('ok');
      });

      expect(result.isSuccess, isTrue);
      expect(callCount, 2);
      verify(() => tokenManager.refreshToken()).called(1);
    });

    test('retries only once on repeated 401', () async {
      when(() => tokenManager.refreshToken()).thenAnswer(
        (_) async => Result.success(_token),
      );

      final manager = RpcRetryManager(
        _noDelayPolicy,
        tokenManager: tokenManager,
      );

      final result = await manager.execute(() async {
        return _httpError<String>(401, 'Unauthorized');
      });

      expect(result.isFailure, isTrue);
      // 1st call → 401 → refresh → 2nd call → 401 → no more auth retries
      // then normal retries continue up to rpcMaxRetries
      verify(() => tokenManager.refreshToken()).called(1);
    });

    test('does not refresh token on non-401 4xx errors', () async {
      var callCount = 0;

      final manager = RpcRetryManager(
        _noDelayPolicy,
        tokenManager: tokenManager,
      );

      final result = await manager.execute(() async {
        callCount++;
        return _httpError<String>(403, 'Forbidden');
      });

      expect(result.isFailure, isTrue);
      expect(callCount, 1); // 403 is not retryable, fails immediately
      verifyNever(() => tokenManager.refreshToken());
    });

    test('does not attempt refresh without tokenManager', () async {
      var callCount = 0;

      const manager = RpcRetryManager(_noDelayPolicy);

      final result = await manager.execute(() async {
        callCount++;
        return _httpError<String>(401, 'Unauthorized');
      });

      expect(result.isFailure, isTrue);
      // 401 is retryable but no tokenManager to refresh — retries with same
      // stale token up to rpcMaxRetries
      expect(callCount, 3);
    });

    test('auth retry does not consume a regular retry slot', () async {
      var callCount = 0;

      when(() => tokenManager.refreshToken()).thenAnswer(
        (_) async => Result.success(_token),
      );

      const policy = RetryPolicy(
        config: RetryConfig(rpcMaxRetries: 2),
        backoff: _zeroBackoff,
      );

      final manager = RpcRetryManager(
        policy,
        tokenManager: tokenManager,
      );

      // 1st → 401 (auth retry, doesn't count)
      // 2nd → 500 (retry slot 1)
      // 3rd → success (retry slot 2)
      final result = await manager.execute(() async {
        callCount++;
        if (callCount == 1) return _httpError<String>(401);
        if (callCount == 2) return _httpError<String>(500);
        return const Result.success('ok');
      });

      expect(result.isSuccess, isTrue);
      expect(callCount, 3);
      verify(() => tokenManager.refreshToken()).called(1);
    });

    test('retries 5xx errors normally without token refresh', () async {
      var callCount = 0;

      final manager = RpcRetryManager(
        _noDelayPolicy,
        tokenManager: tokenManager,
      );

      final result = await manager.execute(() async {
        callCount++;
        if (callCount < 3) {
          return _httpError<String>(503, 'Service Unavailable');
        }

        return const Result.success('ok');
      });

      expect(result.isSuccess, isTrue);
      expect(callCount, 3);
      verifyNever(() => tokenManager.refreshToken());
    });
  });
}
