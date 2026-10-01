import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_audio_level.dart';
import 'package:stream_video/src/sfu/data/models/sfu_call_state.dart';
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
  String? sessionId,
  List<SfuTrackType> publishedTracks = const [],
  SfuConnectionQuality connectionQuality = SfuConnectionQuality.unspecified,
}) {
  return SfuParticipant(
    userId: userId,
    userName: userName ?? userId,
    userImage: '',
    sessionId: sessionId ?? '$userId-session',
    custom: const <String, Object?>{},
    customData: const <String, Object?>{},
    publishedTracks: publishedTracks,
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

/// The states [notifier] pushes while [act] runs.
Future<List<CallState>> _emissionsDuring(
  CallStateNotifier notifier,
  void Function() act,
) async {
  final seen = <CallState>[];
  final sub = notifier.callStateStream.valueStream.listen(seen.add);
  await Future<void>.delayed(Duration.zero);
  seen.clear();

  act();
  await Future<void>.delayed(Duration.zero);

  await sub.cancel();
  return seen;
}

/// The same user from two devices, so a test can check that only the session
/// an event names is touched.
List<CallParticipantState> _twoDevices() => [
  _participant(userId: 'alice'),
  _participant(userId: 'alice').copyWith(
    sessionId: 'alice-tablet',
    trackIdPrefix: 'alice-tablet-prefix',
  ),
];

SfuJoinResponseEvent _joinResponse(List<SfuParticipant> participants) {
  return SfuJoinResponseEvent(
    callState: SfuCallState(
      participants: participants,
      participantCount: SfuParticipantCount(
        total: participants.length,
        anonymous: 0,
      ),
      startedAt: DateTime.utc(2026),
      pins: const [],
      e2eeEnabled: false,
    ),
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
      final sub = notifier.callStateStream.valueStream.listen(seen.add);
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

  group('sfuJoinResponse', () {
    test('replaces the list with what the SFU sent', () {
      final notifier = _notifier([
        _participant(userId: 'alice'),
        _participant(userId: 'bob'),
      ]);

      notifier.sfuJoinResponse(
        _joinResponse([
          _sfuParticipant(userId: 'bob'),
          _sfuParticipant(userId: 'carol'),
        ]),
      );
      expect(
        notifier.callState.callParticipants.map((it) => it.userId),
        ['bob', 'carol'],
      );

      notifier.sfuJoinResponse(_joinResponse([]));
      expect(notifier.callState.callParticipants, isEmpty);
    });

    test('carries over what the state holds for a user, to every session', () {
      final notifier = _notifier([
        _participant(
          userId: 'alice',
          connectionQuality: SfuConnectionQuality.good,
        ).copyWith(name: 'Alice', image: 'alice.png', roles: ['host']),
      ]);

      notifier.sfuJoinResponse(
        _joinResponse([
          _sfuParticipant(userId: 'alice', userName: ''),
          _sfuParticipant(
            userId: 'alice',
            userName: '',
            sessionId: 'alice-tablet',
          ),
          _sfuParticipant(userId: 'carol'),
        ]),
      );

      final participants = notifier.callState.callParticipants;
      expect(participants.map((it) => it.sessionId), [
        'alice-session',
        'alice-tablet',
        'carol-session',
      ]);
      for (final alice in participants.take(2)) {
        expect(alice.name, 'Alice');
        expect(alice.image, 'alice.png');
        expect(alice.roles, ['host']);
        expect(alice.connectionQuality, SfuConnectionQuality.good);
      }
      expect(participants[2].name, 'carol');
    });

    test('what the SFU sends wins over what the state knew', () {
      final notifier = _notifier([
        _participant(
          userId: 'alice',
          connectionQuality: SfuConnectionQuality.poor,
        ).copyWith(name: 'Old name', roles: ['guest']),
      ]);

      notifier.sfuJoinResponse(
        _joinResponse([
          SfuParticipant(
            userId: 'alice',
            userName: 'New name',
            userImage: 'new.png',
            sessionId: 'alice-session',
            custom: const {},
            customData: const {},
            publishedTracks: [SfuTrackType.audio],
            joinedAt: DateTime.utc(2026),
            trackLookupPrefix: 'alice-prefix',
            connectionQuality: SfuConnectionQuality.excellent,
            isSpeaking: true,
            isDominantSpeaker: true,
            audioLevel: 0.7,
            roles: const ['host'],
            participantSource: SfuParticipantSource.webrtc,
          ),
        ]),
      );

      final alice = notifier.callState.callParticipants.single;
      expect(alice.name, 'New name');
      expect(alice.image, 'new.png');
      expect(alice.roles, ['host']);
      expect(alice.connectionQuality, SfuConnectionQuality.excellent);
      expect(alice.isSpeaking, isTrue);
      expect(alice.isDominantSpeaker, isTrue);
      expect(alice.audioLevel, 0.7);
      expect(
        alice.publishedTracks[SfuTrackType.audio],
        isA<RemoteTrackState>(),
      );
      expect(alice.publishedTracks[SfuTrackType.audio]?.muted, isFalse);
    });

    test('marks the local participant, with local track states', () {
      final notifier = _notifier([]);
      notifier.lifecycleCallSessionStart(sessionId: 'userId-session');

      notifier.sfuJoinResponse(
        _joinResponse([
          _sfuParticipant(
            userId: 'userId',
            publishedTracks: [SfuTrackType.audio],
          ),
          _sfuParticipant(userId: 'bob'),
        ]),
      );

      final participants = notifier.callState.callParticipants;
      expect(participants[0].isLocal, isTrue);
      expect(participants[0].isOnline, isFalse);
      expect(
        participants[0].publishedTracks[SfuTrackType.audio],
        isA<LocalTrackState>(),
      );
      expect(participants[1].isLocal, isFalse);
      expect(participants[1].isOnline, isTrue);
    });
  });

  group('sfuParticipantJoined', () {
    test('appends a new participant and keeps the others identical', () {
      final notifier = _notifier([
        _participant(userId: 'alice'),
        _participant(userId: 'bob'),
      ]);
      final before = notifier.callState.callParticipants;

      notifier.sfuParticipantJoined(
        SfuParticipantJoinedEvent(
          callCid: 'default:id',
          participant: _sfuParticipant(userId: 'carol'),
        ),
      );

      final participants = notifier.callState.callParticipants;
      expect(participants.map((it) => it.userId), ['alice', 'bob', 'carol']);
      expect(participants[0], same(before[0]));
      expect(participants[1], same(before[1]));
    });

    test('replaces an existing session in place', () {
      final notifier = _notifier([
        _participant(userId: 'alice'),
        _participant(userId: 'bob'),
      ]);
      final bob = notifier.callState.callParticipants[1];

      notifier.sfuParticipantJoined(
        SfuParticipantJoinedEvent(
          callCid: 'default:id',
          participant: _sfuParticipant(userId: 'alice', userName: 'Alice v2'),
        ),
      );

      final participants = notifier.callState.callParticipants;
      expect(participants.map((it) => it.userId), ['alice', 'bob']);
      expect(participants[0].name, 'Alice v2');
      expect(participants[1], same(bob));
    });

    test('a second device of a known user is a new participant', () {
      final notifier = _notifier([_participant(userId: 'alice')]);

      notifier.sfuParticipantJoined(
        SfuParticipantJoinedEvent(
          callCid: 'default:id',
          participant: _sfuParticipant(
            userId: 'alice',
            sessionId: 'alice-tablet',
          ),
        ),
      );

      expect(
        notifier.callState.callParticipants.map((it) => it.sessionId),
        ['alice-session', 'alice-tablet'],
      );
    });
  });

  group('sfuParticipantLeft', () {
    SfuParticipantLeftEvent left(String userId, {String? sessionId}) {
      return SfuParticipantLeftEvent(
        callCid: 'default:id',
        participant: _sfuParticipant(userId: userId, sessionId: sessionId),
      );
    }

    test('removes the session that left and keeps the others identical', () {
      final notifier = _notifier([
        _participant(userId: 'alice'),
        _participant(userId: 'bob'),
        _participant(userId: 'carol'),
      ]);
      final before = notifier.callState.callParticipants;

      notifier.sfuParticipantLeft(left('bob'));
      var participants = notifier.callState.callParticipants;
      expect(participants.map((it) => it.userId), ['alice', 'carol']);
      expect(participants[0], same(before[0]));
      expect(participants[1], same(before[2]));

      notifier.sfuParticipantLeft(left('alice'));
      notifier.sfuParticipantLeft(left('carol'));
      participants = notifier.callState.callParticipants;
      expect(participants, isEmpty);
    });

    test('removes only the session that left when a user has two', () {
      final notifier = _notifier(_twoDevices());

      notifier.sfuParticipantLeft(left('alice', sessionId: 'alice-tablet'));

      expect(
        notifier.callState.callParticipants.map((it) => it.sessionId),
        ['alice-session'],
      );
    });

    test('a left for an unknown session does not emit', () async {
      final notifier = _notifier([_participant(userId: 'alice')]);
      final before = notifier.callState.callParticipants;

      final seen = await _emissionsDuring(
        notifier,
        () => notifier.sfuParticipantLeft(left('ghost')),
      );

      expect(seen, isEmpty);
      expect(notifier.callState.callParticipants, same(before));
    });
  });

  group('sfuTrackPublished', () {
    SfuTrackPublishedEvent published(
      String userId,
      SfuTrackType trackType, {
      String? sessionId,
    }) {
      return SfuTrackPublishedEvent(
        userId: userId,
        sessionId: sessionId ?? '$userId-session',
        trackType: trackType,
        participant: _sfuParticipant(userId: userId, sessionId: sessionId),
      );
    }

    test('adds or unmutes the track and leaves the rest alone', () {
      final audio = TrackState.remote(subscribed: true);
      final notifier = _notifier([
        _participant(userId: 'alice').copyWith(
          publishedTracks: {
            SfuTrackType.audio: audio,
            SfuTrackType.video: TrackState.remote(
              muted: true,
              subscribed: true,
              received: true,
            ),
          },
        ),
        _participant(userId: 'bob'),
      ]);
      final bob = notifier.callState.callParticipants[1];

      notifier.sfuTrackPublished(published('alice', SfuTrackType.video));
      notifier.sfuTrackPublished(published('alice', SfuTrackType.screenShare));

      final participants = notifier.callState.callParticipants;
      final tracks = participants[0].publishedTracks;
      final video = tracks[SfuTrackType.video]! as RemoteTrackState;
      expect(video.muted, isFalse);
      expect(
        video.subscribed,
        isTrue,
        reason: 'unmuting keeps the other fields',
      );
      expect(video.received, isTrue);
      expect(tracks[SfuTrackType.screenShare]?.muted, isFalse);
      expect(tracks[SfuTrackType.audio], same(audio));
      expect(participants[1], same(bob));
    });

    test('gives the local participant a local track state', () {
      final notifier = _notifier([
        _participant(userId: 'userId').copyWith(isLocal: true),
      ]);

      notifier.sfuTrackPublished(published('userId', SfuTrackType.audio));

      expect(
        notifier.callState.callParticipants.single.publishedTracks[SfuTrackType
            .audio],
        isA<LocalTrackState>(),
      );
    });

    test('only touches the session the event names', () {
      final notifier = _notifier(_twoDevices());
      final phone = notifier.callState.callParticipants[0];

      notifier.sfuTrackPublished(
        published('alice', SfuTrackType.video, sessionId: 'alice-tablet'),
      );

      final participants = notifier.callState.callParticipants;
      expect(participants[0], same(phone));
      expect(participants[1].publishedTracks.keys, [SfuTrackType.video]);
    });
  });

  group('sfuTrackUnpublished', () {
    SfuTrackUnpublishedEvent unpublished(
      String userId,
      SfuTrackType trackType, {
      String? sessionId,
    }) {
      return SfuTrackUnpublishedEvent(
        userId: userId,
        sessionId: sessionId ?? '$userId-session',
        trackType: trackType,
        participant: _sfuParticipant(userId: userId, sessionId: sessionId),
      );
    }

    test('mutes and unpauses the track and leaves the rest alone', () {
      final audio = TrackState.remote(subscribed: true);
      final notifier = _notifier([
        _participant(userId: 'alice').copyWith(
          publishedTracks: {
            SfuTrackType.audio: audio,
            SfuTrackType.video: TrackState.remote(subscribed: true),
          },
          pausedTracks: {SfuTrackType.video},
        ),
        _participant(userId: 'bob'),
      ]);
      final bob = notifier.callState.callParticipants[1];

      notifier.sfuTrackUnpublished(unpublished('alice', SfuTrackType.video));

      final participants = notifier.callState.callParticipants;
      final tracks = participants[0].publishedTracks;
      final video = tracks[SfuTrackType.video]! as RemoteTrackState;
      expect(video.muted, isTrue);
      expect(video.subscribed, isTrue, reason: 'muting keeps the subscription');
      expect(participants[0].pausedTracks, isEmpty);
      expect(tracks[SfuTrackType.audio], same(audio));
      expect(participants[1], same(bob));
    });

    test('unpauses a paused track that was never published', () {
      final notifier = _notifier([
        _participant(
          userId: 'alice',
        ).copyWith(pausedTracks: {SfuTrackType.video}),
      ]);

      notifier.sfuTrackUnpublished(unpublished('alice', SfuTrackType.video));

      final alice = notifier.callState.callParticipants.single;
      expect(alice.pausedTracks, isEmpty);
      expect(alice.publishedTracks, isEmpty);
    });

    test('does not emit when there is nothing to mute or unpause', () async {
      final notifier = _notifier([
        _participant(userId: 'alice').copyWith(
          publishedTracks: {
            SfuTrackType.audio: TrackState.remote(muted: true),
          },
        ),
      ]);
      final before = notifier.callState.callParticipants;

      final seen = await _emissionsDuring(notifier, () {
        // Never published.
        notifier.sfuTrackUnpublished(unpublished('alice', SfuTrackType.video));
        // Already muted.
        notifier.sfuTrackUnpublished(unpublished('alice', SfuTrackType.audio));
        // Unknown participant.
        notifier.sfuTrackUnpublished(unpublished('ghost', SfuTrackType.audio));
      });

      expect(seen, isEmpty);
      expect(notifier.callState.callParticipants, same(before));
    });

    test('only touches the session the event names', () {
      final notifier = _notifier(
        _twoDevices()
            .map(
              (it) => it.copyWith(
                publishedTracks: {SfuTrackType.video: TrackState.remote()},
              ),
            )
            .toList(),
      );
      final phone = notifier.callState.callParticipants[0];

      notifier.sfuTrackUnpublished(
        unpublished('alice', SfuTrackType.video, sessionId: 'alice-tablet'),
      );

      final participants = notifier.callState.callParticipants;
      expect(participants[0], same(phone));
      expect(
        participants[1].publishedTracks[SfuTrackType.video]?.muted,
        isTrue,
      );
    });
  });

  // Events that name participants are matched on session ID and user ID.
  // Each test holds a user on two devices plus one more participant, names
  // one device and the other participant, and checks the second device is
  // left alone.
  group('participant lookups by session', () {
    List<CallParticipantState> threeSessions() => [
      ..._twoDevices(),
      _participant(userId: 'bob'),
    ];

    test('audio levels', () {
      final notifier = _notifier(threeSessions());
      final phone = notifier.callState.callParticipants[0];

      notifier.sfuUpdateAudioLevelChanged(
        const SfuAudioLevelChangedEvent(
          audioLevels: [
            SfuAudioLevel(
              userId: 'alice',
              sessionId: 'alice-tablet',
              level: 0.8,
              isSpeaking: true,
            ),
            SfuAudioLevel(
              userId: 'bob',
              sessionId: 'bob-session',
              level: 0.5,
              isSpeaking: true,
            ),
          ],
        ),
      );

      final participants = notifier.callState.callParticipants;
      expect(participants[0], same(phone));
      expect(participants[1].isSpeaking, isTrue);
      expect(participants[1].audioLevel, 0.8);
      expect(participants[2].isSpeaking, isTrue);
      expect(participants[2].audioLevel, 0.5);
    });

    test('connection quality', () {
      final notifier = _notifier(threeSessions());
      final phone = notifier.callState.callParticipants[0];

      notifier.sfuConnectionQualityChanged(
        const SfuConnectionQualityChangedEvent(
          connectionQualityUpdates: [
            SfuConnectionQualityInfo(
              userId: 'alice',
              sessionId: 'alice-tablet',
              connectionQuality: SfuConnectionQuality.poor,
            ),
            SfuConnectionQualityInfo(
              userId: 'bob',
              sessionId: 'bob-session',
              connectionQuality: SfuConnectionQuality.excellent,
            ),
          ],
        ),
      );

      final participants = notifier.callState.callParticipants;
      expect(participants[0], same(phone));
      expect(participants[1].connectionQuality, SfuConnectionQuality.poor);
      expect(participants[2].connectionQuality, SfuConnectionQuality.excellent);
    });

    test('pins', () {
      final notifier = _notifier(threeSessions());
      final phone = notifier.callState.callParticipants[0];

      notifier.sfuPinsUpdated(const [
        SfuPin(userId: 'alice', sessionId: 'alice-tablet'),
        SfuPin(userId: 'bob', sessionId: 'bob-session'),
      ]);

      final participants = notifier.callState.callParticipants;
      expect(participants[0], same(phone));
      expect(participants[1].isPinned, isTrue);
      expect(participants[2].isPinned, isTrue);
    });

    test('inbound video state', () {
      final notifier = _notifier(threeSessions());
      final phone = notifier.callState.callParticipants[0];

      notifier.sfuInboundStateNotification(
        SfuInboundStateNotificationEvent(
          inboundVideoStates: [
            SfuInboundVideoState(
              userId: 'alice',
              sessionId: 'alice-tablet',
              trackType: SfuTrackType.video,
              paused: true,
            ),
            SfuInboundVideoState(
              userId: 'bob',
              sessionId: 'bob-session',
              trackType: SfuTrackType.screenShare,
              paused: true,
            ),
          ],
        ),
      );

      final participants = notifier.callState.callParticipants;
      expect(participants[0], same(phone));
      expect(participants[1].pausedTracks, {SfuTrackType.video});
      expect(participants[2].pausedTracks, {SfuTrackType.screenShare});
    });

    test('dominant speaker', () {
      final notifier = _notifier(threeSessions());
      final phone = notifier.callState.callParticipants[0];

      notifier.sfuDominantSpeakerChanged(
        const SfuDominantSpeakerChangedEvent(
          userId: 'alice',
          sessionId: 'alice-tablet',
        ),
      );

      final participants = notifier.callState.callParticipants;
      expect(participants[0], same(phone));
      expect(participants[1].isDominantSpeaker, isTrue);
      expect(participants[2].isDominantSpeaker, isFalse);
    });
  });

  // The same session ID with another user ID is not a match. Each of these
  // would pass with a lookup on the session ID alone, so they guard the user
  // ID check.
  group('participant lookups with a mismatched user id', () {
    test('audio levels', () {
      final notifier = _notifier([_participant(userId: 'alice')]);
      final before = notifier.callState.callParticipants;

      notifier.sfuUpdateAudioLevelChanged(
        const SfuAudioLevelChangedEvent(
          audioLevels: [
            SfuAudioLevel(
              userId: 'mallory',
              sessionId: 'alice-session',
              level: 0.8,
              isSpeaking: true,
            ),
          ],
        ),
      );

      expect(notifier.callState.callParticipants, same(before));
    });

    test('connection quality', () {
      final notifier = _notifier([_participant(userId: 'alice')]);
      final before = notifier.callState.callParticipants;

      notifier.sfuConnectionQualityChanged(
        const SfuConnectionQualityChangedEvent(
          connectionQualityUpdates: [
            SfuConnectionQualityInfo(
              userId: 'mallory',
              sessionId: 'alice-session',
              connectionQuality: SfuConnectionQuality.poor,
            ),
          ],
        ),
      );

      expect(notifier.callState.callParticipants, same(before));
    });

    test('pins', () {
      final notifier = _notifier([_participant(userId: 'alice')]);
      final before = notifier.callState.callParticipants;

      notifier.sfuPinsUpdated(
        const [SfuPin(userId: 'mallory', sessionId: 'alice-session')],
      );
      expect(notifier.callState.callParticipants, same(before));

      // The other way round: once alice is pinned, a pin for her session
      // under another user id does not keep her pinned.
      notifier.sfuPinsUpdated(
        const [SfuPin(userId: 'alice', sessionId: 'alice-session')],
      );
      notifier.sfuPinsUpdated(
        const [SfuPin(userId: 'mallory', sessionId: 'alice-session')],
      );
      expect(notifier.callState.callParticipants.single.isPinned, isFalse);
    });

    test('inbound video state', () {
      final notifier = _notifier([_participant(userId: 'alice')]);
      final before = notifier.callState.callParticipants;

      notifier.sfuInboundStateNotification(
        SfuInboundStateNotificationEvent(
          inboundVideoStates: [
            SfuInboundVideoState(
              userId: 'mallory',
              sessionId: 'alice-session',
              trackType: SfuTrackType.video,
              paused: true,
            ),
          ],
        ),
      );

      expect(notifier.callState.callParticipants, same(before));
    });
  });

  group('counters emit only on change', () {
    test('participant count', () async {
      final notifier = _notifier([]);
      notifier.setParticipantsCount(totalCount: 5, anonymousCount: 1);

      final unchanged = await _emissionsDuring(
        notifier,
        () => notifier.setParticipantsCount(totalCount: 5, anonymousCount: 1),
      );
      final total = await _emissionsDuring(
        notifier,
        () => notifier.setParticipantsCount(totalCount: 6, anonymousCount: 1),
      );
      final anonymous = await _emissionsDuring(
        notifier,
        () => notifier.setParticipantsCount(totalCount: 6, anonymousCount: 2),
      );

      expect(unchanged, isEmpty);
      expect(total, hasLength(1));
      expect(anonymous, hasLength(1));
      expect(notifier.callState.participantCount, 6);
      expect(notifier.callState.anonymousParticipantCount, 2);
    });

    test('e2ee flag', () async {
      final notifier = _notifier([]);

      final changed = await _emissionsDuring(
        notifier,
        () => notifier.sfuE2eeEnabledUpdated(true),
      );
      final unchanged = await _emissionsDuring(
        notifier,
        () => notifier.sfuE2eeEnabledUpdated(true),
      );

      expect(changed, hasLength(1));
      expect(unchanged, isEmpty);
      expect(notifier.callState.isE2eeEnabled, isTrue);
    });
  });
}
