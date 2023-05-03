import 'package:collection/collection.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../call_state.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../models/call_participant_state.dart';
import '../../../models/call_status.dart';
import '../../../models/call_track_state.dart';
import '../../../models/disconnect_reason.dart';
import '../../../sfu/data/events/sfu_events.dart';
import '../../../utils/string.dart';

final _logger = taggedLogger(tag: 'SV:CoordReducer');

mixin StateSfuMixin on StateNotifier<CallState> {
  void sfuJoinResponse(
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

    state = state.copyWith(
      callParticipants: participants,
    );
  }

  void sfuTrackUnpublished(
    SfuTrackUnpublishedEvent event,
  ) {
    _logger.d(
      () => '[reduceTrackUnpublished] ${state.sessionId}; event: $event',
    );
    state = state.copyWith(
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

  void sfuTrackPublished(
    SfuTrackPublishedEvent event,
  ) {
    _logger.d(() => '[reduceTrackPublished] ${state.sessionId}; event: $event');

    state = state.copyWith(
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

  void sfuUpdateAudioLevelChanged(
    SfuAudioLevelChangedEvent event,
  ) {
    state = state.copyWith(
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

  void sfuDominantSpeakerChanged(
    SfuDominantSpeakerChangedEvent event,
  ) {
    state = state.copyWith(
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

  void sfuConnectionQualityChanged(
    SfuConnectionQualityChangedEvent event,
  ) {
    state = state.copyWith(
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

  void sfuParticipantJoined(
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
    state = state.copyWith(
      callParticipants: [
        ...state.callParticipants,
        participant,
      ],
    );
  }
}
