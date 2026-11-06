import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: implementation_imports
import 'package:stream_video/src/core/client_state.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';

// Pins the manager's wiring of the device registrar: the token it hands over
// as the device's own is the platform's VoIP token on iOS, and the registrar
// is reached through the public `create` factory. The registrar's own rules
// are pinned in push_device_registrar_test.dart.

const _voipToken = 'voip-token';

class _FakePushPlatform extends StreamVideoPushNotificationPlatform {
  @override
  Future<void> init(Map<String, dynamic> pushConfiguration) async {}

  @override
  Future<List<CallData>> activeCalls() async => const [];

  @override
  Stream<RingingEvent?> get onEvent => const Stream.empty();

  @override
  Future<String> getDevicePushTokenVoIP() async => _voipToken;
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

  late _MockCoordinatorClient client;
  late _MockStreamVideo streamVideo;

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
    StreamVideoPushNotificationPlatform.instance = _FakePushPlatform();
    SharedPreferences.setMockInitialValues({});

    client = _MockCoordinatorClient();
    when(
      () => client.deleteDevice(id: any(named: 'id')),
    ).thenAnswer((_) async => const Result.success(none));

    final state = _MockClientState();
    // `thenAnswer`, not `thenReturn`: a StateEmitter is a Stream, which
    // mocktail refuses to return directly.
    final activeCalls = MutableStateEmitter<List<Call>>(const <Call>[]);
    when(() => state.activeCalls).thenAnswer((_) => activeCalls);
    streamVideo = _MockStreamVideo();
    when(() => streamVideo.state).thenReturn(state);
  });

  tearDown(() {
    CurrentPlatform.debugCurrentPlatformOverride = null;
  });

  test(
    'unregisterDevice deletes the VoIP token the platform reports',
    () async {
      final manager = StreamVideoPushNotificationManager.create(
        iosPushProvider: const StreamVideoPushProvider.apn(name: 'apn'),
        androidPushProvider: const StreamVideoPushProvider.firebase(
          name: 'fcm',
        ),
      )(client, streamVideo);
      addTearDown(manager.dispose);

      await manager.unregisterDevice();

      verify(() => client.deleteDevice(id: _voipToken)).called(1);
      verifyNoMoreInteractions(client);
    },
  );

  test('getDevicePushTokenVoIP is the platform VoIP token on iOS', () async {
    final manager = StreamVideoPushNotificationManager.create(
      iosPushProvider: const StreamVideoPushProvider.apn(name: 'apn'),
      androidPushProvider: const StreamVideoPushProvider.firebase(name: 'fcm'),
    )(client, streamVideo);
    addTearDown(manager.dispose);

    expect(await manager.getDevicePushTokenVoIP(), _voipToken);
  });
}
