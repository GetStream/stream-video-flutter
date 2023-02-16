import 'package:collection/collection.dart';

import '../../logger/impl/tagged_logger.dart';
import '../action/sfu_action.dart';
import '../call_participant_state.dart';
import '../call_state.dart';
import '../model/call_track_state.dart';
import '../sfu/data/events/sfu_events.dart';

final _logger = taggedLogger(tag: 'SV:Reducer-SFU');

class SfuReducer {
  const SfuReducer();

  CallStateV2 reduce(
    CallStateV2 state,
    SfuAction action,
  ) {
    if (action is SfuJoinedAction) {
      return _reduceJoined(state, action);
    } else if (action is SfuParticipantJoinedAction) {
      return _reduceParticipantJoined2(state, action);
    } else if (action is SfuEventAction) {
      return _reduceSfuEvent(state, action.event);
    }
    return state;
  }

  CallStateV2 _reduceSfuEvent(CallStateV2 state, SfuEventV2 event) {
    if (event is SfuJoinResponseEvent) {
      return _reduceJoinResponse(state, event);
    } else if (event is SfuParticipantJoinedEvent) {
      return _reduceParticipantJoined(state, event);
    } else if (event is SfuParticipantLeftEvent) {
      return _reduceParticipantLeft(state, event);
    } else if (event is SfuConnectionQualityChangedEvent) {
      return _reduceConnectionQualityChanged(state, event);
    } else if (event is SfuAudioLevelChangedEvent) {
      return _reduceAudioLevelChanged(state, event);
    } else if (event is SfuTrackPublishedEvent) {
      return _reduceTrackPublished(state, event);
    } else if (event is SfuTrackUnpublishedEvent) {
      return _reduceTrackUnpublished(state, event);
    } else if (event is SfuDominantSpeakerChangedEvent) {
      return _reduceDominantSpeakerChanged(state, event);
    }
    return state;
  }

  CallStateV2 _reduceJoinResponse(
    CallStateV2 state,
    SfuJoinResponseEvent event,
  ) {
    _logger.d(() => '[reduceJoinResponse] ${state.sessionId}; event: $event');
    final participants = event.callState.participants.map((aParticipant) {
      final isLocal = aParticipant.userId == state.currentUserId;
      return CallParticipantStateV2(
        userId: aParticipant.userId,
        role: '',
        name: aParticipant.userId,
        profileImageURL: '',
        sessionId: aParticipant.sessionId,
        trackIdPrefix: aParticipant.trackLookupPrefix,
        publishedTracks: {
          for (var track in aParticipant.publishedTracks)
            track: TrackState.base(isLocal: isLocal)
        },
        isLocal: isLocal,
        isOnline: !isLocal,
        isSpeaking: aParticipant.isSpeaking,
        audioLevel: aParticipant.audioLevel,
        isDominantSpeaker: aParticipant.isDominantSpeaker,
      );
    }).toList();

    return state.copyWith(
      callParticipants: participants,
    );
  }

  CallStateV2 _reduceJoined(
    CallStateV2 state,
    SfuJoinedAction action,
  ) {
    _logger.d(
      () => '[reduceJoined] ${state.sessionId}; action: $action',
    );
    final participants = action.participants.map((aParticipant) {
      final user = action.users[aParticipant.userId];
      final isLocal = aParticipant.userId == state.currentUserId;
      return CallParticipantStateV2(
        userId: user?.id ?? aParticipant.userId,
        role: user?.role ?? '',
        name: user?.name ?? aParticipant.userId,
        profileImageURL: user?.imageUrl,
        sessionId: aParticipant.sessionId,
        trackIdPrefix: aParticipant.trackLookupPrefix,
        publishedTracks: {
          for (var track in aParticipant.publishedTracks)
            track: TrackState.base(isLocal: isLocal)
        },
        isLocal: isLocal,
        isOnline: !isLocal,
        isSpeaking: aParticipant.isSpeaking,
        audioLevel: aParticipant.audioLevel,
        isDominantSpeaker: aParticipant.isDominantSpeaker,
      );
    }).toList();

    return state.copyWith(
      callParticipants: participants,
    );
  }

