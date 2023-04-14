import 'package:equatable/equatable.dart';

class CallSettings with EquatableMixin {
  const CallSettings({
    required this.audio,
    required this.video,
    required this.screenShare,
  });

  const CallSettings.disabled()
      : audio = const AudioSetting(accessRequestEnabled: false),
        video = const VideoSetting(accessRequestEnabled: false),
        screenShare = const ScreenShareSetting(accessRequestEnabled: false);

  const CallSettings.enabled()
      : audio = const AudioSetting(accessRequestEnabled: true),
        video = const VideoSetting(accessRequestEnabled: true),
        screenShare = const ScreenShareSetting(accessRequestEnabled: true);

  final AudioSetting audio;
  final VideoSetting video;
  final ScreenShareSetting screenShare;

  @override
  List<Object?> get props => [audio, video, screenShare];
}

abstract class CallSetting with EquatableMixin {
  const CallSetting({required this.accessRequestEnabled});

  final bool accessRequestEnabled;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [accessRequestEnabled];
}

class AudioSetting extends CallSetting {
  const AudioSetting({required super.accessRequestEnabled});
}

class VideoSetting extends CallSetting {
  const VideoSetting({required super.accessRequestEnabled});
}

class ScreenShareSetting extends CallSetting {
  const ScreenShareSetting({required super.accessRequestEnabled});
}
