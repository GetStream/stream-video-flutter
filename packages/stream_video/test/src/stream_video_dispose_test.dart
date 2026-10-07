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

      await streamVideo.dispose();

      await stateDone.timeout(const Duration(seconds: 5));
      expect(ringing.state.value.status.isDisconnected, isTrue);
      expect((await ringing.join()).getErrorOrNull(), isA<CallLeftException>());
    });
  });
}
