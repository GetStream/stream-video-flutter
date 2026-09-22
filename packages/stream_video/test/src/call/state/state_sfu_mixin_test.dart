import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_audio_level.dart';
import 'package:stream_video/src/sfu/data/models/sfu_connection_info.dart';
import 'package:stream_video/src/sfu/data/models/sfu_inbound_video_state.dart';
import 'package:stream_video/src/sfu/data/models/sfu_participant.dart';
import 'package:stream_video/src/sfu/data/models/sfu_pin.dart';
import 'package:stream_video/stream_video.dart';

CallParticipantState _participant({
  required String userId,
  bool isSpeaking = false,
  bool isDominantSpeaker = false,
  SfuConnectionQuality connectionQuality = SfuConnectionQuality.unspecified,
}) {
  return CallParticipantState(
    userId: userId,
    roles: const [],
    name: userId,
    custom: const {},
    sessionId: '$userId-session',
    trackIdPrefix: '$userId-prefix',
    isSpeaking: isSpeaking,
    isDominantSpeaker: isDominantSpeaker,
    connectionQuality: connectionQuality,
  );
}

SfuParticipant _sfuParticipant({
  required String userId,
  bool isSpeaking = false,
  double audioLevel = 0,
  String? userName,
  SfuConnectionQuality connectionQuality = SfuConnectionQuality.unspecified,
}) {
  return SfuParticipant(
    userId: userId,
    userName: userName ?? userId,
    userImage: '',
    sessionId: '$userId-session',
    custom: const <String, Object?>{},
    customData: const <String, Object?>{},
    publishedTracks: const <SfuTrackType>[],
    joinedAt: DateTime.utc(2026),
    trackLookupPrefix: '$userId-prefix',
    connectionQuality: connectionQuality,
    isSpeaking: isSpeaking,
    isDominantSpeaker: false,
    audioLevel: audioLevel,
    roles: const <String>[],
    participantSource: SfuParticipantSource.webrtc,
  );
}

CallStateNotifier _notifier(List<CallParticipantState> participants) {
  final callState = CallState(
    callCid: StreamCallCid.from(
      type: StreamCallType.defaultType(),
      id: 'id',
    ),
    currentUserId: 'userId',
    preferences: DefaultCallPreferences(),
  ).copyWith(callParticipants: participants);

  return CallStateNotifier(callState);
}

