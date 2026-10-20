import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';

class _MockRtcManager extends Mock implements RtcManager {}

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    registerFallbackValue(const AudioConfigurationPolicy.broadcaster());
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Call.join on iOS', () {
    late MockCallSession callSession;
    late _MockRtcManager rtcManager;
    late MockRtcMediaDeviceNotifier deviceNotifier;
    late Completer<void> appleConfigurationApplied;

    // The stats reporter reads the thermal state on iOS.
    const thermalChannels = ['thermal', 'thermal/events'];

    setUp(() {
      CurrentPlatform.debugPlatformOverride = PlatformType.ios;
      for (final channel in thermalChannels) {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              MethodChannel(channel),
              (_) async => null,
            );
      }

      rtcManager = _MockRtcManager();
      appleConfigurationApplied = Completer<void>();
      when(
        () => rtcManager.setAppleAudioConfiguration(
          policy: any(named: 'policy'),
          speakerOn: any(named: 'speakerOn'),
        ),
      ).thenAnswer((_) async {
        if (!appleConfigurationApplied.isCompleted) {
          appleConfigurationApplied.complete();
        }
        return const Result.success(none);
      });

      // Starting the session hands the RTC manager to the call, which applies
      // the connect options to it.
      callSession = setupMockCallSession();
      when(() => callSession.rtcManager).thenReturn(rtcManager);
      when(
        () => callSession.start(
          reconnectDetails: any(named: 'reconnectDetails'),
          onRtcManagerCreatedCallback: any(
            named: 'onRtcManagerCreatedCallback',
          ),
          isAnonymousUser: any(named: 'isAnonymousUser'),
          capabilities: any(named: 'capabilities'),
          unifiedSessionId: any(named: 'unifiedSessionId'),
          clientEventRetryCount: any(named: 'clientEventRetryCount'),
        ),
      ).thenAnswer((invocation) async {
        final onRtcManagerCreated =
            invocation.namedArguments[#onRtcManagerCreatedCallback]
                as FutureOr<void> Function(RtcManager)?;
        await onRtcManagerCreated?.call(rtcManager);
        return Result.success(
          (
            callState: createTestSfuCallState(),
            fastReconnectDeadline: Duration.zero,
          ),
        );
      });

      // Bluetooth headphones are connected, so iOS keeps the route and the
      // call only configures the audio session.
      deviceNotifier = MockRtcMediaDeviceNotifier();
      when(() => deviceNotifier.enumerateDevicesFor(any())).thenAnswer(
        (_) async =>
            Result.success(TestDeviceScenarios.withBluetoothHeadphones),
      );
    });

    tearDown(() {
      CurrentPlatform.debugPlatformOverride = null;
      for (final channel in thermalChannels) {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(MethodChannel(channel), null);
      }
    });

    Call makeCall(AudioConfigurationPolicy policy) {
      return createTestCall(
        stateManager: CallStateNotifier(
          createTestCallState(
            preferences: DefaultCallPreferences(
              audioConfigurationPolicy: policy,
            ),
          ),
        ),
        sessionFactory: setupMockSessionFactory(callSession: callSession),
        rtcMediaDeviceNotifier: deviceNotifier,
      );
    }

    // Connect options passed to `join`, as `LivestreamPlayer` does. Merging
    // them resets `speakerDefaultOn` to false.
    final viewerConnectOptions = CallConnectOptions(
      camera: TrackOption.disabled(),
      microphone: TrackOption.disabled(),
    );

    test(
      'a viewer joining with its own connect options keeps the loudspeaker as '
      'the built-in output',
      () async {
        const policy = AudioConfigurationPolicy.viewer();
        final call = makeCall(policy);

        final result = await call.join(connectOptions: viewerConnectOptions);
        expect(result.isSuccess, isTrue);
        await appleConfigurationApplied.future.timeout(
          const Duration(seconds: 5),
        );

        expect(call.connectOptions.speakerDefaultOn, isFalse);
        verify(
          () => rtcManager.setAppleAudioConfiguration(
            policy: policy,
            speakerOn: true,
          ),
        ).called(1);
      },
    );

    test(
      'a broadcaster with headphones does not ask for the loudspeaker',
      () async {
        const policy = AudioConfigurationPolicy.broadcaster();
        final call = makeCall(policy);

        final result = await call.join(connectOptions: viewerConnectOptions);
        expect(result.isSuccess, isTrue);
        await appleConfigurationApplied.future.timeout(
          const Duration(seconds: 5),
        );

        verify(
          () => rtcManager.setAppleAudioConfiguration(
            policy: policy,
            // Explicit, since the point is that the speaker stays off.
            // ignore: avoid_redundant_argument_values
            speakerOn: false,
          ),
        ).called(1);
      },
    );
  });
}
