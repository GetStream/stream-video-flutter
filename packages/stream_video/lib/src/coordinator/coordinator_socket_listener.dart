import 'models/coordinator_events.dart';

abstract class CoordinatorEventListener {
  /// Used for passing down all [CoordinatorEvent]s coming from
  /// the WebSocket connection, after parse.
  void onCoordinatorEvent(covariant CoordinatorEvent event);
}
