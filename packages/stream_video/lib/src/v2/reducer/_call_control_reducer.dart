import '../../../stream_video.dart';
import '../../logger/stream_logger.dart';
import '../model/call_track_state.dart';

final _logger = taggedLogger(tag: 'SV:Reducer-Control');

class CallControlReducer {
  const CallControlReducer();

  CallStateV2 reduce(
    CallStateV2 state,
    CallControlAction action,
  ) {
    if (action is AcceptCall) {
      return _reduceCallAccepted(state, action);
    } else if (action is RejectCall) {
      return _reduceCallRejected(state, action);
    } else if (action is CancelCall) {
      return _reduceCallCancelled(state, action);
    } else if (action is SetCameraEnabled) {
      return _reduceCameraEnabled(state, action);
    } else if (action is SetMicrophoneEnabled) {
      return _reduceMicrophoneEnabled(state, action);
    } else if (action is SetScreenShareEnabled) {
      return _reduceScreenShareEnabled(state, action);
    } else if (action is UpdateSubscriptions) {
      return _reduceUpdateSubscriptions(state, action);
    } else if (action is UpdateSubscription) {
      return _reduceSubscribeVideoTrack(state, action);
    } else if (action is RemoveSubscription) {
      return _reduceUnsubscribeVideoTrack(state, action);
    }
    return state;
  }

  CallStateV2 _reduceUpdateSubscriptions(
    CallStateV2 state,
    UpdateSubscriptions action,
  ) {
    final sessionId = state.sessionId;
    _logger.d(() => '[reduceSubscriptions] #$sessionId; action: $action');
    var newState = state;
    for (final child in action.actions) {
      if (child is UpdateSubscription) {
        newState = _reduceSubscribeVideoTrack(newState, child);
      } else if (child is RemoveSubscription) {
        newState = _reduceUnsubscribeVideoTrack(newState, child);
      }
    }
    return newState;
  }

  CallStateV2 _reduceSubscribeVideoTrack(
    CallStateV2 state,
    UpdateSubscription action,
  ) {
    _logger.d(() => '[reduceSubscribe] #${state.sessionId}; action: $action');
    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.userId == action.userId &&
            participant.sessionId == action.sessionId) {
          _logger.v(() => '[reduceSubscribe] pFound: $participant');
          final publishedTracks = {
            ...participant.publishedTracks,
          };
          final trackState = publishedTracks[action.trackType]?.copyWith(
            subscribed: true,
            videoDimension: action.videoDimension,
          );
          if (trackState != null) {
            publishedTracks[action.trackType] = trackState;
          }
          return participant.copyWith(
            publishedTracks: publishedTracks,
          );
        } else {
          _logger.v(() => '[reduceSubscribe] pSame: $participant');
          return participant;
        }
      }).toList(),
    );
  }

  CallStateV2 _reduceUnsubscribeVideoTrack(
    CallStateV2 state,
    RemoveSubscription action,
  ) {
    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.sessionId == action.sessionId) {
          final publishedTracks = {
            ...participant.publishedTracks,
          };
          final trackState = publishedTracks[action.trackType]?.copyWith(
            subscribed: false,
          );
          if (trackState != null) {
            publishedTracks[action.trackType] = trackState;
          }
          return participant.copyWith(
            publishedTracks: publishedTracks,
          );
        } else {
          return participant;
        }
      }).toList(),
    );
  }

  CallStateV2 _reduceCallAccepted(
    CallStateV2 state,
    AcceptCall action,
  ) {
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(
        () => '[reduceCallAccepted] rejected (invalid status): $status',
      );
      return state;
    }
    return state.copyWith(
      status: CallStatus.incoming(acceptedByMe: true),
    );
  }

  CallStateV2 _reduceCallRejected(
    CallStateV2 state,
    RejectCall action,
  ) {
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(
        () => '[reduceCallRejected] rejected (invalid status): $status',
      );
      return state;
    }
    return state.copyWith(
      status: CallStatus.drop(
        DropReason.rejected(
          byUserId: state.currentUserId,
        ),
      ),
    );
  }

  CallStateV2 _reduceCallCancelled(
    CallStateV2 state,
    CancelCall action,
  ) {
    return state.copyWith(
      status: CallStatus.drop(
        DropReason.cancelled(
          byUserId: state.currentUserId,
        ),
      ),
    );
  }

  CallStateV2 _reduceCameraEnabled(
    CallStateV2 state,
    SetCameraEnabled action,
  ) {
    return _toggleTrackType(state, SfuTrackType.video, action.enabled);
  }

  CallStateV2 _reduceMicrophoneEnabled(
    CallStateV2 state,
    SetMicrophoneEnabled action,
  ) {
    return _toggleTrackType(state, SfuTrackType.audio, action.enabled);
  }

  CallStateV2 _reduceScreenShareEnabled(
    CallStateV2 state,
    SetScreenShareEnabled action,
  ) {
    return _toggleTrackType(state, SfuTrackType.screenShare, action.enabled);
  }

  CallStateV2 _toggleTrackType(
    CallStateV2 state,
    SfuTrackType trackType,
    bool enabled,
  ) {
    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) {
          final publishedTracks = {
            ...participant.publishedTracks,
          };
          if (enabled) {
            publishedTracks[trackType] = const CallTrackState();
          } else {
            publishedTracks.removeWhere((it, _) => it == trackType);
          }
          return participant.copyWith(
            publishedTracks: publishedTracks,
          );
        } else {
          return participant;
        }
      }).toList(),
    );
  }
}
