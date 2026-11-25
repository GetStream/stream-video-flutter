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

  @override
  void attach(MediaStreamTrack track) {
    _track = track;
    _attached = true;
  }

  @override
  void detach() => _attached = false;

  @override
  bool isAttachedTo(MediaStreamTrack track) => identical(_track, track);

  @override
  bool muted = false;

  @override
  Future<void> setSinkId(String deviceId) async {}

  @override
  bool get isBlocked => false;

  @override
  Stream<bool> get playbackBlocked => const Stream.empty();

  @override
  bool get isRecovering => false;

  @override
  Future<void> resume() async {}

  @override
  Future<void> dispose() async => _attached = false;
}
