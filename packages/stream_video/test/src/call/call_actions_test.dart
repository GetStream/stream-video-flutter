import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/open_api/video/coordinator/api.dart' as open;
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';
import 'fixtures/connection_harness.dart';
import 'fixtures/data.dart';

/// Pins what the `Call` actions that forward to the permissions manager and
/// the coordinator client pass on, and which state flags they set.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
    registerFallbackValue(TrackType.audio);
    registerFallbackValue(RecordingType.composite);
  });

  final cid = SampleCallData.defaultCid;
  const refused = Result<Never>.failure(StreamVideoException(message: 'no'));

  late ConnectionHarness harness;
  late MockPermissionsManager permissions;

  setUp(() {
    harness = ConnectionHarness();
    permissions = harness.permissionsManager;
  });
  tearDown(() => harness.dispose());

  group('forwarding', () {
    test('kickUser passes the user and block', () async {
      when(
        () => permissions.kickUser(any(), block: any(named: 'block')),
      ).thenAnswer((_) async => const Result.success(none));

      await harness.buildCall().kickUser('alice', block: true);

      verify(() => permissions.kickUser('alice', block: true)).called(1);
    });

    test('muteOthers passes the track', () async {
      when(
        () => permissions.muteOthers(track: any(named: 'track')),
      ).thenAnswer((_) async => const Result.success(none));

      await harness.buildCall().muteOthers(track: TrackType.video);

      verify(() => permissions.muteOthers(track: TrackType.video)).called(1);
    });

    test('unpinning for everyone asks to unpin', () async {
      when(
        () => permissions.unpinForEveryone(
          userId: any(named: 'userId'),
          sessionId: any(named: 'sessionId'),
        ),
      ).thenAnswer((_) async => const Result.success(none));

      await harness.buildCall().setParticipantPinnedForEveryone(
        sessionId: 's1',
        userId: 'alice',
        pinned: false,
      );

      verify(
        () => permissions.unpinForEveryone(userId: 'alice', sessionId: 's1'),
      ).called(1);
      verifyNever(
        () => permissions.pinForEveryone(
          userId: any(named: 'userId'),
          sessionId: any(named: 'sessionId'),
        ),
      );
    });

    test('queryMembers passes the query', () async {
      when(
        () => permissions.queryMembers(
          filterConditions: any(named: 'filterConditions'),
          next: any(named: 'next'),
          prev: any(named: 'prev'),
          sorts: any(named: 'sorts'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => refused);

      await harness.buildCall().queryMembers(
        filterConditions: {'role': 'host'},
        next: 'n',
        limit: 5,
      );

      verify(
        () => permissions.queryMembers(
          filterConditions: {'role': 'host'},
          next: 'n',
          sorts: const [],
          limit: 5,
        ),
      ).called(1);
    });

    test('addMembers turns users into member requests for the call', () async {
      when(
        () => harness.coordinatorClient.addMembers(
          callCid: any(named: 'callCid'),
          members: any(named: 'members'),
        ),
      ).thenAnswer((_) async => const Result.success(none));

      await harness.buildCall().addMembers([
        const UserInfo(id: 'alice', role: 'host'),
      ]);

      final members =
          verify(
                () => harness.coordinatorClient.addMembers(
                  callCid: cid,
                  members: captureAny(named: 'members'),
                ),
              ).captured.single
              as Iterable<open.MemberRequest>;
      expect(
        members.map((m) => (m.userId, m.role)),
        [('alice', 'host')],
      );
    });

    test('startRtmpBroadcasts passes the broadcasts for the call', () async {
      when(
        () => harness.coordinatorClient.startRtmpBroadcasts(
          any(),
          broadcasts: any(named: 'broadcasts'),
        ),
      ).thenAnswer((_) async => const Result.success(none));
      const broadcasts = [
        StreamRtmpBroadcastRequest(name: 'yt', streamUrl: 'rtmp://yt'),
      ];

      await harness.buildCall().startRtmpBroadcasts(broadcasts: broadcasts);

      verify(
        () => harness.coordinatorClient.startRtmpBroadcasts(
          cid,
          broadcasts: broadcasts,
        ),
      ).called(1);
    });

    test('sendCustomEvent passes the event for the call', () async {
      when(
        () => harness.coordinatorClient.sendCustomEvent(
          callCid: any(named: 'callCid'),
          eventType: any(named: 'eventType'),
          custom: any(named: 'custom'),
        ),
      ).thenAnswer((_) async => const Result.success(none));

      await harness.buildCall().sendCustomEvent(
        eventType: 'wave',
        custom: {'to': 'alice'},
      );

      verify(
        () => harness.coordinatorClient.sendCustomEvent(
          callCid: cid,
          eventType: 'wave',
          custom: {'to': 'alice'},
        ),
      ).called(1);
    });
  });

  group('state flags', () {
    void stubRecording(Result<None> result) {
      when(
        () => permissions.startRecording(
          recordingType: any(named: 'recordingType'),
          recordingExternalStorage: any(named: 'recordingExternalStorage'),
        ),
      ).thenAnswer((_) async => result);
      when(
        () => permissions.stopRecording(
          recordingType: any(named: 'recordingType'),
        ),
      ).thenAnswer((_) async => result);
    }

    test('recording follows a successful start and stop', () async {
      stubRecording(const Result.success(none));
      final call = harness.buildCall();

      await call.startRecording();
      expect(call.state.value.isRecording, isTrue);
      await call.stopRecording();
      expect(call.state.value.isRecording, isFalse);
    });

    test('a refused start leaves recording off', () async {
      stubRecording(refused);
      final call = harness.buildCall();

      await call.startRecording();

      expect(call.state.value.isRecording, isFalse);
    });

    test('transcribing follows a successful start and stop', () async {
      when(
        () => permissions.startTranscription(
          enableClosedCaptions: any(named: 'enableClosedCaptions'),
          language: any(named: 'language'),
          transcriptionExternalStorage: any(
            named: 'transcriptionExternalStorage',
          ),
        ),
      ).thenAnswer((_) async => const Result.success(none));
      when(
        permissions.stopTranscription,
      ).thenAnswer((_) async => const Result.success(none));
      final call = harness.buildCall();

      await call.startTranscription();
      expect(call.state.value.isTranscribing, isTrue);
      await call.stopTranscription();
      expect(call.state.value.isTranscribing, isFalse);
    });

    test('captioning follows a successful start and stop', () async {
      when(
        () => permissions.startClosedCaptions(
          enableTranscription: any(named: 'enableTranscription'),
          language: any(named: 'language'),
          transcriptionExternalStorage: any(
            named: 'transcriptionExternalStorage',
          ),
        ),
      ).thenAnswer((_) async => const Result.success(none));
      when(
        permissions.stopClosedCaptions,
      ).thenAnswer((_) async => const Result.success(none));
      final call = harness.buildCall();

      await call.startClosedCaptions();
      expect(call.state.value.isCaptioning, isTrue);
      await call.stopClosedCaptions();
      expect(call.state.value.isCaptioning, isFalse);
    });

    test('broadcasting follows HLS, with the playlist url', () async {
      when(
        permissions.startBroadcasting,
      ).thenAnswer((_) async => const Result.success('https://hls.m3u8'));
      when(
        permissions.stopBroadcasting,
      ).thenAnswer((_) async => const Result.success(none));
      final call = harness.buildCall();

      await call.startHLS();
      expect(call.state.value.isBroadcasting, isTrue);
      expect(call.state.value.egress.hlsPlaylistUrl, 'https://hls.m3u8');
      await call.stopHLS();
      expect(call.state.value.isBroadcasting, isFalse);
    });

    test('a refused HLS start leaves broadcasting off', () async {
      when(permissions.startBroadcasting).thenAnswer((_) async => refused);
      final call = harness.buildCall();

      await call.startHLS();

      expect(call.state.value.isBroadcasting, isFalse);
    });

    test('going live leaves the backstage, stopping returns to it', () async {
      final metadata = Result.success(SampleCallData.defaultCallMetadata);
      when(
        () => harness.coordinatorClient.goLive(
          callCid: any(named: 'callCid'),
          startHls: any(named: 'startHls'),
          startRecording: any(named: 'startRecording'),
          startCompositeRecording: any(named: 'startCompositeRecording'),
          startIndividualRecording: any(named: 'startIndividualRecording'),
          startRawRecording: any(named: 'startRawRecording'),
          startTranscription: any(named: 'startTranscription'),
          startClosedCaption: any(named: 'startClosedCaption'),
          recordingStorageName: any(named: 'recordingStorageName'),
          transcriptionStorageName: any(named: 'transcriptionStorageName'),
        ),
      ).thenAnswer((_) async => metadata);
      when(
        () => harness.coordinatorClient.stopLive(
          any(),
          continueClosedCaption: any(named: 'continueClosedCaption'),
          continueCompositeRecording: any(named: 'continueCompositeRecording'),
          continueHls: any(named: 'continueHls'),
          continueIndividualRecording: any(
            named: 'continueIndividualRecording',
          ),
          continueRawRecording: any(named: 'continueRawRecording'),
          continueRecording: any(named: 'continueRecording'),
          continueRtmpBroadcasts: any(named: 'continueRtmpBroadcasts'),
          continueTranscription: any(named: 'continueTranscription'),
        ),
      ).thenAnswer((_) async => metadata);
      final call = harness.buildCall();

      await call.goLive(startHls: true);
      expect(call.state.value.isBackstage, isFalse);
      verify(
        () => harness.coordinatorClient.goLive(callCid: cid, startHls: true),
      ).called(1);
      await call.stopLive();
      expect(call.state.value.isBackstage, isTrue);
    });
  });

  group('collectUserFeedback', () {
    test('rejects a rating outside 1 to 5', () {
      final call = harness.buildCall();

      expect(
        () => call.collectUserFeedback(rating: 0),
        throwsArgumentError,
      );
      expect(
        () => call.collectUserFeedback(rating: 6),
        throwsArgumentError,
      );
    });

    test('rejects feedback outside a call session', () {
      final call = harness.buildCall();

      expect(
        () => call.collectUserFeedback(rating: 4),
        throwsArgumentError,
      );
    });

    test('sends the session id as both session and user session', () async {
      when(
        () => harness.coordinatorClient.collectUserFeedback(
          callType: any(named: 'callType'),
          callId: any(named: 'callId'),
          sessionId: any(named: 'sessionId'),
          rating: any(named: 'rating'),
          sdk: any(named: 'sdk'),
          sdkVersion: any(named: 'sdkVersion'),
          userSessionId: any(named: 'userSessionId'),
          reason: any(named: 'reason'),
          custom: any(named: 'custom'),
        ),
      ).thenAnswer((_) async => const Result.success(none));
      final call = harness.buildCall();
      await call.join();

      await call.collectUserFeedback(rating: 4, reason: 'good');

      verify(
        () => harness.coordinatorClient.collectUserFeedback(
          callType: cid.type.value,
          callId: cid.id,
          sessionId: 'session-0',
          rating: 4,
          sdk: any(named: 'sdk'),
          sdkVersion: any(named: 'sdkVersion'),
          userSessionId: 'session-0',
          reason: 'good',
        ),
      ).called(1);
    });
  });
}
