import 'package:stream_core/stream_core.dart' show StreamApiError;

import '../../call/call_events.dart';
import '../../models/stream_video_event.dart';

/// The events coming in from the coordinator socket.
@Deprecated('Use StreamVideoEvent instead.')
typedef CoordinatorEvent = StreamVideoEvent;

/// Sent one time after successful connection.
class CoordinatorConnectedEvent extends StreamVideoEvent {
  const CoordinatorConnectedEvent({
    required this.connectionId,
    required this.userId,
  });

  final String connectionId;
  final String userId;

  @override
  List<Object?> get props => [connectionId, userId];
}

/// Fired when web socket is closed.
class CoordinatorDisconnectedEvent extends StreamVideoEvent {
  const CoordinatorDisconnectedEvent({
    this.connectionId,
    this.userId,
    this.closeCode,
    this.closeReason,
    this.apiError,
  });

  final String? connectionId;
  final String? userId;
  final int? closeCode;
  final String? closeReason;

  /// The error the server reported before closing, when it sent one.
  ///
  /// A refused token is reported this way rather than as a close code, so for
  /// a connection the server rejected this is the only description of why.
  final StreamApiError? apiError;

  @override
  List<Object?> get props => [
    connectionId,
    userId,
    closeCode,
    closeReason,
    apiError,
  ];
}

/// Fired when web socket reconnected.
class CoordinatorReconnectedEvent extends StreamVideoEvent {
  const CoordinatorReconnectedEvent({
    this.connectionId,
    this.userId,
  });

  final String? connectionId;
  final String? userId;

  @override
  List<Object?> get props => [connectionId, userId];
}

/// Sent periodically by the server to keep the connection alive.
class CoordinatorHealthCheckEvent extends StreamVideoEvent {
  const CoordinatorHealthCheckEvent({
    required this.clientId,
  });

  final String clientId;

  @override
  List<Object?> get props => [clientId];
}

/// Never delivered: a coordinator message this SDK version has no model for
/// is dropped when it is decoded.
@Deprecated('Never delivered; unknown coordinator messages are dropped.')
class CoordinatorUnknownEvent extends StreamVideoEvent {
  @Deprecated('Never delivered.')
  const CoordinatorUnknownEvent();
}

/// Never delivered.
@Deprecated('Never delivered.')
class CoordinatorUnsupportedEvent extends StreamVideoEvent {
  @Deprecated('Never delivered.')
  const CoordinatorUnsupportedEvent();
}

// The coordinator used to deliver its own copy of every call event, which each
// `Call` then mapped again into the matching `StreamCall*Event`. The call events
// are now delivered once, as `StreamCall*Event`; these aliases keep code that
// names the old types compiling. `dart fix --apply` renames them.

@Deprecated('Use StreamCallEvent instead.')
typedef CoordinatorCallEvent = StreamCallEvent;

@Deprecated('Use StreamCallCreatedEvent instead.')
typedef CoordinatorCallCreatedEvent = StreamCallCreatedEvent;

@Deprecated('Use StreamCallRingingEvent instead.')
typedef CoordinatorCallRingingEvent = StreamCallRingingEvent;

@Deprecated('Use StreamCallMissedEvent instead.')
typedef CoordinatorCallMissedEvent = StreamCallMissedEvent;

@Deprecated('Use StreamCallUpdatedEvent instead.')
typedef CoordinatorCallUpdatedEvent = StreamCallUpdatedEvent;

@Deprecated('Use StreamCallEndedEvent instead.')
typedef CoordinatorCallEndedEvent = StreamCallEndedEvent;

@Deprecated('Use StreamCallAcceptedEvent instead.')
typedef CoordinatorCallAcceptedEvent = StreamCallAcceptedEvent;

@Deprecated('Use StreamCallRejectedEvent instead.')
typedef CoordinatorCallRejectedEvent = StreamCallRejectedEvent;

@Deprecated('Use StreamCallPermissionRequestEvent instead.')
typedef CoordinatorCallPermissionRequestEvent =
    StreamCallPermissionRequestEvent;

@Deprecated('Use StreamCallPermissionsUpdatedEvent instead.')
typedef CoordinatorCallPermissionsUpdatedEvent =
    StreamCallPermissionsUpdatedEvent;

