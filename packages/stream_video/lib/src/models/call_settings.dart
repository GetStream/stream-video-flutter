import 'package:equatable/equatable.dart';

import '../../open_api/video/coordinator/api.dart';
import '../coordinator/open_api/open_api_extensions.dart';
import '../webrtc/model/rtc_video_dimension.dart';
import '../webrtc/model/rtc_video_encoding.dart';
import '../webrtc/model/rtc_video_parameters.dart';
import 'call_egress.dart';

class CallSettings extends Equatable {
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
    this.individualRecording = const StreamIndividualRecordingSettings(),
    this.rawRecording = const StreamRawRecordingSettings(),
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
  final StreamIndividualRecordingSettings individualRecording;
  final StreamRawRecordingSettings rawRecording;
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
    StreamIndividualRecordingSettings? individualRecording,
    StreamRawRecordingSettings? rawRecording,
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
      individualRecording: individualRecording ?? this.individualRecording,
      rawRecording: rawRecording ?? this.rawRecording,
      ingress: ingress ?? this.ingress,
    );
  }
}

abstract class AbstractSettings extends Equatable {
  const AbstractSettings();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

abstract class MediaSettings extends Equatable {
  const MediaSettings({required this.accessRequestEnabled});

  final bool accessRequestEnabled;
}

class StreamAudioSettings extends MediaSettings {
  const StreamAudioSettings({
    super.accessRequestEnabled = false,
    this.opusDtxEnabled = false,
    this.redundantCodingEnabled = false,
    this.defaultDevice = AudioSettingsRequestDefaultDevice.speaker,
    this.micDefaultOn = true,
    this.speakerDefaultOn = true,
    this.noiseCancellation,
    this.hifiAudioEnabled = false,
  });

  /// When true, the call will optimize bandwidth usage by disabling audio when participants are not speaking via discontinuous transmission (DTX).
  final bool opusDtxEnabled;

  /// When true, the call will send additional audio streams to ensure calls are more resistant to poor network conditions.
  final bool redundantCodingEnabled;

  final AudioSettingsRequestDefaultDevice defaultDevice;
  final bool micDefaultOn;
  final bool speakerDefaultOn;
  final StreamNoiceCancellingSettings? noiseCancellation;

  /// When true, the call will use high-fidelity audio for better audio quality.
  final bool hifiAudioEnabled;

  @override
  List<Object?> get props => [
    accessRequestEnabled,
    opusDtxEnabled,
    redundantCodingEnabled,
    defaultDevice,
    micDefaultOn,
    speakerDefaultOn,
    noiseCancellation,
    hifiAudioEnabled,
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
      hifiAudioEnabled: hifiAudioEnabled,
    );
  }
}

class StreamVideoSettings extends MediaSettings {
  const StreamVideoSettings({
    super.accessRequestEnabled = false,
    this.enabled = false,
    this.cameraDefaultOn = true,
    this.cameraFacing = VideoSettingsRequestCameraFacing.front,
    this.targetResolution = const StreamTargetResolution(
      height: 720,
      width: 1280,
    ),
  });

  final bool enabled;
  final bool cameraDefaultOn;
  final VideoSettingsRequestCameraFacing cameraFacing;
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
    this.targetResolution = const StreamTargetResolution(
      height: 1280,
      width: 720,
    ),
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

class StreamIndividualRecordingSettings extends AbstractSettings {
  const StreamIndividualRecordingSettings({
    this.mode = IndividualRecordingSettingsMode.disabled,
    this.outputTypes = const [],
  });

  final IndividualRecordingSettingsMode mode;
  final List<IndividualRecordingOutputType> outputTypes;

  @override
  List<Object?> get props => [mode, outputTypes];

  IndividualRecordingSettingsRequest toOpenDto() {
    return IndividualRecordingSettingsRequest(
      mode: mode.toOpenDto(),
      outputTypes: outputTypes.map((e) => e.toOpenDto()).toList(),
    );
  }
}

class StreamRawRecordingSettings extends AbstractSettings {
  const StreamRawRecordingSettings({
    this.mode = RawRecordingSettingsMode.disabled,
    this.audioOnly,
  });

  final RawRecordingSettingsMode mode;
  final bool? audioOnly;

  @override
  List<Object?> get props => [mode, audioOnly];

  RawRecordingSettingsRequest toOpenDto() {
    return RawRecordingSettingsRequest(
      mode: mode.toOpenDto(),
      audioOnly: audioOnly,
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
  List<Object?> get props => [
    autoCancelTimeout,
    autoRejectTimeout,
    missedCallTimeout,
  ];

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
    this.mode = NoiseCancellationSettingsMode.disabled,
  });

  final NoiseCancellationSettingsMode mode;

  @override
  List<Object?> get props => [mode];

