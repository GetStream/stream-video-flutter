import 'package:equatable/equatable.dart';

import '../../open_api/video/coordinator/api.dart';

class CallSettings with EquatableMixin {
  const CallSettings({
    this.ring = const StreamRingSettings(),
    this.audio = const StreamAudioSettings(),
    this.video = const StreamVideoSettings(),
    this.screenShare = const StreamScreenShareSettings(),
    this.recording = const StreamRecordingSettings(),
    this.broadcasting = const StreamBroadcastingSettings(),
    this.transcription = const StreamTranscriptionSettings(),
    this.backstage = const StreamBackstageSettings(),
    this.geofencing = const StreamGeofencingSettings(),
  });

  final StreamRingSettings ring;
  final StreamAudioSettings audio;
  final StreamVideoSettings video;
  final StreamScreenShareSettings screenShare;
  final StreamRecordingSettings recording;
  final StreamBroadcastingSettings broadcasting;
  final StreamTranscriptionSettings transcription;
  final StreamBackstageSettings backstage;
  final StreamGeofencingSettings geofencing;

  @override
  List<Object?> get props => [audio, video, screenShare];

  /// Returns a copy of this [CallSettings] with the given fields
  /// replaced with the new values.
  CallSettings copyWith({
    StreamRingSettings? ring,
    StreamAudioSettings? audio,
    StreamVideoSettings? video,
    StreamScreenShareSettings? screenShare,
    StreamRecordingSettings? recording,
    StreamBroadcastingSettings? broadcasting,
    StreamTranscriptionSettings? transcription,
    StreamBackstageSettings? backstage,
    StreamGeofencingSettings? geofencing,
  }) {
    return CallSettings(
      ring: ring ?? this.ring,
      audio: audio ?? this.audio,
      video: video ?? this.video,
      screenShare: screenShare ?? this.screenShare,
      recording: recording ?? this.recording,
      broadcasting: broadcasting ?? this.broadcasting,
      transcription: transcription ?? this.transcription,
      backstage: backstage ?? this.backstage,
      geofencing: geofencing ?? this.geofencing,
    );
  }
}

abstract class AbstractSettings with EquatableMixin {
  const AbstractSettings();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

abstract class MediaSettings with EquatableMixin {
  const MediaSettings({required this.accessRequestEnabled});

  final bool accessRequestEnabled;
}

class StreamAudioSettings extends MediaSettings {
  const StreamAudioSettings({
    super.accessRequestEnabled = false,
    this.opusDtxEnabled = false,
    this.redundantCodingEnabled = false,
    this.defaultDevice = AudioSettingsRequestDefaultDeviceEnum.speaker,
  });

  final bool opusDtxEnabled;
  final bool redundantCodingEnabled;
  final AudioSettingsRequestDefaultDeviceEnum defaultDevice;

  @override
  List<Object?> get props => [
        accessRequestEnabled,
        opusDtxEnabled,
        redundantCodingEnabled,
      ];

  AudioSettingsRequest toOpenDto() {
    return AudioSettingsRequest(
      defaultDevice: defaultDevice,
      accessRequestEnabled: accessRequestEnabled,
      opusDtxEnabled: opusDtxEnabled,
      redundantCodingEnabled: redundantCodingEnabled,
    );
  }
}

class StreamVideoSettings extends MediaSettings {
  const StreamVideoSettings({
    super.accessRequestEnabled = false,
    this.enabled = false,
  });

  final bool enabled;

  @override
  List<Object?> get props => [
        accessRequestEnabled,
        enabled,
      ];

  VideoSettingsRequest toOpenDto() {
    return VideoSettingsRequest(
      enabled: enabled,
      accessRequestEnabled: accessRequestEnabled,
    );
  }
}

class StreamScreenShareSettings extends MediaSettings {
  const StreamScreenShareSettings({
    super.accessRequestEnabled = false,
    this.enabled = false,
  });

  final bool enabled;

  @override
  List<Object?> get props => [
        accessRequestEnabled,
        enabled,
      ];

  ScreensharingSettingsRequest toOpenDto() {
    return ScreensharingSettingsRequest(
      enabled: enabled,
      accessRequestEnabled: accessRequestEnabled,
    );
  }
}

class StreamBackstageSettings extends AbstractSettings {
  const StreamBackstageSettings({
    this.enabled = false,
  });

  final bool enabled;

  @override
  List<Object?> get props => [enabled];

  BackstageSettingsRequest toOpenDto() {
    return BackstageSettingsRequest(
      enabled: enabled,
    );
  }
}

class StreamBroadcastingSettings extends AbstractSettings {
  const StreamBroadcastingSettings({
    this.enabled = false,
    this.hls = const StreamHlsSettings(),
  });

