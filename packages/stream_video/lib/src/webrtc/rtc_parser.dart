import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';

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
