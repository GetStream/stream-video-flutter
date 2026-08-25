// ignore_for_file: avoid_web_libraries_in_flutter, implementation_imports

import 'dart:async';
import 'dart:js_interop' as jsutil;
import 'dart:js_interop_unsafe';
import 'dart:math' as math;

import 'package:dart_webrtc/src/media_stream_track_impl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:web/web.dart' as web;

import '../../call/stats/trace_tag.dart';
import '../../logger/stream_log.dart';

const audioContainerId = 'stream_audio_container';
const audioPrefix = 'stream_audio_';

const _tag = 'SV:RtcAudioWeb';

/// Number of consecutive failed recovery attempts after which the outage is
/// reported as sustained.
const _maxRecoveryAttempts = 10;

/// Signature of the sink the web audio layer reports playback traces to.
typedef AudioTraceHandler = void Function(String tag, Object? data);

AudioTraceHandler? _traceHandler;

/// Installs the handler that receives remote audio playback traces.
void setAudioTraceHandler(AudioTraceHandler? handler) {
  _traceHandler = handler;
}

void _trace(String tag, Object? data) => _traceHandler?.call(tag, data);

final _watchdogs = <String, _AudioPlaybackWatchdog>{};

/// Track ids whose audio element the browser's autoplay policy is blocking.
final _blockedTrackIds = <String>{};

/// Whether the browser's autoplay policy is currently blocking playback of at
/// least one remote audio element.
///
/// Seeded so a listener that subscribes after playback was already blocked
/// (e.g. a second call joining the page) gets the current value.
final _blockedController = BehaviorSubject<bool>.seeded(false);

/// Emits whenever the autoplay policy starts or stops blocking remote audio.
///
/// The audio elements are page-global, so this reflects remote playback across
/// every call running on the page.
///
/// Only the autoplay policy is reported here: it is the one failure the app can
/// do something about, by calling [resumeAudioPlayback] from a gesture. Every
/// other playback failure is retried indefinitely by the watchdog instead.
Stream<bool> get audioPlaybackBlockedChanges => _blockedController.stream;

/// Publishes the current blocked state, if it changed.
///
/// Called after every mutation of [_blockedTrackIds]: the set is the mechanism,
/// this is how the rest of the SDK finds out about it without polling.
void _notifyBlocked() {
  final blocked = _blockedTrackIds.isNotEmpty;
  if (blocked == _blockedController.value) return;

  _blockedController.add(blocked);
}

void startAudio(String id, rtc.MediaStreamTrack track) {
  if (track is! MediaStreamTrackWeb) return;

  final elementId = audioPrefix + id;
  var audioElement = web.document.getElementById(elementId);
  if (audioElement == null) {
    audioElement = web.HTMLAudioElement()
      ..id = elementId
      ..autoplay = true;
    findOrCreateAudioContainer().append(audioElement);
  }

  if (audioElement is! web.HTMLAudioElement) return;

  final audioStream = web.MediaStream();
  audioStream.addTrack(track.jsTrack);
  audioElement.srcObject = audioStream;

  // `autoplay` alone fails silently when the browser's autoplay policy blocks
  // playback, so drive `play()` explicitly and watch the element from here on.
  _watchdogs.remove(id)?.dispose();
  _watchdogs[id] = _AudioPlaybackWatchdog(trackId: id, element: audioElement);
}

void stopAudio(String id) {
  _watchdogs.remove(id)?.dispose();
  _blockedTrackIds.remove(id);
  _notifyBlocked();

  final audioElement = web.document.getElementById(audioPrefix + id);
  if (audioElement != null) {
    if (audioElement is web.HTMLAudioElement) {
      audioElement.srcObject = null;
    }
    audioElement.remove();
  }
}

