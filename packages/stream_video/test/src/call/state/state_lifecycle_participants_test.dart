import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/data.dart';

// `lifecycleCallJoined` rebuilds the participant list from the coordinator's
// session participants, keeping what the state already held for each session.

CallMetadata _metadata({
  required Map<String, CallParticipant> participants,
  Map<String, CallUser> users = const {},
}) {
  return CallMetadata(
    session: CallSessionData(participants: participants),
    users: users,
    members: const {},
    cid: SampleCallData.defaultCid,
    details: CallDetails(
      createdBy: SampleCallData.defaultCallUser,
      team: '',
      ownCapabilities: const [CallPermission.sendAudio],
      blockedUserIds: const [],
      broadcasting: false,
      recording: false,
      backstage: false,
      transcribing: false,
      captioning: false,
      custom: const {},
      egress: const CallEgress(),
      rtmpIngress: '',
    ),
    settings: const CallSettings(),
  );
}

CallJoinedData _joined({
  required Map<String, CallParticipant> participants,
  Map<String, CallUser> users = const {},
}) {
  return CallJoinedData(
    callCid: SampleCallData.defaultCid,
    wasCreated: false,
    credentials: SampleCallData.defaultCredentials,
    statsOptions: const StatsOptions(
      enableRtcStats: false,
      reportingIntervalMs: 500,
    ),
    metadata: _metadata(participants: participants, users: users),
  );
}

CallParticipant _sessionParticipant(String userId, {String? sessionId}) {
  return CallParticipant(
    userSessionId: sessionId ?? '$userId-session',
    userId: userId,
    role: 'user',
  );
}

CallParticipantState _participant({
  required String userId,
  String? sessionId,
}) {
  return CallParticipantState(
    userId: userId,
    roles: const ['user'],
    name: userId,
    custom: const {},
    sessionId: sessionId ?? '$userId-session',
    trackIdPrefix: '$userId-prefix',
  );
}

CallStateNotifier _notifier(List<CallParticipantState> participants) {
  final callState = CallState(
    callCid: SampleCallData.defaultCid,
    currentUserId: 'me',
    preferences: DefaultCallPreferences(),
  ).copyWith(callParticipants: participants, sessionId: 'me-session');

  return CallStateNotifier(callState);
}

void main() {
  group('lifecycleCallJoined participants', () {
    test('builds participants from the session, in session order', () {
      final notifier = _notifier([]);

      notifier.lifecycleCallJoined(
        _joined(
          participants: {
            'alice-session': _sessionParticipant('alice'),
            'bob-session': _sessionParticipant('bob'),
          },
        ),
      );

      expect(
        notifier.callState.callParticipants.map((it) => it.userId),
        ['alice', 'bob'],
      );
      expect(notifier.callState.status.isJoined, isFalse);
      expect(
        notifier.callState.ownCapabilities,
        [CallPermission.sendAudio],
      );
    });

    test(
      'takes the profile from the users map and the role from the session',
      () {
        final notifier = _notifier([]);

        notifier.lifecycleCallJoined(
          _joined(
            participants: {
              'alice-session': _sessionParticipant('alice'),
              'bob-session': _sessionParticipant('bob'),
            },
            users: {
              'alice': const CallUser(
                id: 'alice',
                name: 'Alice',
                roles: ['host'],
                image: 'alice.png',
                custom: {'seat': 1},
              ),
            },
          ),
        );

        final participants = notifier.callState.callParticipants;
        expect(participants[0].name, 'Alice');
        expect(participants[0].image, 'alice.png');
        expect(participants[0].roles, ['host']);
        expect(participants[0].customData, {'seat': 1});
        expect(participants[1].name, '');
        expect(participants[1].roles, ['user']);
      },
    );

    test('keeps what the state held for a session that is still there', () {
      final notifier = _notifier([
        _participant(userId: 'alice').copyWith(
          publishedTracks: {SfuTrackType.audio: TrackState.remote()},
          connectionQuality: SfuConnectionQuality.good,
          isSpeaking: true,
        ),
      ]);

      notifier.lifecycleCallJoined(
        _joined(
          participants: {'alice-session': _sessionParticipant('alice')},
          users: {
            'alice': const CallUser(
              id: 'alice',
              name: 'Alice',
              roles: ['user'],
              image: '',
            ),
          },
        ),
      );

      final alice = notifier.callState.callParticipants.single;
      expect(alice.trackIdPrefix, 'alice-prefix');
      expect(alice.publishedTracks.keys, [SfuTrackType.audio]);
      expect(alice.connectionQuality, SfuConnectionQuality.good);
      expect(alice.isSpeaking, isTrue);
      expect(alice.name, 'Alice', reason: 'the profile is refreshed');
    });

    test('drops a session the coordinator no longer lists', () {
      final notifier = _notifier([
        _participant(userId: 'alice'),
        _participant(userId: 'bob'),
      ]);

      notifier.lifecycleCallJoined(
        _joined(participants: {'bob-session': _sessionParticipant('bob')}),
      );

      expect(
        notifier.callState.callParticipants.map((it) => it.userId),
        ['bob'],
      );
    });

    test('another session of a known user starts fresh', () {
      final notifier = _notifier([
        _participant(userId: 'alice').copyWith(
          publishedTracks: {SfuTrackType.audio: TrackState.remote()},
        ),
      ]);

      notifier.lifecycleCallJoined(
        _joined(
          participants: {
            'alice-session': _sessionParticipant('alice'),
            'alice-tablet': _sessionParticipant(
              'alice',
              sessionId: 'alice-tablet',
            ),
          },
        ),
      );

      final participants = notifier.callState.callParticipants;
      expect(participants[0].sessionId, 'alice-session');
      expect(participants[0].publishedTracks.keys, [SfuTrackType.audio]);
      expect(participants[1].sessionId, 'alice-tablet');
      expect(participants[1].publishedTracks, isEmpty);
      expect(participants[1].trackIdPrefix, '');
    });

    test('a held session whose user id changed is not reused', () {
      final notifier = _notifier([
        _participant(userId: 'alice').copyWith(
          publishedTracks: {SfuTrackType.audio: TrackState.remote()},
        ),
      ]);

      notifier.lifecycleCallJoined(
        _joined(
          participants: {
            'alice-session': _sessionParticipant(
              'mallory',
              sessionId: 'alice-session',
            ),
          },
        ),
      );

      final participant = notifier.callState.callParticipants.single;
      expect(participant.userId, 'mallory');
      expect(participant.publishedTracks, isEmpty);
    });

    test('marks the local participant', () {
      final notifier = _notifier([]);

      notifier.lifecycleCallJoined(
        _joined(
          participants: {
            'me-session': _sessionParticipant('me'),
            'bob-session': _sessionParticipant('bob'),
          },
        ),
      );

      final participants = notifier.callState.callParticipants;
      expect(participants[0].isLocal, isTrue);
      expect(participants[0].isOnline, isFalse);
      expect(participants[1].isLocal, isFalse);
      expect(participants[1].isOnline, isTrue);
    });

    test('moves a joining call to joined', () {
      final notifier = _notifier([]);
      notifier.lifecycleCallJoining();

      notifier.lifecycleCallJoined(_joined(participants: const {}));

      expect(notifier.callState.status.isJoined, isTrue);
    });
  });
}
