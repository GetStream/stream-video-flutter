import 'package:equatable/equatable.dart';

class CallSettings with EquatableMixin {
  const CallSettings({
    required this.audio,
    required this.video,
    required this.screenShare,
  });

  const CallSettings.disabled()
      : audio = const AudioSettings(
          accessRequestEnabled: false,
          opusDtxEnabled: false,
          redundantCodingEnabled: false,
        ),
        video = const VideoSettings(accessRequestEnabled: false),
        screenShare = const ScreenShareSetting(accessRequestEnabled: false);

  const CallSettings.enabled()
      : audio = const AudioSettings(
          accessRequestEnabled: true,
          opusDtxEnabled: false,
          redundantCodingEnabled: false,
        ),
        video = const VideoSettings(accessRequestEnabled: true),
        screenShare = const ScreenShareSetting(accessRequestEnabled: true);

  final AudioSettings audio;
  final VideoSettings video;
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

class AudioSettings extends CallSetting {
  const AudioSettings({
    required super.accessRequestEnabled,
    required this.opusDtxEnabled,
    required this.redundantCodingEnabled,
  });

  final bool opusDtxEnabled;
  final bool redundantCodingEnabled;
}

class VideoSettings extends CallSetting {
  const VideoSettings({required super.accessRequestEnabled});
}

class ScreenShareSetting extends CallSetting {
  const ScreenShareSetting({required super.accessRequestEnabled});
}
