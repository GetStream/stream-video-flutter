import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';

// ignore: missing_override_of_must_be_overridden
class _MockRtcManager extends Mock implements RtcManager {}

class _CapturingLogger extends StreamLogger {
  final errors = <String>[];

  @override
  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) {
    if (priority == Priority.error) errors.add(message());
  }
}

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    registerFallbackValue(const AudioConfigurationPolicy.broadcaster());
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Call on iOS', () {
    late MockCallSession callSession;
    late _MockRtcManager rtcManager;
    late MockRtcMediaDeviceNotifier deviceNotifier;
    late Completer<void> appleConfigurationApplied;

    // The stats reporter reads the thermal state on iOS.
    const thermalChannels = ['thermal', 'thermal/events'];

    setUp(() {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
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
      CurrentPlatform.debugCurrentPlatformOverride = null;
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

    test('a failure to configure the audio session is logged', () async {
      final logger = _CapturingLogger();
      StreamLog()
        ..logger = logger
        ..priority = Priority.error;
      addTearDown(() {
        StreamLog()
          ..logger = const SilentStreamLogger()
          ..priority = Priority.none;
      });

      when(
        () => rtcManager.setAppleAudioConfiguration(
          policy: any(named: 'policy'),
          speakerOn: any(named: 'speakerOn'),
        ),
      ).thenAnswer((_) async {
        if (!appleConfigurationApplied.isCompleted) {
          appleConfigurationApplied.complete();
        }
        return failureWithError<None>('session busy');
      });

      final call = makeCall(const AudioConfigurationPolicy.viewer());

      final result = await call.join(connectOptions: viewerConnectOptions);
      expect(result.isSuccess, isTrue);
      await appleConfigurationApplied.future.timeout(
        const Duration(seconds: 5),
      );
      // The result reaches the log after the stub returns.
      await pumpEventQueue();

      expect(
        logger.errors,
        contains(
          allOf(contains('appleAudioConfiguration'), contains('session busy')),
        ),
      );
    });

    group('resumeAudio', () {
      setUp(() {
        when(
          () => callSession.restoreAppleAudioConfiguration(),
        ).thenAnswer((_) async => const Result.success(none));
        when(
          () => callSession.applyCurrentAudioOutputDevice(),
        ).thenAnswer((_) async {});
        when(
          () => callSession.resumeSuspendedAudioTracks(any()),
        ).thenAnswer((_) async {});
      });

      test('restores the audio session configuration applied since the call '
          'started, then the output the user picked', () async {
        // The broadcaster's factory configuration has no loudspeaker, so
        // without the restore a speaker from the call settings is lost.
        final call = makeCall(const AudioConfigurationPolicy.broadcaster());
        await call.join(connectOptions: viewerConnectOptions);
        // The session's RTC manager can't run the ADM mute reconciliation
        // as a mock; its restore goes through the session.
        when(() => callSession.rtcManager).thenReturn(null);

        await call.suspendAudio();
        await call.resumeAudio();

        verifyInOrder([
          () => callSession.restoreAppleAudioConfiguration(),
          () => callSession.applyCurrentAudioOutputDevice(),
        ]);
      });

      test('a failure to restore the configuration is logged', () async {
        final logger = _CapturingLogger();
        StreamLog()
          ..logger = logger
          ..priority = Priority.error;
        addTearDown(() {
          StreamLog()
            ..logger = const SilentStreamLogger()
            ..priority = Priority.none;
        });
        when(
          () => callSession.restoreAppleAudioConfiguration(),
        ).thenAnswer((_) async => failureWithError<None>('session busy'));

        final call = makeCall(const AudioConfigurationPolicy.broadcaster());
        await call.join(connectOptions: viewerConnectOptions);
        // The session's RTC manager can't run the ADM mute reconciliation
        // as a mock; its restore goes through the session.
        when(() => callSession.rtcManager).thenReturn(null);

        await call.suspendAudio();
        await call.resumeAudio();

        expect(
          logger.errors,
          contains(
            allOf(contains('[resumeAudio]'), contains('session busy')),
          ),
        );
        // The user's output is still re-applied.
        verify(() => callSession.applyCurrentAudioOutputDevice()).called(1);
      });
    });
  });
}
