import 'package:stream_video/src/v2/coordinator/ws/video_events.dart';

class VideoEventListener {
  /// Used for passing down all [VideoEvent]s coming from
  /// the WebSocket connection, after parse.
  void onEvent(VideoEvent event) {}
}
