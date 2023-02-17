import 'package:stream_video/src/v2/errors/video_error.dart';
import 'package:stream_video/src/v2/sfu/data/events/sfu_events.dart';

mixin SfuEventListener {
  /// Used for passing down all [SfuEvent]s coming from
  /// the WebSocket connection, after parse.
  void onSfuEvent(SfuEvent event);

  void onSfuError(VideoError error);
}
