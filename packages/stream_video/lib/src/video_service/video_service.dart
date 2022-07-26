import 'package:livekit_client/livekit_client.dart';
import 'package:stream_video/src/core/error/error.dart';
import 'package:stream_video/src/video_service/room.dart';

class VideoService {
  Future<VideoRoom> connect(String url, String token) async {
    final room = Room();
    final connectOptions = ConnectOptions(autoSubscribe: true);
    final roomOptions = RoomOptions(
      defaultScreenShareCaptureOptions: ScreenShareCaptureOptions(),
      defaultVideoPublishOptions: VideoPublishOptions(simulcast: true),
      adaptiveStream: true,
      dynacast: true,
      // reportStats: true
    );

    try {
    await room.connect(url, token);
          // final listener = streamVideo.createListener();
      return VideoRoom(room: room);
    } catch (e, stack) {
      throw StreamVideoError('''
      Unknown Exception Occurred: $e
      Stack trace: $stack
      ''');
    }
  }
}