@Deprecated('Use StreamCallRecordingStartedEvent instead.')
typedef CoordinatorCallRecordingStartedEvent = StreamCallRecordingStartedEvent;

@Deprecated('Use StreamCallRecordingStoppedEvent instead.')
typedef CoordinatorCallRecordingStoppedEvent = StreamCallRecordingStoppedEvent;

@Deprecated('Use StreamCallRecordingFailedEvent instead.')
typedef CoordinatorCallRecordingFailedEvent = StreamCallRecordingFailedEvent;

@Deprecated('Use StreamCallTranscriptionStartedEvent instead.')
typedef CoordinatorCallTranscriptionStartedEvent =
    StreamCallTranscriptionStartedEvent;

@Deprecated('Use StreamCallTranscriptionStoppedEvent instead.')
typedef CoordinatorCallTranscriptionStoppedEvent =
    StreamCallTranscriptionStoppedEvent;

@Deprecated('Use StreamCallTranscriptionFailedEvent instead.')
typedef CoordinatorCallTranscriptionFailedEvent =
    StreamCallTranscriptionFailedEvent;

@Deprecated('Use StreamCallClosedCaptionsStartedEvent instead.')
typedef CoordinatorCallClosedCaptionStartedEvent =
    StreamCallClosedCaptionsStartedEvent;

@Deprecated('Use StreamCallClosedCaptionsStoppedEvent instead.')
typedef CoordinatorCallClosedCaptionStoppedEvent =
    StreamCallClosedCaptionsStoppedEvent;

@Deprecated('Use StreamCallClosedCaptionsFailedEvent instead.')
typedef CoordinatorCallClosedCaptionFailedEvent =
    StreamCallClosedCaptionsFailedEvent;

@Deprecated('Use StreamCallBroadcastingStartedEvent instead.')
typedef CoordinatorCallBroadcastingStartedEvent =
    StreamCallBroadcastingStartedEvent;

@Deprecated('Use StreamCallBroadcastingStoppedEvent instead.')
typedef CoordinatorCallBroadcastingStoppedEvent =
    StreamCallBroadcastingStoppedEvent;

@Deprecated('Use StreamCallBroadcastingFailedEvent instead.')
typedef CoordinatorCallBroadcastingFailedEvent =
    StreamCallBroadcastingFailedEvent;

@Deprecated('Use StreamCallRtmpBroadcastStartedEvent instead.')
typedef CoordinatorCallRtmpBroadcastStartedEvent =
    StreamCallRtmpBroadcastStartedEvent;

@Deprecated('Use StreamCallRtmpBroadcastStoppedEvent instead.')
typedef CoordinatorCallRtmpBroadcastStoppedEvent =
    StreamCallRtmpBroadcastStoppedEvent;

@Deprecated('Use StreamCallRtmpBroadcastFailedEvent instead.')
typedef CoordinatorCallRtmpBroadcastFailedEvent =
    StreamCallRtmpBroadcastFailedEvent;

@Deprecated('Use StreamCallUserBlockedEvent instead.')
typedef CoordinatorCallUserBlockedEvent = StreamCallUserBlockedEvent;

@Deprecated('Use StreamCallUserUnblockedEvent instead.')
typedef CoordinatorCallUserUnblockedEvent = StreamCallUserUnblockedEvent;

@Deprecated('Use StreamCallUserKickedEvent instead.')
typedef CoordinatorCallUserKickedEvent = StreamCallUserKickedEvent;

@Deprecated('Use StreamCallReactionEvent instead.')
typedef CoordinatorCallReactionEvent = StreamCallReactionEvent;

@Deprecated('Use StreamCallCustomEvent instead.')
typedef CoordinatorCallCustomEvent = StreamCallCustomEvent;

@Deprecated('Use StreamCallSessionStartedEvent instead.')
typedef CoordinatorCallSessionStartedEvent = StreamCallSessionStartedEvent;

@Deprecated('Use StreamCallSessionEndedEvent instead.')
typedef CoordinatorCallSessionEndedEvent = StreamCallSessionEndedEvent;

@Deprecated('Use StreamCallSessionParticipantJoinedEvent instead.')
typedef CoordinatorCallSessionParticipantJoinedEvent =
    StreamCallSessionParticipantJoinedEvent;

