import 'dart:convert';

import 'package:stream_webrtc_flutter/flutter_webrtc.dart';

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
