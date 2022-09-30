import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:stream_video/protobuf/video/coordinator/event_v1/event.pb.dart';
import 'package:stream_video/src/models/events/events.dart';

class BroadcastController {
  final _broadcastStartedController = BehaviorSubject<BroadcastEvent>();

  void _emit(BroadcastEvent event) => _broadcastStartedController.add(event);

  emitStarted(BroadcastStarted payload) => _emit(BroadcastStartedEvent(payload));

  emitEnded(BroadcastEnded payload) => _emit(BroadcastEndedEvent(payload));

  BroadcastEvent get broadcastEvent => _broadcastStartedController.value;

  Stream<BroadcastEvent> get broadcastStream =>
      _broadcastStartedController.stream.distinct();

  StreamSubscription<BroadcastEvent> _listen(
    FutureOr<void> Function(BroadcastEvent event) onEvent,
  ) =>
      broadcastStream.listen(onEvent);

  StreamSubscription<BroadcastEvent> on<E extends BroadcastEvent>(
    FutureOr<void> Function(E) then, {
    bool Function(E)? filter,
  }) =>
      _listen((event) async {
        // event must be E
        if (event is! E) return;
        // filter must be true (if filter is used)
        if (filter != null && !filter(event)) return;
        // cast to E
        await then(event);
      });

  Future<void> dispose() async => _broadcastStartedController.close();

}