  NoiseCancellationSettings toOpenDto() {
    return NoiseCancellationSettings(
      mode: mode,
    );
  }
}

class StreamHlsSettings extends AbstractSettings {
  /// Creates HLS settings.
  ///
  /// [qualityTracks] accepts raw string aliases (e.g. `'720p'`, `'1080p'`)
  /// for backward compatibility but is deprecated. Use [qualities] with
  /// [StreamVideoQuality] values instead. If both are provided, [qualities]
  /// takes precedence.
  const StreamHlsSettings({
    this.autoOn,
    this.enabled,
    @Deprecated('Use qualities with StreamVideoQuality values instead.')
    this.qualityTracks = const [],
    this.qualities = const [],
  });

  final bool? enabled;
  final bool? autoOn;

  @Deprecated('Use qualities with StreamVideoQuality values instead.')
  final List<String> qualityTracks;

  final List<StreamVideoQuality> qualities;

  List<StreamVideoQuality> get _resolvedQualities {
    if (qualities.isNotEmpty) return qualities;
    // ignore: deprecated_member_use_from_same_package
    if (qualityTracks.isNotEmpty) {
      // ignore: deprecated_member_use_from_same_package
      return qualityTracks.map(StreamVideoQuality.fromAlias).nonNulls.toList();
    }
    return const [];
  }

  @override
  // ignore: deprecated_member_use_from_same_package
  List<Object?> get props => [enabled, autoOn, qualityTracks, qualities];

  HLSSettingsRequest toOpenDto() {
    return HLSSettingsRequest(
      enabled: enabled,
      autoOn: autoOn,
      qualityTracks: _resolvedQualities
          .map((q) => q.toHlsQualityTrackDomain())
          .toList(),
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
  List<Object?> get props => [
    audioEncodingOptions,
    enabled,
    videoEncodingOptions,
  ];

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
    required this.source,
    this.layers = const [],
  });

  final List<StreamIngressVideoLayer> layers;
  final StreamIngressSource source;

  @override
  List<Object?> get props => [layers, source];

  IngressVideoEncodingOptionsRequest toOpenDto() {
    return IngressVideoEncodingOptionsRequest(
      layers: layers.map((e) => e.toOpenDto()).toList(),
      source: source.toOpenDto(),
    );
  }
}

class StreamIngressSource extends AbstractSettings {
  const StreamIngressSource({
    required this.fps,
    required this.height,
    required this.width,
  });

  final StreamIngressSourceFps fps;

  /// Minimum value: 2.
  final int height;

  /// Minimum value: 2.
  final int width;

  @override
  List<Object?> get props => [fps, height, width];

  IngressSourceRequest toOpenDto() {
    return IngressSourceRequest(
      fps: fps.toOpenDto(),
      height: height,
      width: width,
    );
  }
}

enum StreamIngressSourceFps {
  fps30(30),
  fps60(60);

  const StreamIngressSourceFps(this.value);

  final int value;

  static StreamIngressSourceFps fromValue(int value) {
    switch (value) {
      case 60:
        return StreamIngressSourceFps.fps60;
      case 30:
      default:
        return StreamIngressSourceFps.fps30;
    }
  }

