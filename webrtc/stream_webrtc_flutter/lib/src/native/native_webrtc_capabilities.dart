import 'dart:io';

import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

/// The capabilities of the native platform the app runs on.
@internal
final WebRtcCapabilities nativeWebRtcCapabilities = nativeWebRtcCapabilitiesFor(
  isAndroid: Platform.isAndroid,
  isIOS: Platform.isIOS,
  isMacOS: Platform.isMacOS,
  isWindows: Platform.isWindows,
  isLinux: Platform.isLinux,
);

/// The capabilities of the native platform described by the flags.
@visibleForTesting
WebRtcCapabilities nativeWebRtcCapabilitiesFor({
  required bool isAndroid,
  required bool isIOS,
  required bool isMacOS,
  required bool isWindows,
  required bool isLinux,
}) {
  return WebRtcCapabilities(
    supportsPerCallFactory: isAndroid || isIOS || isMacOS,
    supportsAudioPlayoutPause: isAndroid || isIOS || isMacOS,
    supportsAudioOutputSelection: true,
    supportsCameraSwitch: true,
    switchesAudioInputInPlace: true,
    selectsAudioOutputPerElement: false,
    supportsBroadcastExtension: isIOS,
    supportsScreenShareSourceSelection: isWindows || isMacOS || isLinux,
    hasUnlistedEarpiece: isIOS,
    usesExactDeviceIdConstraints: false,
    reusesScreenShareCapture: true,
  );
}
