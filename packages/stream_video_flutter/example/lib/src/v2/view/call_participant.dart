import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/stream_video.dart';

class CallParticipantV2 {
  const CallParticipantV2({
    required this.state,
    this.renderer,
  });

  final CallParticipantStateV2 state;
  final ParticipantRenderer? renderer;
}

class ParticipantRenderer {
  final rtc.RTCVideoRenderer videoRenderer = rtc.RTCVideoRenderer();
  late final SfuTrackType trackType;

  set srcObject(RtcTrack srcObject) {
    trackType = srcObject.trackType;
    videoRenderer.srcObject = srcObject.stream;
  }

  Future<void> initialize() async {
    await videoRenderer.initialize();
  }

  Future<void> dispose() async {
    await videoRenderer.dispose();
  }
}
