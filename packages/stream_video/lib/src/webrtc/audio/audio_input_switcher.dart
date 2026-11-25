import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart' as rtc;

import '../../../stream_video.dart';
import '../publisher/rtc_publisher.dart';
import '../webrtc_engine.dart';

const _tag = 'SV:RtcLocalAudioTrack';

/// Moves a local microphone track to another audio input.
///
/// Native platforms switch the input of the running capture. On web the input
/// is part of the capture, so the microphone is captured again on the new
/// device.
@internal
abstract interface class AudioInputSwitcher {
  /// The switcher of the current platform.
  factory AudioInputSwitcher.forPlatform() {
    if (webRtcEngine.capabilities.switchesAudioInputInPlace) {
      return const InPlaceAudioInputSwitcher();
    }
    return const RecaptureAudioInputSwitcher();
  }

  /// Moves the published track [trackId] of [publisher] to [device], and
  /// keeps the result in its place.
  Future<Result<RtcLocalTrack>> switchPublished(
    RtcPublisher publisher,
    String trackId,
    RtcMediaDevice device, {
    required String tag,
  });

  /// Moves [track] to [device]. A new capture is sent on [transceivers].
  Future<RtcLocalAudioTrack> switchTrack(
    RtcLocalAudioTrack track,
    List<rtc.RTCRtpTransceiver> transceivers,
    RtcMediaDevice device,
  );
}

/// Switches the input of the running capture.
@internal
class InPlaceAudioInputSwitcher implements AudioInputSwitcher {
  const InPlaceAudioInputSwitcher();

  @override
  Future<Result<RtcLocalTrack>> switchPublished(
    RtcPublisher publisher,
    String trackId,
    RtcMediaDevice device, {
    required String tag,
  }) {
    return publisher.updateHeldTrack(
      trackId,
      // Through selectAudioInput, which keeps a track already on [device].
      (current) =>
          (current as RtcLocalAudioTrack).selectAudioInput(const [], device),
      tag: tag,
    );
  }

  @override
  Future<RtcLocalAudioTrack> switchTrack(
    RtcLocalAudioTrack track,
    List<rtc.RTCRtpTransceiver> transceivers,
    RtcMediaDevice device,
  ) async {
    try {
      await webRtcEngine.audio.selectAudioInput(device.id);
    } catch (e) {
      streamLog.e(_tag, () => 'Error selecting audio input: $e');
      rethrow;
    }
    return track.copyWith(
      mediaConstraints: track.mediaConstraints.copyWith(deviceId: device.id),
    );
  }
}

/// Captures the microphone again on the new input.
@internal
class RecaptureAudioInputSwitcher implements AudioInputSwitcher {
  const RecaptureAudioInputSwitcher();

  @override
  Future<Result<RtcLocalTrack>> switchPublished(
    RtcPublisher publisher,
    String trackId,
    RtcMediaDevice device, {
    required String tag,
  }) {
    return publisher.recapture(
      trackId,
      tag: tag,
      constraintsFor: (current) => (current as RtcLocalAudioTrack)
          .mediaConstraints
          .copyWith(deviceId: device.id),
    );
  }

  @override
  Future<RtcLocalAudioTrack> switchTrack(
    RtcLocalAudioTrack track,
    List<rtc.RTCRtpTransceiver> transceivers,
    RtcMediaDevice device,
  ) {
    return track.recreate(
      transceivers,
      mediaConstraints: track.mediaConstraints.copyWith(deviceId: device.id),
    );
  }
}
