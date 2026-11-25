// ignore_for_file: invalid_use_of_visible_for_testing_member, implementation_imports

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_webrtc_flutter/src/native/native_webrtc_capabilities.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

/// Reports Android's WebRTC capabilities, with audio playout pause as given,
/// for the rest of the test, whatever the host running it supports.
///
/// Call it from a test body or a `setUp`.
void overrideAudioPlayoutPauseSupport({required bool supported}) {
  rtc.debugWebRtcCapabilitiesOverride = nativeWebRtcCapabilitiesFor(
    isAndroid: true,
    isIOS: false,
    isMacOS: false,
    isWindows: false,
    isLinux: false,
  ).copyWith(supportsAudioPlayoutPause: supported);
  addTearDown(() => rtc.debugWebRtcCapabilitiesOverride = null);
}
