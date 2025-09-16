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
    this.session = const StreamSessionSettings(),
    this.frameRecording = const StreamFrameRecordingSettings(),
    this.ingress,
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
  final StreamSessionSettings session;
  final StreamFrameRecordingSettings frameRecording;
  final StreamIngressSettings? ingress;

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
    StreamSessionSettings? session,
    StreamFrameRecordingSettings? frameRecording,
    StreamIngressSettings? ingress,
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
      session: session ?? this.session,
      frameRecording: frameRecording ?? this.frameRecording,
      ingress: ingress ?? this.ingress,
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
    this.maxParticipantsExcludeOwner,
    this.maxParticipantsExcludeRoles = const [],
  });

  final int? maxDurationSeconds;
  final int? maxParticipants;
  final bool? maxParticipantsExcludeOwner;
  final List<String> maxParticipantsExcludeRoles;

  @override
  List<Object?> get props => [
        maxDurationSeconds,
        maxParticipants,
        maxParticipantsExcludeOwner,
        maxParticipantsExcludeRoles,
      ];

  LimitsSettingsRequest toOpenDto() {
    return LimitsSettingsRequest(
      maxDurationSeconds: maxDurationSeconds,
      maxParticipants: maxParticipants,
      maxParticipantsExcludeOwner: maxParticipantsExcludeOwner,
      maxParticipantsExcludeRoles: maxParticipantsExcludeRoles,
    );
  }
}

class StreamBroadcastingSettings extends AbstractSettings {
  const StreamBroadcastingSettings({
    this.enabled,
    this.hls,
    this.rtmp,
  });

  final bool? enabled;
  final StreamHlsSettings? hls;
  final StreamRtmpSettings? rtmp;

  @override
  List<Object?> get props => [enabled, hls, rtmp];

  BroadcastSettingsRequest toOpenDto() {
    return BroadcastSettingsRequest(
      enabled: enabled,
      hls: hls?.toOpenDto(),
      rtmp: rtmp?.toOpenDto(),
    );
  }
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

class StreamFrameRecordingSettings extends AbstractSettings {
  const StreamFrameRecordingSettings({
    this.captureIntervalInSeconds = 5,
    this.mode = FrameRecordingSettingsMode.disabled,
    this.quality,
  });

  final int captureIntervalInSeconds;
  final FrameRecordingSettingsMode mode;
  final FrameRecordingSettingsQuality? quality;

  @override
  List<Object?> get props => [
        captureIntervalInSeconds,
        mode,
        quality,
      ];

  FrameRecordingSettingsRequest toOpenDto() {
    return FrameRecordingSettingsRequest(
      captureIntervalInSeconds: captureIntervalInSeconds,
      mode: mode.toOpenDto(),
      quality: quality?.toOpenDto(),
    );
  }
}

class StreamSessionSettings extends AbstractSettings {
  const StreamSessionSettings({
    this.inactivityTimeoutSeconds = 30,
  });

  final int inactivityTimeoutSeconds;

  @override
  List<Object?> get props => [
        inactivityTimeoutSeconds,
      ];

  SessionSettingsRequest toOpenDto() {
    return SessionSettingsRequest(
      inactivityTimeoutSeconds: inactivityTimeoutSeconds,
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
    this.closedCaptionMode = ClosedCaptionSettingsMode.disabled,
    this.transcriptionMode = TranscriptionSettingsMode.disabled,
    this.language = TranscriptionSettingsLanguage.auto,
  });

  final TranscriptionSettingsLanguage language;
  final ClosedCaptionSettingsMode closedCaptionMode;
  final TranscriptionSettingsMode transcriptionMode;

  @override
  List<Object?> get props => [closedCaptionMode, transcriptionMode, language];

  TranscriptionSettingsRequest toOpenDto() {
    return TranscriptionSettingsRequest(
      closedCaptionMode: closedCaptionMode.toOpenDto(),
      mode: transcriptionMode.toOpenDto(),
      language: language.toOpenDto(),
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
    this.autoOn,
    this.enabled,
    this.qualityTracks = const [],
  });

  final bool? enabled;
  final bool? autoOn;
  final List<String> qualityTracks;

