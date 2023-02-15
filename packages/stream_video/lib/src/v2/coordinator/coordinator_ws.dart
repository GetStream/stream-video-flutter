import '../../ws/ws.dart';
import '../shared_emitter.dart';
import 'models/coordinator_events.dart';

abstract class CoordinatorWebSocketV2 extends StreamWebSocket {
  CoordinatorWebSocketV2(
    super.url, {
    super.protocols,
  });

  SharedEmitter<CoordinatorEventV2> get events;
}
