import 'package:stream_video/src/v2/coordinator/ws/coordinator_events.dart';

abstract class CoordinatorEventListener {
  /// Used for passing down all [CoordinatorEvent]s coming from
  /// the WebSocket connection, after parse.
  void onCoordinatorEvent(CoordinatorEvent event);
}
