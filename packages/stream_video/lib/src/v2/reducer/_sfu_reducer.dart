import '../action/sfu_action.dart';
import '../call_participant_state.dart';
import '../call_state.dart';
import '../sfu/data/events/sfu_events.dart';

class SfuReducer {
  SfuReducer(this.currentUserId);

  final String currentUserId;

  CallStateV2 reduce(
    CallStateV2 state,
    SfuAction action,
  ) {
    if (action is SfuJoinedAction) {
      return _reduceJoined(state, action);
    } else if (action is SfuParticipantJoinedAction) {
      return _reduceParticipantJoined(state, action);
    } else if (action is SfuEventAction) {
      return _reduceSfuEvent(state, action.event);
    }
    return state;
  }

  CallStateV2 _reduceSfuEvent(CallStateV2 state, SfuEventV2 event) {
    if (event is SfuParticipantLeftEvent) {
      return _reduceParticipantLeft(state, event);
    } else if (event is SfuConnectionQualityChangedEvent) {
      return _reduceConnectionQualityChanged(state, event);
    } else if (event is SfuAudioLevelChangedEvent) {
      return _reduceAudioLevelChanged(state, event);
    } else if (event is SfuTrackPublishedEvent) {
      return _reduceTrackPublished(state, event);
    } else if (event is SfuTrackUnpublishedEvent) {
      return _reduceTrackUnpublished(state, event);
    }
    return state;
  }

  CallStateV2 _reduceJoined(
    CallStateV2 state,
    SfuJoinedAction action,
  ) {
    final states = action.participants.values.map((aParticipant) {
      final user = action.users[aParticipant.userId];
      final isLocal = aParticipant.userId == currentUserId;
      return CallParticipantStateV2(
        userId: user?.id ?? aParticipant.userId,
        role: user?.role ?? '',
        name: user?.name ?? aParticipant.userId,
        profileImageURL: user?.imageUrl,
        sessionId: aParticipant.sessionId,
        trackIdPrefix: aParticipant.trackLookupPrefix,
        isLocal: isLocal,
        isOnline: !isLocal,
      );
    });

    return state.copyWith(
      callParticipants: <String, CallParticipantStateV2>{
        for (var it in states) it.userId: it,
      },
    );
  }

  CallStateV2 _reduceTrackUnpublished(
    CallStateV2 state,
    SfuTrackUnpublishedEvent event,
  ) {
    return state.copyWith(
      callParticipants: {
        ...state.callParticipants,
      }..updateAll((userId, participant) {
          if (userId == event.userId && state.sessionId == event.sessionId) {
            return participant.copyWith(
              publishedTrackTypes: [
                ...participant.publishedTrackTypes,
              ]..removeWhere((trackType) => trackType == event.trackType),
            );
          } else {
            return participant;
          }
        }),
    );
  }

  CallStateV2 _reduceTrackPublished(
    CallStateV2 state,
    SfuTrackPublishedEvent event,
  ) {
    return state.copyWith(
      callParticipants: {
        ...state.callParticipants,
      }..updateAll((userId, participant) {
          if (userId == event.userId && state.sessionId == event.sessionId) {
            return participant.copyWith(
              publishedTrackTypes: [
                ...participant.publishedTrackTypes,
                event.trackType,
              ],
            );
          } else {
            return participant;
          }
        }),
    );
  }

  CallStateV2 _reduceAudioLevelChanged(
    CallStateV2 state,
    SfuAudioLevelChangedEvent event,
  ) {
    return state.copyWith(
      callParticipants: {
        ...state.callParticipants,
      }..updateAll((userId, participant) {
          final levelInfo = event.audioLevels[userId];
          if (state.sessionId == levelInfo?.sessionId) {
            return participant.copyWith(
              audioLevel: levelInfo?.level,
            );
          } else {
            return participant;
          }
        }),
    );
  }

  CallStateV2 _reduceConnectionQualityChanged(
    CallStateV2 state,
    SfuConnectionQualityChangedEvent event,
  ) {
    return state.copyWith(
      callParticipants: {
        ...state.callParticipants,
      }..updateAll((userId, participant) {
          final update = event.connectionQualityUpdates[userId];
          if (state.sessionId == update?.sessionId) {
            return participant.copyWith(
              connectionQuality: update?.connectionQuality,
            );
          } else {
            return participant;
          }
        }),
    );
  }

  CallStateV2 _reduceParticipantLeft(
    CallStateV2 state,
    SfuParticipantLeftEvent event,
  ) {
    return state.copyWith(
      callParticipants: {
        ...state.callParticipants,
      }..remove(event.participant.userId),
    );
  }

  CallStateV2 _reduceParticipantJoined(
    CallStateV2 state,
    SfuParticipantJoinedAction action,
  ) {
    final participant = CallParticipantStateV2(
      userId: action.user?.id ?? action.participant.userId,
      role: action.user?.role ?? '',
      name: action.user?.name ?? action.participant.userId,
      profileImageURL: action.user?.imageUrl,
      sessionId: action.participant.sessionId,
      trackIdPrefix: action.participant.trackLookupPrefix,
      isLocal: action.isLocalUser,
      isOnline: !action.isLocalUser,
    );
    return state.copyWith(
      callParticipants: {
        ...state.callParticipants,
        participant.userId: participant,
      },
    );
  }
}
