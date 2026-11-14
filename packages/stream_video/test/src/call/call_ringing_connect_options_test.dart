// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/media/local_media_controller.dart';
import 'package:stream_video/src/webrtc/rtc_media_device/device_enumeration_trigger.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';

const _defaultsOn = CallSettings(
  audio: StreamAudioSettings(micDefaultOn: true),
  video: StreamVideoSettings(
    cameraDefaultOn: true,
    cameraFacing: CameraFacing.back,
  ),
);

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(DeviceEnumerationTrigger.explicit);
    registerFallbackValue(
      StreamCallCid.from(
        type: StreamCallType.defaultType(),
        id: 'fallback-call-id',
      ),
    );
  });

  group('Call.fromRinging connect options', () {
    late StreamVideo streamVideo;
    late MockCoordinatorClient mockCoordinatorClient;

    setUp(() {
      mockCoordinatorClient = setupMockCoordinatorClient();
      streamVideo = StreamVideo.create(
        'test-api-key',
        user: const User(id: 'test-user', name: 'Test User'),
        userToken:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiSm9obiBEb2UifQ.hrrtiYCtfs2cowE2sx2dypxoXhsEE8pQl-V6Nq4i8qU',
        options: StreamVideoOptions(
          allowMultipleActiveCalls: true,
          autoConnect: false,
        ),
      );
    });

    tearDown(() async {
      await StreamVideo.reset();
    });

    Call createIncomingCall(CallSettings settings) {
      final callCid = StreamCallCid.from(
        id: 'ringing-call',
        type: StreamCallType.defaultType(),
      );

      return Call.fromRinging(
        data: CallRingingData(
          callCid: callCid,
          ringing: true,
          metadata: CallMetadata(
            cid: callCid,
            details: createTestCallDetails(createdByUserId: 'other-user'),
            settings: settings,
            session: const CallSessionData(),
            users: const {},
            members: const {},
          ),
        ),
        coordinatorClient: mockCoordinatorClient,
        streamVideo: streamVideo,
        networkMonitor: InternetConnection.createInstance(),
      );
    }

    test('reports the microphone and camera the settings turn on', () {
      final call = createIncomingCall(_defaultsOn);

      expect(call.connectOptions.microphone.isEnabled, isTrue);
      expect(call.connectOptions.camera.isEnabled, isTrue);
      expect(call.connectOptions.cameraFacingMode, FacingMode.environment);
    });

    test('reports them off when the settings leave them off', () {
      final call = createIncomingCall(
        const CallSettings(
          audio: StreamAudioSettings(micDefaultOn: false),
          video: StreamVideoSettings(cameraDefaultOn: false),
        ),
      );

      expect(call.connectOptions.microphone.isEnabled, isFalse);
      expect(call.connectOptions.camera.isEnabled, isFalse);
      expect(call.connectOptions.cameraFacingMode, FacingMode.user);
    });

    test('reports an override set before the join', () {
      final call = createIncomingCall(_defaultsOn);

      final result = call.setConnectOptions(
        call.connectOptions.copyWith(
          microphone: TrackOption.disabled(),
          camera: TrackOption.disabled(),
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(call.connectOptions.microphone.isEnabled, isFalse);
      expect(call.connectOptions.camera.isEnabled, isFalse);
    });
  });

  group('LocalMediaController.applyRingingSettings', () {
    late MockRtcMediaDeviceNotifier mockDeviceNotifier;
    late LocalMediaController media;

    setUp(() {
      mockDeviceNotifier = MockRtcMediaDeviceNotifier();
      when(
        () => mockDeviceNotifier.enumerateDevicesFor(any()),
      ).thenAnswer(
        (_) async => Result.success(TestDeviceScenarios.builtInDevicesOnly),
      );

      media = LocalMediaController(
        stateManager: MockCallStateNotifier(),
        session: () => null,
        sfuStatsReporter: () => null,
        hasPermission: (_) => true,
        rtcMediaDeviceNotifier: () => mockDeviceNotifier,
        audioConfigurationPolicy: () =>
            const AudioConfigurationPolicy.broadcaster(),
        muteVideoWhenInBackground: () => false,
        muteAudioWhenInBackground: () => false,
        onMicrophoneMuted: (_) async {},
        logger: taggedLogger(tag: 'test'),
      );
    });

    test('matches what the join resolves from the same settings', () async {
      media.applyRingingSettings(_defaultsOn);
      final seeded = media.connectOptions;

      await media.applyJoinSettings(_defaultsOn);

      expect(media.connectOptions.microphone, seeded.microphone);
      expect(media.connectOptions.camera, seeded.camera);
      expect(media.connectOptions.cameraFacingMode, seeded.cameraFacingMode);
    });

    test('lets an override set before the join win at the join', () async {
      media.applyRingingSettings(_defaultsOn);
      media.setConnectOptions(
        media.connectOptions.copyWith(
          microphone: TrackOption.disabled(),
          camera: TrackOption.disabled(),
        ),
      );

      await media.applyJoinSettings(_defaultsOn);

      expect(media.connectOptions.microphone.isEnabled, isFalse);
      expect(media.connectOptions.camera.isEnabled, isFalse);
    });
  });
}
