import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/retry/retry_manager.dart';
import 'package:stream_video/stream_video.dart';

Result<None> _apiFailure(int status, {bool? unrecoverable}) {
  return Result.failure(
    VideoErrorWithCause(
      message: 'failed',
      cause: ApiException(
        status,
        jsonEncode({
          'code': 109,
          'message': 'nope',
          'StatusCode': status,
          'duration': '0.00ms',
          'more_info': '',
          'details': <int>[],
          if (unrecoverable != null) 'unrecoverable': unrecoverable,
        }),
      ),
    ),
  );
}

void main() {
  const manager = RpcRetryManager(
    RetryPolicy(config: RetryConfig(rpcMaxRetries: 3)),
  );

  Future<int> attemptsFor(Result<None> failure) async {
    var attempts = 0;
    await manager.execute<None>(() async {
      attempts++;
      return failure;
    });
    return attempts;
  }

  group('RpcRetryManager honours the server verdict', () {
    test('stops on a 5xx the server marked unrecoverable', () async {
      // The status alone would have us retry this five times.
      expect(await attemptsFor(_apiFailure(500, unrecoverable: true)), 1);
    });

    test('retries a 5xx the server did not mark', () async {
      expect(await attemptsFor(_apiFailure(500)), 3);
    });

    test('retries a 4xx the server marked recoverable', () async {
      // The inverse case: the status heuristic would give up here.
      expect(await attemptsFor(_apiFailure(400, unrecoverable: false)), 3);
    });

    test('falls back to the status when the server said nothing', () async {
      expect(await attemptsFor(_apiFailure(400)), 1);
      expect(await attemptsFor(_apiFailure(429)), 3);
    });
  });
}