@Deprecated('Use StreamCallSessionParticipantLeftEvent instead.')
typedef CoordinatorCallSessionParticipantLeftEvent =
    StreamCallSessionParticipantLeftEvent;

@Deprecated('Use StreamCallSessionParticipantCountUpdatedEvent instead.')
typedef CoordinatorCallSessionParticipantCountUpdatedEvent =
    StreamCallSessionParticipantCountUpdatedEvent;

@Deprecated('Use StreamCallClosedCaptionsEvent instead.')
typedef CoordinatorCallClosedCaptionEvent = StreamCallClosedCaptionsEvent;

@Deprecated('Use StreamCallLiveStartedEvent instead.')
typedef CoordinatorCallLiveStartedEvent = StreamCallLiveStartedEvent;

@Deprecated('Use StreamCallMemberAddedEvent instead.')
typedef CoordinatorCallMemberAddedEvent = StreamCallMemberAddedEvent;

@Deprecated('Use StreamCallMemberRemovedEvent instead.')
typedef CoordinatorCallMemberRemovedEvent = StreamCallMemberRemovedEvent;

@Deprecated('Use StreamCallMemberUpdatedEvent instead.')
typedef CoordinatorCallMemberUpdatedEvent = StreamCallMemberUpdatedEvent;

@Deprecated('Use StreamCallMemberUpdatedPermissionEvent instead.')
typedef CoordinatorCallMemberUpdatedPermissionEvent =
    StreamCallMemberUpdatedPermissionEvent;

@Deprecated('Use StreamCallFrameRecordingStartedEvent instead.')
typedef CoordinatorCallFrameRecordingStartedEvent =
    StreamCallFrameRecordingStartedEvent;

@Deprecated('Use StreamCallFrameRecordingStoppedEvent instead.')
typedef CoordinatorCallFrameRecordingStoppedEvent =
    StreamCallFrameRecordingStoppedEvent;

@Deprecated('Use StreamCallFrameRecordingFailedEvent instead.')
typedef CoordinatorCallFrameRecordingFailedEvent =
    StreamCallFrameRecordingFailedEvent;

@Deprecated('Use StreamCallFrameRecordingReadyEvent instead.')
typedef CoordinatorCallFrameRecordingReadyEvent =
    StreamCallFrameRecordingReadyEvent;

@Deprecated('Use StreamCallNotificationEvent instead.')
typedef CoordinatorCallNotificationEvent = StreamCallNotificationEvent;

@Deprecated('Use StreamCallUserMutedEvent instead.')
typedef CoordinatorCallUserMutedEvent = StreamCallUserMutedEvent;

@Deprecated('Use StreamCallRecordingReadyEvent instead.')
typedef CoordinatorCallRecordingReadyEvent = StreamCallRecordingReadyEvent;

@Deprecated('Use StreamCallModerationBlurEvent instead.')
typedef CoordinatorCallModerationBlurEvent = StreamCallModerationBlurEvent;

@Deprecated('Use StreamCallModerationWarningEvent instead.')
typedef CoordinatorCallModerationWarningEvent =
    StreamCallModerationWarningEvent;

@Deprecated('Use StreamCallDeletedEvent instead.')
typedef CoordinatorCallDeletedEvent = StreamCallDeletedEvent;

@Deprecated('Use StreamCallUserFeedbackSubmittedEvent instead.')
typedef CoordinatorCallUserFeedbackSubmittedEvent =
    StreamCallUserFeedbackSubmittedEvent;

@Deprecated('Use StreamCallTranscriptionReadyEvent instead.')
typedef CoordinatorCallTranscriptionReadyEvent =
    StreamCallTranscriptionReadyEvent;

@Deprecated('Use StreamCallIngressStartedEvent instead.')
typedef CoordinatorIngressStartedEvent = StreamCallIngressStartedEvent;

@Deprecated('Use StreamCallIngressStoppedEvent instead.')
typedef CoordinatorIngressStoppedEvent = StreamCallIngressStoppedEvent;

@Deprecated('Use StreamCallIngressErrorEvent instead.')
typedef CoordinatorIngressErrorEvent = StreamCallIngressErrorEvent;
