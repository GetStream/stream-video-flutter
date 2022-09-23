import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_video/protobuf/video/coordinator/event_v1/event.pb.dart';
import 'package:stream_video/src/models/events/events.dart';

class CallController {
  final _callController = BehaviorSubject<CallEvent>();

  void _emit(CallEvent event) => _callController.add(event);

  // emitRinging(CallRinging payload) => emit(CallRingingEvent(payload));

  emitCreated(CallCreated payload) => _emit(CallCreatedEvent(payload));

  emitUpdated(CallUpdated payload) => _emit(CallUpdatedEvent(payload));

  emitEnded(CallEnded payload) => _emit(CallEndedEvent(payload));

  emitDeleted(CallDeleted payload) => _emit(CallDeletedEvent(payload));

  emitStarted(CallStarted payload) => _emit(CallStartedEvent(payload));

  CallEvent get callEvent => _callController.value;

  Stream<CallEvent> get callEventStream => _callController.stream.distinct();

  StreamSubscription<CallEvent> listen(
    FutureOr<void> Function(CallEvent event) onEvent,
  ) =>
      callEventStream.listen(onEvent);

  StreamSubscription<CallEvent> on<E extends CallEvent>(
    FutureOr<void> Function(E) then, {
    bool Function(E)? filter,
  }) =>
      listen((event) async {
        // event must be E
        if (event is! E) return;
        // filter must be true (if filter is used)
        if (filter != null && !filter(event)) return;
        // cast to E
        await then(event);
      });

  Future<void> dispose() async => _callController.close();
}
