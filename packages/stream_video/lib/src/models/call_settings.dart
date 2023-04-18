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
        screenShare = const ScreenShareSettings(accessRequestEnabled: false);

  const CallSettings.enabled()
      : audio = const AudioSettings(
          accessRequestEnabled: true,
          opusDtxEnabled: false,
          redundantCodingEnabled: false,
        ),
        video = const VideoSettings(accessRequestEnabled: true),
        screenShare = const ScreenShareSettings(accessRequestEnabled: true);

  final AudioSettings audio;
  final VideoSettings video;
  final ScreenShareSettings screenShare;

  @override
  List<Object?> get props => [audio, video, screenShare];
}

abstract class MediaSettings with EquatableMixin {
  const MediaSettings({required this.accessRequestEnabled});

  final bool accessRequestEnabled;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [accessRequestEnabled];
}

class AudioSettings extends MediaSettings {
  const AudioSettings({
    required super.accessRequestEnabled,
    required this.opusDtxEnabled,
    required this.redundantCodingEnabled,
  });

  final bool opusDtxEnabled;
  final bool redundantCodingEnabled;
}

class VideoSettings extends MediaSettings {
  const VideoSettings({required super.accessRequestEnabled});
}

class ScreenShareSettings extends MediaSettings {
  const ScreenShareSettings({required super.accessRequestEnabled});
}
