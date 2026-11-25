import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../call/stats/trace_tag.dart';
import '../logger/stream_log.dart';

const _tag = 'SV:RemoteAudioPlayback';

/// Receives a playback trace, tagged with a [TraceTag] or an
/// [rtc.AudioRendererTraceTag].
typedef RemoteAudioTraceHandler = void Function(String tag, Object? data);

/// Creates the renderer of the remote audio track [id].
typedef AudioRendererFactory =
    rtc.RTCAudioRenderer Function(
      String id, {
      rtc.AudioRendererTraceHandler? onTrace,
    });

/// How long [RemoteAudioPlayback.reattach] leaves the renderers detached
/// before attaching them again. The media element picks up a new `srcObject`
/// in a queued task, so a detach and re-attach in the same task is seen as one
/// swap; the gap makes the detach real.
const _reattachDelay = Duration(milliseconds: 25);

/// Plays the remote audio tracks of every call through the WebRTC plugin's
/// [rtc.RTCAudioRenderer]s, one per track id, and decides when to re-attach
/// them, which tracks are blocked by the browser's autoplay policy and what is
/// traced.
@internal
class RemoteAudioPlayback {
  RemoteAudioPlayback({
    this.traceHandler,
    this._createRenderer = rtc.createAudioRenderer,
  });

  static RemoteAudioPlayback? _instance;

  /// The playback shared by every call on the page.
  // ignore: prefer_constructors_over_static_methods, lazy singleton accessor
  static RemoteAudioPlayback get instance =>
      _instance ??= RemoteAudioPlayback();

  /// Overrides the shared [instance], for testing. Null goes back to a
  /// lazily created one.
  @visibleForTesting
  static set instance(RemoteAudioPlayback? playback) => _instance = playback;

  /// Receives the playback traces, the renderers' included.
  RemoteAudioTraceHandler? traceHandler;

  final AudioRendererFactory _createRenderer;

  void _trace(String tag, Object? data) => traceHandler?.call(tag, data);

  void _traceRenderer(rtc.AudioRendererTrace trace) {
    _trace(trace.tag, trace.data);
  }

  /// The renderer of each track id.
  ///
  /// A track id is `trackIdPrefix:trackType`, which a migration keeps, so the
  /// session being replaced and the one replacing it share a renderer.
  final _renderers = <String, rtc.RTCAudioRenderer>{};

  final _stateSubscriptions =
      <String, StreamSubscription<rtc.AudioRendererState>>{};

  /// Seeded so a listener that subscribes after playback was already blocked
  /// (e.g. a second call joining the page) gets the current value.
  final _blockedController = BehaviorSubject<bool>.seeded(false);

  /// Emits whenever the autoplay policy starts or stops blocking at least one
  /// remote audio track.
  ///
  /// Only the autoplay policy is reported here: it is the one failure the app
  /// can do something about, by calling [resume] from a gesture. Every other
  /// playback failure is retried by the renderer instead.
  Stream<bool> get blockedChanges => _blockedController.stream;

  /// Whether the "this browser can't switch audio output" trace was already
  /// reported. The capability is page-global, so tracing it per track would
  /// repeat one fact once per participant.
  bool _tracedOutputChangeUnsupported = false;

  void _notifyBlocked() {
    final blocked = _renderers.values.any(_isBlocked);
    if (blocked == _blockedController.value) return;

    _blockedController.add(blocked);
  }

  /// Plays [track] as the remote audio of track [id].
  void start(String id, rtc.MediaStreamTrack track) {
    final renderer = _renderers[id] ??= _newRenderer(id);
    renderer.attach(track);
  }

  rtc.RTCAudioRenderer _newRenderer(String id) {
    final renderer = _createRenderer(id, onTrace: _traceRenderer);
    _stateSubscriptions[id] = renderer.stateChanges.listen(
      (_) => _notifyBlocked(),
    );
    return renderer;
  }

  static bool _isBlocked(rtc.RTCAudioRenderer renderer) {
    return renderer.state == rtc.AudioRendererState.blocked;
  }

  static bool _isRecovering(rtc.RTCAudioRenderer renderer) {
    return renderer.state == rtc.AudioRendererState.recovering;
  }

  /// Stops playing [track] and releases the renderer of track [id].
  ///
  /// Does nothing when the renderer has since been given another track. That
  /// is the new session's after a migration: the superseded session is
  /// disposed only once its replacement has bound the same ids.
  void stop(String id, rtc.MediaStreamTrack track) {
    final renderer = _renderers[id];
    if (renderer == null) return;
    if (renderer.track != null && !renderer.isAttachedTo(track)) {
      streamLog.v(
        _tag,
        () =>
            'Not stopping audio for track $id: its renderer plays another '
            'track',
      );
      return;
    }

    _renderers.remove(id);
    unawaited(_stateSubscriptions.remove(id)?.cancel());
    unawaited(
      renderer.dispose().catchError((Object e, StackTrace stk) {
        streamLog.e(_tag, () => 'Failed to dispose audio for $id: $e\n$stk');
      }),
    );
    _notifyBlocked();
  }

