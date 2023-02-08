import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/stream_video.dart';

class CallParticipantV2 {
  const CallParticipantV2({
    required this.state,
    this.renderer,
  });

  final CallParticipantStateV2 state;
  final ParticipantRenderer? renderer;

  @override
  String toString() {
    return 'CallParticipantV2{renderer: $renderer, state: $state}';
  }
}

class ParticipantRenderer {
  final rtc.RTCVideoRenderer videoRenderer = rtc.RTCVideoRenderer();
  late SfuTrackTypeVideo trackType;

  void srcObject(RtcTrack srcObject, SfuTrackTypeVideo trackType) {
    this.trackType = trackType;
    videoRenderer.srcObject = srcObject.stream;
  }

  Future<void> initialize() async {
    await videoRenderer.initialize();
  }

  Future<void> dispose() async {
    await videoRenderer.dispose();
  }
}
