import 'package:collection/collection.dart';

import '../../logger/stream_logger.dart';
import '../action/sfu_action.dart';
import '../call_participant_state.dart';
import '../call_state.dart';
import '../model/call_track_status.dart';
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
            track: CallTrackStatus.published()
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
          return participant.copyWith(
            publishedTracks: {
              ...participant.publishedTracks,
            }..removeWhere((trackType, _) => trackType == event.trackType),
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
          return participant.copyWith(
            publishedTracks: {
              ...participant.publishedTracks,
              event.trackType: CallTrackStatus.published(),
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
          );
        } else {
          return participant;
        }
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
      callParticipants: [
        ...state.callParticipants,
        participant,
      ],
    );
  }
}
