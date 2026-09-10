import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/retry/retry_policy.dart';

/// The coordinator socket is paced by stream_core's [DefaultRetryStrategy], not
/// by this SDK's [RetryPolicy]. The two budgets are not comparable: an RPC stops
/// after `rpcMaxRetries` attempts, so its three-second ceiling only ever costs a
/// moment, while the socket retries for the life of the call with no attempt cap
/// — at that ceiling, every client knocks on a failing backend every three
/// seconds indefinitely.
///
/// That makes the strategy's shape part of this SDK's behaviour, so it is pinned
/// here: an upgrade that changes how hard the SDK retries a failing backend
/// should fail this file.
void main() {
  ({Duration low, Duration high}) sample(int failures) {
    final strategy = DefaultRetryStrategy();
    for (var i = 0; i < failures; i++) {
      strategy.incrementConsecutiveFailures();
    }

    var low = const Duration(days: 1);
    var high = Duration.zero;
    for (var i = 0; i < 400; i++) {
      final d = strategy.getNextRetryDelay();
      if (d < low) low = d;
      if (d > high) high = d;
    }
    return (low: low, high: high);
  }

  group('coordinator socket reconnect pacing', () {
    test('reconnects immediately on the first failure', () {
      // A drop is usually a blip, so the first attempt back is not delayed.
      expect(sample(0).high, Duration.zero);
    });

    test('backs off to 25s rather than the RPC ceiling', () {
      final settled = sample(50);

      expect(settled.low, const Duration(seconds: 25));
      expect(settled.high, const Duration(seconds: 25));
      // The RPC ceiling this socket used to share.
      expect(settled.low, greaterThan(const RetryPolicy().config.maxBackoff));
    });

    test('reaches the ceiling within a dozen or so failures', () {
      // A ceiling only helps if the curve gets there. On the RPC curve
      // (200ms per failure) this would take over a hundred attempts.
      expect(sample(13).low, greaterThanOrEqualTo(const Duration(seconds: 24)));
    });

    test('is jittered, so clients that dropped together return apart', () {
      final spread = sample(5);

      expect(spread.low, lessThan(spread.high));
    });

    test('resets once a connection is established', () {
      final strategy = DefaultRetryStrategy();
      for (var i = 0; i < 20; i++) {
        strategy.incrementConsecutiveFailures();
      }
      expect(strategy.getNextRetryDelay(), const Duration(seconds: 25));

      strategy.resetConsecutiveFailures();

      // Back to an immediate attempt, so an ordinary blip recovers at once
      // even after a long outage.
      expect(strategy.getNextRetryDelay(), Duration.zero);
    });

    test('leaves the RPC backoff on its own ceiling', () {
      const policy = RetryPolicy();

      expect(policy.backoff(50), policy.config.maxBackoff);
    });
  });
}
