import 'dart:async';

import 'package:stream_video/protobuf/video/coordinator/event_v1/event.pb.dart';
// import 'package:stream_video/protobuf/video_events/events.pb.dart';

/// Base type for all StreamVideoEvent events.
mixin StreamVideoEvent {}

/// Base type for all Coordinator events.
mixin CoordinatorEvent implements StreamVideoEvent {}

mixin CallEvent implements CoordinatorEvent {}

// class CallRingingEvent with CallEvent {
//   const CallRingingEvent(this.payload);
//   final CallRinging payload;

//   @override
//   String toString() => 'call.ringing ${payload.toString()}';
// }

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

// mixin ParticipantEvent implements CoordinatorEvent {}

// class ParticipantJoinEvent with ParticipantEvent {
//   const ParticipantJoinEvent(this.payload);
//   final ParticipantJoined payload;

//   @override
//   String toString() => 'participant.joined ${payload.toString()}';
// }

// class ParticipantInvitedEvent with ParticipantEvent {
//   const ParticipantInvitedEvent(this.payload);
//   final ParticipantInvited payload;

//   @override
//   String toString() => 'participant.invited ${payload.toString()}';
// }

// class ParticipantUpdatedEvent with ParticipantEvent {
//   const ParticipantUpdatedEvent(this.payload);
//   final ParticipantUpdated payload;

//   @override
//   String toString() => 'participant.updated ${payload.toString()}';
// }

// class ParticipantDeletedEvent with ParticipantEvent {
//   const ParticipantDeletedEvent(this.payload);
//   final ParticipantDeleted payload;

//   @override
//   String toString() => 'participant.deleted ${payload.toString()}';
// }

// class ParticipantLeftEvent with ParticipantEvent {
//   const ParticipantLeftEvent(this.payload);
//   final ParticipantLeft payload;

//   @override
//   String toString() => 'participant.left ${payload.toString()}';
// }

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

// mixin VideoEvent implements CoordinatorEvent {}

// class VideoStartedEvent with VideoEvent {
//   const VideoStartedEvent(this.payload);
//   final VideoStarted payload;

//   @override
//   String toString() => 'video.started ${payload.toString()}';
// }

// class VideoStoppedEvent with VideoEvent {
//   const VideoStoppedEvent(this.payload);
//   final VideoStopped payload;

//   @override
//   String toString() => 'video.stopped ${payload.toString()}';
// }

// mixin ScreenshareEvent implements CoordinatorEvent {}

// class ScreenshareStartedEvent with ScreenshareEvent {
//   const ScreenshareStartedEvent(this.payload);
//   final ScreenshareStarted payload;

//   @override
//   String toString() => 'screenshare.started ${payload.toString()}';
// }

// class ScreenshareStoppedEvent with ScreenshareEvent {
//   const ScreenshareStoppedEvent(this.payload);
//   final ScreenshareStopped payload;

//   @override
//   String toString() => 'screenshare.stopped ${payload.toString()}';
// }

// mixin AudioEvent implements CoordinatorEvent {}

// class AudioMutedEvent with AudioEvent {
//   const AudioMutedEvent(this.payload);
//   final AudioMuted payload;

//   @override
//   String toString() => 'audio.muted ${payload.toString()}';
// }

// class AudioUnmutedEvent with AudioEvent {
//   const AudioUnmutedEvent(this.payload);
//   final AudioUnmuted payload;

//   @override
//   String toString() => 'audio.unmuted ${payload.toString()}';
// }

mixin RecordingEvent implements CoordinatorEvent {}

class RecordingStartedEvent with RecordingEvent {
  const RecordingStartedEvent(this.payload);
  final RecordingStarted payload;

  @override
  String toString() => 'recording.started ${payload.toString()}';
}

class RecordingStoppedEvent with RecordingEvent {
  const RecordingStoppedEvent(this.payload);
  final RecordingStopped payload;

  @override
  String toString() => 'recording.stopped ${payload.toString()}';
}
