import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_video/src/state/controllers/controllers.dart';

@internal
class RoomController {
  final participants = CallParticipantController();

  final calls = CallController();

  final tracks = TrackController();

  final sfu = SfuController();

  final broadcasts = BroadcastController();

  final recordings = RecordingController();
  final callMembers = CallMembersController();

  Future<void> disposeCall() async {
    await Future.wait([
      calls.dispose(),
      tracks.dispose(),
      recordings.dispose(),
      callMembers.dispose(),
      recordings.dispose(),
      participants.dispose(),
    ]);
  }
}
