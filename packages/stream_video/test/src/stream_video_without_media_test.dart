import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../test_helpers.dart';
import 'fixtures/stream_video_fixture.dart';

class _MockPushNotificationManager extends Mock
    implements PushNotificationManager {}

class _MockRtcMediaDeviceNotifier extends Mock
    implements RtcMediaDeviceNotifier {}

/// Pins that a client built for a background push sets up no media, also
/// while it accepts or declines a ring.
void main() {
  const cid = 'default:ringing-call';
  final callCid = StreamCallCid(cid: cid);

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(const UserInfo(id: 'fallback'));
    registerFallbackValue(callCid);
    registerFallbackValue(const BroadcasterAudioPolicy());
  });

  late _MockRtcMediaDeviceNotifier notifier;
  late _MockPushNotificationManager push;
  late StreamController<RingingEvent> nativeEvents;

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    notifier = _MockRtcMediaDeviceNotifier();
    when(
      () => notifier.reinitializeAudioConfiguration(any()),
    ).thenAnswer((_) async {});
    RtcMediaDeviceNotifier.instance = notifier;

    push = _MockPushNotificationManager();
    nativeEvents = StreamController<RingingEvent>.broadcast();
    when(() => push.onCallEvent).thenAnswer((_) => nativeEvents.stream);
    when(push.dispose).thenAnswer((_) async {});
    when(
      () => push.endCallByCid(any(), silent: any(named: 'silent')),
    ).thenAnswer((_) async {});
  });

  tearDown(() async {
    RtcMediaDeviceNotifier.instance = null;
    CurrentPlatform.debugCurrentPlatformOverride = null;
    await nativeEvents.close();
  });

  StreamVideoFixture buildFixture() {
    final fixture = StreamVideoFixture(
      pushNotificationManagerProvider: (_, _) => push,
    );
    when(
      () => fixture.client.rejectCall(
        cid: any(named: 'cid'),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer((_) async => const Result.success(none));
    when(
      () => fixture.client.acceptCall(cid: any(named: 'cid')),
    ).thenAnswer((_) async => const Result.success(none));
    return fixture;
  }

  Call ring(StreamVideoFixture fixture) {
    fixture.streamVideo.debugHandleCoordinatorEvent(
      CoordinatorCallRingingEvent(
        data: CallRingingData(
          callCid: callCid,
          ringing: true,
          metadata: CallMetadata(
            cid: callCid,
            details: createTestCallDetails(createdByUserId: 'caller'),
            settings: const CallSettings(),
            session: const CallSessionData(),
            users: const {},
            members: const {},
          ),
        ),
        video: false,
        sessionId: 'session-id',
        createdAt: DateTime.now(),
      ),
    );
    return fixture.streamVideo.state.incomingCall.value!;
  }

  test('declining a ring touches no media', () async {
    final fixture = await StreamVideo.runWithoutMedia(buildFixture);
    addTearDown(fixture.dispose);
    await fixture.streamVideo.ready;
    await expectLater(fixture.streamVideo.webrtcInitialized, completes);

    ring(fixture);
    fixture.streamVideo.ringing.observeCallDeclinedRingingEvent();
    nativeEvents.add(
      const ActionCallDecline(
        data: CallData(uuid: 'u', callCid: cid),
      ),
    );
    await pumpEventQueue();

    verify(
      () => fixture.client.rejectCall(
        cid: callCid,
        reason: CallRejectReason.decline().value,
      ),
    ).called(1);
    verifyZeroInteractions(notifier);
  });

  test('accepting a ring touches no media', () async {
    final fixture = await StreamVideo.runWithoutMedia(buildFixture);
    addTearDown(fixture.dispose);
    await fixture.streamVideo.ready;
    await expectLater(fixture.streamVideo.webrtcInitialized, completes);

    final call = ring(fixture);
    expect((await call.accept()).isSuccess, isTrue);

    verifyZeroInteractions(notifier);
  });

  test('a ring from a client built without media cannot be joined', () async {
    final fixture = await StreamVideo.runWithoutMedia(buildFixture);
    addTearDown(fixture.dispose);
    await fixture.streamVideo.ready;

    final result = await ring(fixture).join();

    expect(result.getErrorOrNull(), isA<CallWithoutMediaException>());
    verifyNever(
      () => fixture.client.joinCall(
        callCid: any(named: 'callCid'),
        ringing: any(named: 'ringing'),
        create: any(named: 'create'),
        migratingFrom: any(named: 'migratingFrom'),
        migratingFromList: any(named: 'migratingFromList'),
        video: any(named: 'video'),
        membersLimit: any(named: 'membersLimit'),
        hintHighScaleLivestreamPublisher: any(
          named: 'hintHighScaleLivestreamPublisher',
        ),
        e2ee: any(named: 'e2ee'),
      ),
    );
    verifyZeroInteractions(notifier);
  });

  test('a client built outside it applies the audio configuration', () async {
    final fixture = buildFixture();
    addTearDown(fixture.dispose);
    await fixture.streamVideo.ready;

    verify(() => notifier.reinitializeAudioConfiguration(any())).called(1);
  });

  test('joining a ring on a client built outside it observes the '
      'notifier', () async {
    when(
      () => notifier.webAudioPlaybackBlockedChanges,
    ).thenAnswer((_) => const Stream.empty());
    when(
      notifier.nativeWebRtcEventsStream,
    ).thenAnswer((_) => const Stream.empty());
    final fixture = buildFixture();
    addTearDown(fixture.dispose);
    when(
      () => fixture.client.joinCall(
        callCid: any(named: 'callCid'),
        ringing: any(named: 'ringing'),
        create: any(named: 'create'),
        migratingFrom: any(named: 'migratingFrom'),
        migratingFromList: any(named: 'migratingFromList'),
        video: any(named: 'video'),
        membersLimit: any(named: 'membersLimit'),
        hintHighScaleLivestreamPublisher: any(
          named: 'hintHighScaleLivestreamPublisher',
        ),
        e2ee: any(named: 'e2ee'),
      ),
    ).thenAnswer((_) async => failureWithError('join refused'));
    await fixture.streamVideo.ready;

    final call = ring(fixture);
    // The join observes the notifier as it starts; the rest of it is not
    // under test, so the call is left right after.
    unawaited(call.join());
    await pumpEventQueue();

    verify(() => notifier.webAudioPlaybackBlockedChanges).called(1);
    await call.leave();
  });

  test('ready and the WebRTC set-up complete when the audio configuration '
      'fails', () async {
    when(
      () => notifier.reinitializeAudioConfiguration(any()),
    ).thenThrow(StateError('audio session'));
    final fixture = buildFixture();
    addTearDown(fixture.dispose);

    await expectLater(fixture.streamVideo.ready, completes);
    await expectLater(fixture.streamVideo.webrtcInitialized, completes);
  });
}
