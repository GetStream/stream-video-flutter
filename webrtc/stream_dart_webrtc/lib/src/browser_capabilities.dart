import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

/// The capabilities of a browser that can, or cannot, route remote audio to
/// an output the app picks.
WebRtcCapabilities webRtcCapabilitiesFor({
  required bool supportsAudioOutputSelection,
}) {
  return WebRtcCapabilities(
    supportsPerCallFactory: false,
    supportsAudioPlayoutPause: true,
    supportsAudioOutputSelection: supportsAudioOutputSelection,
    supportsCameraSwitch: false,
    switchesAudioInputInPlace: false,
    selectsAudioOutputPerElement: true,
    supportsBroadcastExtension: false,
    supportsScreenShareSourceSelection: false,
    hasUnlistedEarpiece: false,
    usesExactDeviceIdConstraints: true,
    reusesScreenShareCapture: false,
  );
}
