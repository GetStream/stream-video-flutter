import 'package:stream_video/src/v2/errors/video_error.dart';
import 'package:stream_video/src/v2/sfu/data/events/sfu_events.dart';

abstract class SfuEventListener {
  /// Used for passing down all [SfuEventV2]s coming from
  /// the WebSocket connection, after parse.
  void onSfuEvent(SfuEventV2 event);

  void onSfuError(VideoError error);
}
