import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_video/src/state/controllers/controllers.dart';
import 'package:stream_video/stream_video.dart';

@internal
class RoomController {
  final participants = CallParticipantController();

  final calls = CallController();

  late final tracks = TrackController()
    ..on<TrackUpdatedEvent>(
      (event) {
        print("WE ARE HERE");
        participants.trackUpdated(track: event.payload, userId: event.id);
      },
    );
  // ..on<RemoteTrackUpdatedEvent>(
  //   (event) => participants.trackUpdated(event.payload, event.payload.id),
  // );

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
