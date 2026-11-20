import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: implementation_imports
import 'package:stream_video/src/core/client_state.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';

// Pins that the manager carries out what core tells it about a call's native
// UI: a ring that is over, a call left, a call accepted in the app.

class _RecordingPlatform extends StreamVideoPushNotificationPlatform {
  List<CallData> active = const [];
  final calls = <String>[];

  @override
  Future<void> init(Map<String, dynamic> pushConfiguration) async {}

  @override
  Stream<RingingEvent?> get onEvent => const Stream.empty();

  @override
  Future<List<CallData>> activeCalls() async => active;

  @override
  Future<void> endCall(String id) async => calls.add('endCall:$id');

  @override
  Future<void> endAllCalls() async => calls.add('endAllCalls');

  @override
  Future<void> dismissRingingCall(
    String cid, {
    CallDismissReason reason = CallDismissReason.accepted,
  }) async => calls.add('dismissRingingCall:$cid:${reason.name}');
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const cid = 'default:c1';

  late _RecordingPlatform platform;
  late StreamVideoPushNotificationManager manager;

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    platform = _RecordingPlatform();
    StreamVideoPushNotificationPlatform.instance = platform;
    SharedPreferences.setMockInitialValues({});

    final state = _MockClientState();
    when(
      () => state.activeCalls,
    ).thenAnswer((_) => MutableStateEmitter<List<Call>>(const <Call>[]));
    when(
      () => state.outgoingCall,
    ).thenAnswer((_) => MutableStateEmitter<Call?>(null));
    final streamVideo = _MockStreamVideo();
    when(() => streamVideo.state).thenReturn(state);

    manager = StreamVideoPushNotificationManager.create(
      iosPushProvider: const StreamVideoPushProvider.apn(name: 'apn'),
      androidPushProvider: const StreamVideoPushProvider.firebase(name: 'fcm'),
    )(_MockCoordinatorClient(), streamVideo);
    addTearDown(manager.dispose);
  });

  tearDown(() {
    CurrentPlatform.debugCurrentPlatformOverride = null;
  });

  test('a ring that is over ends only a ring not answered', () async {
    platform.active = const [
      CallData(uuid: 'u1', callCid: cid, isAccepted: true),
    ];
    await manager.onRingEnded(cid);
    platform.active = const [CallData(uuid: 'u1', callCid: cid)];
    await manager.onRingEnded(cid);

    expect(platform.calls, ['endAllCalls']);
  });

  test('a call left is ended once listed, answered or not', () async {
    await manager.onCallLeft(cid);
    platform.active = const [
      CallData(uuid: 'u1', callCid: cid, isAccepted: true),
    ];
    await manager.onCallLeft(cid);

    expect(platform.calls, ['endAllCalls']);
  });

  test('a call accepted in the app has its ring dismissed', () async {
    platform.active = const [CallData(uuid: 'u1', callCid: cid)];

    await manager.onCallAccepted(cid);

    expect(platform.calls, ['dismissRingingCall:$cid:accepted']);
  });
}