  CallStateV2 _reduceTrackUnpublished(
    CallStateV2 state,
    SfuTrackUnpublishedEvent event,
  ) {
    _logger.d(
      () => '[reduceTrackUnpublished] ${state.sessionId}; event: $event',
    );
    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.userId == event.userId &&
            participant.sessionId == event.sessionId) {
          final trackState = participant.publishedTracks[event.trackType]
              ?.copyWith(muted: true);

          final publishedTracks = {
            ...participant.publishedTracks,
          };
          if (trackState != null) {
            publishedTracks[event.trackType] = trackState;
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

  CallStateV2 _reduceTrackPublished(
    CallStateV2 state,
    SfuTrackPublishedEvent event,
  ) {
    _logger.d(() => '[reduceTrackPublished] ${state.sessionId}; event: $event');

    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        if (participant.userId == event.userId &&
            participant.sessionId == event.sessionId) {
          _logger.v(() => '[reduceTrackPublished] pFound: $participant');

          final trackState = participant.publishedTracks[event.trackType]
                  ?.copyWith(muted: false) ??
              TrackState.base(isLocal: participant.isLocal);
          return participant.copyWith(
            publishedTracks: {
              ...participant.publishedTracks,
              event.trackType: trackState,
            },
          );
        } else {
          _logger.v(() => '[reduceTrackPublished] pSame: $participant');
          return participant;
        }
      }).toList(),
    );
  }

  CallStateV2 _reduceAudioLevelChanged(
    CallStateV2 state,
    SfuAudioLevelChangedEvent event,
  ) {
    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        final levelInfo = event.audioLevels.firstWhereOrNull((level) {
          return level.userId == participant.userId &&
              level.sessionId == participant.sessionId;
        });
        if (levelInfo != null) {
          return participant.copyWith(
            audioLevel: levelInfo.level,
            isSpeaking: levelInfo.isSpeaking,
          );
        } else {
          return participant;
        }
      }).toList(),
    );
  }

  CallStateV2 _reduceDominantSpeakerChanged(
    CallStateV2 state,
    SfuDominantSpeakerChangedEvent event,
  ) {
    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        // Mark the new dominant speaker
        if (participant.userId == event.userId &&
            participant.sessionId == event.sessionId) {
          return participant.copyWith(
            isDominantSpeaker: true,
          );
        }
        // Unmark the old dominant speaker
        if (participant.isDominantSpeaker) {
          return participant.copyWith(
            isDominantSpeaker: false,
          );
        }
        return participant;
      }).toList(),
    );
  }

  CallStateV2 _reduceConnectionQualityChanged(
    CallStateV2 state,
    SfuConnectionQualityChangedEvent event,
  ) {
    return state.copyWith(
      callParticipants: state.callParticipants.map((participant) {
        final update = event.connectionQualityUpdates.firstWhereOrNull((it) {
          return it.userId == participant.userId &&
              it.sessionId == participant.sessionId;
        });
        if (state.sessionId == update?.sessionId) {
          return participant.copyWith(
            connectionQuality: update?.connectionQuality,
          );
        } else {
          return participant;
        }
      }).toList(),
    );
  }

  CallStateV2 _reduceParticipantJoined(
    CallStateV2 state,
    SfuParticipantJoinedEvent event,
  ) {
    final isLocal = state.currentUserId == event.participant.userId;
    final participant = CallParticipantStateV2(
      userId: event.participant.userId,
      role: '',
      name: '',
      sessionId: event.participant.sessionId,
      trackIdPrefix: event.participant.trackLookupPrefix,
      isLocal: isLocal,
      isOnline: !isLocal,
    );
    return state.copyWith(
      callParticipants: [
        ...state.callParticipants,
        participant,
      ],
    );
  }

  CallStateV2 _reduceParticipantLeft(
    CallStateV2 state,
    SfuParticipantLeftEvent event,
  ) {
    return state.copyWith(
      callParticipants: [...state.callParticipants]..removeWhere(
          (participant) =>
              participant.userId == event.participant.userId &&
              participant.sessionId == event.participant.sessionId,
        ),
    );
  }

  CallStateV2 _reduceParticipantJoined2(
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
      callParticipants: [
        ...state.callParticipants,
        participant,
      ],
    );
  }
}
