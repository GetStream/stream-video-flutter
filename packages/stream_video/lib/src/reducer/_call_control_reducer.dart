import '../../stream_video.dart';

final _logger = taggedLogger(tag: 'SV:Reducer-Control');

class CallControlReducer {
  const CallControlReducer();

  CallState reduce(
    CallState state,
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
    } else if (action is SetMicrophoneDevice) {
      return _reduceSetMicrophoneDevice(state, action);
    } else if (action is SetScreenShareEnabled) {
      return _reduceScreenShareEnabled(state, action);
    } else if (action is FlipCamera) {
      return _reduceFlipCamera(state, action);
    } else if (action is SetCameraDevice) {
      return _reduceSetCameraDevice(state, action);
    } else if (action is SetCameraPosition) {
      return _reduceCameraPosition(state, action);
    } else if (action is UpdateSubscriptions) {
      return _reduceUpdateSubscriptions(state, action);
    } else if (action is UpdateSubscription) {
      return _reduceUpdateSubscription(state, action);
    } else if (action is RemoveSubscription) {
      return _reduceRemoveSubscription(state, action);
    } else if (action is SetSpeakerDevice) {
      return _reduceSetSpeakerDevice(state, action);
    } else if (action is SetSpeakerphoneEnabled) {
      return _reduceSpeakerphoneEnabled(state, action);
    }
    return state;
  }

  CallState _reduceUpdateSubscriptions(
    CallState state,
    UpdateSubscriptions action,
  ) {
    final sessionId = state.sessionId;
    _logger.d(() => '[reduceSubscriptions] #$sessionId; action: $action');
    var newState = state;
    for (final child in action.actions) {
      if (child is UpdateSubscription) {
        newState = _reduceUpdateSubscription(newState, child);
      } else if (child is RemoveSubscription) {
        newState = _reduceRemoveSubscription(newState, child);
      }
    }
    return newState;
  }

  CallState _reduceUpdateSubscription(
    CallState state,
    UpdateSubscription action,
  ) {
    _logger.d(() => '[updateSub] #${state.sessionId}; action: $action');
    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        final trackState = participant.publishedTracks[action.trackType];
        if (participant.userId == action.userId &&
            participant.sessionId == action.sessionId &&
            trackState is RemoteTrackState) {
          _logger.v(() => '[updateSub] pFound: $participant');
          return participant.copyWith(
            publishedTracks: {
              ...participant.publishedTracks,
              action.trackType: trackState.copyWith(
                subscribed: true,
                videoDimension: action.videoDimension,
              ),
            },
          );
        }
        _logger.v(() => '[updateSub] pSame: $participant');
        return participant;
      }).toList(),
    );
  }

  CallState _reduceRemoveSubscription(
    CallState state,
    RemoveSubscription action,
  ) {
    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.userId == action.userId &&
            participant.sessionId == action.sessionId) {
          final trackState = participant.publishedTracks[action.trackType];
          if (trackState is RemoteTrackState) {
            return participant.copyWith(
              publishedTracks: {
                ...participant.publishedTracks,
                action.trackType: trackState.copyWith(
                  subscribed: false,
                ),
              },
            );
          }
        }
        return participant;
      }).toList(),
    );
  }

  CallState _reduceSetSpeakerDevice(
    CallState state,
    SetSpeakerDevice action,
  ) {
    return state.copyWith(
      speakerDevice: action.device,
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) return participant;

        final trackState = participant.publishedTracks[SfuTrackType.audio];
        if (trackState is! RemoteTrackState) return participant;

        return participant.copyWith(
          publishedTracks: {
            ...participant.publishedTracks,
            SfuTrackType.audio: trackState.copyWith(
              audioSinkDevice: action.device,
            ),
          },
        );
      }).toList(),
    );
  }

  CallState _reduceSpeakerphoneEnabled(
    CallState state,
    SetSpeakerphoneEnabled action,
  ) {
    return state.copyWith(
      speakerphoneEnabled: action.enabled,
    );
  }

  CallState _reduceCallAccepted(
    CallState state,
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

  CallState _reduceCallRejected(
    CallState state,
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

  CallState _reduceCallCancelled(
    CallState state,
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

  CallState _reduceCameraPosition(
    CallState state,
    SetCameraPosition action,
  ) {
    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) {
          final trackState = participant.publishedTracks[SfuTrackType.video];
          if (trackState is LocalTrackState) {
            return participant.copyWith(
              publishedTracks: {
                ...participant.publishedTracks,
                SfuTrackType.video: trackState.copyWith(
                  cameraPosition: action.cameraPosition,
                ),
              },
            );
          }
        }
        return participant;
      }).toList(),
    );
  }

  CallState _reduceFlipCamera(
    CallState state,
    FlipCamera action,
  ) {
    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) {
          final trackState = participant.publishedTracks[SfuTrackType.video];
          if (trackState is LocalTrackState) {
            return participant.copyWith(
              publishedTracks: {
                ...participant.publishedTracks,
                SfuTrackType.video: trackState.copyWith(
                  cameraPosition: trackState.cameraPosition?.flip(),
                ),
              },
            );
          }
        }
        return participant;
      }).toList(),
    );
  }

  CallState _reduceSetCameraDevice(
    CallState state,
    SetCameraDevice action,
  ) {
    return state.copyWith(
      cameraDevice: action.device,
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) {
          final trackState = participant.publishedTracks[SfuTrackType.video];
          if (trackState is LocalTrackState) {
            return participant.copyWith(
              publishedTracks: {
                ...participant.publishedTracks,
                SfuTrackType.video: trackState.copyWith(
                  sourceDevice: action.device,
                  // reset camera position to default
                  cameraPosition: CameraPosition.front,
                ),
              },
            );
          }
        }
        return participant;
      }).toList(),
    );
  }

  CallState _reduceSetMicrophoneDevice(
    CallState state,
    SetMicrophoneDevice action,
  ) {
    return state.copyWith(
      microphoneDevice: action.device,
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) {
          final trackState = participant.publishedTracks[SfuTrackType.audio];
          if (trackState is LocalTrackState) {
            return participant.copyWith(
              publishedTracks: {
                ...participant.publishedTracks,
                SfuTrackType.audio: trackState.copyWith(
                  sourceDevice: action.device,
                ),
              },
            );
          }
        }
        return participant;
      }).toList(),
    );
  }

  CallState _reduceCameraEnabled(
    CallState state,
    SetCameraEnabled action,
  ) {
    return _toggleTrackType(state, SfuTrackType.video, action.enabled);
  }

  CallState _reduceMicrophoneEnabled(
    CallState state,
    SetMicrophoneEnabled action,
  ) {
    return _toggleTrackType(state, SfuTrackType.audio, action.enabled);
  }

  CallState _reduceScreenShareEnabled(
    CallState state,
    SetScreenShareEnabled action,
  ) {
    return _toggleTrackType(state, SfuTrackType.screenShare, action.enabled);
  }

  CallState _toggleTrackType(
    CallState state,
    SfuTrackType trackType,
    bool enabled,
  ) {
    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.isLocal) {
          final publishedTracks = participant.publishedTracks;
          final trackState = publishedTracks[trackType] ?? TrackState.local();
          if (trackState is LocalTrackState) {
            var cameraPosition = trackState.cameraPosition;
            if (trackType == SfuTrackType.video && cameraPosition == null) {
              cameraPosition = CameraPosition.front;
            }
            return participant.copyWith(
              publishedTracks: {
                ...publishedTracks,
                trackType: trackState.copyWith(
                  muted: !enabled,
                  cameraPosition: cameraPosition,
                ),
              },
            );
          }
        }
        return participant;
      }).toList(),
    );
  }
}
