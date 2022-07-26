import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_video/events/events.dart';
import 'package:stream_video/protobuf/video_events/events.pb.dart';

class CallController {
  final _callController = BehaviorSubject<CallEvent>();

  emitCreated(CallRinging payload) =>
      _callController.add(CallRingingEvent(payload));

  emitRinging(CallCreated payload) =>
      _callController.add(CallCreatedEvent(payload));

  CallEvent get callEvent => _callController.value;

  Stream<CallEvent> get callEventStream => _callController.stream.distinct();

  StreamSubscription<CallEvent> listen(
          FutureOr<void> Function(CallEvent event) onEvent) =>
      callEventStream.listen(onEvent);

  StreamSubscription<CallEvent> on<E extends CallEvent>(
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

  // onCallRinging()

  // final _callUpdatedController = BehaviorSubject<CallUpdated>();

  // set callUpdated(CallUpdated callUpdated) =>
  //     _callUpdatedController.add(callUpdated);

  // /// The current connection status value
  // CallUpdated get callUpdated => _callUpdatedController.value;

  // /// This notifies of Healthcheck changes
  // Stream<CallUpdated> get callUpdatedStream =>
  //     _callUpdatedController.stream.distinct();

  // final _callEndedController = BehaviorSubject<CallEnded>();

  // set callEnded(CallEnded callEnded) => _callEndedController.add(callEnded);

  // /// The current connection status value
  // CallEnded get callEnded => _callEndedController.value;

  // /// This notifies of Healthcheck changes
  // Stream<CallEnded> get callEndedStream =>
  //     _callEndedController.stream.distinct();

  // final _callDeletedController = BehaviorSubject<CallDeleted>();

  // set callDeleted(CallDeleted callDeleted) =>
  //     _callDeletedController.add(callDeleted);

  // /// The current connection status value
  // CallDeleted get callDeleted => _callDeletedController.value;

  // /// This notifies of Healthcheck changes
  // Stream<CallDeleted> get callDeletedStream =>
  //     _callDeletedController.stream.distinct();

}