  /// Applies the audio output device [deviceId] to the renderer of track
  /// [id]. Only where the output is selected per renderer; elsewhere the
  /// platform's audio session selects it.
  Future<void> setSinkId(String id, String deviceId) async {
    final capabilities = rtc.webRtcCapabilities;
    if (!capabilities.selectsAudioOutputPerElement) return;

    if (!capabilities.supportsAudioOutputSelection) {
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

    final renderer = _renderers[id];
    if (renderer == null) {
      // Not a failure: the renderer is created when the track starts, and
      // every site that starts a track re-applies the selected output
      // immediately after, via `applyCurrentAudioOutputDevice` in
      // `call_session.dart`, which re-derives the device from call state.
      streamLog.w(
        _tag,
        () =>
            'No audio renderer for track $id yet, sink id $deviceId will be '
            're-applied once the track starts',
      );
      _trace(TraceTag.setSinkId, {
        'trackId': id,
        'deviceId': deviceId,
        'deferred': true,
      });
      return;
    }

    try {
      await renderer.setSinkId(deviceId);
      streamLog.i(_tag, () => 'Set sink id for track $id to $deviceId');
      _trace(TraceTag.setSinkId, {'trackId': id, 'deviceId': deviceId});
    } catch (e) {
      final unsupported = e is UnsupportedError;
      if (unsupported) {
        streamLog.w(
          _tag,
          () => 'Audio renderer for track $id does not support setSinkId',
        );
      } else {
        streamLog.e(_tag, () => 'Failed to set sink id for track $id: $e');
      }
      _trace(TraceTag.setSinkId, {
        'trackId': id,
        'deviceId': deviceId,
        'error': unsupported ? 'unsupported' : '$e',
      });
      rethrow;
    }
  }

  /// Retries playback of every renderer the browser's autoplay policy
  /// blocked, plus any renderer currently recovering. Must be called from
  /// within a user gesture.
  ///
  /// Recovering renderers are included because the gesture may be exactly
  /// what they were missing, and retrying now beats waiting out the backoff.
  Future<void> resume() async {
    final blocked = _renderers.values.where(_isBlocked).toList();
    final recovering = _renderers.values.where(_isRecovering).toList();

    _trace(TraceTag.resumeAudio, {
      'blockedTracks': blocked.length,
      'recoveringTracks': recovering.length,
    });

    await Future.wait([
      for (final renderer in {...blocked, ...recovering}) renderer.resume(),
    ]);
  }

  /// Whether remote audio has to be re-attached after a subscriber
  /// renegotiation that adds an audio source. True on WebKit only, where such
  /// a renegotiation silences the audio already playing; elsewhere [reattach]
  /// does nothing, so the offers need not be compared at all.
  bool get needsReattach => rtc.webRtcCapabilities.needsRemoteAudioReattach;

  /// The re-attach waiting out [_reattachDelay], if one is.
  ///
  /// A call arriving meanwhile joins it rather than detaching again: its own
  /// renegotiation has been applied by then, and the renderers are still
  /// detached, so the pending re-attach already comes after it. Cleared before
  /// the renderers are re-attached, so a call from then on starts a re-attach
  /// of its own, and cleared too by a re-attach that fails before its gap
  /// ends.
  Future<void>? _pendingReattach;

  /// Detaches every renderer and attaches it again to the same track. WebKit
  /// only; a no-op elsewhere.
  ///
  /// Called after a subscriber renegotiation that brought in a new audio
  /// source. Calls that arrive while one is waiting share it, so several
  /// participants joining together cost the renderers one gap rather than
  /// one each. Playback the autoplay policy blocks stays blocked until
  /// [resume]. [reason] names the trigger in the trace.
  Future<void> reattach({required String reason}) {
    if (!needsReattach) return Future.value();

    final pending = _pendingReattach;
    if (pending != null) {
      streamLog.v(
        _tag,
        () => 'Re-attach after $reason joins the one already waiting',
      );
      return pending;
    }

    final trackIds = _renderers.keys.toList();
    if (trackIds.isEmpty) return Future.value();

    final reattach = _reattach(trackIds, reason: reason);
    _pendingReattach = reattach;
    // A re-attach that runs to the end has cleared this already, when its gap
    // ended. One that failed before then has not, and would otherwise be
    // joined by every later call, leaving re-attach off for the rest of the
    // page.
    reattach.whenComplete(() {
      if (identical(_pendingReattach, reattach)) _pendingReattach = null;
    }).ignore();
    return reattach;
  }

  Future<void> _reattach(
    List<String> trackIds, {
    required String reason,
  }) async {
    streamLog.i(
      _tag,
      () =>
          'Re-attaching ${trackIds.length} remote audio renderer(s) '
          'after $reason',
    );
    _trace(TraceTag.audioPlaybackReattach, {
      'reason': reason,
      'tracks': trackIds.length,
      'blockedTracks': _renderers.values.where(_isBlocked).length,
    });

    for (final trackId in trackIds) {
      // Contained per track: stopping at one would leave the rest without a
      // re-attach, and the ones already detached silent.
      try {
        _renderers[trackId]?.detach();
      } catch (e, stk) {
        streamLog.e(
          _tag,
          () => 'Failed to detach audio for $trackId: $e\n$stk',
        );
      }
    }

    try {
      await Future<void>.delayed(_reattachDelay);
    } finally {
      _pendingReattach = null;
    }

    for (final trackId in trackIds) {
      final renderer = _renderers[trackId];
      final track = renderer?.track;
      // Stopped while we waited.
      if (renderer == null || track == null) continue;
      // Re-attached by a `start` that ran while we waited.
      if (renderer.isAttached) continue;

      // Contained per track, so one failure leaves no other renderer
      // detached.
      try {
        renderer.attach(track);
      } catch (e, stk) {
        streamLog.e(
          _tag,
          () => 'Failed to re-attach audio for $trackId: $e\n$stk',
        );
      }
    }
  }
}
