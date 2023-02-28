import '../webrtc/media/media_constraints.dart';
import '../webrtc/rtc_track/rtc_local_track.dart';

class CallConnectOptions {
  const CallConnectOptions({
    this.camera = const CameraTrackOption(),
    this.microphone = const MicrophoneTrackOption(),
    this.screenShare = const ScreenShareTrackOption(),
    this.dropTimeout = const Duration(seconds: 30),
  });

  final CameraTrackOption camera;
  final MicrophoneTrackOption microphone;
  final ScreenShareTrackOption screenShare;
  final Duration dropTimeout;

  CallConnectOptions copyWith({
    CameraTrackOption? camera,
    MicrophoneTrackOption? microphone,
    ScreenShareTrackOption? screenShare,
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
  String toString() {
    return 'CallConnectOptions{'
        'camera: $camera,'
        ' microphone: $microphone,'
        ' screenShare: $screenShare,'
        ' dropTimeout: $dropTimeout'
        '}';
  }
}

abstract class TrackOption<T extends MediaConstraints> {
  const TrackOption({this.enabled = false, this.track});

  final bool enabled;
  final RtcLocalTrack<T>? track;

  @override
  String toString() => 'TrackOption{enabled: $enabled, track: $track}';
}

class CameraTrackOption extends TrackOption<CameraConstraints> {
  const CameraTrackOption({super.enabled, super.track});
}

class MicrophoneTrackOption extends TrackOption<AudioConstraints> {
  const MicrophoneTrackOption({super.enabled, super.track});
}

class ScreenShareTrackOption extends TrackOption<ScreenShareConstraints> {
  const ScreenShareTrackOption({super.enabled, super.track});
}
