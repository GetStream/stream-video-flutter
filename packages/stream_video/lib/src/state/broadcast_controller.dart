import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:stream_video/events/events.dart';
import 'package:stream_video/protobuf/video_events/events.pb.dart';

class BroadcastController {
  final _broadcastStartedController = BehaviorSubject<BroadcastEvent>();

  void emit(BroadcastEvent event) => _broadcastStartedController.add(event);

  emitStarted(BroadcastStarted payload) => emit(BroadcastStartedEvent(payload));

  emitEnded(BroadcastEnded payload) => emit(BroadcastEndedEvent(payload));

  BroadcastEvent get broadcastEvent => _broadcastStartedController.value;

  Stream<BroadcastEvent> get broadcastStream =>
      _broadcastStartedController.stream.distinct();

  StreamSubscription<BroadcastEvent> listen(
          FutureOr<void> Function(BroadcastEvent event) onEvent) =>
      broadcastStream.listen(onEvent);

  StreamSubscription<BroadcastEvent> on<E extends BroadcastEvent>(
          FutureOr<void> Function(E) then,
          {bool Function(E)? filter}) =>
      listen((event) async {
        // event must be E
        if (event is! E) return;
        // filter must be true (if filter is used)
        if (filter != null && !filter(event)) return;
        // cast to E
        await then(event);
      });

  Future<void> dispose() async => _broadcastStartedController.close();

  // set broadcastStarted(BroadcastStarted broadcastStarted) =>
  //     _broadcastStartedController.add(broadcastStarted);

  // /// The current connection status value
  // BroadcastStarted get broadcastStarted => _broadcastStartedController.value;

  // /// This notifies of Healthcheck changes
  // Stream<BroadcastStarted> get broadcastStartedStream =>
  //     _broadcastStartedController.stream.distinct();

  // final _broadcastEndedController = BehaviorSubject<BroadcastEnded>();

  // set broadcastEnded(BroadcastEnded broadcastEnded) =>
  //     _broadcastEndedController.add(broadcastEnded);

  // /// The current connection status value
  // BroadcastEnded get broadcastEnded => _broadcastEndedController.value;

  // /// This notifies of Healthcheck changes
  // Stream<BroadcastEnded> get broadcastEndedStream =>
  //     _broadcastEndedController.stream.distinct();
}
