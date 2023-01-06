import 'package:stream_video/src/v2/coordinator/models/video_models.dart';

// TODO: Should we call it VideoEvent or CoordinatorEvent?

/// Represents the events coming in from the socket.
class CoordinatorEvent {
  const CoordinatorEvent();
}

/// Sent periodically by the server to keep the connection alive.
class VideoHealthCheckEvent extends CoordinatorEvent {
  const VideoHealthCheckEvent({required this.clientId, required this.userId});

  final String clientId;
  final String userId;
}

/// Sent when someone creates a call and invites another person to participate.
class VideoCallCreatedEvent extends CoordinatorEvent {
  const VideoCallCreatedEvent({
    required this.callCid,
    required this.ringing,
    required this.info,
    required this.details,
  });

  final String callCid;
  final bool ringing;
  final CallInfo info;
  final CallDetails details;
}

/// Sent when a call gets updated.
class VideoCallUpdatedEvent extends CoordinatorEvent {
  const VideoCallUpdatedEvent({
    required this.callCid,
    required this.info,
    required this.details,
  });

  final String callCid;
  final CallInfo info;
  final CallDetails details;
}

/// Sent when a calls gets ended.
class VideoCallEndedEvent extends CoordinatorEvent {
  const VideoCallEndedEvent({
    required this.callCid,
    required this.info,
    required this.details,
  });

  final String callCid;
  final CallInfo info;
  final CallDetails details;
}

/// Sent when a user accepts the call.
class VideoCallAcceptedEvent extends CoordinatorEvent {
  const VideoCallAcceptedEvent({
    required this.callCid,
    required this.sentByUserId,
    required this.info,
    required this.details,
  });

  final String callCid;
  final String sentByUserId;
  final CallInfo info;
  final CallDetails details;
}

/// Sent when a user rejects the call.
class VideoCallRejectedEvent extends CoordinatorEvent {
  const VideoCallRejectedEvent({
    required this.callCid,
    required this.sentByUserId,
    required this.info,
    required this.details,
  });

  final String callCid;
  final String sentByUserId;
  final CallInfo info;
  final CallDetails details;
}

/// Sent when a user cancels the call.
class VideoCallCancelledEvent extends CoordinatorEvent {
  const VideoCallCancelledEvent({
    required this.callCid,
    required this.sentByUserId,
    required this.info,
    required this.details,
  });

  final String callCid;
  final String sentByUserId;
  final CallInfo info;
  final CallDetails details;
}

/// Sent when call members are updated.
class VideoCallMembersUpdatedEvent extends CoordinatorEvent {
  const VideoCallMembersUpdatedEvent({
    required this.callCid,
    required this.info,
    required this.details,
  });

  final String callCid;
  final CallInfo info;
  final CallDetails details;
}

/// Sent when call members are deleted.
class VideoCallMembersDeletedEvent extends CoordinatorEvent {
  const VideoCallMembersDeletedEvent({
    required this.callCid,
    required this.info,
    required this.details,
  });

  final String callCid;
  final CallInfo info;
  final CallDetails details;
}

// Unknown event.
class VideoUnknownEvent extends CoordinatorEvent {
  const VideoUnknownEvent();
}
