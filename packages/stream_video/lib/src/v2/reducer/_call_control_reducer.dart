import '../action/call_control_action.dart';
import '../call_state.dart';
import '../sfu/data/models/sfu_track_type.dart';

class CallControlReducer {
  const CallControlReducer(this.currentUserId);

  final String currentUserId;

  CallStateV2 reduce(
    CallStateV2 state,
    CallControlAction action,
  ) {
    if (action is SetCameraEnabled) {
      return _reduceCameraEnabled(state, action);
    } else if (action is SetMicrophoneEnabled) {
      return _reduceMicrophoneEnabled(state, action);
    } else if (action is SetScreenShareEnabled) {
      return _reduceScreenShareEnabled(state, action);
    }

    return state;
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
      callParticipants: {
        ...state.callParticipants,
      }..updateAll((userId, participant) {
          if (participant.isLocal) {
            final publishedTrackTypes = [
              ...participant.publishedTrackTypes,
            ];
            if (enabled) {
              publishedTrackTypes.add(trackType);
            } else {
              publishedTrackTypes.removeWhere((it) => it == trackType);
            }
            return participant.copyWith(
              publishedTrackTypes: publishedTrackTypes,
            );
          } else {
            return participant;
          }
        }),
    );
  }
}
