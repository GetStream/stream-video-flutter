import 'package:stream_video/src/v2/coordinator/ws/coordinator_events.dart';

class CoordinatorEventListener {
  /// Used for passing down all [CoordinatorEvent]s coming from
  /// the WebSocket connection, after parse.
  void onEvent(CoordinatorEvent event) {}
}
