import 'package:meta/meta.dart';

/// What the WebRTC implementation on this platform can do.
///
/// The WebRTC packages build the value for the platform the app runs on; a
/// test builds one with the capabilities it needs. A capability added later
/// defaults to `false`.
@immutable
final class WebRtcCapabilities {
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
    required this.reportsAudioInterruptions,
    required this.supportsSystemManagedAudioFocus,
    this.needsRemoteAudioReattach = false,
    this.supportsEncryption = false,
    this.supportsAudioModuleMicrophoneMute = false,
    this.supportsVideoEffects = false,
    required this.supportsAudioProcessingModule,
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

  /// Whether the camera can be switched on a running capture: between front
  /// and back on mobile, to the next camera on desktop. Not on web.
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

  /// Whether the platform reports interruptions of the app's audio, such as a
  /// phone call or another app taking it, on
  /// `WebRtcPlatformEvents.onInterruption`. Android and iOS.
  final bool reportsAudioInterruptions;

  /// Whether WebRTC can be told that the system manages audio focus for the
  /// call in progress, such as Android's Telecom for a call it holds, and then
  /// leaves the focus to it. Android.
  final bool supportsSystemManagedAudioFocus;

  /// Whether remote audio goes silent after a subscriber renegotiation that
  /// adds an audio source, until each audio renderer is detached and attached
  /// again. WebKit browsers.
  final bool needsRemoteAudioReattach;

  /// Whether outgoing and incoming frames can be end-to-end encrypted, see
  /// `EncryptionManager`. Android, iOS and macOS.
  final bool supportsEncryption;

  /// Whether the microphone can be muted in the audio device module, see
  /// `PeerConnectionFactory.setMicrophoneMuted`. iOS and macOS.
  final bool supportsAudioModuleMicrophoneMute;

  /// Whether frame processors registered by name in the plugin's
  /// `ProcessorProvider` can be attached to a local video track through
  /// `setVideoEffects`. Android and iOS.
  final bool supportsVideoEffects;

  /// Whether a native audio processing module, such as noise cancellation,
  /// can be installed through the plugin's audio processing hook. Android,
  /// iOS and macOS.
  final bool supportsAudioProcessingModule;

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
    bool? reportsAudioInterruptions,
    bool? supportsSystemManagedAudioFocus,
    bool? needsRemoteAudioReattach,
    bool? supportsEncryption,
    bool? supportsAudioModuleMicrophoneMute,
    bool? supportsVideoEffects,
    bool? supportsAudioProcessingModule,
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
      reportsAudioInterruptions:
          reportsAudioInterruptions ?? this.reportsAudioInterruptions,
      supportsSystemManagedAudioFocus:
          supportsSystemManagedAudioFocus ??
          this.supportsSystemManagedAudioFocus,
      needsRemoteAudioReattach:
          needsRemoteAudioReattach ?? this.needsRemoteAudioReattach,
      supportsEncryption: supportsEncryption ?? this.supportsEncryption,
      supportsAudioModuleMicrophoneMute:
          supportsAudioModuleMicrophoneMute ??
          this.supportsAudioModuleMicrophoneMute,
      supportsVideoEffects: supportsVideoEffects ?? this.supportsVideoEffects,
      supportsAudioProcessingModule:
          supportsAudioProcessingModule ?? this.supportsAudioProcessingModule,
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
      'reportsAudioInterruptions': reportsAudioInterruptions,
      'supportsSystemManagedAudioFocus': supportsSystemManagedAudioFocus,
      'needsRemoteAudioReattach': needsRemoteAudioReattach,
      'supportsEncryption': supportsEncryption,
      'supportsAudioModuleMicrophoneMute': supportsAudioModuleMicrophoneMute,
      'supportsVideoEffects': supportsVideoEffects,
      'supportsAudioProcessingModule': supportsAudioProcessingModule,
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
          other.reportsAudioInterruptions == reportsAudioInterruptions &&
          other.supportsSystemManagedAudioFocus ==
              supportsSystemManagedAudioFocus &&
          other.needsRemoteAudioReattach == needsRemoteAudioReattach &&
          other.supportsEncryption == supportsEncryption &&
          other.supportsAudioModuleMicrophoneMute ==
              supportsAudioModuleMicrophoneMute &&
          other.supportsVideoEffects == supportsVideoEffects &&
          other.supportsAudioProcessingModule == supportsAudioProcessingModule;

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
    reportsAudioInterruptions,
    supportsSystemManagedAudioFocus,
    needsRemoteAudioReattach,
    supportsEncryption,
    supportsAudioModuleMicrophoneMute,
    supportsVideoEffects,
    supportsAudioProcessingModule,
  );
}

/// Replaces the platform's [WebRtcCapabilities] while set, for tests. Null
/// goes back to the platform's own. Read only in debug builds.
@visibleForTesting
WebRtcCapabilities? debugWebRtcCapabilitiesOverride;
