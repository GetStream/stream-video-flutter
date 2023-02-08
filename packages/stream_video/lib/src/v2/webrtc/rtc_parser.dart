import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';

class RtcIceCandidateParser {
  static RTCIceCandidate fromJsonString(String jsonText) {
    final iceCandidateJson = json.decode(jsonText);
    return RTCIceCandidate(
      iceCandidateJson['candidate'],
      iceCandidateJson['sdpMid'],
      iceCandidateJson['sdpMLineIndex'],
    );
  }
}
