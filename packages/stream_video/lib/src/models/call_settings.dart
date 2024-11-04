import 'package:equatable/equatable.dart';

import '../../open_api/video/coordinator/api.dart';
import '../webrtc/model/rtc_video_dimension.dart';
import '../webrtc/model/rtc_video_encoding.dart';
import '../webrtc/model/rtc_video_parameters.dart';

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
    this.limits = const StreamLimitsSettings(),
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
  final StreamLimitsSettings limits;

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
    StreamLimitsSettings? limits,
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
      limits: limits ?? this.limits,
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
    this.micDefaultOn = true,
    this.speakerDefaultOn = true,
    this.noiseCancellation,
  });

  final bool opusDtxEnabled;
  final bool redundantCodingEnabled;
  final AudioSettingsRequestDefaultDeviceEnum defaultDevice;
  final bool micDefaultOn;
  final bool speakerDefaultOn;
  final StreamNoiceCancellingSettings? noiseCancellation;

  @override
  List<Object?> get props => [
        accessRequestEnabled,
        opusDtxEnabled,
        redundantCodingEnabled,
        defaultDevice,
        micDefaultOn,
        speakerDefaultOn,
        noiseCancellation,
      ];

  AudioSettingsRequest toOpenDto() {
    return AudioSettingsRequest(
      defaultDevice: defaultDevice,
      accessRequestEnabled: accessRequestEnabled,
      opusDtxEnabled: opusDtxEnabled,
      redundantCodingEnabled: redundantCodingEnabled,
      micDefaultOn: micDefaultOn,
      speakerDefaultOn: speakerDefaultOn,
      noiseCancellation: noiseCancellation?.toOpenDto(),
    );
  }
}

class StreamVideoSettings extends MediaSettings {
  const StreamVideoSettings({
    super.accessRequestEnabled = false,
    this.enabled = false,
    this.cameraDefaultOn = true,
    this.cameraFacing = VideoSettingsRequestCameraFacingEnum.front,
    this.targetResolution = const StreamTargetResolution(
      height: 720,
      width: 1280,
    ),
  });

  final bool enabled;
  final bool cameraDefaultOn;
  final VideoSettingsRequestCameraFacingEnum cameraFacing;
  final StreamTargetResolution targetResolution;

  @override
  List<Object?> get props => [
        accessRequestEnabled,
        enabled,
        cameraDefaultOn,
        cameraFacing,
        targetResolution,
      ];

  VideoSettingsRequest toOpenDto() {
    return VideoSettingsRequest(
      enabled: enabled,
      accessRequestEnabled: accessRequestEnabled,
      cameraDefaultOn: cameraDefaultOn,
      cameraFacing: cameraFacing,
      targetResolution: targetResolution.toOpenDto(),
    );
  }
}

class StreamScreenShareSettings extends MediaSettings {
  const StreamScreenShareSettings({
    super.accessRequestEnabled = false,
    this.enabled = false,
    this.targetResolution =
        const StreamTargetResolution(height: 1280, width: 720),
  });

  final bool enabled;
  final StreamTargetResolution targetResolution;

  @override
  List<Object?> get props => [
        accessRequestEnabled,
        enabled,
        targetResolution,
      ];

  ScreensharingSettingsRequest toOpenDto() {
    return ScreensharingSettingsRequest(
      enabled: enabled,
      accessRequestEnabled: accessRequestEnabled,
      targetResolution: targetResolution.toOpenDto(),
    );
  }
}

class StreamBackstageSettings extends AbstractSettings {
  const StreamBackstageSettings({
    this.enabled = false,
    this.joinAheadTimeSeconds,
  });

  final bool enabled;
  final int? joinAheadTimeSeconds;

  @override
  List<Object?> get props => [enabled, joinAheadTimeSeconds];

  BackstageSettingsRequest toOpenDto() {
    return BackstageSettingsRequest(
      enabled: enabled,
      joinAheadTimeSeconds: joinAheadTimeSeconds,
    );
  }
}

class StreamLimitsSettings extends AbstractSettings {
  const StreamLimitsSettings({
    this.maxDurationSeconds,
    this.maxParticipants,
  });

  final int? maxDurationSeconds;
  final int? maxParticipants;

  @override
  List<Object?> get props => [maxDurationSeconds, maxParticipants];

  LimitsSettingsRequest toOpenDto() {
    return LimitsSettingsRequest(
      maxDurationSeconds: maxDurationSeconds,
      maxParticipants: maxParticipants,
    );
  }
}

class StreamBroadcastingSettings extends AbstractSettings {
  const StreamBroadcastingSettings({
    this.enabled = false,
    this.hls = const StreamHlsSettings(),
    this.rtmp = const StreamRtmpSettings(quality: ''),
  });

