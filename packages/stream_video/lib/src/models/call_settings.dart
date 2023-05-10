import 'package:equatable/equatable.dart';

class CallSettings with EquatableMixin {
  const CallSettings({
    this.ring = const RingSettings(),
    this.audio = const AudioSettings(),
    this.video = const VideoSettings(),
    this.screenShare = const ScreenShareSettings(),
    this.recording = const RecordingSettings(),
    this.broadcasting = const BroadcastingSettings(),
    this.transcription = const TranscriptionSettings(),
    this.backstage = const BackstageSettings(),
    this.geofencing = const GeofencingSettings(),
  });

  final RingSettings ring;
  final AudioSettings audio;
  final VideoSettings video;
  final ScreenShareSettings screenShare;
  final RecordingSettings recording;
  final BroadcastingSettings broadcasting;
  final TranscriptionSettings transcription;
  final BackstageSettings backstage;
  final GeofencingSettings geofencing;

  @override
  List<Object?> get props => [audio, video, screenShare];

  /// Returns a copy of this [CallSettings] with the given fields
  /// replaced with the new values.
  CallSettings copyWith({
    RingSettings? ring,
    AudioSettings? audio,
    VideoSettings? video,
    ScreenShareSettings? screenShare,
    RecordingSettings? recording,
    BroadcastingSettings? broadcasting,
    TranscriptionSettings? transcription,
    BackstageSettings? backstage,
    GeofencingSettings? geofencing,
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

class AudioSettings extends MediaSettings {
  const AudioSettings({
    super.accessRequestEnabled = false,
    this.opusDtxEnabled = false,
    this.redundantCodingEnabled = false,
  });

  final bool opusDtxEnabled;
  final bool redundantCodingEnabled;

  @override
  List<Object?> get props => [
        accessRequestEnabled,
        opusDtxEnabled,
        redundantCodingEnabled,
      ];
}

class VideoSettings extends MediaSettings {
  const VideoSettings({
    super.accessRequestEnabled = false,
    this.enabled = false,
  });

  final bool enabled;

  @override
  List<Object?> get props => [
        accessRequestEnabled,
        enabled,
      ];
}

class ScreenShareSettings extends MediaSettings {
  const ScreenShareSettings({
    super.accessRequestEnabled = false,
    this.enabled = false,
  });

  final bool enabled;

  @override
  List<Object?> get props => [
        accessRequestEnabled,
        enabled,
      ];
}

class BackstageSettings extends AbstractSettings {
  const BackstageSettings({
    this.enabled = false,
  });

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class BroadcastingSettings extends AbstractSettings {
  const BroadcastingSettings({
    this.enabled = false,
    this.hls = const HlsSettings(),
  });

  final bool enabled;
  final HlsSettings hls;

  @override
  List<Object?> get props => [enabled, hls];
}

class GeofencingSettings extends AbstractSettings {
  const GeofencingSettings({
    this.names = const [],
  });

  final List<String> names;

  @override
  List<Object?> get props => [names];
}

class RecordingSettings extends AbstractSettings {
  const RecordingSettings({
    this.audioOnly = false,
    this.mode = RecordSettingsMode.disabled,
    this.quality = RecordSettingsQuality.audioOnly,
  });

  final bool audioOnly;

  final RecordSettingsMode mode;

  final RecordSettingsQuality quality;

  @override
  List<Object?> get props => [audioOnly, mode, quality];
}

class RingSettings extends AbstractSettings {
  const RingSettings({
    this.autoCancelTimeout = const Duration(seconds: 30),
    this.autoRejectTimeout = const Duration(seconds: 30),
  });

  final Duration autoCancelTimeout;

  final Duration autoRejectTimeout;

  @override
  List<Object?> get props => [autoCancelTimeout, autoRejectTimeout];
}

class TranscriptionSettings extends AbstractSettings {
  const TranscriptionSettings({
    this.closedCaptionMode = '',
    this.mode = TranscriptionSettingsMode.disabled,
  });

  final String closedCaptionMode;

  final TranscriptionSettingsMode mode;

  @override
  List<Object?> get props => [closedCaptionMode, mode];
}

class HlsSettings extends AbstractSettings {
  const HlsSettings({
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
}

enum TranscriptionSettingsMode {
  available,
  disabled,
  autoOn;

  @override
  String toString() => name;
}
