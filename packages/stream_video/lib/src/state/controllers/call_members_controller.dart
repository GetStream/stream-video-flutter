import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_video/protobuf/video/coordinator/event_v1/event.pb.dart';
import 'package:stream_video/src/models/events/events.dart';

class CallMembersController {
  final _callMembersController = BehaviorSubject<CallMembersEvent>();

  void _emit(CallMembersEvent event) => _callMembersController.add(event);

  void emitUpdated(CallMembersUpdated event) =>
      _emit(CallMembersUpdatedEvent(event));

  void emitDeleted(CallMembersDeleted event) =>
      _emit(CallMembersDeletedEvent(event));

  CallMembersEvent get callMembersEvent => _callMembersController.value;

  Stream<CallMembersEvent> get callMembersStream =>
      _callMembersController.stream.distinct();

  StreamSubscription<CallMembersEvent> _listen(
    FutureOr<void> Function(CallMembersEvent event) onEvent,
  ) =>
      callMembersStream.listen(onEvent);

  StreamSubscription<CallMembersEvent> on<E extends CallMembersEvent>(
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

  Future<void> dispose() async => _callMembersController.close();
}
