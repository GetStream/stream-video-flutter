import 'models/coordinator_events.dart';

abstract class CoordinatorEventListener {
  /// Used for passing down all [CoordinatorEventV2]s coming from
  /// the WebSocket connection, after parse.
  void onCoordinatorEvent(CoordinatorEventV2 event);
}
