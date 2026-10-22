import 'package:meta/meta.dart';

import '../../open_api/video/coordinator/api.dart';
import '../models/audio_configuration_policy.dart';
import '../utils/extensions.dart';
import 'rtc_media_device/rtc_media_device.dart';

/// The port type iOS reports for the built-in receiver (earpiece),
/// `AVAudioSessionPortBuiltInReceiver`.
const _iosBuiltInReceiverPortType = 'Receiver';

/// Whether the iOS audio session should ask for the loudspeaker
/// (`defaultToSpeaker`) as its built-in output.
///
/// The loudspeaker is asked for when [speakerRequested], or when [policy]
/// [AudioConfigurationPolicy.defaultsToSpeaker] and the earpiece was not
/// explicitly requested. Under such a policy the loudspeaker therefore stays
/// the built-in fallback while headphones or a Bluetooth device are in use,
/// so disconnecting them does not move the audio to the earpiece.
@internal
bool resolveAppleSpeakerOn({
  required AudioConfigurationPolicy policy,
  required bool speakerRequested,
  bool earpieceRequested = false,
}) {
  return speakerRequested || (policy.defaultsToSpeaker && !earpieceRequested);
}

@internal
extension AppleAudioRouteDevice on RtcMediaDevice {
  /// Whether this is the built-in loudspeaker.
  bool get isBuiltInSpeaker =>
      id.equalsIgnoreCase(AudioSettingsRequestDefaultDevice.speaker);

  /// Whether this is the built-in earpiece (receiver).
  bool get isBuiltInEarpiece =>
      id.equalsIgnoreCase(
        AudioSettingsRequestDefaultDevice.earpiece,
      ) ||
      groupId == _iosBuiltInReceiverPortType;
}
