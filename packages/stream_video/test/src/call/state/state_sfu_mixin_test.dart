import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_audio_level.dart';
import 'package:stream_video/src/sfu/data/models/sfu_connection_info.dart';
import 'package:stream_video/src/sfu/data/models/sfu_inbound_video_state.dart';
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
}