  final bool enabled;
  final StreamHlsSettings hls;

  @override
  List<Object?> get props => [enabled, hls];
}

class StreamGeofencingSettings extends AbstractSettings {
  const StreamGeofencingSettings({
    this.names = const [],
  });

  final List<String> names;

  @override
  List<Object?> get props => [names];

  GeofenceSettingsRequest toOpenDto() {
    return GeofenceSettingsRequest(
      names: names,
    );
  }
}

class StreamRecordingSettings extends AbstractSettings {
  const StreamRecordingSettings({
    this.audioOnly = false,
    this.mode = RecordSettingsMode.disabled,
    this.quality = RecordSettingsQuality.audioOnly,
  });

  final bool audioOnly;

  final RecordSettingsMode mode;

  final RecordSettingsQuality quality;

  @override
  List<Object?> get props => [audioOnly, mode, quality];

  RecordSettingsRequest toOpenDto() {
    return RecordSettingsRequest(
      audioOnly: audioOnly,
      mode: mode.toOpenDto(),
      quality: quality.toOpenDto(),
    );
  }
}

class StreamRingSettings extends AbstractSettings {
  const StreamRingSettings({
    this.autoCancelTimeout = const Duration(seconds: 30),
    this.autoRejectTimeout = const Duration(seconds: 30),
  });

  final Duration autoCancelTimeout;

  final Duration autoRejectTimeout;

  @override
  List<Object?> get props => [autoCancelTimeout, autoRejectTimeout];

  RingSettingsRequest toOpenDto() {
    return RingSettingsRequest(
      autoCancelTimeoutMs: autoCancelTimeout.inMilliseconds,
      incomingCallTimeoutMs: autoRejectTimeout.inMilliseconds,
    );
  }
}

class StreamTranscriptionSettings extends AbstractSettings {
  const StreamTranscriptionSettings({
    this.closedCaptionMode = '',
    this.mode = TranscriptionSettingsMode.disabled,
  });

  final String closedCaptionMode;

  final TranscriptionSettingsMode mode;

  @override
  List<Object?> get props => [closedCaptionMode, mode];

  TranscriptionSettingsRequest toOpenDto() {
    return TranscriptionSettingsRequest(
      closedCaptionMode: closedCaptionMode,
      mode: mode.toOpenDto(),
    );
  }
}

class StreamHlsSettings extends AbstractSettings {
  const StreamHlsSettings({
    this.autoOn = false,
    this.enabled = false,
    this.qualityTracks = const [],
  });

  final bool enabled;
  final bool autoOn;
  final List<String> qualityTracks;

  @override
  List<Object?> get props => [enabled, autoOn, qualityTracks];
}

enum RecordSettingsMode {
  available,
  disabled,
  autoOn;

  @override
  String toString() => name;

  RecordSettingsRequestModeEnum toOpenDto() {
    switch (this) {
      case RecordSettingsMode.available:
        return RecordSettingsRequestModeEnum.available;
      case RecordSettingsMode.disabled:
        return RecordSettingsRequestModeEnum.disabled;
      case RecordSettingsMode.autoOn:
        return RecordSettingsRequestModeEnum.autoOn;
    }
  }
}

enum RecordSettingsQuality {
  audioOnly,
  n360p,
  n480p,
  n720p,
  n1080p,
  n1440p;

  @override
  String toString() => name;

  RecordSettingsRequestQualityEnum toOpenDto() {
    switch (this) {
      case RecordSettingsQuality.audioOnly:
        return RecordSettingsRequestQualityEnum.audioOnly;
      case RecordSettingsQuality.n360p:
        return RecordSettingsRequestQualityEnum.n360p;
      case RecordSettingsQuality.n480p:
        return RecordSettingsRequestQualityEnum.n480p;
      case RecordSettingsQuality.n720p:
        return RecordSettingsRequestQualityEnum.n720p;
      case RecordSettingsQuality.n1080p:
        return RecordSettingsRequestQualityEnum.n1080p;
      case RecordSettingsQuality.n1440p:
        return RecordSettingsRequestQualityEnum.n1440p;
    }
  }
}

enum TranscriptionSettingsMode {
  available,
  disabled,
  autoOn;

  @override
  String toString() => name;

  TranscriptionSettingsRequestModeEnum toOpenDto() {
    switch (this) {
      case TranscriptionSettingsMode.available:
        return TranscriptionSettingsRequestModeEnum.available;
      case TranscriptionSettingsMode.disabled:
        return TranscriptionSettingsRequestModeEnum.disabled;
      case TranscriptionSettingsMode.autoOn:
        return TranscriptionSettingsRequestModeEnum.autoOn;
    }
  }
}
