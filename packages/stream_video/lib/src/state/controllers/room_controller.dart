import 'package:stream_video/src/state/controllers/controllers.dart';

class RoomController {
  final calls = CallController();

  final participants = ParticipantController();

  final broadcasts = BroadcastController();

  final screenshares = ScreenshareController();

  final audios = AudioController();

  final videos = VideoController();

  final recordings = RecordingController();

  Future<void> disposeCall() async {
    await Future.wait([
      calls.dispose(),
      participants.dispose(),
      screenshares.dispose(),
      audios.dispose(),
      videos.dispose(),
      recordings.dispose()
    ]);
  }
}
