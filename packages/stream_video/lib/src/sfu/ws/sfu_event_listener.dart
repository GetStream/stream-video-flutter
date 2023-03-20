import '../../errors/video_error.dart';
import '../data/events/sfu_events.dart';

mixin SfuEventListener {
  /// Used for passing down all [SfuEvent]s coming from
  /// the WebSocket connection, after parse.
  void onSfuEvent(SfuEvent event);

  void onSfuError(VideoError error);
}
