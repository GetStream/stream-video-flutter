import '../shared_emitter.dart';
import '../ws/ws.dart';
import 'models/coordinator_events.dart';

abstract class CoordinatorWebSocket extends StreamWebSocket {
  CoordinatorWebSocket(
    super.url, {
    super.protocols,
    super.tag,
  });

  SharedEmitter<CoordinatorEvent> get events;
}
