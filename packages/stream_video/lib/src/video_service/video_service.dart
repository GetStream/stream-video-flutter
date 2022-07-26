import 'package:livekit_client/livekit_client.dart';
import 'package:stream_video/src/core/error/error.dart';
import 'package:stream_video/src/models/video_options.dart';
import 'package:stream_video/src/video_service/room.dart';

class VideoService {
  Future<VideoRoom> connect(
      {required String url,
      required String token,
      required VideoOptions options}) async {
    final room = Room();
    final connectOptions = ConnectOptions(autoSubscribe: options.autoSubscribe);
    final roomOptions = RoomOptions(
      defaultScreenShareCaptureOptions:
          ScreenShareCaptureOptions(params: options.videoPresets),
      defaultVideoPublishOptions:
          VideoPublishOptions(simulcast: options.simulcast),
      adaptiveStream: options.adaptiveStream,
      dynacast: options.dynacast,
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
