import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import '../third_party/flutter_webrtc/helper.dart';

/// Creates the renderer of the remote audio track [id]. Native platforms play
/// remote audio themselves, so it does nothing.
RTCAudioRenderer createAudioRenderer(
  String id, {
  AudioRendererTraceHandler? onTrace,
}) {
  return NativeAudioRenderer(id);
}

/// Pauses or resumes remote audio playout in the audio device module. Android,
/// iOS and macOS; see `WebRtcCapabilities.supportsAudioPlayoutPause`.
Future<void> setAudioPlayoutPaused(bool paused) {
  return paused ? Helper.pauseAudioPlayout() : Helper.resumeAudioPlayout();
}

// ignore: subtype_of_sealed_class, the plugin implements its own contract
/// An [RTCAudioRenderer] that does nothing, for native platforms.
@internal
class NativeAudioRenderer implements RTCAudioRenderer {
  NativeAudioRenderer(this.id);

  @override
  final String id;

  MediaStreamTrack? _track;
  bool _attached = false;

  @override
  MediaStreamTrack? get track => _track;

  @override
  bool get isAttached => _attached;

  final _stateChanges = StreamController<AudioRendererState>.broadcast(
    sync: true,
  );

  @override
  void attach(MediaStreamTrack track) {
    _track = track;
    _setAttached(true);
  }

  @override
  void detach() => _setAttached(false);

  void _setAttached(bool attached) {
    if (_attached == attached) return;
    _attached = attached;
    _stateChanges.add(state);
  }

  @override
  bool isAttachedTo(MediaStreamTrack track) {
    final attached = _track;
    return attached != null && attached.id == track.id;
  }

  @override
  bool muted = false;

  @override
  Future<void> setSinkId(String deviceId) async {}

  @override
  AudioRendererState get state =>
      _attached ? AudioRendererState.playing : AudioRendererState.detached;

  @override
  Stream<AudioRendererState> get stateChanges => _stateChanges.stream;

  @override
  Future<void> resume() async {}

  @override
  Future<void> dispose() async {
    _setAttached(false);
    await _stateChanges.close();
  }
}
