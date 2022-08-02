import 'package:livekit_client/livekit_client.dart'
    show
        Room,
        ConnectOptions,
        RoomOptions,
        ScreenShareCaptureOptions,
        VideoPublishOptions;
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
      print("connecting to livekit");
      print("uwith rl $url");
      print("and token $token");
      await room.connect("wss://$url", token,
          connectOptions: connectOptions, roomOptions: roomOptions);
      // final listener = streamVideo.createListener();
      return VideoRoom(room: room);
    } catch (e, stack) {
      await room.dispose();
      // rethrow;
      throw StreamVideoError('''
      Unknown Exception Occurred: $e
      Stack trace: $stack
      ''');
    }
  }
}
