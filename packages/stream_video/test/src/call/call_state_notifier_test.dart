import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_participant.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  group('CallStateNotifier pending tracks race condition tests', () {
    late CallStateNotifier stateNotifier;
    late CallState initialState;

    setUp(() {
      initialState = CallState(
        callCid: StreamCallCid.from(
          type: StreamCallType.defaultType(),
          id: 'test-call',
        ),
        currentUserId: 'current-user',
        preferences: DefaultCallPreferences(),
      );

      stateNotifier = CallStateNotifier(initialState);
    });

    tearDown(() {
      stateNotifier.dispose();
    });

    test(
      'rtcUpdateSubscriberTrack before participant join buffers track',
      () {
        // Arrange - No participants yet
        expect(stateNotifier.state.callParticipants, isEmpty);

        // Act - RTC track received before participant joins
        stateNotifier.rtcUpdateSubscriberTrack(
          trackIdPrefix: 'remote-track-123',
          trackType: SfuTrackType.video,
        );

        // Assert - Still no participants (track should be buffered)
        expect(stateNotifier.state.callParticipants, isEmpty);

        // Act - Participant joins
        final sfuParticipant = SfuParticipant(
          userId: 'remote-user',
          userName: 'Remote User',
          userImage: '',
          sessionId: 'remote-session',
          custom: const {},
          publishedTracks: const [],
          joinedAt: DateTime.now(),
          trackLookupPrefix: 'remote-track-123',
          connectionQuality: SfuConnectionQuality.excellent,
          isSpeaking: false,
          isDominantSpeaker: false,
          audioLevel: 0,
          roles: const [],
          participantSource: SfuParticipantSource.webrtc,
        );

        stateNotifier.sfuParticipantJoined(
          SfuParticipantJoinedEvent(
            callCid: 'test:test-call',
            participant: sfuParticipant,
          ),
        );

        // Assert - Participant added with buffered track
        expect(stateNotifier.state.callParticipants.length, 1);
        final participant = stateNotifier.state.callParticipants.first;
        expect(participant.userId, 'remote-user');
        expect(participant.trackIdPrefix, 'remote-track-123');
        expect(
          participant.publishedTracks.containsKey(SfuTrackType.video),
          true,
        );

        final videoTrack =
            participant.publishedTracks[SfuTrackType.video]!
                as RemoteTrackState;
        expect(videoTrack.subscribed, true);
        expect(videoTrack.received, true);
        expect(videoTrack.muted, false);
      },
    );

    test(
      'sfuTrackPublished before participant join buffers track',
      () {
        // Arrange - No participants yet
        expect(stateNotifier.state.callParticipants, isEmpty);

        // Act - SFU track published event received before participant joins
        final sfuParticipant = SfuParticipant(
          userId: 'remote-user',
          userName: 'Remote User',
          userImage: '',
          sessionId: 'remote-session',
          custom: const {},
          publishedTracks: const [],
          joinedAt: DateTime.now(),
          trackLookupPrefix: 'remote-track-123',
          connectionQuality: SfuConnectionQuality.excellent,
          isSpeaking: false,
          isDominantSpeaker: false,
          audioLevel: 0,
          roles: const [],
          participantSource: SfuParticipantSource.webrtc,
        );

        stateNotifier.sfuTrackPublished(
          SfuTrackPublishedEvent(
            userId: 'remote-user',
            sessionId: 'remote-session',
            trackType: SfuTrackType.audio,
            participant: sfuParticipant,
          ),
        );

        // Assert - Still no participants (track should be buffered)
        expect(stateNotifier.state.callParticipants, isEmpty);

        // Act - Participant joins
        stateNotifier.sfuParticipantJoined(
          SfuParticipantJoinedEvent(
            callCid: 'test:test-call',
            participant: sfuParticipant,
          ),
        );

        // Assert - Participant added with buffered track
        expect(stateNotifier.state.callParticipants.length, 1);
        final participant = stateNotifier.state.callParticipants.first;
        expect(
          participant.publishedTracks.containsKey(SfuTrackType.audio),
          true,
        );

        final audioTrack =
            participant.publishedTracks[SfuTrackType.audio]!
                as RemoteTrackState;
        expect(audioTrack.subscribed, false);
        expect(audioTrack.received, false);
        expect(audioTrack.muted, false);
      },
    );

    test(
      'both sfuTrackPublished and rtcUpdateSubscriberTrack before join merge correctly',
      () {
        // Arrange - No participants yet
        expect(stateNotifier.state.callParticipants, isEmpty);

        final sfuParticipant = SfuParticipant(
          userId: 'remote-user',
          userName: 'Remote User',
          userImage: '',
          sessionId: 'remote-session',
          custom: const {},
          publishedTracks: const [],
          joinedAt: DateTime.now(),
          trackLookupPrefix: 'remote-track-123',
          connectionQuality: SfuConnectionQuality.excellent,
          isSpeaking: false,
          isDominantSpeaker: false,
          audioLevel: 0,
          roles: const [],
          participantSource: SfuParticipantSource.webrtc,
        );

        // Act - SFU track published event first (track not yet received)
        stateNotifier.sfuTrackPublished(
          SfuTrackPublishedEvent(
            userId: 'remote-user',
            sessionId: 'remote-session',
            trackType: SfuTrackType.video,
            participant: sfuParticipant,
          ),
        );

        // Act - RTC media track received
        stateNotifier.rtcUpdateSubscriberTrack(
          trackIdPrefix: 'remote-track-123',
          trackType: SfuTrackType.video,
        );

        // Assert - Still no participants (both events should be buffered)
        expect(stateNotifier.state.callParticipants, isEmpty);

        // Act - Participant joins
        stateNotifier.sfuParticipantJoined(
          SfuParticipantJoinedEvent(
            callCid: 'test:test-call',
            participant: sfuParticipant,
          ),
        );

        // Assert - Participant added with merged track state
        expect(stateNotifier.state.callParticipants.length, 1);
        final participant = stateNotifier.state.callParticipants.first;
        expect(
          participant.publishedTracks.containsKey(SfuTrackType.video),
          true,
        );

        final videoTrack =
            participant.publishedTracks[SfuTrackType.video]!
                as RemoteTrackState;
        // Should have RTC state (subscribed and received)
        expect(videoTrack.subscribed, true);
        expect(videoTrack.received, true);
        expect(videoTrack.muted, false);
      },
    );

    test(
      'multiple tracks buffered for same participant',
      () {
        // Arrange
        expect(stateNotifier.state.callParticipants, isEmpty);

        final sfuParticipant = SfuParticipant(
          userId: 'remote-user',
          userName: 'Remote User',
          userImage: '',
          sessionId: 'remote-session',
          custom: const {},
          publishedTracks: const [],
          joinedAt: DateTime.now(),
          trackLookupPrefix: 'remote-track-123',
          connectionQuality: SfuConnectionQuality.excellent,
          isSpeaking: false,
          isDominantSpeaker: false,
          audioLevel: 0,
          roles: const [],
          participantSource: SfuParticipantSource.webrtc,
        );

        // Act - Multiple tracks arrive before participant
        stateNotifier.rtcUpdateSubscriberTrack(
          trackIdPrefix: 'remote-track-123',
          trackType: SfuTrackType.video,
        );

        stateNotifier.sfuTrackPublished(
          SfuTrackPublishedEvent(
            userId: 'remote-user',
            sessionId: 'remote-session',
            trackType: SfuTrackType.audio,
            participant: sfuParticipant,
          ),
        );

        stateNotifier.rtcUpdateSubscriberTrack(
          trackIdPrefix: 'remote-track-123',
          trackType: SfuTrackType.screenShare,
        );

        // Assert - Still no participants
        expect(stateNotifier.state.callParticipants, isEmpty);

        // Act - Participant joins
        stateNotifier.sfuParticipantJoined(
          SfuParticipantJoinedEvent(
            callCid: 'test:test-call',
            participant: sfuParticipant,
          ),
        );

        // Assert - All buffered tracks applied
        expect(stateNotifier.state.callParticipants.length, 1);
        final participant = stateNotifier.state.callParticipants.first;

        expect(participant.publishedTracks.length, 3);
        expect(
          participant.publishedTracks.containsKey(SfuTrackType.video),
          true,
        );
        expect(
          participant.publishedTracks.containsKey(SfuTrackType.audio),
          true,
        );
        expect(
          participant.publishedTracks.containsKey(SfuTrackType.screenShare),
          true,
        );

        final videoTrack =
            participant.publishedTracks[SfuTrackType.video]!
                as RemoteTrackState;
        expect(videoTrack.received, true);

        final audioTrack =
            participant.publishedTracks[SfuTrackType.audio]!
                as RemoteTrackState;
        expect(audioTrack.received, false);

        final screenTrack =
            participant.publishedTracks[SfuTrackType.screenShare]!
                as RemoteTrackState;
        expect(screenTrack.received, true);
      },
    );

    test(
      'participant left clears pending tracks',
      () {
        // Arrange
        expect(stateNotifier.state.callParticipants, isEmpty);

        final sfuParticipant = SfuParticipant(
          userId: 'remote-user',
          userName: 'Remote User',
          userImage: '',
          sessionId: 'remote-session',
          custom: const {},
          publishedTracks: const [],
          joinedAt: DateTime.now(),
          trackLookupPrefix: 'remote-track-123',
          connectionQuality: SfuConnectionQuality.excellent,
          isSpeaking: false,
          isDominantSpeaker: false,
          audioLevel: 0,
          roles: const [],
          participantSource: SfuParticipantSource.webrtc,
        );

        // Act - Track arrives before participant
        stateNotifier.rtcUpdateSubscriberTrack(
          trackIdPrefix: 'remote-track-123',
          trackType: SfuTrackType.video,
        );

        // Act - Participant left event (they never actually joined in our state)
        stateNotifier.sfuParticipantLeft(
          SfuParticipantLeftEvent(
            callCid: 'test:test-call',
            participant: sfuParticipant,
          ),
        );

        // Assert - Still no participants
        expect(stateNotifier.state.callParticipants, isEmpty);

        // Act - Now participant tries to join
        stateNotifier.sfuParticipantJoined(
          SfuParticipantJoinedEvent(
            callCid: 'test:test-call',
            participant: sfuParticipant,
          ),
        );

        // Assert - Participant added without the cleared pending track
        expect(stateNotifier.state.callParticipants.length, 1);
        final participant = stateNotifier.state.callParticipants.first;
        expect(participant.publishedTracks, isEmpty);
      },
    );
  });

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
