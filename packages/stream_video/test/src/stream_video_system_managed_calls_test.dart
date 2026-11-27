import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/call/media/ios_broadcast_screen_share.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/webrtc_capabilities.dart';
import 'fixtures/stream_video_fixture.dart';

class _MockPushNotificationManager extends Mock
    implements PushNotificationManager {}

/// A manager that keeps [PushNotificationManager]'s defaults.
// ignore: prefer_mixin
class _DefaultsManager extends PushNotificationManager with Mock {}

// ignore: subtype_of_sealed_class, a mock for the tests
class _MockPlatformAudioController extends Mock
    implements PlatformAudioController {}

/// Pins that the client tells WebRTC the system manages Android audio focus
/// while one of its active calls is a call whose focus the system manages,
/// such as one Telecom holds, and that it no longer does after.
void main() {
  late _MockPlatformAudioController audio;
  late _MockPushNotificationManager push;
  late BehaviorSubject<Set<String>> systemManaged;
  late List<bool> handledBySystem;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    overrideWebRtcCapabilities(platform: PlatformType.android);
    registerFallbackValue(const AudioConfigurationPolicy.broadcaster());

    handledBySystem = [];
    audio = _MockPlatformAudioController();
    when(
      () => audio.reinitializeAudioConfiguration(any()),
    ).thenAnswer((_) async {});
    when(
      audio.nativeWebRtcEventsStream,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => audio.setAndroidAudioFocusHandledBySystem(
        handledBySystem: any(named: 'handledBySystem'),
      ),
    ).thenAnswer((invocation) async {
      handledBySystem.add(invocation.namedArguments[#handledBySystem] as bool);
    });
    PlatformAudioController.instance = audio;

    systemManaged = BehaviorSubject.seeded(const {});
    push = _MockPushNotificationManager();
    when(
      () => push.systemManagedCallCids,
    ).thenAnswer((_) => systemManaged.stream);
    when(() => push.onCallEvent).thenAnswer((_) => const Stream.empty());
    when(
      () => push.systemAudioOutputs,
    ).thenAnswer((_) => const Stream.empty());
    when(push.dispose).thenAnswer((_) async {});
  });

  tearDown(() async {
    IosBroadcastScreenShare.resetOwnership();
    PlatformAudioController.instance = null;
    CurrentPlatform.debugCurrentPlatformOverride = null;
    await systemManaged.close();
  });

  Future<(StreamVideoFixture, Call)> client({
    StreamVideoOptions? options,
  }) async {
    final fixture = StreamVideoFixture(
      options: options,
      pushNotificationManagerProvider: (_, _) => push,
    );
    addTearDown(fixture.dispose);
    final call = fixture.streamVideo.makeCall(
      callType: StreamCallType.defaultType(),
      id: 'c1',
    );
    await pumpEventQueue();
    return (fixture, call);
  }

  test('tells WebRTC at start that the system does not manage focus, so a '
      'value an earlier client left does not stand', () async {
    await client();

    expect(handledBySystem, [false]);
  });

  test('tells WebRTC the system manages focus while an active call is '
      'system managed, and that it no longer does after', () async {
    final (fixture, call) = await client();

    systemManaged.add({'default:c1'});
    await pumpEventQueue();
    expect(handledBySystem, [false]);

    await fixture.streamVideo.state.setActiveCall(call);
    await pumpEventQueue();
    expect(handledBySystem, [false, true]);

    systemManaged.add(const {});
    await pumpEventQueue();
    expect(handledBySystem, [false, true, false]);
  });

  test('no longer tells WebRTC the system manages focus once the call is not '
      'active, while the system still lists it', () async {
    final (fixture, call) = await client();
    systemManaged.add({'default:c1'});
    await fixture.streamVideo.state.setActiveCall(call);
    await pumpEventQueue();

    // A leave removes the call before it ends the system's call.
    await fixture.streamVideo.state.removeActiveCall(call);
    await pumpEventQueue();

    expect(handledBySystem, [false, true, false]);
  });

  test('with two active calls, follows the one the system manages', () async {
    final (fixture, managed) = await client(
      options: StreamVideoOptions(
        autoConnect: false,
        allowMultipleActiveCalls: true,
        multiCallAudioPolicy: MultiCallAudioPolicy.manual,
      ),
    );
    final other = fixture.streamVideo.makeCall(
      callType: StreamCallType.defaultType(),
      id: 'c2',
    );
    systemManaged.add({'default:c1'});
    await fixture.streamVideo.state.setActiveCall(other);
    await pumpEventQueue();
    expect(handledBySystem, [false]);

    await fixture.streamVideo.state.setActiveCall(managed);
    await pumpEventQueue();
    expect(handledBySystem, [false, true]);

    await fixture.streamVideo.state.removeActiveCall(other);
    await pumpEventQueue();
    expect(handledBySystem, [false, true]);

    await fixture.streamVideo.state.removeActiveCall(managed);
    await pumpEventQueue();
    expect(handledBySystem, [false, true, false]);
  });

  test('tells WebRTC nothing after the client is disposed', () async {
    final (fixture, call) = await client();

    await fixture.streamVideo.dispose();
    (fixture.streamVideo.state.activeCalls as MutableStateEmitter<List<Call>>)
        .value = [
      call,
    ];
    systemManaged.add({'default:c1'});
    await pumpEventQueue();

    expect(handledBySystem, [false]);
  });

  test('a manager that keeps the default reports no system-managed calls, so '
      'WebRTC is still told at start', () async {
    final defaults = _DefaultsManager();
    when(() => defaults.onCallEvent).thenAnswer((_) => const Stream.empty());
    when(defaults.dispose).thenAnswer((_) async {});
    final fixture = StreamVideoFixture(
      pushNotificationManagerProvider: (_, _) => defaults,
    );
    addTearDown(fixture.dispose);
    await pumpEventQueue();

    expect(handledBySystem, [false]);
  });

  test('a system-managed call that is not active changes nothing', () async {
    await client();

    systemManaged.add({'default:other'});
    await pumpEventQueue();

    expect(handledBySystem, [false]);
  });

  test('does nothing off Android', () async {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
    overrideWebRtcCapabilities(platform: PlatformType.ios);
    final (fixture, call) = await client();

    systemManaged.add({'default:c1'});
    await fixture.streamVideo.state.setActiveCall(call);
    await pumpEventQueue();

    expect(handledBySystem, isEmpty);
  });
}
