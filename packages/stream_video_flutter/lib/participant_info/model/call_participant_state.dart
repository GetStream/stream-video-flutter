import 'package:stream_video_flutter/stream_video_flutter.dart';

class CallParticipantState {
  final UserInfo user;
  final bool self;
  final bool audioAvailable;
  final bool videoAvailable;

  CallParticipantState(
      {required this.user,
      required this.self,
      required this.audioAvailable,
      required this.videoAvailable});
}