  @override
  List<Object?> get props => [enabled, autoOn, qualityTracks];

  HLSSettingsRequest toOpenDto() {
    return HLSSettingsRequest(
      enabled: enabled,
      autoOn: autoOn,
      qualityTracks: qualityTracks,
    );
  }
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
        quality: RtcVideoQuality.high,
      ),
    );
  }
}

class StreamRtmpSettings extends AbstractSettings {
  const StreamRtmpSettings({
    this.quality,
    this.enabled,
  });

  final bool? enabled;
  final RTMPSettingsQuality? quality;

  @override
  List<Object?> get props => [enabled, quality];

  RTMPSettingsRequest toOpenDto() {
    return RTMPSettingsRequest(
      enabled: enabled,
      quality: quality?.toOpenDto(),
    );
  }
}

class StreamIngressSettings extends AbstractSettings {
  const StreamIngressSettings({
    this.audioEncodingOptions,
    this.enabled,
    this.videoEncodingOptions = const {},
  });

  final StreamIngressAudioEncodingOptions? audioEncodingOptions;
  final bool? enabled;
  final Map<String, StreamIngressVideoEncodingOptions> videoEncodingOptions;

  @override
  List<Object?> get props =>
      [audioEncodingOptions, enabled, videoEncodingOptions];

  IngressSettingsRequest toOpenDto() {
    return IngressSettingsRequest(
      audioEncodingOptions: audioEncodingOptions?.toOpenDto(),
      enabled: enabled,
      videoEncodingOptions: videoEncodingOptions.map(
        (key, value) => MapEntry(key, value.toOpenDto()),
      ),
    );
  }
}

class StreamIngressAudioEncodingOptions extends AbstractSettings {
  const StreamIngressAudioEncodingOptions({
    required this.bitrate,
    required this.channels,
    this.enableDtx,
  });

  final int bitrate;
  final IngressAudioChannels channels;
  final bool? enableDtx;

  @override
  List<Object?> get props => [bitrate, channels, enableDtx];

  IngressAudioEncodingOptionsRequest toOpenDto() {
    return IngressAudioEncodingOptionsRequest(
      bitrate: bitrate,
      channels: channels.toOpenDto(),
      enableDtx: enableDtx,
    );
  }
}

class StreamIngressVideoEncodingOptions extends AbstractSettings {
  const StreamIngressVideoEncodingOptions({
    this.layers = const [],
  });

  final List<StreamIngressVideoLayer> layers;

  @override
  List<Object?> get props => [layers];

  IngressVideoEncodingOptionsRequest toOpenDto() {
    return IngressVideoEncodingOptionsRequest(
      layers: layers.map((e) => e.toOpenDto()).toList(),
    );
  }
}

class StreamIngressVideoLayer extends AbstractSettings {
  const StreamIngressVideoLayer({
    required this.bitrate,
    required this.codec,
    required this.frameRateLimit,
    required this.maxDimension,
    required this.minDimension,
  });

  final int bitrate;
  final IngressVideoLayerRequestCodecEnum codec;
  final int frameRateLimit;
  final int maxDimension;
  final int minDimension;

  @override
  List<Object?> get props =>
      [bitrate, codec, frameRateLimit, maxDimension, minDimension];

  IngressVideoLayerRequest toOpenDto() {
    return IngressVideoLayerRequest(
      bitrate: bitrate,
      codec: codec,
      frameRateLimit: frameRateLimit,
      maxDimension: maxDimension,
      minDimension: minDimension,
    );
  }
}

enum IngressAudioChannels {
  mono(1),
  stereo(2);

  const IngressAudioChannels(this.value);
  final int value;

  IngressAudioEncodingOptionsRequestChannelsEnum toOpenDto() {
    switch (this) {
      case IngressAudioChannels.mono:
        return IngressAudioEncodingOptionsRequestChannelsEnum.number1;
      case IngressAudioChannels.stereo:
        return IngressAudioEncodingOptionsRequestChannelsEnum.number2;
    }
  }

  static IngressAudioChannels fromValue(int value) {
    switch (value) {
      case 1:
        return IngressAudioChannels.mono;
      case 2:
        return IngressAudioChannels.stereo;
      default:
        return IngressAudioChannels.stereo;
    }
  }
}

