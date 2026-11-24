import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/stream_video_fixture.dart';

class _MockPushNotificationManager extends Mock
    implements PushNotificationManager {}

class _MockRtcMediaDeviceNotifier extends Mock
    implements RtcMediaDeviceNotifier {}

/// Pins that the client tells WebRTC the system manages Android audio focus
/// while one of its active calls is a call whose focus the system manages,
/// such as one Telecom holds, and that it no longer does after.
void main() {
  late _MockRtcMediaDeviceNotifier notifier;
  late _MockPushNotificationManager push;
  late BehaviorSubject<Set<String>> systemManaged;
  late List<bool> handledBySystem;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    registerFallbackValue(const AudioConfigurationPolicy.broadcaster());

    handledBySystem = [];
    notifier = _MockRtcMediaDeviceNotifier();
    when(
      () => notifier.reinitializeAudioConfiguration(any()),
    ).thenAnswer((_) async {});
    when(
      () => notifier.setAndroidAudioFocusHandledBySystem(
        handledBySystem: any(named: 'handledBySystem'),
      ),
    ).thenAnswer((invocation) async {
      handledBySystem.add(invocation.namedArguments[#handledBySystem] as bool);
    });
    RtcMediaDeviceNotifier.instance = notifier;

    systemManaged = BehaviorSubject.seeded(const {});
    push = _MockPushNotificationManager();
    when(
      () => push.systemManagedCallCids,
    ).thenAnswer((_) => systemManaged.stream);
    when(() => push.onCallEvent).thenAnswer((_) => const Stream.empty());
    when(push.dispose).thenAnswer((_) async {});
  });

  tearDown(() async {
    RtcMediaDeviceNotifier.instance = null;
    CurrentPlatform.debugCurrentPlatformOverride = null;
    await systemManaged.close();
  });

  Future<(StreamVideoFixture, Call)> client() async {
    final fixture = StreamVideoFixture(
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

  test('a system-managed call that is not active changes nothing', () async {
    await client();

    systemManaged.add({'default:other'});
    await pumpEventQueue();

    expect(handledBySystem, [false]);
  });

  test('does nothing off Android', () async {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
    final (fixture, call) = await client();

    systemManaged.add({'default:c1'});
    await fixture.streamVideo.state.setActiveCall(call);
    await pumpEventQueue();

    expect(handledBySystem, isEmpty);
  });
}
