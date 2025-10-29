import 'package:equatable/equatable.dart';

import '../models/models.dart';
import '../webrtc/media/media_constraints.dart';
import '../webrtc/rtc_media_device/rtc_media_device.dart';
import '../webrtc/rtc_track/rtc_track.dart';

class CallConnectOptions with EquatableMixin {
  const CallConnectOptions({
    this.camera = TrackDisabled._instance,
    this.microphone = TrackDisabled._instance,
    this.screenShare = TrackDisabled._instance,
    this.audioOutputDevice,
    this.audioInputDevice,
    this.videoInputDevice,
    this.speakerDefaultOn = false,
    this.cameraFacingMode = FacingMode.user,
    this.targetResolution,
    this.screenShareTargetResolution,
  });

  final TrackOption camera;
  final TrackOption microphone;
  final TrackOption screenShare;

  final RtcMediaDevice? audioOutputDevice;
  final RtcMediaDevice? audioInputDevice;
  final RtcMediaDevice? videoInputDevice;
  final bool speakerDefaultOn;

  final FacingMode cameraFacingMode;
  final StreamTargetResolution? targetResolution;
  final StreamTargetResolution? screenShareTargetResolution;

  CallConnectOptions copyWith({
    TrackOption? camera,
    TrackOption? microphone,
    TrackOption? screenShare,
    RtcMediaDevice? audioOutputDevice,
    RtcMediaDevice? audioInputDevice,
    RtcMediaDevice? videoInputDevice,
    FacingMode? cameraFacingMode,
    bool? speakerDefaultOn,
    StreamTargetResolution? targetResolution,
    StreamTargetResolution? screenShareTargetResolution,
  }) {
    return CallConnectOptions(
      camera: camera ?? this.camera,
      microphone: microphone ?? this.microphone,
      screenShare: screenShare ?? this.screenShare,
      audioOutputDevice: audioOutputDevice ?? this.audioOutputDevice,
      audioInputDevice: audioInputDevice ?? this.audioInputDevice,
      videoInputDevice: videoInputDevice ?? this.videoInputDevice,
      cameraFacingMode: cameraFacingMode ?? this.cameraFacingMode,
      speakerDefaultOn: speakerDefaultOn ?? this.speakerDefaultOn,
      targetResolution: targetResolution ?? this.targetResolution,
      screenShareTargetResolution:
          screenShareTargetResolution ?? this.screenShareTargetResolution,
    );
  }

  CallConnectOptions merge(CallConnectOptions other) {
    return copyWith(
      camera: other.camera,
      microphone: other.microphone,
      screenShare: other.screenShare,
      audioOutputDevice: other.audioOutputDevice,
      audioInputDevice: other.audioInputDevice,
      videoInputDevice: other.videoInputDevice,
      cameraFacingMode: other.cameraFacingMode,
      speakerDefaultOn: other.speakerDefaultOn,
      targetResolution: other.targetResolution,
      screenShareTargetResolution: other.screenShareTargetResolution,
    );
  }

  @override
  List<Object?> get props => [
    camera,
    microphone,
    screenShare,
    audioOutputDevice,
    audioInputDevice,
    videoInputDevice,
    cameraFacingMode,
    speakerDefaultOn,
    targetResolution,
    screenShareTargetResolution,
  ];

  @override
  String toString() {
    return 'CallConnectOptions{'
        'camera: $camera,'
        ' microphone: $microphone,'
        ' screenShare: $screenShare, '
        ' audioOutput: $audioOutputDevice,'
        ' audioInput: $audioInputDevice, '
        ' videoInput: $videoInputDevice, '
        ' cameraFacingMode: $cameraFacingMode, '
        ' speakerDefaultOn: $speakerDefaultOn'
        ' targetResolution: $targetResolution'
        ' screenShareTargetResolution: $screenShareTargetResolution'
        '}';
  }
}

abstract class TrackOption with EquatableMixin {
  const TrackOption();

  factory TrackOption.fromSetting({required bool enabled}) =>
      enabled ? TrackOption.enabled() : TrackOption.disabled();

  factory TrackOption.enabled({MediaConstraints? constraints}) {
    return TrackEnabled._(constraints: constraints);
  }

  factory TrackOption.disabled() {
    return TrackDisabled._instance;
  }

  factory TrackOption.provided(RtcLocalTrack track) {
    return TrackProvided._(track: track);
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

class TrackDisabled extends TrackOption {
  const TrackDisabled._();

  static const TrackDisabled _instance = TrackDisabled._();

  @override
  String toString() => 'disabled';
}

class TrackEnabled extends TrackOption {
  const TrackEnabled._({this.constraints});

  final MediaConstraints? constraints;

  @override
  List<Object?> get props => [constraints];

  @override
  String toString() => 'enabled($constraints)';
}

class TrackProvided<T extends MediaConstraints> extends TrackOption {
  const TrackProvided._({required this.track});

  final RtcLocalTrack<T> track;

  @override
  List<Object?> get props => [track.trackType];

  @override
  String toString() => 'provided(${track.trackId})';
}

extension TrackOptionX on TrackOption {
  TrackOption toggle() {
    if (isEnabled) {
      return TrackOption.disabled();
    } else if (isDisabled) {
      return TrackOption.enabled();
    }
    return this;
  }

  bool get isEnabled => this is TrackEnabled;

  bool get isDisabled => this is TrackDisabled;

  bool get isProvided => this is TrackProvided;

  RtcLocalTrack? get trackOrNull {
    final self = this;
    if (self is TrackProvided) {
      return self.track;
    }
    return null;
  }
}
