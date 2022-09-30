import 'dart:async';

import 'package:stream_video/protobuf/video/coordinator/event_v1/event.pb.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_events/events.pb.dart';
import 'package:webrtc_interface/src/media_stream_track.dart';

/// Base type for all StreamVideoEvent events.
mixin StreamVideoEvent {}

/// Base type for all Coordinator events.
mixin CoordinatorEvent implements StreamVideoEvent {}

mixin CallEvent implements CoordinatorEvent {}

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
  String toString() => 'call.ended ${payload.toString()}';
}

class CallStartedEvent with CallEvent {
  const CallStartedEvent(this.payload);
  final CallStarted payload;

  @override
  String toString() => 'call.deleted ${payload.toString()}';
}

class CallDeletedEvent with CallEvent {
  const CallDeletedEvent(this.payload);
  final CallDeleted payload;

  @override
  String toString() => 'call.deleted ${payload.toString()}';
}

mixin CallMembersEvent implements CoordinatorEvent {}

class CallMembersUpdatedEvent with CallMembersEvent {
  const CallMembersUpdatedEvent(this.payload);
  final CallMembersUpdated payload;

  @override
  String toString() => 'callMembers.updated ${payload.toString()}';
}

class CallMembersDeletedEvent with CallMembersEvent {
  const CallMembersDeletedEvent(this.payload);
  final CallMembersDeleted payload;

  @override
  String toString() => 'callMembers.deleted ${payload.toString()}';
}

class RecordingStoppedEvent with RecordingEvent {
  const RecordingStoppedEvent(this.payload);
  final RecordingStopped payload;

  @override
  String toString() => 'recording.stopped ${payload.toString()}';
}

mixin ParticipantEvent implements SFUEvent {}

class ParticipantJoinEvent with ParticipantEvent {
  const ParticipantJoinEvent(this.payload);
  final ParticipantJoined payload;

  @override
  String toString() => 'participant.joined ${payload.toString()}';
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

class BroadcastEndedEvent with BroadcastEvent {
  const BroadcastEndedEvent(this.payload);
  final BroadcastEnded payload;

  @override
  String toString() => 'broadcast.ended ${payload.toString()}';
}

mixin RecordingEvent implements CoordinatorEvent {}

class RecordingStartedEvent with RecordingEvent {
  const RecordingStartedEvent(this.payload);
  final RecordingStarted payload;

  @override
  String toString() => 'recording.started ${payload.toString()}';
}

mixin WebRTCEvent implements StreamVideoEvent {}

mixin TrackEvent implements WebRTCEvent {}

class LocalTrackUpdatedEvent with TrackEvent {
  const LocalTrackUpdatedEvent(this.payload);
  final MediaStreamTrack payload;

  @override
  String toString() => 'track.local.updated ${payload.toString()}';
}

class RemoteTrackUpdatedEvent with TrackEvent {
  const RemoteTrackUpdatedEvent(this.payload);
  final MediaStreamTrack payload;

  @override
  String toString() => 'track.remote.updated ${payload.toString()}';
}

mixin SFUEvent implements StreamVideoEvent {}

class SubscriberOfferEvent with SFUEvent {
  const SubscriberOfferEvent(this.payload);
  final SubscriberOffer payload;

  @override
  String toString() => 'sfu.subscriberOffer ${payload.toString()}';
}
