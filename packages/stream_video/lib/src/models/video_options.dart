import 'package:livekit_client/src/types/video_parameters.dart';

class VideoOptions {
  final bool autoSubscribe;
  final VideoParameters videoPresets;

  final bool simulcast;

  final bool reportStats;

  final bool dynacast;

  final bool adaptiveStream;

  // static const VideoOptions default_ = 

  const VideoOptions({
    required this.autoSubscribe,
    required this.reportStats,
    required this.dynacast,
    required this.adaptiveStream,
    required this.videoPresets,
    required this.simulcast,
  });
}
