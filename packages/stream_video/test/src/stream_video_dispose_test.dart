// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../test_helpers.dart';

class MockPushNotificationManager extends Mock
    implements PushNotificationManager {}

/// Pins that disposing the client disposes the calls it tracks.
void main() {
  const cid = 'default:ringing-call';
  const caller = 'caller-user';

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    registerFallbackValue(
      StreamCallCid.from(
        type: StreamCallType.defaultType(),
        id: 'fallback-call-id',
      ),
    );
  });

  group('StreamVideo.dispose', () {
    late StreamVideo streamVideo;
    late MockCoordinatorClient mockCoordinatorClient;
    late MockPushNotificationManager mockPushManager;

    CallMetadata metadataCreatedBy(String userId) => CallMetadata(
      cid: StreamCallCid(cid: cid),
      details: createTestCallDetails(createdByUserId: userId),
      settings: const CallSettings(),
      session: const CallSessionData(),
      users: const {},
      members: const {},
    );

    /// Rings [streamVideo] for a call created by [caller].
    void ring() {
      streamVideo.debugHandleCoordinatorEvent(
        CoordinatorCallRingingEvent(
          data: CallRingingData(
            callCid: StreamCallCid(cid: cid),
            ringing: true,
            metadata: metadataCreatedBy(caller),
          ),
          video: false,
          sessionId: 'session-id',
          createdAt: DateTime.now(),
        ),
      );
    }

    setUp(() {
      mockCoordinatorClient = MockCoordinatorClient();
      mockPushManager = MockPushNotificationManager();

      when(
        () => mockPushManager.endCallByCid(any(), silent: any(named: 'silent')),
      ).thenAnswer((_) async {});
      when(mockPushManager.dispose).thenAnswer((_) async {});

      // `thenAnswer`, not `thenReturn`: a SharedEmitter is a Stream, which
      // mocktail refuses to hand back from `thenReturn`.
      final coordinatorEvents = MutableSharedEmitter<CoordinatorEvent>();
      when(() => mockCoordinatorClient.events).thenAnswer(
        (_) => coordinatorEvents,
      );

      streamVideo = StreamVideo.create(
        'test-api-key',
        user: const User(id: 'test-user', name: 'Test User'),
        userToken:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiSm9obiBEb2UifQ.hrrtiYCtfs2cowE2sx2dypxoXhsEE8pQl-V6Nq4i8qU',
        options: StreamVideoOptions(
          allowMultipleActiveCalls: true,
          autoConnect: false,
        ),
        pushNotificationManagerProvider: (_, _) => mockPushManager,
      );
    });

    tearDown(StreamVideo.reset);

    test('disposes a ringing call', () async {
      ring();
      final ringing = streamVideo.state.incomingCall.value!;
      final stateDone = ringing.state.drain<void>();
      // The calls go first, while the push manager can still end theirs.
      Call? incomingWhenPushDisposed = ringing;
      when(mockPushManager.dispose).thenAnswer((_) async {
        incomingWhenPushDisposed = streamVideo.state.incomingCall.value;
      });

      await streamVideo.dispose();

      expect(incomingWhenPushDisposed, isNull);

      await stateDone.timeout(const Duration(seconds: 5));
      expect(streamVideo.state.incomingCall.value, isNull);
      expect((await ringing.join()).getErrorOrNull(), isA<CallLeftException>());
    });

    test('ends the native call of a ringing call', () async {
      ring();
      final ringing = streamVideo.state.incomingCall.value!;

      await streamVideo.dispose();

      verify(() => mockPushManager.endCallByCid(cid, silent: true)).called(1);
      expect(ringing.state.value.status, isA<CallStatusDisconnected>());
    });

    test(
      'leaves the native call alone when another instance joined the call',
      () async {
        ring();
        final ringing = streamVideo.state.incomingCall.value!;
        final joined = streamVideo.makeCall(
          callType: StreamCallType.defaultType(),
          id: StreamCallCid(cid: cid).id,
        );
        await streamVideo.state.setActiveCall(joined);

        await ringing.dispose();

        verifyNever(
          () =>
              mockPushManager.endCallByCid(any(), silent: any(named: 'silent')),
        );
        expect(ringing.state.value.status, isA<CallStatusDisconnected>());
      },
    );

    test('disposes an outgoing and a watched call', () async {
      final outgoing = streamVideo.makeCall(
        callType: StreamCallType.defaultType(),
        id: 'outgoing',
      );
      final watched = streamVideo.makeCall(
        callType: StreamCallType.defaultType(),
        id: 'watched',
      );
      await streamVideo.state.setOutgoingCall(outgoing);
      streamVideo.state.setWatchedCall(watched);
      final done = Future.wait([
        outgoing.state.drain<void>(),
        watched.state.drain<void>(),
      ]);

      await streamVideo.dispose();

      await done.timeout(const Duration(seconds: 5));
      expect(streamVideo.state.watchedCalls.value, isEmpty);
    });
  });
}
