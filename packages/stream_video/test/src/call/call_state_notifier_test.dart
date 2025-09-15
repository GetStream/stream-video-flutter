import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  group('CallStateNotifier participantMirrorVideo tests', () {
    late CallStateNotifier stateNotifier;
    late CallState initialState;

    setUp(() {
      final targetParticipant = CallParticipantState(
        userId: 'target-user',
        sessionId: 'target-session',
        name: 'Target Participant',
        roles: const [],
        custom: const {},
        trackIdPrefix: 'target-track',
        publishedTracks: {
          SfuTrackType.video: TrackState.remote(
            subscribed: true,
            received: true,
          ),
        },
      );

      final otherParticipant = CallParticipantState(
        userId: 'other-user',
        sessionId: 'other-session',
        name: 'Other Participant',
        image: '',
        roles: const [],
        custom: const {},
        trackIdPrefix: 'other-track',
        publishedTracks: {
          SfuTrackType.video: TrackState.remote(
            subscribed: true,
            received: true,
          ),
        },
      );

      initialState =
          CallState(
            callCid: StreamCallCid.from(
              type: StreamCallType.defaultType(),
              id: 'test-call',
            ),
            currentUserId: 'current-user',
            preferences: DefaultCallPreferences(),
          ).copyWith(
            callParticipants: [targetParticipant, otherParticipant],
          );

      stateNotifier = CallStateNotifier(initialState);
    });

    tearDown(() {
      stateNotifier.dispose();
    });

    test('participantMirrorVideo updates target participant video track', () {
      final stateBefore = stateNotifier.state;
      expect(stateBefore.callParticipants.length, 2);

      final targetParticipantBefore = stateBefore.callParticipants.firstWhere(
        (p) => p.sessionId == 'target-session',
      );
      final targetVideoTrackBefore =
          targetParticipantBefore.publishedTracks[SfuTrackType.video]!
              as RemoteTrackState;
      expect(targetVideoTrackBefore.mirrorVideo, false);

      final otherParticipantBefore = stateBefore.callParticipants.firstWhere(
        (p) => p.sessionId == 'other-session',
      );
      final otherVideoTrackBefore =
          otherParticipantBefore.publishedTracks[SfuTrackType.video]!
              as RemoteTrackState;
      expect(otherVideoTrackBefore.mirrorVideo, false);

      stateNotifier.participantMirrorVideo(
        sessionId: 'target-session',
        userId: 'target-user',
        mirrorVideo: true,
      );

      final stateAfter = stateNotifier.state;
      expect(stateAfter.callParticipants.length, 2);

      final targetParticipantAfter = stateAfter.callParticipants.firstWhere(
        (p) => p.sessionId == 'target-session',
      );
      final targetVideoTrackAfter =
          targetParticipantAfter.publishedTracks[SfuTrackType.video]!
              as RemoteTrackState;
      expect(targetVideoTrackAfter.mirrorVideo, true);

      // Other participant should remain unchanged
      final otherParticipantAfter = stateAfter.callParticipants.firstWhere(
        (p) => p.sessionId == 'other-session',
      );
      final otherVideoTrackAfter =
          otherParticipantAfter.publishedTracks[SfuTrackType.video]!
              as RemoteTrackState;
      expect(otherVideoTrackAfter.mirrorVideo, false);

      // Verify other properties remain unchanged
      expect(targetVideoTrackAfter.muted, targetVideoTrackBefore.muted);
      expect(
        targetVideoTrackAfter.subscribed,
        targetVideoTrackBefore.subscribed,
      );
      expect(targetVideoTrackAfter.received, targetVideoTrackBefore.received);
    });

    test(
      'participantMirrorVideo ignores participants without video tracks',
      () {
        // Arrange - Create state with participant that has no video track
        final participantWithoutVideo = CallParticipantState(
          userId: 'no-video-user',
          sessionId: 'no-video-session',
          name: 'Audio Only Participant',
          image: '',
          roles: const [],
          custom: const {},
          trackIdPrefix: 'no-video-track',
          publishedTracks: {
            SfuTrackType.audio: TrackState.remote(), // Only audio track
          },
        );

        final stateWithAudioOnly = initialState.copyWith(
          callParticipants: [
            ...initialState.callParticipants,
            participantWithoutVideo,
          ],
        );
        stateNotifier.state = stateWithAudioOnly;

        stateNotifier.participantMirrorVideo(
          sessionId: 'no-video-session',
          userId: 'no-video-user',
          mirrorVideo: true,
        );

        final stateAfter = stateNotifier.state;
        final participantAfter = stateAfter.callParticipants.firstWhere(
          (p) => p.sessionId == 'no-video-session',
        );

        expect(
          participantAfter.publishedTracks.containsKey(SfuTrackType.video),
          false,
        );
        expect(
          participantAfter.publishedTracks[SfuTrackType.audio],
          isA<RemoteTrackState>(),
        );
      },
    );

    test('participantMirrorVideo only affects RemoteTrackState', () {
      // Arrange - Create participant with LocalTrackState
      final localParticipant = CallParticipantState(
        userId: 'local-user',
        sessionId: 'local-session',
        name: 'Local Participant',
        roles: const [],
        custom: const {},
        isLocal: true,
        trackIdPrefix: 'local-track',
        publishedTracks: {
          SfuTrackType.video: TrackState.local(), // Local track
        },
      );

      final stateWithLocal = initialState.copyWith(
        callParticipants: [...initialState.callParticipants, localParticipant],
      );
      stateNotifier.state = stateWithLocal;

      final localTrackBefore =
          stateWithLocal.callParticipants
                  .firstWhere((p) => p.isLocal)
                  .publishedTracks[SfuTrackType.video]!
              as LocalTrackState;

      stateNotifier.participantMirrorVideo(
        sessionId: 'local-session',
        userId: 'local-user',
        mirrorVideo: true,
      );

      // Assert - Local track should remain unchanged (no mirrorVideo property)
      final stateAfter = stateNotifier.state;
      final localTrackAfter =
          stateAfter.callParticipants
                  .firstWhere((p) => p.sessionId == 'local-session')
                  .publishedTracks[SfuTrackType.video]!
              as LocalTrackState;

      expect(localTrackAfter.muted, localTrackBefore.muted);
      expect(localTrackAfter.sourceDevice, localTrackBefore.sourceDevice);
      expect(localTrackAfter.cameraPosition, localTrackBefore.cameraPosition);
    });
  });
}
