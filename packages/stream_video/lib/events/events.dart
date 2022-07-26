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

class CallUpdatedEvent with CallEvent {
  const CallUpdatedEvent(this.payload);
  final CallUpdated payload;

  @override
  String toString() => 'call.updated ${payload.toString()}';
}

class CallEndedEvent with CallEvent {
  const CallEndedEvent(this.payload);
  final CallEnded payload;

  @override
  String toString() => 'call.updated ${payload.toString()}';
}

class CallDeletedEvent with CallEvent {
  const CallDeletedEvent(this.payload);
  final CallDeleted payload;

  @override
  String toString() => 'call.deleted ${payload.toString()}';
}

mixin ParticipantEvent implements CoordinatorEvent {}

class ParticipantJoinEvent with ParticipantEvent {
  const ParticipantJoinEvent(this.payload);
  final ParticipantJoined payload;

  @override
  String toString() => 'participant.joined ${payload.toString()}';
}

class ParticipantInvitedEvent with ParticipantEvent {
  const ParticipantInvitedEvent(this.payload);
  final ParticipantInvited payload;

  @override
  String toString() => 'participant.invited ${payload.toString()}';
}

class ParticipantUpdatedEvent with ParticipantEvent {
  const ParticipantUpdatedEvent(this.payload);
  final ParticipantUpdated payload;

  @override
  String toString() => 'participant.updated ${payload.toString()}';
}

class ParticipantDeletedEvent with ParticipantEvent {
  const ParticipantDeletedEvent(this.payload);
  final ParticipantDeleted payload;

  @override
  String toString() => 'participant.deleted ${payload.toString()}';
}

class ParticipantLeftEvent with ParticipantEvent {
  const ParticipantLeftEvent(this.payload);
  final ParticipantLeft payload;

  @override
  String toString() => 'participant.left ${payload.toString()}';
}


mixin BroadcastEvent implements CoordinatorEvent {}

class BroadcastStartedEvent with BroadcastEvent {
  const BroadcastStartedEvent(this.payload);
  final BroadcastStarted payload;

  @override
  String toString() => 'broadcast.started ${payload.toString()}';
}