import 'dart:async';

import '../../open_api/video/coordinator/api.dart' as open;
import '../logger/impl/tagged_logger.dart';
import '../ring_state_polling_settings.dart';
import '../utils/result.dart';

/// Polls the coordinator for the outcome of a ring the current user started.
///
/// After [RingStatePollingSettings.startAfter] without a ring event it reads
/// the ring state every [RingStatePollingSettings.interval], until
/// [onRingState] reports the ring settled, the ring timeout runs out or [stop]
/// is called. The poller only reads: deciding the outcome and applying it is
/// left to [onRingState].
class RingStatePoller {
  RingStatePoller({
    required this.settings,
    required this.ringTimeout,
    required this.fetchRingState,
    required this.onRingState,
  });

  final RingStatePollingSettings settings;

  /// How long the ring lasts at most. Polling never outlives it.
  final Duration ringTimeout;

  final Future<Result<open.GetCallRingStateResponse>> Function() fetchRingState;

  /// Applies a polled ring state, returning whether the ring is settled.
  final bool Function(open.GetCallRingStateResponse ringState) onRingState;

  late final _logger = taggedLogger(tag: 'SV:RingStatePoller');

  Timer? _deadlineTimer;
  Timer? _quietTimer;
  Timer? _pollTimer;
  bool _started = false;
  bool _stopped = false;
  bool _inFlight = false;

  bool get isStopped => _stopped;

  /// Starts the quiet period. The poller can be started only once.
  void start() {
    if (_started || _stopped) return;
    _started = true;

    _logger.d(
      () =>
          '[start] startAfter: ${settings.startAfter}, '
          'interval: ${settings.interval}, ringTimeout: $ringTimeout',
    );

    _deadlineTimer = Timer(ringTimeout, () {
      _logger.d(() => '[deadline] the ring timed out');
      stop();
    });
    _armQuietPeriod();
  }

  /// Starts the quiet period over, going back to waiting before polling.
  ///
  /// Called on every ring event: an event proves the WebSocket is alive, and in
  /// a group ring one rejection does not settle the ring.
  void restartQuietPeriod() {
    if (!_started || _stopped) return;
    _armQuietPeriod();
  }

  /// Stops polling for good.
  void stop() {
    if (_stopped) return;
    _stopped = true;
    _deadlineTimer?.cancel();
    _quietTimer?.cancel();
    _pollTimer?.cancel();
  }

  void _armQuietPeriod() {
    _quietTimer?.cancel();
    _pollTimer?.cancel();
    _pollTimer = null;
    _quietTimer = Timer(settings.startAfter, () {
      if (_stopped) return;
      _pollTimer = Timer.periodic(settings.interval, (_) => _poll());
      _poll();
    });
  }

  Future<void> _poll() async {
    if (_stopped || _inFlight) return;
    _inFlight = true;

    try {
      final result = await fetchRingState();
      if (_stopped) return;

      switch (result) {
        case Success(:final data):
          if (onRingState(data)) {
            _logger.d(() => '[poll] the ring settled');
            stop();
          }
        case final Failure failure:
          // Only a few polls fit in a ring, so a failure is simply retried.
          _logger.w(() => '[poll] failed, retrying: ${failure.videoError}');
      }
    } catch (e, stk) {
      // The polls run unawaited from timers, so a throw would otherwise be an
      // unhandled error. It is a bug, which polling again won't heal.
      _logger.e(() => '[poll] threw, stopping: $e\n$stk');
      stop();
    } finally {
      _inFlight = false;
    }
  }
}
