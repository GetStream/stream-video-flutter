import 'dart:async';

import 'package:stream_video/src/models/call_participant.dart';
import 'package:stream_video/src/state/controllers/call_members_controller.dart';
import 'package:stream_video/stream_video.dart';

class RoomController {
  RoomController() {
    // _listener = participants.onParticipantJoined((event) =>
    //     participants.room.add(event.payload.participant.toCallParticipant()));
  }
  final calls = CallController();

  final participants = ParticipantController();
  // late final StreamSubscription<ParticipantEvent> _listener;

  final broadcasts = BroadcastController();

  // final screenshares = ScreenshareController();

  // final audios = AudioController();

  // final videos = VideoController();

  final recordings = RecordingController();
  final callMembers = CallMembersController();

  Future<void> disposeCall() async {
    await Future.wait([
      // _listener.cancel(),
      calls.dispose(),
      // participants.dispose(),
      // screenshares.dispose(),
      // audios.dispose(),
      // videos.dispose(),
      // recordings.dispose()
    ]);
  }
}
