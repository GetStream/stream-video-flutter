import 'package:stream_video/src/v2/coordinator/models/video_models.dart';

// TODO: Should we call it VideoEvent or CoordinatorEvent?

/// Represents the events coming in from the socket.
class VideoEvent {
  const VideoEvent();
}

/// Sent periodically by the server to keep the connection alive.
class VideoHealthCheckEvent extends VideoEvent {
  const VideoHealthCheckEvent({required this.clientId, required this.userId});

  final String clientId;
  final String userId;
}

/// Sent when someone creates a call and invites another person to participate.
class VideoCallCreatedEvent extends VideoEvent {
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
class VideoCallUpdatedEvent extends VideoEvent {
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
class VideoCallEndedEvent extends VideoEvent {
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
class VideoCallAcceptedEvent extends VideoEvent {
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
class VideoCallRejectedEvent extends VideoEvent {
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
class VideoCallCancelledEvent extends VideoEvent {
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
class VideoCallMembersUpdatedEvent extends VideoEvent {
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
class VideoCallMembersDeletedEvent extends VideoEvent {
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
class VideoUnknownEvent extends VideoEvent {
  const VideoUnknownEvent();
}
