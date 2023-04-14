import 'package:collection/collection.dart';

import '../../stream_video.dart';
import '../action/sfu_action.dart';
import '../sfu/data/events/sfu_events.dart';

final _logger = taggedLogger(tag: 'SV:Reducer-SFU');

class SfuReducer {
  const SfuReducer();

  CallState reduce(
    CallState state,
    SfuAction action,
  ) {
    if (action is SfuEventAction) {
      return _reduceSfuEvent(state, action.event);
    }
    return state;
  }

  CallState _reduceSfuEvent(CallState state, SfuEvent event) {
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

  CallState _reduceJoinResponse(
    CallState state,
    SfuJoinResponseEvent event,
  ) {
    _logger.d(() => '[reduceJoinResponse] ${state.sessionId}; event: $event');
    final participants = event.callState.participants.map((aParticipant) {
      final isLocal = aParticipant.userId == state.currentUserId;
      final existing = state.callParticipants.firstWhereOrNull(
        (it) => it.userId == aParticipant.userId,
      );
      final existingName = existing?.name ?? '';
      final existingRole = existing?.role ?? '';
      final existingImage = existing?.image ?? '';
      return CallParticipantState(
        userId: aParticipant.userId,
        role: existingRole,
        name: aParticipant.userName.ifEmpty(() => existingName),
        image: aParticipant.userImage.ifEmpty(() => existingImage),
        sessionId: aParticipant.sessionId,
        trackIdPrefix: aParticipant.trackLookupPrefix,
        publishedTracks: {
          for (final track in aParticipant.publishedTracks)
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

  CallState _reduceTrackUnpublished(
    CallState state,
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

          return participant.copyWith(
            publishedTracks: {
              ...participant.publishedTracks,
              if (trackState != null) event.trackType: trackState,
            },
          );
        }

        return participant;
      }).toList(),
    );
  }

  CallState _reduceTrackPublished(
    CallState state,
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

  CallState _reduceAudioLevelChanged(
    CallState state,
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

  CallState _reduceDominantSpeakerChanged(
    CallState state,
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

  CallState _reduceConnectionQualityChanged(
    CallState state,
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

  CallState _reduceParticipantJoined(
    CallState state,
    SfuParticipantJoinedEvent event,
  ) {
    _logger.d(
      () => '[reduceParticipantJoined] ${state.sessionId}; event: $event',
    );
    final isLocal = state.currentUserId == event.participant.userId;
    final participant = CallParticipantState(
      userId: event.participant.userId,
      role: '',
      name: event.participant.userName,
      image: event.participant.userImage,
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

  CallState _reduceParticipantLeft(
    CallState state,
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
}
