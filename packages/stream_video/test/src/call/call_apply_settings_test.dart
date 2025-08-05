// ignore_for_file: avoid_redundant_argument_values
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/shared_emitter.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() {
    // Initialize Flutter bindings for testing
    TestWidgetsFlutterBinding.ensureInitialized();

    // Register fallback values for types used with any() matchers
    registerFallbackValue(
      StreamCallCid.from(
        type: StreamCallType.defaultType(),
        id: 'fallback-call-id',
      ),
    );
  });

  group('Call `applyCallSettingsToConnectOptions` tests', () {
    late User user;
    late String userToken;
    late StreamVideo streamVideo;
    late MockCoordinatorClient mockCoordinatorClient;
    late MockRtcMediaDeviceNotifier mockDeviceNotifier;

    setUp(() {
      user = User.regular(
        userId: 'test-user',
        name: 'Test User',
      );

      userToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiSm9obiBEb2UifQ.hrrtiYCtfs2cowE2sx2dypxoXhsEE8pQl-V6Nq4i8qU';

      mockCoordinatorClient = MockCoordinatorClient();
      mockDeviceNotifier = MockRtcMediaDeviceNotifier();

      // Mock coordinator client methods that might be called
      when(() => mockCoordinatorClient.events)
          .thenReturn(MutableSharedEmitterImpl<CoordinatorEvent>());

      // Default device enumeration mocking - returns built-in devices only
      when(mockDeviceNotifier.enumerateDevices).thenAnswer(
        (_) async => Result.success(TestDeviceScenarios.builtInDevicesOnly),
      );

      streamVideo = StreamVideo.create(
        'test-api-key',
        user: user,
        userToken: userToken,
        options: const StreamVideoOptions(
          autoConnect: false,
        ),
      );
    });

    tearDown(() async {
      await StreamVideo.reset();
    });

    group('Speaker priority logic', () {
      test('enables speaker when video camera is on by default', () async {
        // Arrange
        const callSettings = CallSettings(
          video: StreamVideoSettings(cameraDefaultOn: true),
          audio: StreamAudioSettings(
            speakerDefaultOn: false,
            defaultDevice: AudioSettingsRequestDefaultDeviceEnum.earpiece,
          ),
        );

        final call = createCallWithMockedResponse(
          streamVideo,
          mockCoordinatorClient,
          callSettings,
          rtcMediaDeviceNotifier: mockDeviceNotifier,
        );

        // Act
        final result = await call.getOrCreate(watch: false);

        // Assert
        expect(result.isSuccess, true);
        expect(call.connectOptions.speakerDefaultOn, true);

        // When video camera is enabled by default, speaker should be prioritized
        // even if settings indicate earpiece as default device
        final audioOutputDevice = call.connectOptions.audioOutputDevice;
        expect(audioOutputDevice?.id.toLowerCase(), contains('speaker'));
      });

      test('enables speaker when audio speaker is on by default', () async {
        // Arrange
        const callSettings = CallSettings(
          video: StreamVideoSettings(cameraDefaultOn: false),
          audio: StreamAudioSettings(
            speakerDefaultOn: true,
            defaultDevice: AudioSettingsRequestDefaultDeviceEnum.earpiece,
          ),
        );

        final call = createCallWithMockedResponse(
          streamVideo,
          mockCoordinatorClient,
          callSettings,
          rtcMediaDeviceNotifier: mockDeviceNotifier,
        );

        // Act
        final result = await call.getOrCreate(watch: false);

        // Assert
        expect(result.isSuccess, true);
        expect(call.connectOptions.speakerDefaultOn, true);

        final audioOutputDevice = call.connectOptions.audioOutputDevice;
        expect(audioOutputDevice?.id.toLowerCase(), contains('speaker'));
      });

      test('enables speaker when default device is set to speaker', () async {
        // Arrange
        const callSettings = CallSettings(
          video: StreamVideoSettings(cameraDefaultOn: false),
          audio: StreamAudioSettings(
            speakerDefaultOn: false,
            defaultDevice: AudioSettingsRequestDefaultDeviceEnum.speaker,
          ),
        );

        final call = createCallWithMockedResponse(
          streamVideo,
          mockCoordinatorClient,
          callSettings,
          rtcMediaDeviceNotifier: mockDeviceNotifier,
        );

        // Act
        final result = await call.getOrCreate(watch: false);

        // Assert
        expect(result.isSuccess, true);
        expect(call.connectOptions.speakerDefaultOn, true);

        final audioOutputDevice = call.connectOptions.audioOutputDevice;
        expect(audioOutputDevice?.id.toLowerCase(), contains('speaker'));
      });

      test('defaults to non-speaker device when speaker is not prioritized',
          () async {
        // Arrange
        const callSettings = CallSettings(
          video: StreamVideoSettings(cameraDefaultOn: false),
          audio: StreamAudioSettings(
            speakerDefaultOn: false,
            defaultDevice: AudioSettingsRequestDefaultDeviceEnum.earpiece,
          ),
        );

        final call = createCallWithMockedResponse(
          streamVideo,
          mockCoordinatorClient,
          callSettings,
          rtcMediaDeviceNotifier: mockDeviceNotifier,
        );

        // Act
        final result = await call.getOrCreate(watch: false);

        // Assert
        expect(result.isSuccess, true);
        expect(call.connectOptions.speakerDefaultOn, false);

        final audioOutputDevice = call.connectOptions.audioOutputDevice;

        // Should prefer non-speaker device when speaker is not prioritized
        expect(
          audioOutputDevice?.id.toLowerCase(),
          isNot(contains('speaker')),
        );
      });
    });

    group('External device priority logic', () {
      test('prioritizes external device over built-in speaker', () async {
        // Arrange
        const callSettings = CallSettings(
          video: StreamVideoSettings(cameraDefaultOn: false),
          audio: StreamAudioSettings(
            speakerDefaultOn: true,
            defaultDevice: AudioSettingsRequestDefaultDeviceEnum.speaker,
          ),
        );

        // Override default device enumeration for this test - add Bluetooth headphones
        when(mockDeviceNotifier.enumerateDevices).thenAnswer(
          (_) async =>
              Result.success(TestDeviceScenarios.withBluetoothHeadphones),
        );

        final call = createCallWithMockedResponse(
          streamVideo,
          mockCoordinatorClient,
          callSettings,
          rtcMediaDeviceNotifier: mockDeviceNotifier,
        );

        // Act
        final result = await call.getOrCreate(watch: false);

        // Assert
        expect(result.isSuccess, true);

        final audioOutputDevice = call.connectOptions.audioOutputDevice;

        // Should prioritize Bluetooth headphones over built-in speaker
        expect(audioOutputDevice?.label, 'Bluetooth Headphones');
        expect(audioOutputDevice?.kind, RtcMediaDeviceKind.audioOutput);
      });

      test('falls back to built-in device when no external device available',
          () async {
        // Arrange
        const callSettings = CallSettings(
          video: StreamVideoSettings(cameraDefaultOn: false),
          audio: StreamAudioSettings(
            speakerDefaultOn: false,
            defaultDevice: AudioSettingsRequestDefaultDeviceEnum.earpiece,
          ),
        );

        // Use default device enumeration (built-in devices only) - no need to override

        final call = createCallWithMockedResponse(
          streamVideo,
          mockCoordinatorClient,
          callSettings,
          rtcMediaDeviceNotifier: mockDeviceNotifier,
        );

        // Act
        final result = await call.getOrCreate(watch: false);

        // Assert
        expect(result.isSuccess, true);
        expect(call.connectOptions.speakerDefaultOn, false);

        final audioOutputDevice = call.connectOptions.audioOutputDevice;

        // Should fall back to earpiece when no external device is available
        expect(audioOutputDevice?.label, 'Earpiece');
        expect(audioOutputDevice?.kind, RtcMediaDeviceKind.audioOutput);
      });

      test('external device priority overrides video camera speaker preference',
          () async {
        // Arrange
        const callSettings = CallSettings(
          video: StreamVideoSettings(
            cameraDefaultOn: true,
          ), // This normally enables speaker
          audio: StreamAudioSettings(
            speakerDefaultOn: false,
            defaultDevice: AudioSettingsRequestDefaultDeviceEnum.earpiece,
          ),
        );

        // Override default device enumeration for this test - add Bluetooth headphones
        when(mockDeviceNotifier.enumerateDevices).thenAnswer(
          (_) async =>
              Result.success(TestDeviceScenarios.withBluetoothHeadphones),
        );

        final call = createCallWithMockedResponse(
          streamVideo,
          mockCoordinatorClient,
          callSettings,
          rtcMediaDeviceNotifier: mockDeviceNotifier,
        );

        // Act
        final result = await call.getOrCreate(watch: false);

        // Assert
        expect(result.isSuccess, true);

        final audioOutputDevice = call.connectOptions.audioOutputDevice;

        // External Bluetooth headphones should be prioritized even when video
        // camera would normally enable speaker
        expect(audioOutputDevice?.label, 'Bluetooth Headphones');
        expect(audioOutputDevice?.kind, RtcMediaDeviceKind.audioOutput);
      });
    });

    group('Video input selection', () {
      test('selects front camera when cameraFacing is front', () async {
        // Arrange
        const callSettings = CallSettings(
          video: StreamVideoSettings(
            cameraFacing: VideoSettingsRequestCameraFacingEnum.front,
          ),
        );

        final call = createCallWithMockedResponse(
          streamVideo,
          mockCoordinatorClient,
          callSettings,
          rtcMediaDeviceNotifier: mockDeviceNotifier,
        );

        // Act
        final result = await call.getOrCreate(watch: false);

        // Assert
        expect(result.isSuccess, true);
        expect(call.connectOptions.cameraFacingMode, FacingMode.user);
      });

      test('selects back camera when cameraFacing is back', () async {
        // Arrange
        const callSettings = CallSettings(
          video: StreamVideoSettings(
            cameraFacing: VideoSettingsRequestCameraFacingEnum.back,
          ),
        );

        final call = createCallWithMockedResponse(
          streamVideo,
          mockCoordinatorClient,
          callSettings,
          rtcMediaDeviceNotifier: mockDeviceNotifier,
        );

        // Act
        final result = await call.getOrCreate(watch: false);

        // Assert
        expect(result.isSuccess, true);
        expect(call.connectOptions.cameraFacingMode, FacingMode.environment);
      });
    });

    group('Track options from settings', () {
      test('sets camera track option based on cameraDefaultOn', () async {
        // Arrange
        const callSettings = CallSettings(
          video: StreamVideoSettings(cameraDefaultOn: true),
        );

        final call = createCallWithMockedResponse(
          streamVideo,
          mockCoordinatorClient,
          callSettings,
          rtcMediaDeviceNotifier: mockDeviceNotifier,
        );

        // Act
        final result = await call.getOrCreate(watch: false);

        // Assert
        expect(result.isSuccess, true);
        expect(call.connectOptions.camera.isEnabled, true);
      });

      test('sets microphone track option based on micDefaultOn', () async {
        // Arrange
        const callSettings = CallSettings(
          audio: StreamAudioSettings(micDefaultOn: false),
        );

        final call = createCallWithMockedResponse(
          streamVideo,
          mockCoordinatorClient,
          callSettings,
          rtcMediaDeviceNotifier: mockDeviceNotifier,
        );

        // Act
        final result = await call.getOrCreate(watch: false);

        // Assert
        expect(result.isSuccess, true);
        expect(call.connectOptions.microphone.isDisabled, true);
      });
    });

    group('Target resolution', () {
      test('sets target resolution from video settings', () async {
        // Arrange
        const targetResolution = StreamTargetResolution(
          width: 1920,
          height: 1080,
          bitrate: 2000000,
        );

        const callSettings = CallSettings(
          video: StreamVideoSettings(targetResolution: targetResolution),
        );

        final call = createCallWithMockedResponse(
          streamVideo,
          mockCoordinatorClient,
          callSettings,
          rtcMediaDeviceNotifier: mockDeviceNotifier,
        );

        // Act
        final result = await call.getOrCreate(watch: false);

        // Assert
        expect(result.isSuccess, true);
        expect(call.connectOptions.targetResolution, targetResolution);
      });

      test('sets screen share target resolution from settings', () async {
        // Arrange
        const screenShareResolution = StreamTargetResolution(
          width: 1280,
          height: 720,
          bitrate: 1000000,
        );

        const callSettings = CallSettings(
          screenShare: StreamScreenShareSettings(
            targetResolution: screenShareResolution,
          ),
        );

        final call = createCallWithMockedResponse(
          streamVideo,
          mockCoordinatorClient,
          callSettings,
          rtcMediaDeviceNotifier: mockDeviceNotifier,
        );

        // Act
        final result = await call.getOrCreate(watch: false);

        // Assert
        expect(result.isSuccess, true);
        expect(
          call.connectOptions.screenShareTargetResolution,
          screenShareResolution,
        );
      });
    });
  });
}
