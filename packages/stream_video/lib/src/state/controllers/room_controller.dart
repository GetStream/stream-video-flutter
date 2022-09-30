import 'dart:async';

import 'package:stream_video/src/state/controllers/call_members_controller.dart';
import 'package:stream_video/src/state/controllers/sfu_controller.dart';
import 'package:stream_video/src/state/controllers/track_controller.dart';
import 'package:stream_video/stream_video.dart';

class RoomController {
  final calls = CallController();

  final tracks = TrackController();

  final sfu = SfuController();

  final participants = ParticipantController();

  final broadcasts = BroadcastController();

  final recordings = RecordingController();
  final callMembers = CallMembersController();

  Future<void> disposeCall() async {
    await Future.wait([
      calls.dispose(),
      tracks.dispose(),
      participants.dispose(),
      recordings.dispose(),
      callMembers.dispose(),
      recordings.dispose(),
    ]);
  }
}