/// Applies the audio output device [deviceId] to the audio element of track
/// [id].
Future<void> setSinkId(String id, String deviceId) async {
  if (!checkIfAudioOutputChangeSupported()) {
    streamLog.w(
      _tag,
      () => 'Audio output device change is not supported on this browser.',
    );
    if (!_tracedOutputChangeUnsupported) {
      _tracedOutputChangeUnsupported = true;
      _trace(TraceTag.setSinkId, {
        'trackId': id,
        'deviceId': deviceId,
        'error': 'unsupported',
      });
    }
    throw UnsupportedError(
      'Audio output device change is not supported on this browser.',
    );
  }

  final audioElement = web.document.getElementById(audioPrefix + id);
  if (audioElement is! web.HTMLAudioElement) {
    // Not a failure: the element is created when the track starts, and every
    // site that starts a track re-applies the selected output immediately
    // after, via `_applyCurrentAudioOutputDevice` in `call_session.dart`, which
    // re-derives the device from call state.
    streamLog.w(
      _tag,
      () =>
          'No audio element for track $id yet, sink id $deviceId will be '
          're-applied once the track starts',
    );
    _trace(TraceTag.setSinkId, {
      'trackId': id,
      'deviceId': deviceId,
      'deferred': true,
    });
    return;
  }

  if (!audioElement.hasProperty('setSinkId'.toJS).toDart) {
    streamLog.w(
      _tag,
      () => 'Audio element for track $id does not support setSinkId',
    );
    _trace(TraceTag.setSinkId, {
      'trackId': id,
      'deviceId': deviceId,
      'error': 'unsupported',
    });
    throw UnsupportedError(
      'Audio output device change is not supported on this browser.',
    );
  }

  try {
    await audioElement.setSinkId(deviceId).toDart;
    streamLog.i(_tag, () => 'Set sink id for track $id to $deviceId');
    _trace(TraceTag.setSinkId, {'trackId': id, 'deviceId': deviceId});
  } catch (e) {
    streamLog.e(_tag, () => 'Failed to set sink id for track $id: $e');
    _trace(TraceTag.setSinkId, {
      'trackId': id,
      'deviceId': deviceId,
      'error': '$e',
    });

    rethrow;
  }
}

/// Retries playback of every remote audio element the browser's autoplay policy
/// blocked, plus any element currently waiting on a recovery backoff. Must be
/// called from within a user gesture.
///
/// Recovering elements are included because the gesture may be exactly what
/// they were missing, and retrying now beats waiting out the backoff.
Future<void> resumeAudioPlayback() async {
  final recovering = _watchdogs.entries
      .where((entry) => entry.value.isRecovering)
      .map((entry) => entry.key)
      .toList();

  final pending = {
    ..._blockedTrackIds.where(_watchdogs.containsKey),
    ...recovering,
  };

  _trace(TraceTag.resumeAudio, {
    'blockedTracks': _blockedTrackIds.length,
    'recoveringTracks': recovering.length,
  });

  final retries = <Future<void>>[];
  for (final trackId in pending) {
    retries.add(_watchdogs[trackId]!.resume());
  }

  await Future.wait(retries);
}

/// Whether the "this browser can't switch audio output" trace was already
/// reported. The capability is page-global and cached, so tracing it per track
/// would repeat one fact once per participant.
bool _tracedOutputChangeUnsupported = false;

/// Cached result of [checkIfAudioOutputChangeSupported].
///
/// Probing creates a detached `<audio>` element, so it is done once per page
/// instead of once per track.
bool? _audioOutputChangeSupported;

bool checkIfAudioOutputChangeSupported() {
  final cached = _audioOutputChangeSupported;
  if (cached != null) return cached;

  // Detect the capability by looking the method up rather than calling it:
  // `setSinkId` returns a promise, so invoking it would route audio and leave
  // a rejection unhandled instead of reporting support.
  final element = web.document.createElement('audio');
  return _audioOutputChangeSupported = element
      .hasProperty('setSinkId'.toJS)
      .toDart;
}

web.HTMLDivElement findOrCreateAudioContainer() {
  var div = web.document.getElementById(audioContainerId);
  if (div != null) return div as web.HTMLDivElement;

  div = web.HTMLDivElement()
    ..id = audioContainerId
    ..style.display = 'none';
  web.document.body?.append(div);
  return div as web.HTMLDivElement;
}

/// Returns true if [error] is a `NotAllowedError` from the browser's autoplay policy.
///
/// This usually means the user hasn't interacted with the page yet (requires "user activation").
/// Detected by checking for a `DOMException` with name `"NotAllowedError"`—via JS interop or in the error string.
bool _isNotAllowedError(Object error) {
  if (error is jsutil.JSObject) {
    final name = error.getProperty<jsutil.JSString?>('name'.toJS)?.toDart;
    if (name != null) return name == 'NotAllowedError';
  }

  return '$error'.contains('NotAllowedError');
}

