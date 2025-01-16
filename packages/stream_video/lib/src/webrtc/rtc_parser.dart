import 'dart:convert';

import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

mixin RtcIceCandidateParser {
  static RTCIceCandidate fromJsonString(String jsonText) {
    final iceCandidateJson = json.decode(jsonText) as Map<String, dynamic>;

    return RTCIceCandidate(
      iceCandidateJson['candidate'],
      iceCandidateJson['sdpMid'],
      iceCandidateJson['sdpMLineIndex'],
    );
  }
}
