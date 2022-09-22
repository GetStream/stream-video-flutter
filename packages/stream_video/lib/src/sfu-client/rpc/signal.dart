import 'package:webrtc_interface/src/rtc_ice_candidate.dart';

abstract class SfuSignalingClient {
  //his.sessionId = uuidv4();
  Future<void> sendCandidate({
    required bool publisher,
    String? candidate,
    String? sdpMid,
    int? sdpMLineIndex,
    String? usernameFragment,
  }) ;//async {}

  Future<String> setPublisher({String? sdp});// async {}

// updateAudioMuteState
// updateVideoMuteState

// requestVideoQuality
// updateSubscriptions
  // sendIceCandidate
}
