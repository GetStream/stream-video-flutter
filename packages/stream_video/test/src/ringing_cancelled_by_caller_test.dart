// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../test_helpers.dart';

class MockPushNotificationManager extends Mock
    implements PushNotificationManager {}

/// A call that is only ringing has never connected, so `Call._observeEvents`
/// has not run for it: it sees no coordinator events of its own, and nothing
/// else ends it when the caller withdraws the call. Left ringing, it stays in
/// `state.incomingCall` until the auto-reject timeout, long enough for an app
/// to raise a screen for a call that is already over.
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

  group('a ringing call the caller cancels', () {
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

    /// Delivers a `call.rejected` for [cid], rejected by [rejectedBy].
    void reject(String rejectedBy) {
      streamVideo.debugHandleCoordinatorEvent(
        CoordinatorCallRejectedEvent(
          callCid: StreamCallCid(cid: cid),
          rejectedBy: CallUser(
            id: rejectedBy,
            name: rejectedBy,
            roles: const [],
            image: '',
          ),
          createdAt: DateTime.now(),
          metadata: metadataCreatedBy(caller),
          user: CallUser(
            id: rejectedBy,
            name: rejectedBy,
            roles: const [],
            image: '',
          ),
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

    tearDown(() async {
      await streamVideo.dispose();
      await StreamVideo.reset();
    });

    test('stops being the incoming call', () async {
      ring();
      final ringing = streamVideo.state.incomingCall.value;
      expect(ringing, isNotNull, reason: 'the ring should have been published');

      reject(caller);
      await pumpEventQueue();

      // An app listening on `incomingCall` has to be told the call is over, or
      // it opens a screen for a call nobody is on.
      expect(streamVideo.state.incomingCall.value, isNull);
      expect(ringing!.state.value.status.isDisconnected, isTrue);
    });

    test('is not handed back to the next consume for the same cid', () async {
      ring();
      final cancelled = streamVideo.state.incomingCall.value;

      reject(caller);
      await pumpEventQueue();

      // The ringing cache is what a later consume reuses. Holding the
      // cancelled call there hands that dead instance back as if it were the
      // new ring, and its join is then rejected as "call was left".
      final consumed = await streamVideo.consumeIncomingCall(
        uuid: 'DF7082E5-D3F5-4244-B96B-F10DF50E8CF6',
        cid: cid,
        metadata: metadataCreatedBy(caller),
      );

      final call = consumed.getDataOrNull();
      expect(call, isNotNull);
      expect(call, isNot(same(cancelled)));
      expect(call!.state.value.status.isDisconnected, isFalse);
    });

    test('is left alone when another member rejects', () async {
      ring();
      final ringing = streamVideo.state.incomingCall.value;

      // Somebody else declining says nothing about our own ringing.
      reject('another-member');
      await pumpEventQueue();

      expect(streamVideo.state.incomingCall.value, same(ringing));
      expect(ringing!.state.value.status.isDisconnected, isFalse);
    });
  });
}
