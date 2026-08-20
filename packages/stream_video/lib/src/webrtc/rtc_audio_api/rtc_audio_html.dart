// ignore_for_file: avoid_web_libraries_in_flutter, implementation_imports

import 'dart:async';
import 'dart:js_interop' as jsutil;
import 'dart:js_interop_unsafe';
import 'dart:math' as math;

import 'package:dart_webrtc/src/media_stream_track_impl.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:web/web.dart' as web;

import '../../call/stats/trace_tag.dart';
import '../../logger/stream_log.dart';

const audioContainerId = 'stream_audio_container';
const audioPrefix = 'stream_audio_';

const _tag = 'SV:RtcAudioWeb';

/// Number of consecutive playback recovery attempts before giving up.
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

/// Track ids whose playback recovery exhausted its retry budget. Kept separate
/// from [_blockedTrackIds] so an exhausted track doesn't make the SDK claim the
/// autoplay policy is blocking audio, while still leaving a way back in via
/// [resumeAudioPlayback].
final _stalledTrackIds = <String>{};

/// Whether the browser's autoplay policy is currently blocking playback of at
/// least one remote audio element.
bool get isAudioPlaybackBlocked => _blockedTrackIds.isNotEmpty;

/// Whether playback of at least one remote audio element stopped and automatic
/// recovery gave up on it.
bool get isAudioPlaybackStalled => _stalledTrackIds.isNotEmpty;

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
  _stalledTrackIds.remove(id);

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
    _trace(TraceTag.setSinkId, {
      'trackId': id,
      'deviceId': deviceId,
      'error': 'unsupported',
    });
    throw UnsupportedError(
      'Audio output device change is not supported on this browser.',
    );
  }

  final audioElement = web.document.getElementById(audioPrefix + id);
  if (audioElement is! web.HTMLAudioElement) {
    // Not a failure: the element is created when the track starts, and
    // `start()` applies the sink id the caller is about to record.
    streamLog.w(
      _tag,
      () =>
          'No audio element for track $id yet, sink id $deviceId will be '
          'applied when the track starts',
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
/// blocked, plus any element whose automatic recovery gave up. Must be called
/// from within a user gesture.
Future<void> resumeAudioPlayback() async {
  _trace(TraceTag.resumeAudio, {
    'blockedTracks': _blockedTrackIds.length,
    'stalledTracks': _stalledTrackIds.length,
  });

  final pending = {
    ..._blockedTrackIds,
    ..._stalledTrackIds,
  }.where(_watchdogs.containsKey).toSet();

  _blockedTrackIds.removeAll(pending);
  _stalledTrackIds.removeAll(pending);

  final retries = <Future<void>>[];
  for (final trackId in pending) {
    retries.add(_watchdogs[trackId]!.resume());
  }

  await Future.wait(retries);
}

/// Cached result of [checkIfAudioOutputChangeSupported].
///
/// Probing creates a detached `<audio>` element and invokes `setSinkId` on it,
/// so it is done once per page instead of once per track.
bool? _audioOutputChangeSupported;

bool checkIfAudioOutputChangeSupported() {
  final cached = _audioOutputChangeSupported;
  if (cached != null) return cached;

  final element = web.document.createElement('audio');

  try {
    element.callMethod('setSinkId'.toJS, 'default'.toJS);
    return _audioOutputChangeSupported = true;
  } catch (_) {
    return _audioOutputChangeSupported = false;
  }
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
    _onPlaying = ((web.Event _) => _handlePlaying()).toJS;

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
      _blockedTrackIds.remove(trackId);
      _stalledTrackIds.remove(trackId);
    } catch (e) {
      if (_disposed) return;

      streamLog.w(
        _tag,
        () =>
            'Playing audio for track $trackId failed '
            '(attempt $_attempt): $e',
      );

      // The autoplay policy will keep rejecting until a user gesture, so stop
      // burning attempts and wait for [resumeAudioPlayback].
      if (_isNotAllowedError(e)) {
        if (_blockedTrackIds.add(trackId)) {
          _trace(TraceTag.mediaPlaybackBlocked, {
            'trackId': trackId,
            'kind': 'audio',
            'error': '$e',
          });
        }
        return;
      }

      if (_attempt >= _maxRecoveryAttempts) {
        _trace(TraceTag.mediaPlaybackRecoverGiveUp, {
          'trackId': trackId,
          'kind': 'audio',
          'attempts': _attempt,
          'readyState': element.readyState,
          'error': '$e',
        });

        // Stop retrying this outage, but re-arm the watchdog.
        _stalledTrackIds.add(trackId);
        _degraded = false;
        _attempt = 0;
        return;
      }

      _scheduleRecovery();
    }
  }

  void _handlePlaying() {
    _stalledTrackIds.remove(trackId);
    if (_blockedTrackIds.remove(trackId)) {
      streamLog.i(_tag, () => 'Audio playback unblocked for track $trackId');
    }

    if (_degraded) {
      _trace(TraceTag.mediaPlaybackRecovered, {
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
