import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: implementation_imports
import 'package:stream_video/src/core/client_state.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';

// Pins when the manager reports the app's outgoing calls to CallKit: only on
// iOS with `reportOutgoingCalls` on, and no longer once it is disposed. What
// the reporter does with a call is pinned in outgoing_call_reporter_test.dart.

class _FakePushPlatform extends StreamVideoPushNotificationPlatform {
  @override
  Future<void> init(Map<String, dynamic> pushConfiguration) async {}

  @override
  Future<List<CallData>> activeCalls() async => const [];

  @override
  Stream<RingingEvent?> get onEvent => const Stream.empty();

  @override
  Future<String> getDevicePushTokenVoIP() async => 'voip-token';
}

class _MockCoordinatorClient extends Mock implements CoordinatorClient {}

// ignore: subtype_of_sealed_class
class _MockStreamVideo extends Mock implements StreamVideo {
  // StreamVideo marks dispose as @mustBeOverridden.
  @override
  Future<void> dispose() =>
      noSuchMethod(Invocation.method(#dispose, const [])) as Future<void>;
}

class _MockClientState extends Mock implements ClientState {}

class _MockCall extends Mock implements Call {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockCoordinatorClient client;
  late _MockStreamVideo streamVideo;
  late MutableStateEmitter<Call?> outgoingCall;

  setUp(() {
    StreamVideoPushNotificationPlatform.instance = _FakePushPlatform();
    SharedPreferences.setMockInitialValues({});

    client = _MockCoordinatorClient();
    final state = _MockClientState();
    // `thenAnswer`, not `thenReturn`: a StateEmitter is a Stream, which
    // mocktail refuses to return directly.
    final activeCalls = MutableStateEmitter<List<Call>>(const <Call>[]);
    outgoingCall = MutableStateEmitter<Call?>(null);
    when(() => state.activeCalls).thenAnswer((_) => activeCalls);
    when(() => state.outgoingCall).thenAnswer((_) => outgoingCall);
    streamVideo = _MockStreamVideo();
    when(() => streamVideo.state).thenReturn(state);
  });

  tearDown(() {
    CurrentPlatform.debugCurrentPlatformOverride = null;
  });

  StreamVideoPushNotificationManager createManager({
    required bool reportOutgoingCalls,
  }) {
    return StreamVideoPushNotificationManager.create(
      iosPushProvider: const StreamVideoPushProvider.apn(name: 'apn'),
      androidPushProvider: const StreamVideoPushProvider.firebase(name: 'fcm'),
      pushConfiguration: StreamVideoPushConfiguration(
        ios: IOSPushConfiguration(reportOutgoingCalls: reportOutgoingCalls),
      ),
    )(client, streamVideo);
  }

  /// A call ringing out; the reporter follows it through its status.
  _MockCall ringOut() {
    final call = _MockCall();
    when(
      () => call.partialState<CallStatus>(any()),
    ).thenAnswer((_) => const Stream.empty());
    outgoingCall.value = call;
    return call;
  }

  test(
    'on iOS with reportOutgoingCalls the outgoing call is followed',
    () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
      final manager = createManager(reportOutgoingCalls: true);
      addTearDown(manager.dispose);

      final call = ringOut();
      await pumpEventQueue();

      verify(() => call.partialState<CallStatus>(any())).called(1);
    },
  );

  test('on iOS without reportOutgoingCalls it is not', () async {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
    final manager = createManager(reportOutgoingCalls: false);
    addTearDown(manager.dispose);

    final call = ringOut();
    await pumpEventQueue();

    verifyNever(() => call.partialState<CallStatus>(any()));
  });

  test('on Android reportOutgoingCalls has no effect', () async {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    final manager = createManager(reportOutgoingCalls: true);
    addTearDown(manager.dispose);

    final call = ringOut();
    await pumpEventQueue();

    verifyNever(() => call.partialState<CallStatus>(any()));
  });

  test('once the manager is disposed no outgoing call is followed', () async {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
    final manager = createManager(reportOutgoingCalls: true);

    await manager.dispose();
    final call = ringOut();
    await pumpEventQueue();

    verifyNever(() => call.partialState<CallStatus>(any()));
  });
}
