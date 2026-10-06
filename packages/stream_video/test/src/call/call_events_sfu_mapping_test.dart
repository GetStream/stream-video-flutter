import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_call_state.dart';
import 'package:stream_video/src/sfu/data/models/sfu_participant.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/data.dart';

// The public call events built from SFU events carry a participant state that
// is filled in from what the call state already knows about the user.

SfuParticipant _sfuParticipant(
  String userId, {
  String userName = '',
  String? sessionId,
  List<SfuTrackType> publishedTracks = const [],
}) {
  return SfuParticipant(
    userId: userId,
    userName: userName,
    userImage: '',
    sessionId: sessionId ?? '$userId-session',
    custom: const {},
    customData: const {},
    publishedTracks: publishedTracks,
    joinedAt: DateTime.utc(2026),
    trackLookupPrefix: '$userId-prefix',
    connectionQuality: SfuConnectionQuality.unspecified,
    isSpeaking: false,
    isDominantSpeaker: false,
    audioLevel: 0,
    roles: const [],
    participantSource: SfuParticipantSource.webrtc,
  );
}

CallParticipantState _participant(String userId) {
  return CallParticipantState(
    userId: userId,
    roles: const ['host'],
    name: 'Known $userId',
    image: '$userId.png',
    custom: const {},
    sessionId: '$userId-session',
    trackIdPrefix: '$userId-prefix',
    connectionQuality: SfuConnectionQuality.good,
  );
}

CallState _state(List<CallParticipantState> participants) {
  return CallState(
    callCid: SampleCallData.defaultCid,
    currentUserId: 'me',
    preferences: DefaultCallPreferences(),
  ).copyWith(callParticipants: participants, sessionId: 'me-session');
}

void main() {
  group('SfuEvent.mapToCallEvent', () {
    test('a join response maps every participant', () {
      final state = _state([_participant('alice')]);
      final event = SfuJoinResponseEvent(
        callState: SfuCallState(
          participants: [
            _sfuParticipant('alice'),
            _sfuParticipant('bob', userName: 'Bob'),
            _sfuParticipant('me', publishedTracks: [SfuTrackType.audio]),
          ],
          participantCount: const SfuParticipantCount(total: 3, anonymous: 1),
          startedAt: DateTime.utc(2026),
          pins: const [],
          e2eeEnabled: false,
        ),
      );

      final mapped = event.mapToCallEvent(state);

      expect(mapped, isA<StreamCallJoinedEvent>());
      final joined = mapped! as StreamCallJoinedEvent;
      expect(joined.callCid, SampleCallData.defaultCid);
      expect(joined.participantCount, 3);
      expect(joined.anonymousCount, 1);
      expect(joined.startedAt, DateTime.utc(2026));
      expect(joined.participants.map((it) => it.userId), [
        'alice',
        'bob',
        'me',
      ]);
      expect(joined.participants[0].name, 'Known alice');
      expect(joined.participants[0].image, 'alice.png');
      expect(joined.participants[0].roles, ['host']);
      expect(
        joined.participants[0].connectionQuality,
        SfuConnectionQuality.good,
      );
      expect(joined.participants[1].name, 'Bob');
      expect(joined.participants[2].isLocal, isTrue);
      expect(
        joined.participants[2].publishedTracks[SfuTrackType.audio],
        isA<LocalTrackState>(),
      );
    });

    test('a joined event fills the participant in from the state', () {
      final state = _state([_participant('alice')]);

      final mapped = SfuParticipantJoinedEvent(
        callCid: 'default:id',
        participant: _sfuParticipant('alice'),
      ).mapToCallEvent(state);

      final joined = mapped! as StreamCallParticipantJoinedEvent;
      expect(joined.participant.userId, 'alice');
      expect(joined.participant.name, 'Known alice');
      expect(joined.participant.isPinned, isFalse);
    });

    test('a pinned joined event carries a server pin', () {
      final mapped = SfuParticipantJoinedEvent(
        callCid: 'default:id',
        participant: _sfuParticipant('alice'),
        isPinned: true,
      ).mapToCallEvent(_state([]));

      final joined = mapped! as StreamCallParticipantJoinedEvent;
      expect(joined.participant.isPinned, isTrue);
      expect(joined.participant.pin?.isLocalPin, isFalse);
    });

    test('a left event names the participant that left', () {
      final state = _state([_participant('alice'), _participant('bob')]);

      final mapped = SfuParticipantLeftEvent(
        callCid: 'default:id',
        participant: _sfuParticipant('bob'),
      ).mapToCallEvent(state);

      final left = mapped! as StreamCallParticipantLeftEvent;
      expect(left.participant.userId, 'bob');
      expect(left.participant.sessionId, 'bob-session');
      expect(left.participant.name, 'Known bob');
    });

    test('track events carry the participant and the track type', () {
      final state = _state([_participant('alice')]);

      final published =
          SfuTrackPublishedEvent(
                userId: 'alice',
                sessionId: 'alice-session',
                trackType: SfuTrackType.video,
                participant: _sfuParticipant('alice'),
              ).mapToCallEvent(state)!
              as StreamCallSfuTrackPublishedEvent;
      final unpublished =
          SfuTrackUnpublishedEvent(
                userId: 'alice',
                sessionId: 'alice-session',
                trackType: SfuTrackType.video,
                participant: _sfuParticipant('alice'),
              ).mapToCallEvent(state)!
              as StreamCallSfuTrackUnpublishedEvent;

      expect(published.userId, 'alice');
      expect(published.sessionId, 'alice-session');
      expect(published.trackType, SfuTrackType.video);
      expect(published.participant.name, 'Known alice');
      expect(unpublished.trackType, SfuTrackType.video);
      expect(unpublished.participant.name, 'Known alice');
    });

    test('a participant the state does not know starts from the event', () {
      final mapped = SfuParticipantJoinedEvent(
        callCid: 'default:id',
        participant: _sfuParticipant('alice'),
      ).mapToCallEvent(_state([]));

      final joined = mapped! as StreamCallParticipantJoinedEvent;
      expect(joined.participant.name, '');
      expect(joined.participant.roles, isEmpty);
      expect(
        joined.participant.connectionQuality,
        SfuConnectionQuality.unspecified,
      );
    });

    test('internal events map to nothing', () {
      expect(
        const SfuHealthCheckResponseEvent(
          SfuParticipantCount(total: 1, anonymous: 0),
        ).mapToCallEvent(_state([])),
        isNull,
      );
    });
  });
}