  IngressSourceRequestFps toOpenDto() {
    switch (this) {
      case StreamIngressSourceFps.fps30:
        return IngressSourceRequestFps.n30;
      case StreamIngressSourceFps.fps60:
        return IngressSourceRequestFps.n60;
    }
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
  final IngressVideoLayerRequestCodec codec;
  final int frameRateLimit;
  final int maxDimension;
  final int minDimension;

  @override
  List<Object?> get props => [
    bitrate,
    codec,
    frameRateLimit,
    maxDimension,
    minDimension,
  ];

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

  IngressAudioEncodingOptionsRequestChannels toOpenDto() {
    switch (this) {
      case IngressAudioChannels.mono:
        return IngressAudioEncodingOptionsRequestChannels.n1;
      case IngressAudioChannels.stereo:
        return IngressAudioEncodingOptionsRequestChannels.n2;
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

  TranscriptionSettingsResponseMode toOpenDto() {
    switch (this) {
      case StreamTranscriptionMode.available:
        return TranscriptionSettingsResponseMode.available;
      case StreamTranscriptionMode.disabled:
        return TranscriptionSettingsResponseMode.disabled;
      case StreamTranscriptionMode.autoOn:
        return TranscriptionSettingsResponseMode.autoOn;
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

  RecordSettingsRequestMode toOpenDto() {
    switch (this) {
      case RecordSettingsMode.available:
        return RecordSettingsRequestMode.available;
      case RecordSettingsMode.disabled:
        return RecordSettingsRequestMode.disabled;
      case RecordSettingsMode.autoOn:
        return RecordSettingsRequestMode.autoOn;
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

enum IndividualRecordingSettingsMode {
  available,
  disabled,
  autoOn;

  @override
  String toString() => name;

  IndividualRecordingSettingsRequestMode toOpenDto() {
    switch (this) {
      case IndividualRecordingSettingsMode.available:
        return IndividualRecordingSettingsRequestMode.available;
      case IndividualRecordingSettingsMode.disabled:
        return IndividualRecordingSettingsRequestMode.disabled;
      case IndividualRecordingSettingsMode.autoOn:
        return IndividualRecordingSettingsRequestMode.autoOn;
    }
  }

  static IndividualRecordingSettingsMode fromString(String value) {
    switch (value) {
      case 'available':
        return IndividualRecordingSettingsMode.available;
      case 'disabled':
        return IndividualRecordingSettingsMode.disabled;
      case 'auto-on':
        return IndividualRecordingSettingsMode.autoOn;
      default:
        return IndividualRecordingSettingsMode.disabled;
    }
  }
}

enum IndividualRecordingOutputType {
  audioOnly,
  videoOnly,
  audioVideo,
  screenshareAudioOnly,
  screenshareVideoOnly,
  screenshareAudioVideo;

  @override
  String toString() => name;

  IndividualRecordingSettingsRequestOutputTypes toOpenDto() {
    switch (this) {
      case IndividualRecordingOutputType.audioOnly:
        return IndividualRecordingSettingsRequestOutputTypes.audioOnly;
      case IndividualRecordingOutputType.videoOnly:
        return IndividualRecordingSettingsRequestOutputTypes.videoOnly;
      case IndividualRecordingOutputType.audioVideo:
        return IndividualRecordingSettingsRequestOutputTypes.audioVideo;
      case IndividualRecordingOutputType.screenshareAudioOnly:
        return IndividualRecordingSettingsRequestOutputTypes
            .screenshareAudioOnly;
      case IndividualRecordingOutputType.screenshareVideoOnly:
        return IndividualRecordingSettingsRequestOutputTypes
            .screenshareVideoOnly;
      case IndividualRecordingOutputType.screenshareAudioVideo:
        return IndividualRecordingSettingsRequestOutputTypes
            .screenshareAudioVideo;
    }
  }

  static IndividualRecordingOutputType? fromString(String value) {
    switch (value) {
      case 'audio_only':
        return IndividualRecordingOutputType.audioOnly;
      case 'video_only':
        return IndividualRecordingOutputType.videoOnly;
      case 'audio_video':
        return IndividualRecordingOutputType.audioVideo;
      case 'screenshare_audio_only':
        return IndividualRecordingOutputType.screenshareAudioOnly;
      case 'screenshare_video_only':
        return IndividualRecordingOutputType.screenshareVideoOnly;
      case 'screenshare_audio_video':
        return IndividualRecordingOutputType.screenshareAudioVideo;
      default:
        return null;
    }
  }
}

enum RawRecordingSettingsMode {
  available,
  disabled,
  autoOn;

  @override
  String toString() => name;

  RawRecordingSettingsRequestMode toOpenDto() {
    switch (this) {
      case RawRecordingSettingsMode.available:
        return RawRecordingSettingsRequestMode.available;
      case RawRecordingSettingsMode.disabled:
        return RawRecordingSettingsRequestMode.disabled;
      case RawRecordingSettingsMode.autoOn:
        return RawRecordingSettingsRequestMode.autoOn;
    }
  }

  static RawRecordingSettingsMode fromString(String value) {
    switch (value) {
      case 'available':
        return RawRecordingSettingsMode.available;
      case 'disabled':
        return RawRecordingSettingsMode.disabled;
      case 'auto-on':
        return RawRecordingSettingsMode.autoOn;
      default:
        return RawRecordingSettingsMode.disabled;
    }
  }
}

enum FrameRecordingSettingsMode {
  available,
  disabled,
  autoOn;

  @override
  String toString() => name;

  FrameRecordingSettingsRequestMode toOpenDto() {
    switch (this) {
      case FrameRecordingSettingsMode.available:
        return FrameRecordingSettingsRequestMode.available;
      case FrameRecordingSettingsMode.disabled:
        return FrameRecordingSettingsRequestMode.disabled;
      case FrameRecordingSettingsMode.autoOn:
        return FrameRecordingSettingsRequestMode.autoOn;
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

enum FrameRecordingSettingsQuality {
  n360p,
  n480p,
  n720p,
  n1080p,
  n1440p;

  @override
  String toString() => name;

  FrameRecordingSettingsRequestQuality toOpenDto() {
    switch (this) {
      case FrameRecordingSettingsQuality.n360p:
        return FrameRecordingSettingsRequestQuality.n360p;
      case FrameRecordingSettingsQuality.n480p:
        return FrameRecordingSettingsRequestQuality.n480p;
      case FrameRecordingSettingsQuality.n720p:
        return FrameRecordingSettingsRequestQuality.n720p;
      case FrameRecordingSettingsQuality.n1080p:
        return FrameRecordingSettingsRequestQuality.n1080p;
      case FrameRecordingSettingsQuality.n1440p:
        return FrameRecordingSettingsRequestQuality.n1440p;
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

  RTMPSettingsRequestQuality toOpenDto() {
    switch (this) {
      case RTMPSettingsQuality.n360p:
        return RTMPSettingsRequestQuality.n360p;
      case RTMPSettingsQuality.n480p:
        return RTMPSettingsRequestQuality.n480p;
      case RTMPSettingsQuality.n720p:
        return RTMPSettingsRequestQuality.n720p;
      case RTMPSettingsQuality.n1080p:
        return RTMPSettingsRequestQuality.n1080p;
      case RTMPSettingsQuality.n1440p:
        return RTMPSettingsRequestQuality.n1440p;
      case RTMPSettingsQuality.portrait360x640:
        return RTMPSettingsRequestQuality.portrait360x640;
      case RTMPSettingsQuality.portrait480x854:
        return RTMPSettingsRequestQuality.portrait480x854;
      case RTMPSettingsQuality.portrait720x1280:
        return RTMPSettingsRequestQuality.portrait720x1280;
      case RTMPSettingsQuality.portrait1080x1920:
        return RTMPSettingsRequestQuality.portrait1080x1920;
      case RTMPSettingsQuality.portrait1440x2560:
        return RTMPSettingsRequestQuality.portrait1440x2560;
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

  RecordSettingsRequestQuality toOpenDto() {
    switch (this) {
      case RecordSettingsQuality.n360p:
        return RecordSettingsRequestQuality.n360p;
      case RecordSettingsQuality.n480p:
        return RecordSettingsRequestQuality.n480p;
      case RecordSettingsQuality.n720p:
        return RecordSettingsRequestQuality.n720p;
      case RecordSettingsQuality.n1080p:
        return RecordSettingsRequestQuality.n1080p;
      case RecordSettingsQuality.n1440p:
        return RecordSettingsRequestQuality.n1440p;
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

enum ClosedCaptionSettingsMode {
  available,
  disabled,
  autoOn;

  @override
  String toString() => name;

  TranscriptionSettingsRequestClosedCaptionMode toOpenDto() {
    switch (this) {
      case ClosedCaptionSettingsMode.available:
        return TranscriptionSettingsRequestClosedCaptionMode.available;
      case ClosedCaptionSettingsMode.disabled:
        return TranscriptionSettingsRequestClosedCaptionMode.disabled;
      case ClosedCaptionSettingsMode.autoOn:
        return TranscriptionSettingsRequestClosedCaptionMode.autoOn;
    }
  }
}

enum TranscriptionSettingsMode {
  available,
  disabled,
  autoOn;

  @override
  String toString() => name;

  TranscriptionSettingsRequestMode toOpenDto() {
    switch (this) {
      case TranscriptionSettingsMode.available:
        return TranscriptionSettingsRequestMode.available;
      case TranscriptionSettingsMode.disabled:
        return TranscriptionSettingsRequestMode.disabled;
      case TranscriptionSettingsMode.autoOn:
        return TranscriptionSettingsRequestMode.autoOn;
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

  TranscriptionSettingsRequestLanguage toOpenDto() {
    return TranscriptionSettingsRequestLanguage.values.firstWhere(
      (e) => e.name == name,
      orElse: () => TranscriptionSettingsRequestLanguage.auto,
    );
  }

  StartTranscriptionRequestLanguage toStartTranscriptionDto() {
    return StartTranscriptionRequestLanguage.values.firstWhere(
      (e) => e.name == name,
      orElse: () => StartTranscriptionRequestLanguage.auto,
    );
  }

  StartClosedCaptionsRequestLanguage toStartClosedCaptionsDto() {
    return StartClosedCaptionsRequestLanguage.values.firstWhere(
      (e) => e.name == name,
      orElse: () => StartClosedCaptionsRequestLanguage.auto,
    );
  }
}

enum RecordingType {
  composite,
  individual,
  raw;

  @override
  String toString() => name;

  String toOpenDto() {
    switch (this) {
      case RecordingType.composite:
        return 'composite';
      case RecordingType.individual:
        return 'individual';
      case RecordingType.raw:
        return 'raw';
    }
  }

  static RecordingType fromString(String value) {
    switch (value) {
      case 'composite':
        return RecordingType.composite;
      case 'individual':
        return RecordingType.individual;
      case 'raw':
        return RecordingType.raw;
      default:
        return RecordingType.composite;
    }
  }
}
