import 'package:equatable/equatable.dart';

import '../webrtc/media/media_constraints.dart';
import '../webrtc/rtc_track/rtc_local_track.dart';

class CallConnectOptions with EquatableMixin {
  const CallConnectOptions({
    this.camera = TrackDisabled._instance,
    this.microphone = TrackDisabled._instance,
    this.screenShare = TrackDisabled._instance,
    this.dropTimeout = const Duration(seconds: 30),
  });

  final TrackOption camera;
  final TrackOption microphone;
  final TrackOption screenShare;
  final Duration dropTimeout;

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
      dropTimeout: dropTimeout ?? this.dropTimeout,
    );
  }

  @override
  List<Object> get props => [camera, microphone, screenShare, dropTimeout];

  @override
  String toString() {
    return 'CallConnectOptions{'
        'camera: $camera,'
        ' microphone: $microphone,'
        ' screenShare: $screenShare,'
        ' dropTimeout: $dropTimeout'
        '}';
  }
}

abstract class TrackOption with EquatableMixin {
  const TrackOption();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

class TrackDisabled extends TrackOption {
  factory TrackDisabled() {
    return _instance;
  }
  const TrackDisabled._();
  static const TrackDisabled _instance = TrackDisabled._();
}

class TrackEnabled extends TrackOption {
  factory TrackEnabled() {
    return _instance;
  }
  const TrackEnabled._();
  static const TrackEnabled _instance = TrackEnabled._();
}

class TrackProvided<T extends MediaConstraints> extends TrackOption {
  const TrackProvided({required this.track});

  final RtcLocalTrack<T> track;

  @override
  List<Object?> get props => [track.trackType];
}

extension TrackOptionX on TrackOption {
  TrackOption toggle() {
    if (this is TrackEnabled) {
      return TrackDisabled();
    } else if (this is TrackDisabled) {
      return TrackEnabled();
    }
    return this;
  }

  bool get isEnabled => this is TrackEnabled;

  bool get isDisabled => this is TrackDisabled;

  bool get isProvided => this is TrackProvided;
}
