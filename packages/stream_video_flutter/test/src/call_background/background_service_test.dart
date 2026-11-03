import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter_method_channel.dart';
import 'package:stream_video_flutter/stream_video_flutter_platform_interface.dart';

import '../mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannelStreamVideoFlutter platform;
  late MockStreamVideo streamVideo;
  late MockCall call;

  /// What the client hands the service as the calls in progress.
  late void Function(List<Call>) reportActiveCalls;

  setUpAll(() => registerFallbackValue(const DisconnectReason.left()));

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;

    platform = MethodChannelStreamVideoFlutter();
    StreamVideoFlutterPlatform.instance = platform;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, (methodCall) async {
          // Nothing is running yet, so a start goes through.
          if (methodCall.method == 'isBackgroundServiceRunning') return false;
          return true;
        });

    final devices = MockRtcMediaDeviceNotifier();
    when(
      devices.nativeWebRtcEventsStream,
    ).thenAnswer((_) => const Stream.empty());
    RtcMediaDeviceNotifier.instance = devices;

    streamVideo = MockStreamVideo();
    when(() => streamVideo.options).thenReturn(StreamVideoOptions());
    when(() => streamVideo.listenActiveCalls(any())).thenAnswer((invocation) {
      reportActiveCalls =
          invocation.positionalArguments.single as void Function(List<Call>);
      return const Stream<List<Call>>.empty().listen(null);
    });

    final callState = MockCallState();
    when(() => callState.preferences).thenReturn(DefaultCallPreferences());
    final state = MockStateEmitter<CallState>();
    when(() => state.value).thenReturn(callState);
    when(
      () => state.listen(any()),
    ).thenAnswer((_) => const Stream<CallState>.empty().listen(null));

    call = MockCall();
    when(() => call.callCid).thenReturn(StreamCallCid(cid: 'default:1'));
    when(() => call.state).thenAnswer((_) => state);
    when(
      () => call.leave(reason: any(named: 'reason')),
    ).thenAnswer((_) async => const Result.success(none));
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, null);
    RtcMediaDeviceNotifier.instance = null;
    CurrentPlatform.debugCurrentPlatformOverride = null;
  });

  // Swiping the app away destroys the Activity while the call service keeps
  // the process alive; the app made that leave, not the user.
  test('leaves the calls it manages as the app when the UI goes', () async {
    StreamBackgroundService.init(
      streamVideo,
      callNotificationOptionsBuilder: (_) => const NotificationOptions(),
    );
    reportActiveCalls([call]);
    await pumpEventQueue();

    platform.onBackgroundNotificationUiLayerDestroyed!('');
    await pumpEventQueue();

    verify(
      () => call.leave(
        reason: const DisconnectReason.left(
          initiator: LeaveInitiator.app,
          message: 'app UI destroyed',
        ),
      ),
    ).called(1);
  });
}