/// Watches a single remote audio element and tries to recover playback when it
/// pauses or suspends unexpectedly.
///
/// Mirrors the JS SDK's `MediaPlaybackWatchdog` / `BlockedAudioTracker`: a
/// `play()` rejected with `NotAllowedError` means the autoplay policy is
/// blocking us, so retrying is pointless until [resumeAudioPlayback] is called
/// from a user gesture. Any other failure is retried with a backoff.
class _AudioPlaybackWatchdog {
  _AudioPlaybackWatchdog({required this.trackId, required this.element}) {
    _onPauseOrSuspend = ((web.Event event) {
      _handlePauseOrSuspend(event.type);
    }).toJS;
    _onPlaying = ((web.Event _) => _markPlaying()).toJS;

    element.addEventListener('pause', _onPauseOrSuspend);
    element.addEventListener('suspend', _onPauseOrSuspend);
    element.addEventListener('playing', _onPlaying);

    // `autoplay` alone fails silently, so start playback explicitly. This is
    // the happy path, not a recovery, so it is not traced.
    unawaited(play());
  }

  final String trackId;
  final web.HTMLAudioElement element;

  late final jsutil.JSFunction _onPauseOrSuspend;
  late final jsutil.JSFunction _onPlaying;

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

    element.removeEventListener('pause', _onPauseOrSuspend);
    element.removeEventListener('suspend', _onPauseOrSuspend);
    element.removeEventListener('playing', _onPlaying);
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
      await element.play().toDart;
      _markPlaying();
    } catch (e) {
      if (_disposed) return;

      String failureMessage() =>
          'Playing audio for track $trackId failed (attempt $_attempt): $e';

      // Past the sustained threshold this repeats every 5s for as long as the
      // track lives. The outage is already on record — one warning run and one
      // [TraceTag.mediaPlaybackRecoverStalled] — so the rest is verbose.
      if (_attempt <= _maxRecoveryAttempts) {
        streamLog.w(_tag, failureMessage);
      } else {
        streamLog.v(_tag, failureMessage);
      }

      // The autoplay policy will keep rejecting until a user gesture, so stop
      // burning attempts and wait for [resumeAudioPlayback].
      if (_isNotAllowedError(e)) {
        if (_blockedTrackIds.add(trackId)) {
          _trace(TraceTag.audioPlaybackBlocked, {
            'trackId': trackId,
            'kind': 'audio',
            'error': '$e',
          });
          _notifyBlocked();
        }
        return;
      }

      // Report the outage as sustained once, then keep retrying at the backoff
      // cap. Stopping here would be terminal: the element stays paused, so no
      // further `pause`/`suspend` arrives to re-enter recovery, and nothing is
      // surfaced to the app to prompt a [resumeAudioPlayback] call either.
      if (_attempt == _maxRecoveryAttempts) {
        _trace(TraceTag.mediaPlaybackRecoverStalled, {
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
    if (_blockedTrackIds.remove(trackId)) {
      streamLog.i(_tag, () => 'Audio playback unblocked for track $trackId');
    }
    _notifyBlocked();

    if (_degraded) {
      _trace(TraceTag.mediaPlaybackRecoverSuccess, {
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
      streamLog.v(
        _tag,
        () => 'Ignoring $reason for track $trackId ($skipReason)',
      );
      return;
    }

    streamLog.w(_tag, () => 'Audio playback $reason for track $trackId');
    _trace(TraceTag.mediaPlaybackPaused, {
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
      streamLog.v(
        _tag,
        () => 'Recovery skipped for track $trackId ($skipReason)',
      );

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
    if (element.srcObject == null) return 'noSrc';
    if (element.ended) return 'ended';
    if (_blockedTrackIds.contains(trackId)) return 'blocked';
    if (!element.paused) return 'notPaused';
    return null;
  }

  /// Exponential backoff capped at 5s, matching the Web SDK's retry interval.
  Duration _backoff(int attempt) {
    if (attempt <= 0) return Duration.zero;
    final exponent = math.min(attempt - 1, 5);
    return Duration(milliseconds: math.min(5000, 250 * (1 << exponent)));
  }
}
