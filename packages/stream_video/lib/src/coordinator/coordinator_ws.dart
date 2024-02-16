import 'package:stream_video/src/coordinator/models/coordinator_events.dart';
import 'package:stream_video/src/shared_emitter.dart';
import 'package:stream_video/src/ws/ws.dart';

abstract class CoordinatorWebSocket extends StreamWebSocket {
  CoordinatorWebSocket(
    super.url, {
    super.protocols,
    super.tag,
  });

  SharedEmitter<CoordinatorEvent> get events;
}
