import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: implementation_imports
import 'package:stream_video/src/core/client_state.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';

const _voipToken = 'voip-token';
const _apnToken = 'apn-token';

class _FakePushPlatform extends StreamVideoPushNotificationPlatform {
  @override
  Future<void> init(Map<String, dynamic> pushConfiguration) async {}

  @override
  Future<dynamic> activeCalls() async => <dynamic>[];

  @override
  Stream<RingingEvent?> get onEvent => const Stream.empty();

  @override
  Future<String> getDevicePushTokenVoIP() async => _voipToken;
}

/// Hands out [apnToken] as the APN token Firebase reports for the device.
class _FakeFirebaseMessaging extends FirebaseMessagingPlatform {
  String? apnToken;

  @override
  FirebaseMessagingPlatform delegateFor({required FirebaseApp app}) => this;

  @override
  FirebaseMessagingPlatform setInitialValues({bool? isAutoInitEnabled}) => this;

  @override
  Future<String?> getAPNSToken() async => apnToken;
}

class _MockCoordinatorClient extends Mock implements CoordinatorClient {}

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
  // FirebaseMessaging caches its delegate, so every test shares one fake.
  final firebaseMessaging = _FakeFirebaseMessaging();

  setUpAll(() async {
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
    FirebaseMessagingPlatform.instance = firebaseMessaging;
  });

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
    StreamVideoPushNotificationPlatform.instance = _FakePushPlatform();

    firebaseMessaging.apnToken = _apnToken;

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

  /// Builds the manager through the public factory and waits for it to load
  /// its shared preferences.
  Future<StreamVideoPushNotificationManager> createManager({
    required bool registerApnDeviceToken,
    Map<String, Object> storedValues = const {},
  }) async {
    SharedPreferences.setMockInitialValues(storedValues);

    final manager = StreamVideoPushNotificationManager.create(
      iosPushProvider: const StreamVideoPushProvider.apn(name: 'apn'),
      androidPushProvider: const StreamVideoPushProvider.firebase(name: 'fcm'),
      registerApnDeviceToken: registerApnDeviceToken,
    )(client, streamVideo);
    addTearDown(manager.dispose);

    await pumpEventQueue();
    return manager;
  }

  List<String> deletedIds() => verify(
    () => client.deleteDevice(id: captureAny(named: 'id')),
  ).captured.cast<String>();

  group('unregisterDevice', () {
    test(
      'does not delete the APN token when registerApnDeviceToken is false',
      () async {
        // The APN token was never registered in this setup, so deleting it
        // failed with a 404 on every disconnect.
        final manager = await createManager(registerApnDeviceToken: false);

        await manager.unregisterDevice();

        expect(deletedIds(), [_voipToken]);
      },
    );

    test(
      'deletes the current APN token when registerApnDeviceToken is true',
      () async {
        final manager = await createManager(registerApnDeviceToken: true);

        await manager.unregisterDevice();

        expect(deletedIds(), [_voipToken, _apnToken]);
      },
    );

    test(
      'deletes a stored APN token after registerApnDeviceToken was disabled',
      () async {
        final manager = await createManager(
          registerApnDeviceToken: false,
          storedValues: {
            StreamVideoPushNotificationManager.userDeviceTokenKey: _apnToken,
          },
        );

        await manager.unregisterDevice();

        expect(deletedIds(), [_voipToken, _apnToken]);
      },
    );

    test(
      'deletes both the stored and the current APN token when they differ',
      () async {
        final manager = await createManager(
          registerApnDeviceToken: true,
          storedValues: {
            StreamVideoPushNotificationManager.userDeviceTokenKey:
                'old-apn-token',
          },
        );

        await manager.unregisterDevice();

        expect(deletedIds(), [_voipToken, 'old-apn-token', _apnToken]);
      },
    );

    test('deletes the same APN token only once', () async {
      final manager = await createManager(
        registerApnDeviceToken: true,
        storedValues: {
          StreamVideoPushNotificationManager.userDeviceTokenKey: _apnToken,
        },
      );

      await manager.unregisterDevice();

      expect(deletedIds(), [_voipToken, _apnToken]);
    });

    test('skips the APN token when Firebase reports none', () async {
      firebaseMessaging.apnToken = null;
      final manager = await createManager(registerApnDeviceToken: true);

      await manager.unregisterDevice();

      expect(deletedIds(), [_voipToken]);
    });

    test('clears the stored tokens', () async {
      final manager = await createManager(
        registerApnDeviceToken: false,
        storedValues: {
          StreamVideoPushNotificationManager.userDeviceTokenKey: _apnToken,
          StreamVideoPushNotificationManager.userDeviceTokenVoIPKey: _voipToken,
        },
      );

      await manager.unregisterDevice();

      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(StreamVideoPushNotificationManager.userDeviceTokenKey),
        isNull,
      );
      expect(
        prefs.getString(
          StreamVideoPushNotificationManager.userDeviceTokenVoIPKey,
        ),
        isNull,
      );
    });
  });
}
