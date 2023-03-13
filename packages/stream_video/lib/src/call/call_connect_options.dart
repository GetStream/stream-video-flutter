import 'package:equatable/equatable.dart';

import '../webrtc/media/media_constraints.dart';
import '../webrtc/rtc_track/rtc_local_track.dart';

class CallConnectOptions with EquatableMixin {
  const CallConnectOptions({
    this.camera = _TrackDisabled._instance,
    this.microphone = _TrackDisabled._instance,
    this.screenShare = _TrackDisabled._instance,
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

  factory TrackOption.enabled() {
    return _TrackEnabled();
  }

  factory TrackOption.disabled() {
    return _TrackEnabled();
  }

  factory TrackOption.provided(RtcLocalTrack track) {
    return _TrackProvided(track: track);
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

class _TrackDisabled extends TrackOption {
  factory _TrackDisabled() {
    return _instance;
  }
  const _TrackDisabled._();
  static const _TrackDisabled _instance = _TrackDisabled._();
}

class _TrackEnabled extends TrackOption {
  factory _TrackEnabled() {
    return _instance;
  }
  const _TrackEnabled._();
  static const _TrackEnabled _instance = _TrackEnabled._();
}

class _TrackProvided<T extends MediaConstraints> extends TrackOption {
  const _TrackProvided({required this.track});

  final RtcLocalTrack<T> track;

  @override
  List<Object?> get props => [track.trackType];
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

  bool get isEnabled => this is _TrackEnabled;

  bool get isDisabled => this is _TrackDisabled;

  bool get isProvided => this is _TrackProvided;

  RtcLocalTrack? get trackOrNull {
    final self = this;
    if (self is _TrackProvided) {
      return self.track;
    }
    return null;
  }

  RtcLocalTrack get track {
    final self = this;
    if (self is _TrackProvided) {
      return self.track;
    }
    throw AssertionError('$runtimeType option has no track');
  }
}
