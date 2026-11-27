import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../test_helpers.dart';
import 'fixtures/stream_video_fixture.dart';

class _MockPushNotificationManager extends Mock
    implements PushNotificationManager {}

/// A manager that keeps [PushNotificationManager]'s defaults.
// ignore: prefer_mixin
class _DefaultsManager extends PushNotificationManager with Mock {}

/// Pins that on Android the client has the active call the system routes to
/// an output follow it, such as a call Telecom holds.
void main() {
  const bluetooth = RtcMediaDevice(
    id: 'bluetooth',
    label: 'Headset',
    groupId: 'bluetooth',
    kind: RtcMediaDeviceKind.audioOutput,
  );

  late _MockPushNotificationManager push;
  late StreamController<({String callCid, RtcMediaDevice device})> outputs;

  setUpAll(() => registerFallbackValue(bluetooth));

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    outputs = StreamController.broadcast();
    push = _MockPushNotificationManager();
    when(() => push.systemAudioOutputs).thenAnswer((_) => outputs.stream);
    when(
      () => push.systemManagedCallCids,
    ).thenAnswer((_) => Stream.value(const {}));
    when(() => push.onCallEvent).thenAnswer((_) => const Stream.empty());
    when(push.dispose).thenAnswer((_) async {});
  });

  tearDown(() async {
    CurrentPlatform.debugCurrentPlatformOverride = null;
    await outputs.close();
  });

  StreamVideoFixture client() {
    final fixture = StreamVideoFixture(
      options: StreamVideoOptions(
        autoConnect: false,
        allowMultipleActiveCalls: true,
        multiCallAudioPolicy: MultiCallAudioPolicy.manual,
      ),
      pushNotificationManagerProvider: (_, _) => push,
    );
    addTearDown(fixture.dispose);
    return fixture;
  }

  MockCall activeCall(String cid) {
    final call = MockCall();
    when(() => call.callCid).thenReturn(StreamCallCid(cid: cid));
    when(() => call.followSystemAudioOutput(any())).thenAnswer((_) async {});
    return call;
  }

  void setActiveCalls(StreamVideoFixture fixture, List<Call> calls) {
    (fixture.streamVideo.state.activeCalls as MutableStateEmitter<List<Call>>)
            .value =
        calls;
  }

  test('the active call the output names follows it', () async {
    final fixture = client();
    final routed = activeCall('default:c1');
    final other = activeCall('default:c2');
    setActiveCalls(fixture, [routed, other]);

    outputs.add((callCid: 'default:c1', device: bluetooth));
    await pumpEventQueue();

    verify(() => routed.followSystemAudioOutput(bluetooth)).called(1);
    verifyNever(() => other.followSystemAudioOutput(any()));
  });

  test('an output for a call that is not active changes nothing', () async {
    final fixture = client();
    final call = activeCall('default:c1');
    setActiveCalls(fixture, [call]);

    outputs.add((callCid: 'default:other', device: bluetooth));
    await pumpEventQueue();

    verifyNever(() => call.followSystemAudioOutput(any()));
  });

  test('a call that fails to follow does not stop the next one', () async {
    final fixture = client();
    final call = activeCall('default:c1');
    when(
      () => call.followSystemAudioOutput(any()),
    ).thenAnswer((_) async => throw StateError('gone'));
    setActiveCalls(fixture, [call]);

    outputs
      ..add((callCid: 'default:c1', device: bluetooth))
      ..add((callCid: 'default:c1', device: bluetooth));
    await pumpEventQueue();

    verify(() => call.followSystemAudioOutput(bluetooth)).called(2);
  });

  test('nothing is followed after the client is disposed', () async {
    final fixture = client();
    final call = activeCall('default:c1');

    await fixture.streamVideo.dispose();
    // Disposing clears the active calls, so one is set again.
    setActiveCalls(fixture, [call]);
    outputs.add((callCid: 'default:c1', device: bluetooth));
    await pumpEventQueue();

    verifyNever(() => call.followSystemAudioOutput(any()));
  });

  test('nothing is followed off Android', () async {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
    final fixture = client();
    final call = activeCall('default:c1');
    setActiveCalls(fixture, [call]);

    outputs.add((callCid: 'default:c1', device: bluetooth));
    await pumpEventQueue();

    verifyNever(() => call.followSystemAudioOutput(any()));
    verifyNever(() => push.systemAudioOutputs);
  });

  test('a manager that keeps the default reports no outputs', () async {
    final defaults = _DefaultsManager();

    expect(await defaults.systemAudioOutputs.isEmpty, isTrue);
  });
}
