import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/connection/rejoin_rate_limiter.dart';

void main() {
  test('allows maxAttempts attempts and refuses the next', () {
    fakeAsync((async) {
      final limiter = RejoinRateLimiter(
        maxAttempts: 3,
        window: const Duration(seconds: 10),
      );

      expect(
        [for (var i = 0; i < 3; i++) limiter.tryRegister()],
        [
          true,
          true,
          true,
        ],
      );
      expect(limiter.tryRegister(), isFalse);
    });
  });

  test('a refused attempt is not recorded', () {
    fakeAsync((async) {
      final limiter = RejoinRateLimiter(
        maxAttempts: 2,
        window: const Duration(seconds: 10),
      );
      limiter.tryRegister();
      async.elapse(const Duration(seconds: 5));
      limiter.tryRegister();
      expect(limiter.tryRegister(), isFalse);

      // Only the first attempt has left the window.
      async.elapse(const Duration(seconds: 5));
      expect(limiter.tryRegister(), isTrue);
      expect(limiter.tryRegister(), isFalse);
    });
  });

  test('attempts older than the window no longer count', () {
    fakeAsync((async) {
      final limiter = RejoinRateLimiter(
        maxAttempts: 2,
        window: const Duration(seconds: 10),
      );
      limiter
        ..tryRegister()
        ..tryRegister();

      async.elapse(const Duration(seconds: 9));
      expect(limiter.tryRegister(), isFalse);

      async.elapse(const Duration(seconds: 1));
      expect(limiter.tryRegister(), isTrue);
      expect(limiter.tryRegister(), isTrue);
      expect(limiter.tryRegister(), isFalse);
    });
  });
}