enum StreamTranscriptionMode {
  available,
  disabled,
  autoOn;

  @override
  String toString() => name;

  TranscriptionSettingsResponseModeEnum toOpenDto() {
    switch (this) {
      case StreamTranscriptionMode.available:
        return TranscriptionSettingsResponseModeEnum.available;
      case StreamTranscriptionMode.disabled:
        return TranscriptionSettingsResponseModeEnum.disabled;
      case StreamTranscriptionMode.autoOn:
        return TranscriptionSettingsResponseModeEnum.autoOn;
    }
  }

  static StreamTranscriptionMode fromString(String value) {
    switch (value) {
      case 'available':
        return StreamTranscriptionMode.available;
      case 'disabled':
        return StreamTranscriptionMode.disabled;
      case 'autoOn':
        return StreamTranscriptionMode.autoOn;
      default:
        return StreamTranscriptionMode.disabled;
    }
  }
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

enum FrameRecordingSettingsMode {
  available,
  disabled,
  autoOn;

  @override
  String toString() => name;

  FrameRecordingSettingsRequestModeEnum toOpenDto() {
    switch (this) {
      case FrameRecordingSettingsMode.available:
        return FrameRecordingSettingsRequestModeEnum.available;
      case FrameRecordingSettingsMode.disabled:
        return FrameRecordingSettingsRequestModeEnum.disabled;
      case FrameRecordingSettingsMode.autoOn:
        return FrameRecordingSettingsRequestModeEnum.autoOn;
    }
  }

  static FrameRecordingSettingsMode fromString(String value) {
    switch (value) {
      case 'available':
        return FrameRecordingSettingsMode.available;
      case 'disabled':
        return FrameRecordingSettingsMode.disabled;
      case 'autoOn':
        return FrameRecordingSettingsMode.autoOn;
      default:
        return FrameRecordingSettingsMode.disabled;
    }
  }
}

enum RTMPSettingsQuality {
  n360p,
  n480p,
  n720p,
  n1080p,
  n1440p,
  portrait360x640,
  portrait480x854,
  portrait720x1280,
  portrait1080x1920,
  portrait1440x2560;

  @override
  String toString() => name;

  RTMPSettingsRequestQualityEnum toOpenDto() {
    switch (this) {
      case RTMPSettingsQuality.n360p:
        return RTMPSettingsRequestQualityEnum.n360p;
      case RTMPSettingsQuality.n480p:
        return RTMPSettingsRequestQualityEnum.n480p;
      case RTMPSettingsQuality.n720p:
        return RTMPSettingsRequestQualityEnum.n720p;
      case RTMPSettingsQuality.n1080p:
        return RTMPSettingsRequestQualityEnum.n1080p;
      case RTMPSettingsQuality.n1440p:
        return RTMPSettingsRequestQualityEnum.n1440p;
      case RTMPSettingsQuality.portrait360x640:
        return RTMPSettingsRequestQualityEnum.portrait360x640;
      case RTMPSettingsQuality.portrait480x854:
        return RTMPSettingsRequestQualityEnum.portrait480x854;
      case RTMPSettingsQuality.portrait720x1280:
        return RTMPSettingsRequestQualityEnum.portrait720x1280;
      case RTMPSettingsQuality.portrait1080x1920:
        return RTMPSettingsRequestQualityEnum.portrait1080x1920;
      case RTMPSettingsQuality.portrait1440x2560:
        return RTMPSettingsRequestQualityEnum.portrait1440x2560;
    }
  }

