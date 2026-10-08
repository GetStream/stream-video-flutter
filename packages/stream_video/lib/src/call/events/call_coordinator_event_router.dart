import 'package:meta/meta.dart';

import '../call_events.dart';
import '../state/call_state_notifier.dart';
import 'call_closed_captions.dart';
import 'call_reactions.dart';
import 'call_video_moderation.dart';

/// Applies a coordinator event for one call to that call's state.
///
/// The events that need the call itself go to the hooks.
@internal
class CallCoordinatorEventRouter {
  CallCoordinatorEventRouter({
    required this._stateManager,
    required this._reactions,
    required this._closedCaptions,
    required this._moderation,
    required this._onPermissionRequest,
    required this._onAccepted,
    required this._onRejected,
    required this._onRingActivity,
  });

  final CallStateNotifier _stateManager;
  final CallReactions _reactions;
  final CallClosedCaptions _closedCaptions;
  final CallVideoModeration _moderation;

  /// Hands a permission request to the app.
  final void Function(StreamCallPermissionRequestEvent event)
  _onPermissionRequest;

  /// Applies an accepted call, after [_onRingActivity].
  final Future<void> Function(StreamCallAcceptedEvent event) _onAccepted;

  /// Applies a rejected call, after [_onRingActivity].
  final Future<void> Function(StreamCallRejectedEvent event) _onRejected;

  /// Called when someone accepts, rejects or misses the call, before the
  /// accept or reject hook runs.
  final void Function() _onRingActivity;

  /// Routes [event], which the caller has already matched to this call.
  Future<void> route(StreamCallEvent event) async {
    switch (event) {
      case StreamCallPermissionRequestEvent _:
        return _onPermissionRequest(event);
      case StreamCallRejectedEvent _:
        _onRingActivity();
        await _onRejected(event);
        return;
      case StreamCallAcceptedEvent _:
        _onRingActivity();
        await _onAccepted(event);
        return;
      case StreamCallEndedEvent _:
        return _stateManager.coordinatorCallEnded(event);
      case StreamCallPermissionsUpdatedEvent _:
        return _stateManager.coordinatorCallPermissionsUpdated(event);
      case StreamCallRecordingStartedEvent _:
        return _stateManager.coordinatorCallRecordingStarted(event);
      case StreamCallRecordingStoppedEvent _:
        return _stateManager.coordinatorCallRecordingStopped(event);
      case StreamCallRecordingFailedEvent _:
        return _stateManager.coordinatorCallRecordingFailed(event);
      case StreamCallTranscriptionStartedEvent _:
        return _stateManager.coordinatorCallTranscriptionStarted(event);
      case StreamCallTranscriptionStoppedEvent _:
        return _stateManager.coordinatorCallTranscriptionStopped(event);
      case StreamCallTranscriptionFailedEvent _:
        return _stateManager.coordinatorCallTranscriptionFailed(event);
      case StreamCallClosedCaptionsStartedEvent _:
        return _stateManager.coordinatorCallClosedCaptionsStarted(event);
      case StreamCallClosedCaptionsStoppedEvent _:
        return _stateManager.coordinatorCallClosedCaptionsStopped(event);
      case StreamCallClosedCaptionsFailedEvent _:
        return _stateManager.coordinatorCallClosedCaptionsFailed(event);
      case StreamCallBroadcastingStartedEvent _:
        return _stateManager.coordinatorCallBroadcastingStarted(event);
      case StreamCallBroadcastingStoppedEvent _:
        return _stateManager.coordinatorCallBroadcastingStopped(event);
      case StreamCallBroadcastingFailedEvent _:
        return _stateManager.coordinatorCallBroadcastingFailed(event);
      case StreamCallRtmpBroadcastStartedEvent _:
        return _stateManager.coordinatorCallRtmpBroadcastStarted(event);
      case StreamCallRtmpBroadcastStoppedEvent _:
        return _stateManager.coordinatorCallRtmpBroadcastStopped(event);
      case StreamCallRtmpBroadcastFailedEvent _:
        return _stateManager.coordinatorCallRtmpBroadcastFailed(event);
      case StreamCallDeletedEvent _:
        return _stateManager.coordinatorCallDeleted(event);
      case StreamCallClosedCaptionsEvent _:
        return _closedCaptions.onClosedCaption(event);
      case StreamCallReactionEvent _:
        return _reactions.onReaction(event);
      case StreamCallSessionParticipantCountUpdatedEvent _:
        final status = _stateManager.callState.status;
        if (status.isConnected || status.isJoined) {
          return;
        }

        return _stateManager.setParticipantsCount(
          totalCount: event.participantsCountByRole.values.fold(
            0,
            (a, b) => a + b,
          ),
          anonymousCount: event.anonymousParticipantCount,
        );
      case StreamCallMemberAddedEvent _:
        return _stateManager.coordinatorCallMemberAdded(event);
      case StreamCallMemberRemovedEvent _:
        return _stateManager.coordinatorCallMemberRemoved(event);
      case StreamCallMemberUpdatedEvent _:
        return _stateManager.coordinatorCallMemberUpdated(event.members);
      case StreamCallMemberUpdatedPermissionEvent _:
        return _stateManager.coordinatorCallMemberUpdated(
          event.updatedMembers,
          capabilitiesByRole: event.capabilitiesByRole,
        );
      case StreamCallUserBlockedEvent _:
        return _stateManager.coordinatorCallUserBlocked(event);
      case StreamCallUserUnblockedEvent _:
        return _stateManager.coordinatorCallUserUnblocked(event);
      case StreamCallUpdatedEvent _:
        return _stateManager.callMetadataChanged(
          event.metadata,
          capabilitiesByRole: event.capabilitiesByRole,
        );
      case StreamCallLiveStartedEvent _:
        return _stateManager.callMetadataChanged(event.metadata);
      case StreamCallRingingEvent _:
        return _stateManager.callMetadataChanged(event.metadata);
      case StreamCallMissedEvent _:
        _onRingActivity();
        return _stateManager.callMetadataChanged(event.metadata);
      case StreamCallSessionEndedEvent _:
        return _stateManager.callMetadataChanged(
          event.metadata,
          updateMembers: false,
        );
      case StreamCallSessionStartedEvent _:
        return _stateManager.callMetadataChanged(
          event.metadata,
          updateMembers: false,
        );
      case StreamCallModerationWarningEvent _:
        return _moderation.onWarning(event);
      case StreamCallModerationBlurEvent _:
        return _moderation.onBlur(event);
      default:
        break;
    }
  }
}
