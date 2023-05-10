import 'package:equatable/equatable.dart';

import '../webrtc/media/media_constraints.dart';
import '../webrtc/rtc_track/rtc_local_track.dart';

class CallConnectOptions with EquatableMixin {
  const CallConnectOptions({
    this.camera = TrackDisabled._instance,
    this.microphone = TrackDisabled._instance,
    this.screenShare = TrackDisabled._instance,
  });

  final TrackOption camera;
  final TrackOption microphone;
  final TrackOption screenShare;

  CallConnectOptions copyWith({
    TrackOption? camera,
    TrackOption? microphone,
    TrackOption? screenShare,
    Duration? dropTimeout,
  }) {
    return CallConnectOptions(
      camera: camera ?? this.camera,
      microphone: microphone ?? this.microphone,
      screenShare: screenShare ?? this.screenShare,
    );
  }

  @override
  List<Object> get props => [camera, microphone, screenShare];

  @override
  String toString() {
    return 'CallConnectOptions{'
        'camera: $camera,'
        ' microphone: $microphone,'
        ' screenShare: $screenShare,'
        '}';
  }
}

abstract class TrackOption with EquatableMixin {
  const TrackOption();

  factory TrackOption.enabled() {
    return TrackEnabled._instance;
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
  const TrackEnabled._();

  static const TrackEnabled _instance = TrackEnabled._();

  @override
  String toString() => 'enabled';
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