  final bool enabled;
  final StreamHlsSettings hls;
  final StreamRtmpSettings rtmp;

  @override
  List<Object?> get props => [enabled, hls, rtmp];
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
    this.quality = RecordSettingsQuality.n360p,
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
    this.missedCallTimeout = const Duration(seconds: 30),
  });

  final Duration autoCancelTimeout;

  final Duration autoRejectTimeout;

  final Duration missedCallTimeout;

  @override
  List<Object?> get props =>
      [autoCancelTimeout, autoRejectTimeout, missedCallTimeout];

  RingSettingsRequest toOpenDto() {
    return RingSettingsRequest(
      autoCancelTimeoutMs: autoCancelTimeout.inMilliseconds,
      incomingCallTimeoutMs: autoRejectTimeout.inMilliseconds,
      missedCallTimeoutMs: missedCallTimeout.inMilliseconds,
    );
  }
}

class StreamTranscriptionSettings extends AbstractSettings {
  const StreamTranscriptionSettings({
    this.closedCaptionMode = '',
    this.mode = TranscriptionSettingsMode.disabled,
    this.languages = const [],
  });

  final String closedCaptionMode;
  final List<String> languages;
  final TranscriptionSettingsMode mode;

  @override
  List<Object?> get props => [closedCaptionMode, mode, languages];

  TranscriptionSettingsRequest toOpenDto() {
    return TranscriptionSettingsRequest(
      closedCaptionMode: closedCaptionMode,
      mode: mode.toOpenDto(),
      languages: languages,
    );
  }
}

class StreamNoiceCancellingSettings extends AbstractSettings {
  const StreamNoiceCancellingSettings({
    this.mode = NoiceCancellationSettingsMode.disabled,
  });

  final NoiceCancellationSettingsMode mode;

  @override
  List<Object?> get props => [mode];

  NoiseCancellationSettings toOpenDto() {
    return NoiseCancellationSettings(
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

class StreamTargetResolution extends AbstractSettings {
  const StreamTargetResolution({
    required this.height,
    required this.width,
    this.bitrate,
  });

  final int height;
  final int width;
  final int? bitrate;

  @override
  List<Object?> get props => [height, width, bitrate];

  TargetResolution toOpenDto() {
    return TargetResolution(
      height: height,
      width: width,
      bitrate: bitrate,
    );
  }

  RtcVideoParameters toVideoParams({
    int defaultBitrate = RtcVideoParametersPresets.k720pBitrate,
  }) {
    return RtcVideoParameters(
      dimension: RtcVideoDimension(
        width: width,
        height: height,
      ),
      encoding: RtcVideoEncoding(
        maxFramerate: 30,
        maxBitrate: bitrate ?? defaultBitrate,
      ),
    );
  }
}

class StreamRtmpSettings extends AbstractSettings {
  const StreamRtmpSettings({
    required this.quality,
    this.enabled = false,
  });

  final bool enabled;
  final String quality;

  @override
  List<Object?> get props => [enabled, quality];
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

  static RecordSettingsMode fromString(String value) {
    switch (value) {
      case 'available':
        return RecordSettingsMode.available;
      case 'disabled':
        return RecordSettingsMode.disabled;
      case 'autoOn':
        return RecordSettingsMode.autoOn;
      default:
        return RecordSettingsMode.disabled;
    }
  }
}

enum RecordSettingsQuality {
  n360p,
  n480p,
  n720p,
  n1080p,
  n1440p;

  @override
  String toString() => name;

  RecordSettingsRequestQualityEnum toOpenDto() {
    switch (this) {
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

  static RecordSettingsQuality fromString(String quality) {
    switch (quality) {
      case 'n360p':
        return RecordSettingsQuality.n360p;
      case 'n480p':
        return RecordSettingsQuality.n480p;
      case 'n720p':
        return RecordSettingsQuality.n720p;
      case 'n1080p':
        return RecordSettingsQuality.n1080p;
      case 'n1440p':
        return RecordSettingsQuality.n1440p;
      default:
        return RecordSettingsQuality.n360p;
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

enum NoiceCancellationSettingsMode {
  available,
  disabled,
  autoOn;

  @override
  String toString() => name;

  NoiseCancellationSettingsModeEnum toOpenDto() {
    switch (this) {
      case NoiceCancellationSettingsMode.available:
        return NoiseCancellationSettingsModeEnum.available;
      case NoiceCancellationSettingsMode.disabled:
        return NoiseCancellationSettingsModeEnum.disabled;
      case NoiceCancellationSettingsMode.autoOn:
        return NoiseCancellationSettingsModeEnum.autoOn;
    }
  }
}
