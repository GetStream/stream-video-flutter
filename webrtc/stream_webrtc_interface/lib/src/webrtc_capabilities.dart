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
    required this.omitsEarpieceFromEnumeration,
    required this.usesExactDeviceIdConstraints,
    required this.reusesScreenShareCapture,
  });

  /// Whether each call can build its own peer connection factory, with its
  /// own audio device module. Android, iOS and macOS.
  final bool supportsPerCallFactory;

  /// Whether remote audio playout can be paused and resumed. Android, iOS,
  /// macOS and web.
  final bool supportsAudioPlayoutPause;

  /// Whether remote audio can be routed to an output the app picks, reliably.
  /// True on native platforms; on web, true where the browser has `setSinkId`
  /// and is not WebKit, whose `setSinkId` exists but is not dependable.
  final bool supportsAudioOutputSelection;

  /// Whether the camera can be switched between front and back on a running
  /// capture. Not on web.
  final bool supportsCameraSwitch;

  /// Whether the microphone can be changed on a running capture. Not on web.
  final bool switchesAudioInputInPlace;

  /// Whether the audio output is set on each remote audio element rather than
  /// on the platform's audio session. Web.
  final bool selectsAudioOutputPerElement;

  /// Whether a screen can be shared through a broadcast extension. iOS.
  final bool supportsBroadcastExtension;

  /// Whether the screen or window to share is picked by its source id.
  /// Windows, macOS and Linux.
  final bool supportsScreenShareSourceSelection;

  /// Whether device enumeration leaves out the built-in earpiece, which is
  /// then the default route rather than a listed output. iOS.
  final bool omitsEarpieceFromEnumeration;

  /// Whether a device is picked with an exact `deviceId` constraint, which
  /// cannot be combined with the optional constraints. Web.
  final bool usesExactDeviceIdConstraints;

  /// Whether a screen share request names its source, so a running share of
  /// the same source can be kept. Not on web, where every request opens the
  /// browser's picker.
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
    bool? omitsEarpieceFromEnumeration,
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
      omitsEarpieceFromEnumeration:
          omitsEarpieceFromEnumeration ?? this.omitsEarpieceFromEnumeration,
      usesExactDeviceIdConstraints:
          usesExactDeviceIdConstraints ?? this.usesExactDeviceIdConstraints,
      reusesScreenShareCapture:
          reusesScreenShareCapture ?? this.reusesScreenShareCapture,
    );
  }

  @override
  String toString() {
    final flags = <String, bool>{
      'supportsPerCallFactory': supportsPerCallFactory,
      'supportsAudioPlayoutPause': supportsAudioPlayoutPause,
      'supportsAudioOutputSelection': supportsAudioOutputSelection,
      'supportsCameraSwitch': supportsCameraSwitch,
      'switchesAudioInputInPlace': switchesAudioInputInPlace,
      'selectsAudioOutputPerElement': selectsAudioOutputPerElement,
      'supportsBroadcastExtension': supportsBroadcastExtension,
      'supportsScreenShareSourceSelection': supportsScreenShareSourceSelection,
      'omitsEarpieceFromEnumeration': omitsEarpieceFromEnumeration,
      'usesExactDeviceIdConstraints': usesExactDeviceIdConstraints,
      'reusesScreenShareCapture': reusesScreenShareCapture,
    };
    final enabled = [
      for (final MapEntry(:key, :value) in flags.entries)
        if (value) key,
    ];
    return 'WebRtcCapabilities(${enabled.join(', ')})';
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
          other.omitsEarpieceFromEnumeration == omitsEarpieceFromEnumeration &&
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
    omitsEarpieceFromEnumeration,
    usesExactDeviceIdConstraints,
    reusesScreenShareCapture,
  );
}

/// Replaces the platform's [WebRtcCapabilities] while set, for tests. Null
/// goes back to the platform's own. Read only in debug builds.
@visibleForTesting
WebRtcCapabilities? debugWebRtcCapabilitiesOverride;