void main() {
  group('sfuUpdateAudioLevelChanged', () {
    test('does not emit when every participant stays silent', () async {
      final notifier = _notifier([_participant(userId: 'alice')]);
      final before = notifier.callState.callParticipants;

      notifier.sfuUpdateAudioLevelChanged(
        const SfuAudioLevelChangedEvent(
          audioLevels: [
            SfuAudioLevel(
              userId: 'alice',
              sessionId: 'alice-session',
              level: 0.2,
              isSpeaking: false,
            ),
          ],
        ),
      );

      expect(identical(notifier.callState.callParticipants, before), isTrue);
    });

    test('emits when a participant starts speaking', () async {
      final notifier = _notifier([_participant(userId: 'alice')]);

      notifier.sfuUpdateAudioLevelChanged(
        const SfuAudioLevelChangedEvent(
          audioLevels: [
            SfuAudioLevel(
              userId: 'alice',
              sessionId: 'alice-session',
              level: 0.8,
              isSpeaking: true,
            ),
          ],
        ),
      );

      final alice = notifier.callState.callParticipants.single;
      expect(alice.isSpeaking, isTrue);
      expect(alice.audioLevel, 0.8);
    });

    test('keeps untouched participants identical', () async {
      final notifier = _notifier([
        _participant(userId: 'alice'),
        _participant(userId: 'bob'),
      ]);
      final bobBefore = notifier.callState.callParticipants[1];

      notifier.sfuUpdateAudioLevelChanged(
        const SfuAudioLevelChangedEvent(
          audioLevels: [
            SfuAudioLevel(
              userId: 'alice',
              sessionId: 'alice-session',
              level: 0.8,
              isSpeaking: true,
            ),
          ],
        ),
      );

      expect(
        identical(notifier.callState.callParticipants[1], bobBefore),
        isTrue,
      );
    });

    test(
      'does not share the audio level history with the previous state',
      () async {
        final notifier = _notifier([_participant(userId: 'alice')]);
        final before = notifier.callState.callParticipants.single;
        final levelsBefore = [...before.audioLevels];

        notifier.sfuUpdateAudioLevelChanged(
          const SfuAudioLevelChangedEvent(
            audioLevels: [
              SfuAudioLevel(
                userId: 'alice',
                sessionId: 'alice-session',
                level: 0.8,
                isSpeaking: true,
              ),
            ],
          ),
        );

        expect(before.audioLevels, levelsBefore);
        expect(
          notifier.callState.callParticipants.single.audioLevels,
          [...levelsBefore, 0.8],
        );
      },
    );
  });

  group('sfuConnectionQualityChanged', () {
    test('does not emit when the quality is unchanged', () async {
      final notifier = _notifier([
        _participant(
          userId: 'alice',
          connectionQuality: SfuConnectionQuality.good,
        ),
      ]);
      final before = notifier.callState.callParticipants;

      notifier.sfuConnectionQualityChanged(
        const SfuConnectionQualityChangedEvent(
          connectionQualityUpdates: [
            SfuConnectionQualityInfo(
              userId: 'alice',
              sessionId: 'alice-session',
              connectionQuality: SfuConnectionQuality.good,
            ),
          ],
        ),
      );

      expect(identical(notifier.callState.callParticipants, before), isTrue);
    });

    test('emits when the quality changes', () async {
      final notifier = _notifier([
        _participant(
          userId: 'alice',
          connectionQuality: SfuConnectionQuality.good,
        ),
      ]);

      notifier.sfuConnectionQualityChanged(
        const SfuConnectionQualityChangedEvent(
          connectionQualityUpdates: [
            SfuConnectionQualityInfo(
              userId: 'alice',
              sessionId: 'alice-session',
              connectionQuality: SfuConnectionQuality.poor,
            ),
          ],
        ),
      );

      expect(
        notifier.callState.callParticipants.single.connectionQuality,
        SfuConnectionQuality.poor,
      );
    });
  });

  group('sfuDominantSpeakerChanged', () {
    test('does not emit when the dominant speaker is unchanged', () async {
      final notifier = _notifier([
        _participant(userId: 'alice', isDominantSpeaker: true),
        _participant(userId: 'bob'),
      ]);
      final before = notifier.callState.callParticipants;

      notifier.sfuDominantSpeakerChanged(
        const SfuDominantSpeakerChangedEvent(
          userId: 'alice',
          sessionId: 'alice-session',
        ),
      );

      expect(identical(notifier.callState.callParticipants, before), isTrue);
    });

    test('moves the flag when the dominant speaker changes', () async {
      final notifier = _notifier([
        _participant(userId: 'alice', isDominantSpeaker: true),
        _participant(userId: 'bob'),
      ]);

      notifier.sfuDominantSpeakerChanged(
        const SfuDominantSpeakerChangedEvent(
          userId: 'bob',
          sessionId: 'bob-session',
        ),
      );

      final participants = notifier.callState.callParticipants;
      expect(participants[0].isDominantSpeaker, isFalse);
      expect(participants[1].isDominantSpeaker, isTrue);
    });
  });

  group('sfuDominantSpeakerChanged with a stale flag', () {
    test('clears a second flagged participant even when the event matches '
        'the first', () {
      final notifier = _notifier([
        _participant(userId: 'alice', isDominantSpeaker: true),
        _participant(userId: 'bob', isDominantSpeaker: true),
      ]);

      notifier.sfuDominantSpeakerChanged(
        const SfuDominantSpeakerChangedEvent(
          userId: 'alice',
          sessionId: 'alice-session',
        ),
      );

      expect(
        notifier.callState.callParticipants
            .where((it) => it.isDominantSpeaker)
            .map((it) => it.userId),
        ['alice'],
      );
    });
  });

  group('sfuInboundStateNotification', () {
    SfuInboundVideoState inbound(
      String userId,
      SfuTrackType trackType, {
      required bool paused,
    }) {
      return SfuInboundVideoState(
        userId: userId,
        sessionId: '$userId-session',
        trackType: trackType,
        paused: paused,
      );
    }

    test('applies several track states for one participant', () {
      final notifier = _notifier([_participant(userId: 'alice')]);

      notifier.sfuInboundStateNotification(
        SfuInboundStateNotificationEvent(
          inboundVideoStates: [
            inbound('alice', SfuTrackType.video, paused: true),
            inbound('alice', SfuTrackType.screenShare, paused: true),
          ],
        ),
      );

      expect(
        notifier.callState.callParticipants.single.pausedTracks,
        {SfuTrackType.video, SfuTrackType.screenShare},
      );
    });

    test('unpauses on the round trip', () {
      final notifier = _notifier([_participant(userId: 'alice')]);

      notifier.sfuInboundStateNotification(
        SfuInboundStateNotificationEvent(
          inboundVideoStates: [
            inbound('alice', SfuTrackType.video, paused: true),
          ],
        ),
      );
      expect(notifier.callState.callParticipants.single.pausedTracks, {
        SfuTrackType.video,
      });

      notifier.sfuInboundStateNotification(
        SfuInboundStateNotificationEvent(
          inboundVideoStates: [
            inbound('alice', SfuTrackType.video, paused: false),
          ],
        ),
      );
      expect(
        notifier.callState.callParticipants.single.pausedTracks,
        isEmpty,
        reason: 'a track must not stay flagged paused',
      );
    });

    test('does not emit when the paused set is unchanged', () {
      final notifier = _notifier([_participant(userId: 'alice')]);

      notifier.sfuInboundStateNotification(
        SfuInboundStateNotificationEvent(
          inboundVideoStates: [
            inbound('alice', SfuTrackType.video, paused: true),
          ],
        ),
      );
      final before = notifier.callState.callParticipants;

      notifier.sfuInboundStateNotification(
        SfuInboundStateNotificationEvent(
          inboundVideoStates: [
            inbound('alice', SfuTrackType.video, paused: true),
          ],
        ),
      );

      expect(identical(notifier.callState.callParticipants, before), isTrue);
    });

    test('leaves participants the event does not mention alone', () {
      final notifier = _notifier([
        _participant(userId: 'alice'),
        _participant(userId: 'bob'),
      ]);
      final bobBefore = notifier.callState.callParticipants[1];

      notifier.sfuInboundStateNotification(
        SfuInboundStateNotificationEvent(
          inboundVideoStates: [
            inbound('alice', SfuTrackType.video, paused: true),
          ],
        ),
      );

      expect(
        identical(notifier.callState.callParticipants[1], bobBefore),
        isTrue,
      );
    });
  });

  group('sfuPinsUpdated', () {
    test('keeps the original pinnedAt for an already pinned participant', () {
      final notifier = _notifier([_participant(userId: 'alice')]);
      const pin = SfuPin(userId: 'alice', sessionId: 'alice-session');

      notifier.sfuPinsUpdated([pin]);
      final first = notifier.callState.callParticipants.single;
      expect(first.pin, isNotNull);

      notifier.sfuPinsUpdated([pin]);

      expect(
        notifier.callState.callParticipants.single.pin!.pinnedAt,
        first.pin!.pinnedAt,
        reason: 'pinnedAt orders pinned participants, so it must not move',
      );
    });

    test('does not emit when the pins are unchanged', () {
      final notifier = _notifier([_participant(userId: 'alice')]);
      const pin = SfuPin(userId: 'alice', sessionId: 'alice-session');

      notifier.sfuPinsUpdated([pin]);
      final before = notifier.callState.callParticipants;

      notifier.sfuPinsUpdated([pin]);

      expect(identical(notifier.callState.callParticipants, before), isTrue);
    });

    test('clears a server pin that is no longer sent', () {
      final notifier = _notifier([_participant(userId: 'alice')]);

      notifier.sfuPinsUpdated([
        const SfuPin(userId: 'alice', sessionId: 'alice-session'),
      ]);
      expect(notifier.callState.callParticipants.single.pin, isNotNull);

      notifier.sfuPinsUpdated([]);
      expect(notifier.callState.callParticipants.single.pin, isNull);
    });
  });

  group('audioLevels', () {
    test('cannot be mutated through the participant', () {
      final participant = _participant(userId: 'alice');

      expect(
        () => participant.audioLevels.add(0.5),
        throwsUnsupportedError,
        reason: 'identity checks rely on collections never changing in place',
      );
    });

    test('stays unmodifiable after an audio level update', () {
      final notifier = _notifier([_participant(userId: 'alice')]);

      notifier.sfuUpdateAudioLevelChanged(
        const SfuAudioLevelChangedEvent(
          audioLevels: [
            SfuAudioLevel(
              userId: 'alice',
              sessionId: 'alice-session',
              level: 0.8,
              isSpeaking: true,
            ),
          ],
        ),
      );

      expect(
        () => notifier.callState.callParticipants.single.audioLevels.add(0.1),
        throwsUnsupportedError,
      );
    });
  });

  group('guard regressions', () {
    test('applies the event that takes a speaker below the threshold', () {
      final notifier = _notifier([
        _participant(userId: 'alice', isSpeaking: true),
      ]);
      final before = notifier.callState.callParticipants;

      notifier.sfuUpdateAudioLevelChanged(
        const SfuAudioLevelChangedEvent(
          audioLevels: [
            SfuAudioLevel(
              userId: 'alice',
              sessionId: 'alice-session',
              level: 0.05,
              isSpeaking: false,
            ),
          ],
        ),
      );

      final alice = notifier.callState.callParticipants.single;
      expect(
        alice.isSpeaking,
        isFalse,
        reason:
            'a speaker falling silent must still be written through, or '
            'every speaking indicator latches on for the rest of the call',
      );
      expect(alice.audioLevel, 0.05);
      expect(identical(notifier.callState.callParticipants, before), isFalse);
    });

    test('keeps a local pin when the server sends its pins', () {
      final notifier = _notifier([_participant(userId: 'alice')]);
      notifier.setParticipantPinned(
        sessionId: 'alice-session',
        userId: 'alice',
        pinned: true,
      );
      final pinned = notifier.callState.callParticipants.single;
      expect(pinned.pin!.isLocalPin, isTrue);

      notifier.sfuPinsUpdated([]);

      expect(
        notifier.callState.callParticipants.single.pin,
        isNotNull,
        reason: "a pin the user placed is not the server's to clear",
      );
    });

    test('an unspecified quality does not downgrade a known one', () {
      final notifier = _notifier([
        _participant(
          userId: 'alice',
          connectionQuality: SfuConnectionQuality.good,
        ),
      ]);
      final before = notifier.callState.callParticipants;

      notifier.sfuConnectionQualityChanged(
        const SfuConnectionQualityChangedEvent(
          connectionQualityUpdates: [
            SfuConnectionQualityInfo(
              userId: 'alice',
              sessionId: 'alice-session',
              connectionQuality: SfuConnectionQuality.unspecified,
            ),
          ],
        ),
      );

      expect(
        notifier.callState.callParticipants.single.connectionQuality,
        SfuConnectionQuality.good,
      );
      expect(identical(notifier.callState.callParticipants, before), isTrue);
    });

    test('a no-op event does not push a new call state', () async {
      final notifier = _notifier([_participant(userId: 'alice')]);

      final seen = <CallState>[];
      final sub = notifier.callStateStream.listen(seen.add);
      await Future<void>.delayed(Duration.zero);
      seen.clear();

      notifier.sfuUpdateAudioLevelChanged(
        const SfuAudioLevelChangedEvent(
          audioLevels: [
            SfuAudioLevel(
              userId: 'alice',
              sessionId: 'alice-session',
              level: 0.2,
              isSpeaking: false,
            ),
          ],
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        seen,
        isEmpty,
        reason:
            'the call state is written unconditionally, so an identical '
            'participant list is not enough to prove nothing was re-emitted',
      );

      await sub.cancel();
    });
  });

  group('sfuParticipantUpdated', () {
    test('holds the audio level of a participant who is still silent', () {
      // `image` matches what the event carries, so the only thing this event
      // could change is the audio level.
      var alice = _participant(
        userId: 'alice',
        isSpeaking: true,
      ).copyWith(image: '');
      alice = alice.copyWithUpdatedAudioLevels(audioLevel: 0.4);
      // The reading that took her below the threshold.
      alice = alice.copyWithUpdatedAudioLevels(
        audioLevel: 0.05,
        isSpeaking: false,
      );

      final notifier = _notifier([alice]);
      final before = notifier.callState.callParticipants.single;

      notifier.sfuParticipantUpdated(
        SfuParticipantUpdatedEvent(
          callCid: notifier.callState.callCid.value,
          participant: _sfuParticipant(userId: 'alice', audioLevel: 0.01),
        ),
      );

      final after = notifier.callState.callParticipants.single;
      expect(
        after.audioLevel,
        0.05,
        reason:
            'the hold-while-silent rule has to hold on both paths that write '
            'audio levels, not just on sfuUpdateAudioLevelChanged',
      );
      expect(after.audioLevels, before.audioLevels);
      expect(
        identical(after, before),
        isTrue,
        reason: 'an event that changes nothing keeps the instance',
      );
    });

    test('advances the audio level once the participant speaks again', () {
      final notifier = _notifier([_participant(userId: 'alice')]);

      notifier.sfuParticipantUpdated(
        SfuParticipantUpdatedEvent(
          callCid: notifier.callState.callCid.value,
          participant: _sfuParticipant(
            userId: 'alice',
            isSpeaking: true,
            audioLevel: 0.7,
          ),
        ),
      );

      final after = notifier.callState.callParticipants.single;
      expect(after.audioLevel, 0.7);
      expect(after.audioLevels, [0.0, 0.7]);
      expect(after.isSpeaking, isTrue);
    });

    test('still writes the participant through when a field changed', () {
      final notifier = _notifier([_participant(userId: 'alice')]);

      notifier.sfuParticipantUpdated(
        SfuParticipantUpdatedEvent(
          callCid: notifier.callState.callCid.value,
          participant: _sfuParticipant(userId: 'alice', userName: 'Alice B.'),
        ),
      );

      expect(notifier.callState.callParticipants.single.name, 'Alice B.');
    });

    test('leaves the other participants on their own instances', () {
      final notifier = _notifier([
        _participant(userId: 'alice'),
        _participant(userId: 'bob'),
      ]);
      final bobBefore = notifier.callState.callParticipants[1];

      notifier.sfuParticipantUpdated(
        SfuParticipantUpdatedEvent(
          callCid: notifier.callState.callCid.value,
          participant: _sfuParticipant(userId: 'alice', userName: 'Alice B.'),
        ),
      );

      expect(
        identical(notifier.callState.callParticipants[1], bobBefore),
        isTrue,
      );
    });
  });

  group('CallParticipantState audio level sealing', () {
    test('a copy that leaves audio alone shares the level list', () {
      final alice = _participant(
        userId: 'alice',
      ).copyWithUpdatedAudioLevels(audioLevel: 0.4, isSpeaking: true);

      final repinned = alice.copyWith(isDominantSpeaker: true);

      expect(
        identical(repinned.audioLevels, alice.audioLevels),
        isTrue,
        reason:
            'the list is already sealed over a list nothing outside can reach, '
            'so re-copying it on every unrelated copyWith is pure waste',
      );
    });

    test('a level update does not share history with the previous copy', () {
      final alice = _participant(
        userId: 'alice',
      ).copyWithUpdatedAudioLevels(audioLevel: 0.4, isSpeaking: true);

      final next = alice.copyWithUpdatedAudioLevels(
        audioLevel: 0.6,
        isSpeaking: true,
      );

      expect(alice.audioLevels, [0.0, 0.4]);
      expect(next.audioLevels, [0.0, 0.4, 0.6]);
      expect(identical(next.audioLevels, alice.audioLevels), isFalse);
    });

    test('a sealed list is still unmodifiable', () {
      final alice = _participant(
        userId: 'alice',
      ).copyWithUpdatedAudioLevels(audioLevel: 0.4, isSpeaking: true);

      expect(() => alice.audioLevels.add(0.5), throwsUnsupportedError);
      expect(
        () => alice.copyWith(isLocal: true).audioLevels.add(0.5),
        throwsUnsupportedError,
      );
    });
  });

  group('CallParticipantState.audioLevels', () {
    test('keeps only the last 10 levels, newest last', () {
      var participant = _participant(userId: 'alice');
      for (var i = 1; i <= 12; i++) {
        participant = participant.copyWithUpdatedAudioLevels(
          audioLevel: i / 100,
          isSpeaking: true,
        );
      }

      expect(participant.audioLevels, hasLength(10));
      expect(participant.audioLevels.last, 0.12);
      expect(participant.audioLevels.first, 0.03);
    });

    test('cannot be mutated through an unmodifiable view of a live list', () {
      final backing = <double>[0.1];
      final participant = _participant(
        userId: 'alice',
      ).copyWith(audioLevels: UnmodifiableListView(backing));

      backing.add(0.9);

      expect(
        participant.audioLevels,
        [0.1],
        reason:
            'an unmodifiable view still writes through to the list it was '
            'built over, so it cannot be trusted as already sealed',
      );
    });

    test('cannot be mutated through the list handed to the constructor', () {
      final levels = <double>[0.1];
      final participant = _participant(
        userId: 'alice',
      ).copyWith(audioLevels: levels);

      levels.add(0.9);

      expect(
        participant.audioLevels,
        [0.1],
        reason:
            'the state copies, so a caller keeping the list cannot write '
            'through it and leave identity unchanged',
      );
    });
  });
}
