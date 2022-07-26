import 'dart:async';

import 'package:stream_video/protobuf/video_events/events.pb.dart';

/// Base type for all StreamVideoEvent events.
mixin StreamVideoEvent {}

/// Base type for all Coordinator events.
mixin CoordinatorEvent implements StreamVideoEvent {}

mixin CallEvent implements CoordinatorEvent {}

class CallRingingEvent with CallEvent {
  const CallRingingEvent(this.payload);
  final CallRinging payload;

  @override
  String toString() => 'call.ringing ${payload.toString()}';
}

class CallCreatedEvent with CallEvent {
  const CallCreatedEvent(this.payload);
  final CallCreated payload;

  @override
  String toString() => 'call.created ${payload.toString()}';
}

// class CallListener with EventEmitter<CallEvent> {

//   void on(FutureOr<void> Function(CallEvent) then,
//           {bool Function(CallEvent)? filter}) =>
//       onEvent(then, filter: filter);
// }