  static RTMPSettingsQuality fromString(String quality) {
    switch (quality) {
      case '360p':
        return RTMPSettingsQuality.n360p;
      case '480p':
        return RTMPSettingsQuality.n480p;
      case '720p':
        return RTMPSettingsQuality.n720p;
      case '1080p':
        return RTMPSettingsQuality.n1080p;
      case '1440p':
        return RTMPSettingsQuality.n1440p;
      case 'portrait-360x640':
        return RTMPSettingsQuality.portrait360x640;
      case 'portrait-480x854':
        return RTMPSettingsQuality.portrait480x854;
      case 'portrait-720x1280':
        return RTMPSettingsQuality.portrait720x1280;
      case 'portrait-1080x1920':
        return RTMPSettingsQuality.portrait1080x1920;
      case 'portrait-1440x2560':
        return RTMPSettingsQuality.portrait1440x2560;
      default:
        return RTMPSettingsQuality.n360p;
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

enum FrameRecordingSettingsQuality {
  n360p,
  n480p,
  n720p,
  n1080p,
  n1440p;

  @override
  String toString() => name;

  FrameRecordingSettingsRequestQualityEnum toOpenDto() {
    switch (this) {
      case FrameRecordingSettingsQuality.n360p:
        return FrameRecordingSettingsRequestQualityEnum.n360p;
      case FrameRecordingSettingsQuality.n480p:
        return FrameRecordingSettingsRequestQualityEnum.n480p;
      case FrameRecordingSettingsQuality.n720p:
        return FrameRecordingSettingsRequestQualityEnum.n720p;
      case FrameRecordingSettingsQuality.n1080p:
        return FrameRecordingSettingsRequestQualityEnum.n1080p;
      case FrameRecordingSettingsQuality.n1440p:
        return FrameRecordingSettingsRequestQualityEnum.n1440p;
    }
  }

  static FrameRecordingSettingsQuality fromString(String quality) {
    switch (quality) {
      case 'n360p':
        return FrameRecordingSettingsQuality.n360p;
      case 'n480p':
        return FrameRecordingSettingsQuality.n480p;
      case 'n720p':
        return FrameRecordingSettingsQuality.n720p;
      case 'n1080p':
        return FrameRecordingSettingsQuality.n1080p;
      case 'n1440p':
        return FrameRecordingSettingsQuality.n1440p;
      default:
        return FrameRecordingSettingsQuality.n360p;
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

enum TranscriptionSettingsLanguage {
  auto('auto'),
  en('en'),
  fr('fr'),
  es('es'),
  de('de'),
  it('it'),
  nl('nl'),
  pt('pt'),
  pl('pl'),
  ca('ca'),
  cs('cs'),
  da('da'),
  el('el'),
  fi('fi'),
  id('id'),
  ja('ja'),
  ru('ru'),
  sv('sv'),
  ta('ta'),
  th('th'),
  tr('tr'),
  hu('hu'),
  ro('ro'),
  zh('zh'),
  ar('ar'),
  tl('tl'),
  he('he'),
  hi('hi'),
  hr('hr'),
  ko('ko'),
  ms('ms'),
  no('no'),
  uk('uk'),
  bg('bg'),
  et('et'),
  sl('sl'),
  sk('sk');

  const TranscriptionSettingsLanguage(this.value);
  final String value;

  @override
  String toString() => value;

  TranscriptionSettingsRequestLanguageEnum toOpenDto() {
    return TranscriptionSettingsRequestLanguageEnumTypeTransformer()
            .decode(value) ??
        TranscriptionSettingsRequestLanguageEnum.auto;
  }

  StartTranscriptionRequestLanguageEnum toStartTranscriptionDto() {
    return StartTranscriptionRequestLanguageEnumTypeTransformer()
            .decode(value) ??
        StartTranscriptionRequestLanguageEnum.auto;
  }

  StartClosedCaptionsRequestLanguageEnum toStartClosedCaptionsDto() {
    return StartClosedCaptionsRequestLanguageEnumTypeTransformer()
            .decode(value) ??
        StartClosedCaptionsRequestLanguageEnum.auto;
  }
}

enum ClosedCaptionSettingsMode {
  available,
  disabled,
  autoOn;

  @override
  String toString() => name;

  TranscriptionSettingsRequestClosedCaptionModeEnum toOpenDto() {
    switch (this) {
      case ClosedCaptionSettingsMode.available:
        return TranscriptionSettingsRequestClosedCaptionModeEnum.available;
      case ClosedCaptionSettingsMode.disabled:
        return TranscriptionSettingsRequestClosedCaptionModeEnum.disabled;
      case ClosedCaptionSettingsMode.autoOn:
        return TranscriptionSettingsRequestClosedCaptionModeEnum.autoOn;
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
