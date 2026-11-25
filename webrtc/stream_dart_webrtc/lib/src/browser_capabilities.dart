import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

/// The capabilities of a browser that can, or cannot, route remote audio to
/// an output the app picks, on WebKit or not.
@visibleForTesting
WebRtcCapabilities browserWebRtcCapabilitiesFor({
  required bool supportsAudioOutputSelection,
  bool isWebKit = false,
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
    omitsEarpieceFromEnumeration: false,
    usesExactDeviceIdConstraints: true,
    reportsAudioInterruptions: false,
    supportsSystemManagedAudioFocus: false,
    needsRemoteAudioReattach: isWebKit,
    supportsAudioProcessingModule: false,
  );
}
