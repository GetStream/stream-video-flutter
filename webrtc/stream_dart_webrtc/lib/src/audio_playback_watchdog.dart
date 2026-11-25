import 'dart:async';
import 'dart:math' as math;

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

final _logger = Logger('AudioPlaybackWatchdog');

/// Number of consecutive failed recovery attempts after which the outage is
/// reported as sustained.
const _maxRecoveryAttempts = 10;

/// The media element an [AudioPlaybackWatchdog] watches.
@internal
abstract interface class PlaybackElement {
  /// Starts playback; completes once it runs and throws when it cannot.
  Future<void> play();

  /// Whether the element has a stream to play.
  bool get hasSource;

  bool get ended;

  bool get paused;

  int get readyState;

  /// Whether [error], thrown by [play], is the autoplay policy's rejection.
  bool isAutoplayBlocked(Object error);

  /// Calls [onPauseOrSuspend] with the event type on every `pause` and
  /// `suspend`, and [onPlaying] on every `playing`, until [unlisten].
  void listen({
    required void Function(String type) onPauseOrSuspend,
    required void Function() onPlaying,
  });

  void unlisten();
}

/// Watches a single remote audio element and tries to recover playback when it
/// pauses or suspends unexpectedly.
///
/// A `play()` rejected by the autoplay policy means retrying is pointless
/// until [resume] is called from a user gesture. Any other failure is retried
/// with a backoff.
@internal
class AudioPlaybackWatchdog {
  AudioPlaybackWatchdog({
    required this.trackId,
    required this.element,
    required this.isBlocked,
    required this.markBlocked,
    required this.markUnblocked,
    this.onTrace,
  }) {
    element.listen(
      onPauseOrSuspend: _handlePauseOrSuspend,
      onPlaying: _markPlaying,
    );

    // `autoplay` alone fails silently, so start playback explicitly. This is
    // the happy path, not a recovery, so it is not traced.
    unawaited(play());
  }

  final String trackId;
  final PlaybackElement element;

  /// Whether the autoplay policy blocks this element.
  final bool Function() isBlocked;

  /// Records the element as blocked; true when it was not blocked before.
  final bool Function() markBlocked;

  /// Records the element as no longer blocked; true when it was blocked.
  final bool Function() markUnblocked;

  final AudioRendererTraceHandler? onTrace;

  void _trace(String tag, Object? data) => onTrace?.call(tag, data);

  Timer? _pendingTimer;
  int _attempt = 0;
  bool _disposed = false;

  /// Whether an unexpected playback stop has been reported and not yet
  /// resolved. Keeps repeated `pause`/`suspend` events for one outage from
  /// emitting a trace each.
  bool _degraded = false;

  /// Whether this element is in the middle of an unresolved outage, so a user
  /// gesture should retry it right away instead of letting the backoff run.
  bool get isRecovering => !_disposed && _degraded;

  void dispose() {
    if (_disposed) return;
    _disposed = true;

    _pendingTimer?.cancel();
    _pendingTimer = null;

    element.unlisten();
  }

  /// Retries playback after a user gesture.
  Future<void> resume() {
    if (_disposed) return Future.value();

    _pendingTimer?.cancel();
    _pendingTimer = null;
    _attempt = 0;

    return play();
  }

  Future<void> play() async {
    if (_disposed) return;
    _attempt += 1;

    try {
      await element.play();
      _markPlaying();
    } catch (e) {
      if (_disposed) return;

      String failureMessage() =>
          'Playing audio for track $trackId failed (attempt $_attempt): $e';

      // Past the sustained threshold this repeats every 5s for as long as the
      // track lives. The outage is already on record — one warning run and one
      // [AudioRendererTraceTag.stalled] — so the rest is verbose.
      if (_attempt <= _maxRecoveryAttempts) {
        _logger.warning(failureMessage());
      } else {
        _logger.fine(failureMessage);
      }

      // The autoplay policy will keep rejecting until a user gesture, so stop
      // burning attempts and wait for [resume].
      if (element.isAutoplayBlocked(e)) {
        if (markBlocked()) {
          _trace(AudioRendererTraceTag.blocked, {
            'trackId': trackId,
            'kind': 'audio',
            'error': '$e',
          });
        }
        return;
      }

      // Report the outage as sustained once, then keep retrying at the backoff
      // cap. Stopping here would be terminal: the element stays paused, so no
      // further `pause`/`suspend` arrives to re-enter recovery, and nothing is
      // surfaced to the app to prompt a [resume] call either.
      if (_attempt == _maxRecoveryAttempts) {
        _trace(AudioRendererTraceTag.stalled, {
          'trackId': trackId,
          'kind': 'audio',
          'attempts': _attempt,
          'readyState': element.readyState,
          'error': '$e',
        });
      }

      _scheduleRecovery();
    }
  }

  /// Records that playback is running again and re-arms the watchdog.
  ///
  /// Called both when `play()` resolves and when the element fires `playing`,
  /// because either can be the one to observe the recovery. Doing it in only
  /// one of them can leave [_degraded] latched with no timer armed, which
  /// silently swallows every later `pause`/`suspend`.
  void _markPlaying() {
    if (markUnblocked()) {
      _logger.info('Audio playback unblocked for track $trackId');
    }

    if (_degraded) {
      _trace(AudioRendererTraceTag.recovered, {
        'trackId': trackId,
        'kind': 'audio',
        'attempts': _attempt,
      });
      _degraded = false;
    }

    _attempt = 0;
    _pendingTimer?.cancel();
    _pendingTimer = null;
  }

  void _handlePauseOrSuspend(String reason) {
    if (_disposed || _degraded) return;

    // A `suspend` on an element that is playing (or has nothing to play) is
    // routine — don't report it as an outage.
    final skipReason = _computeSkipReason();
    if (skipReason != null) {
      _logger.fine('Ignoring $reason for track $trackId ($skipReason)');
      return;
    }

    _logger.warning('Audio playback $reason for track $trackId');
    _trace(AudioRendererTraceTag.paused, {
      'trackId': trackId,
      'kind': 'audio',
      'reason': reason,
      'readyState': element.readyState,
    });

    _scheduleRecovery();
  }

  void _scheduleRecovery() {
    if (_disposed || _pendingTimer != null) return;

    final skipReason = _computeSkipReason();
    if (skipReason != null) {
      _logger.fine('Recovery skipped for track $trackId ($skipReason)');

      // There is nothing to recover, so leave the machine re-armed. A latched
      // [_degraded] with no timer pending would swallow every later outage.
      _degraded = false;
      return;
    }

    _degraded = true;
    _pendingTimer = Timer(_backoff(_attempt), () {
      _pendingTimer = null;
      unawaited(play());
    });
  }

  String? _computeSkipReason() {
    if (_disposed) return 'disposed';
    if (!element.hasSource) return 'noSrc';
    if (element.ended) return 'ended';
    if (isBlocked()) return 'blocked';
    if (!element.paused) return 'notPaused';
    return null;
  }

  /// Exponential backoff from 250ms, capped at 5s.
  Duration _backoff(int attempt) {
    if (attempt <= 0) return Duration.zero;
    final exponent = math.min(attempt - 1, 5);
    return Duration(milliseconds: math.min(5000, 250 * (1 << exponent)));
  }
}
