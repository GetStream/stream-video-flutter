import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/stream_video.dart';

class CallParticipantV2 {
  const CallParticipantV2({
    required this.state,
    this.renderer,
  });

  final CallParticipantStateV2 state;
  final rtc.RTCVideoRenderer? renderer;
}
