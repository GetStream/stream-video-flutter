import 'package:stream_video_flutter/stream_video_flutter.dart';

class ParticipantTrack {
  ParticipantTrack({
    required this.participant,
    required this.videoTrack,
  });

  final Participant participant;
  final VideoTrack? videoTrack;
}
