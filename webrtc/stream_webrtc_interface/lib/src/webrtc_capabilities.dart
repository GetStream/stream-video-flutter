import 'package:meta/meta.dart';

/// What the WebRTC implementation on this platform can do.
///
/// The WebRTC packages build the value for the platform the app runs on; a
/// test builds one with the capabilities it needs.
@immutable
class WebRtcCapabilities {
  const WebRtcCapabilities({
    required this.supportsPerCallFactory,
    required this.supportsAudioPlayoutPause,
    required this.supportsAudioOutputSelection,
    required this.supportsCameraSwitch,
    required this.switchesAudioInputInPlace,
    required this.selectsAudioOutputPerElement,
    required this.supportsBroadcastExtension,
    required this.supportsScreenShareSourceSelection,
    required this.hasUnlistedEarpiece,
    required this.usesExactDeviceIdConstraints,
    required this.reusesScreenShareCapture,
  });

  /// Whether each call can build its own peer connection factory, with its
  /// own audio device module. Android, iOS and macOS.
  final bool supportsPerCallFactory;

  /// Whether remote audio playout can be paused and resumed. Android, iOS,
  /// macOS and web.
  final bool supportsAudioPlayoutPause;

  /// Whether remote audio can be routed to an output the app picks. True on
  /// native platforms; on web, true where the browser has `setSinkId` and is
  /// not WebKit.
  final bool supportsAudioOutputSelection;

  /// Whether the camera can be switched between front and back on a running
  /// capture. Not on web.
  final bool supportsCameraSwitch;

  /// Whether the microphone can be changed on a running capture. On web the
  /// input is part of the capture, so a new one is needed.
  final bool switchesAudioInputInPlace;

  /// Whether the audio output is set on each remote audio element rather than
  /// on the platform's audio session. Web.
  final bool selectsAudioOutputPerElement;

  /// Whether a screen can be shared through a broadcast extension. iOS.
  final bool supportsBroadcastExtension;

  /// Whether the screen or window to share is picked by its source id.
  /// Windows, macOS and Linux.
  final bool supportsScreenShareSourceSelection;

  /// Whether the device has a built-in earpiece that device enumeration
  /// leaves out. iOS.
  final bool hasUnlistedEarpiece;

  /// Whether a device is picked with an exact `deviceId` constraint, which
  /// cannot be combined with the optional constraints. Web.
  final bool usesExactDeviceIdConstraints;

  /// Whether a running screen share can be kept when it is asked for again
  /// with the same source. Not on web, where every request opens a new
  /// capture.
  final bool reusesScreenShareCapture;

  WebRtcCapabilities copyWith({
    bool? supportsPerCallFactory,
    bool? supportsAudioPlayoutPause,
    bool? supportsAudioOutputSelection,
    bool? supportsCameraSwitch,
    bool? switchesAudioInputInPlace,
    bool? selectsAudioOutputPerElement,
    bool? supportsBroadcastExtension,
    bool? supportsScreenShareSourceSelection,
    bool? hasUnlistedEarpiece,
    bool? usesExactDeviceIdConstraints,
    bool? reusesScreenShareCapture,
  }) {
    return WebRtcCapabilities(
      supportsPerCallFactory:
          supportsPerCallFactory ?? this.supportsPerCallFactory,
      supportsAudioPlayoutPause:
          supportsAudioPlayoutPause ?? this.supportsAudioPlayoutPause,
      supportsAudioOutputSelection:
          supportsAudioOutputSelection ?? this.supportsAudioOutputSelection,
      supportsCameraSwitch: supportsCameraSwitch ?? this.supportsCameraSwitch,
      switchesAudioInputInPlace:
          switchesAudioInputInPlace ?? this.switchesAudioInputInPlace,
      selectsAudioOutputPerElement:
          selectsAudioOutputPerElement ?? this.selectsAudioOutputPerElement,
      supportsBroadcastExtension:
          supportsBroadcastExtension ?? this.supportsBroadcastExtension,
      supportsScreenShareSourceSelection:
          supportsScreenShareSourceSelection ??
          this.supportsScreenShareSourceSelection,
      hasUnlistedEarpiece: hasUnlistedEarpiece ?? this.hasUnlistedEarpiece,
      usesExactDeviceIdConstraints:
          usesExactDeviceIdConstraints ?? this.usesExactDeviceIdConstraints,
      reusesScreenShareCapture:
          reusesScreenShareCapture ?? this.reusesScreenShareCapture,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WebRtcCapabilities &&
          other.supportsPerCallFactory == supportsPerCallFactory &&
          other.supportsAudioPlayoutPause == supportsAudioPlayoutPause &&
          other.supportsAudioOutputSelection == supportsAudioOutputSelection &&
          other.supportsCameraSwitch == supportsCameraSwitch &&
          other.switchesAudioInputInPlace == switchesAudioInputInPlace &&
          other.selectsAudioOutputPerElement == selectsAudioOutputPerElement &&
          other.supportsBroadcastExtension == supportsBroadcastExtension &&
          other.supportsScreenShareSourceSelection ==
              supportsScreenShareSourceSelection &&
          other.hasUnlistedEarpiece == hasUnlistedEarpiece &&
          other.usesExactDeviceIdConstraints == usesExactDeviceIdConstraints &&
          other.reusesScreenShareCapture == reusesScreenShareCapture;

  @override
  int get hashCode => Object.hash(
    supportsPerCallFactory,
    supportsAudioPlayoutPause,
    supportsAudioOutputSelection,
    supportsCameraSwitch,
    switchesAudioInputInPlace,
    selectsAudioOutputPerElement,
    supportsBroadcastExtension,
    supportsScreenShareSourceSelection,
    hasUnlistedEarpiece,
    usesExactDeviceIdConstraints,
    reusesScreenShareCapture,
  );
}

/// Replaces the platform's [WebRtcCapabilities] while set, for tests. Null
/// goes back to the platform's own.
@visibleForTesting
WebRtcCapabilities? debugWebRtcCapabilitiesOverride;
