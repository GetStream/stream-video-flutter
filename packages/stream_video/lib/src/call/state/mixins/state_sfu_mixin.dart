import 'package:collection/collection.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../../stream_video.dart';
import '../../../models/call_participant_pin.dart';
import '../../../sfu/data/events/sfu_events.dart';
import '../../../sfu/data/models/sfu_inbound_video_state.dart';
import '../../../sfu/data/models/sfu_pin.dart';
import '../../../sfu/sfu_extensions.dart';
import 'state_pending_tracks_mixin.dart';

final _logger = taggedLogger(tag: 'SV:CallState:Sfu');

/// Keys a participant for lookup within one event.
///
/// `userId` alone is not unique — a user can be in the call from several
/// devices — so the session is part of the key.
String _participantKey(String userId, String sessionId) => '$userId:$sessionId';

mixin StateSfuMixin on StateNotifier<CallState>, StatePendingTracksMixin {
  /// Rewrites the participant list through [update], writing the state only if
  /// some participant came back a different instance.
  ///
  /// [update] returns the participant it was given to mean "nothing to do".
  void _updateParticipants(
    CallParticipantState Function(CallParticipantState participant) update,
  ) {
    final participants = state.callParticipants;
    List<CallParticipantState>? updated;

    for (var index = 0; index < participants.length; index++) {
      final participant = participants[index];
      final next = update(participant);
      if (identical(next, participant)) continue;

      updated ??= [...participants];
      updated[index] = next;
    }

    if (updated == null) return;

    state = state.copyWith(callParticipants: updated);
  }

  void sfuParticipantLeft(
    SfuParticipantLeftEvent event,
  ) {
    _logger.d(() => '[sfuParticipantLeft] ${state.sessionId}; event: $event');
    final callParticipants = [...state.callParticipants]
      ..removeWhere(
        (participant) =>
            participant.userId == event.participant.userId &&
            participant.sessionId == event.participant.sessionId,
      );

    state = state.copyWith(
      callParticipants: callParticipants,
    );

    clearPendingTracks(event.participant.trackLookupPrefix);
  }

  /// Replaces the participant list with the one the SFU states on a join.
  ///
  /// [subscriberReused] is what a fast reconnect passes: it kept the subscriber
  /// peer connection, so remote media never stopped arriving and the tracks
  /// already being received stay that way. A rejoin builds a new subscriber and
  /// leaves it false, which blanks the renderers until the media lands again.
  void sfuJoinResponse(
    SfuJoinResponseEvent event, {
    bool subscriberReused = false,
  }) {
    _logger.d(
      () =>
          '[sfuJoinResponse] ${state.sessionId}; '
          'subscriberReused: $subscriberReused; event: $event',
    );
    final participants = event.callState.participants
        .map(
          (sfuParticipant) => sfuParticipant.toParticipantState(
            state,
            subscriberReused: subscriberReused,
          ),
        )
        .toList();

    state = state.copyWith(
      callParticipants: participants,
    );
  }

  void sfuCallEnded(
    SfuCallEndedEvent event,
  ) {
    _logger.d(() => '[sfuCallEnded] ${state.sessionId}; event: $event');

    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.ended(),
      ),
      callParticipants: const [],
    );
  }

  void sfuTrackUnpublished(
    SfuTrackUnpublishedEvent event,
  ) {
    _logger.d(
      () => '[sfuTrackUnpublished] ${state.sessionId}; event: $event',
    );
    state = state.copyWith(
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
            pausedTracks: participant.pausedTracks
                .toList()
                .where((track) => track != event.trackType)
                .toSet(),
          );
        }

        return participant;
      }).toList(),
    );
  }

  void sfuTrackPublished(
    SfuTrackPublishedEvent event,
  ) {
    _logger.d(() => '[sfuTrackPublished] ${state.sessionId}; event: $event');

    final participant = state.callParticipants.firstWhereOrNull(
      (p) => p.userId == event.userId && p.sessionId == event.sessionId,
    );

    if (participant == null) {
      addPendingTrack(
        event.participant.trackLookupPrefix,
        event.trackType,
      );
      return;
    }

    final trackState =
        participant.publishedTracks[event.trackType]?.copyWith(
          muted: false,
        ) ??
        TrackState.base(isLocal: participant.isLocal);

    state = state.copyWith(
      callParticipants: state.callParticipants.map((p) {
        if (p.userId == event.userId && p.sessionId == event.sessionId) {
          _logger.v(() => '[sfuTrackPublished] pFound: $p');
          return p.copyWith(
            publishedTracks: {
              ...p.publishedTracks,
              event.trackType: trackState,
            },
          );
        } else {
          return p;
        }
      }).toList(),
    );
  }

  void sfuUpdateAudioLevelChanged(
    SfuAudioLevelChangedEvent event,
  ) {
    if (event.audioLevels.isEmpty) return;

    final levelsByParticipant = {
      for (final level in event.audioLevels)
        _participantKey(level.userId, level.sessionId): level,
    };

    _updateParticipants((participant) {
      final levelInfo =
          levelsByParticipant[_participantKey(
            participant.userId,
            participant.sessionId,
          )];

      // A participant the event does not mention, or who was silent and still
      // is, keeps their existing instance. The event that takes them below the
      // speaking threshold is still applied, so their `audioLevel` and
      // `audioLevels` hold at that reading until they speak again.
      if (levelInfo == null ||
          (!levelInfo.isSpeaking && !participant.isSpeaking)) {
        return participant;
      }

      return participant.copyWithUpdatedAudioLevels(
        audioLevel: levelInfo.level,
        isSpeaking: levelInfo.isSpeaking,
      );
    });
  }

  void sfuDominantSpeakerChanged(
    SfuDominantSpeakerChangedEvent event,
  ) {
    _logger.d(
      () => '[sfuDominantSpeakerChanged] ${state.sessionId}; event: $event',
    );

    _updateParticipants((participant) {
      // Every participant is checked, not just the one the event names:
      // nothing stops two carrying the flag, since `sfuJoinResponse` and
      // `sfuParticipantUpdated` both take it straight off the wire.
      final isDominantSpeaker =
          participant.userId == event.userId &&
          participant.sessionId == event.sessionId;

      if (isDominantSpeaker == participant.isDominantSpeaker) {
        return participant;
      }

      return participant.copyWith(isDominantSpeaker: isDominantSpeaker);
    });
  }

  /// Records whether the SFU considers this call end-to-end encrypted.
  void sfuE2eeEnabledUpdated(bool isE2eeEnabled) {
    state = state.copyWith(isE2eeEnabled: isE2eeEnabled);
  }

  void sfuPinsUpdated(
    List<SfuPin> pins,
  ) {
    final pinnedKeys = {
      for (final pin in pins) _participantKey(pin.userId, pin.sessionId),
    };

    _updateParticipants((participant) {
      final isPinned = pinnedKeys.contains(
        _participantKey(participant.userId, participant.sessionId),
      );
      final serverPin = participant.pin != null && !participant.pin!.isLocalPin;

      if (isPinned) {
        // `pinnedAt` orders pinned participants, so an already-pinned one keeps
        // the time it was pinned at.
        if (serverPin) return participant;

        return participant.copyWithPin(
          participantPin: CallParticipantPin(
            isLocalPin: false,
            pinnedAt: DateTime.now(),
          ),
        );
      }

      if (serverPin) return participant.copyWithPin(participantPin: null);

      return participant;
    });
  }

  void sfuConnectionQualityChanged(
    SfuConnectionQualityChangedEvent event,
  ) {
    if (event.connectionQualityUpdates.isEmpty) return;

    final updatesByParticipant = {
      for (final update in event.connectionQualityUpdates)
        _participantKey(update.userId, update.sessionId): update,
    };

    _updateParticipants((participant) {
      final update =
          updatesByParticipant[_participantKey(
            participant.userId,
            participant.sessionId,
          )];
      if (update == null) return participant;

      final quality = update.connectionQuality.mergeWithPrevious(
        participant.connectionQuality,
      );
      if (quality == participant.connectionQuality) return participant;

      return participant.copyWith(connectionQuality: quality);
    });
  }

  void sfuParticipantJoined(
    SfuParticipantJoinedEvent event,
  ) {
    _logger.d(
      () => '[sfuParticipantJoined] ${state.sessionId}; event: $event',
    );
    final isLocal =
        state.currentUserId == event.participant.userId &&
        state.sessionId == event.participant.sessionId;

    final participant = CallParticipantState(
      userId: event.participant.userId,
      roles: event.participant.roles,
      name: event.participant.userName,
      custom: event.participant.custom,
      customData: event.participant.customData,
      image: event.participant.userImage,
      sessionId: event.participant.sessionId,
      trackIdPrefix: event.participant.trackLookupPrefix,
      publishedTracks:
          consumePendingTracks(event.participant.trackLookupPrefix) ?? {},
      isLocal: isLocal,
      isOnline: !isLocal,
      pin: event.isPinned
          ? CallParticipantPin(isLocalPin: false, pinnedAt: DateTime.now())
          : null,
    );

    var isExisting = false;
    final participants = state.callParticipants.map((it) {
      if (it.userId == participant.userId &&
          it.sessionId == participant.sessionId) {
        isExisting = true;
        return participant;
      } else {
        return it;
      }
    });

    state = state.copyWith(
      callParticipants: [
        ...participants,
        if (!isExisting) participant,
      ],
    );
  }

  void sfuParticipantUpdated(
    SfuParticipantUpdatedEvent event,
  ) {
    _logger.d(
      () => '[sfuParticipantUpdated] ${state.sessionId}; event: $event',
    );
    final participant = event.participant;

    final isKnown = state.callParticipants.any(
      (it) =>
          it.userId == participant.userId &&
          it.sessionId == participant.sessionId,
    );
    if (!isKnown) {
      _logger.w(
        () =>
            '[sfuParticipantUpdated] dropped, unknown participant '
            '${participant.userId}/${participant.sessionId}',
      );
      return;
    }

    _updateParticipants((it) {
      if (it.userId != participant.userId ||
          it.sessionId != participant.sessionId) {
        return it;
      }

      final updated = it.copyWith(
        name: participant.userName,
        custom: participant.custom,
        customData: participant.customData,
        image: participant.userImage,
        trackIdPrefix: participant.trackLookupPrefix,
        isSpeaking: participant.isSpeaking,
        isDominantSpeaker: participant.isDominantSpeaker,
        connectionQuality: participant.connectionQuality.mergeWithPrevious(
          it.connectionQuality,
        ),
        roles: participant.roles,
      );

      // Same rule as `sfuUpdateAudioLevelChanged`: a participant who was
      // silent and still is keeps the reading that took them below the
      // speaking threshold, so the two paths that write audio levels agree.
      // Without this, a `ParticipantUpdated` would advance the levels this
      // handler's counterpart deliberately holds.
      if (!participant.isSpeaking && !it.isSpeaking) {
        return updated == it ? it : updated;
      }

      return updated.copyWithUpdatedAudioLevels(
        audioLevel: participant.audioLevel,
      );
    });
  }

  void sfuInboundStateNotification(SfuInboundStateNotificationEvent event) {
    _logger.d(
      () => '[sfuInboundStateNotification] ${state.sessionId}; event: $event',
    );

    if (event.inboundVideoStates.isEmpty) return;

    final statesByParticipant = <String, List<SfuInboundVideoState>>{};
    for (final inboundState in event.inboundVideoStates) {
      statesByParticipant
          .putIfAbsent(
            _participantKey(inboundState.userId, inboundState.sessionId),
            () => [],
          )
          .add(inboundState);
    }

    _updateParticipants((participant) {
      final inboundStates =
          statesByParticipant[_participantKey(
            participant.userId,
            participant.sessionId,
          )];

      if (inboundStates == null) {
        return participant;
      }

      final pausedTracks = {...participant.pausedTracks};
      for (final inboundState in inboundStates) {
        if (inboundState.paused) {
          pausedTracks.add(inboundState.trackType);
        } else {
          pausedTracks.remove(inboundState.trackType);
        }
      }

      if (const SetEquality<SfuTrackType>().equals(
        pausedTracks,
        participant.pausedTracks,
      )) {
        return participant;
      }

      return participant.copyWith(
        pausedTracks: pausedTracks,
      );
    });
  }
}
