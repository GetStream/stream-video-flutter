import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';

class _MockRtcManager extends Mock implements RtcManager {
  @override
  Future<void> dispose() async {}
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  group('Call applies its connect options', () {
    late MockCallSession callSession;
    late MockPermissionsManager permissionManager;

    // The default mock never runs the callback that applies the connect
    // options, so the session has to hand it an rtc manager itself.
    void startInvokesRtcManagerCreated() {
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
        final onCreated =
            invocation.namedArguments[const Symbol(
                  'onRtcManagerCreatedCallback',
                )]
                as FutureOr<void> Function(RtcManager)?;

        await onCreated?.call(_MockRtcManager());

        return Result.success((
          callState: createTestSfuCallState(),
          fastReconnectDeadline: Duration.zero,
        ));
      });
    }

    setUp(() {
      callSession = setupMockCallSession();
      permissionManager = MockPermissionsManager();

      for (final permission in CallPermission.values) {
        when(
          () => permissionManager.hasPermission(permission),
        ).thenReturn(true);
      }

      startInvokesRtcManagerCreated();
    });

    Future<Call> joinWith(CallConnectOptions connectOptions) async {
      final call = createTestCall(
        permissionManager: permissionManager,
        sessionFactory: setupMockSessionFactory(callSession: callSession),
      );

      await call.join(connectOptions: connectOptions);
      // `_applyConnectOptions` is started unawaited, so let it settle.
      await pumpEventQueue();

      return call;
    }

    // A refused apply leaves the device off. The intent has to come down with
    // it: a control that reads it while no track has been reported would
    // otherwise draw the device as live for the rest of the call, and refuse
    // to toggle, having no track to mute.
    test(
      'drops the microphone intent when the call refuses to send audio',
      () async {
        when(
          () => permissionManager.hasPermission(CallPermission.sendAudio),
        ).thenReturn(false);

        final call = await joinWith(
          CallConnectOptions(microphone: TrackOption.enabled()),
        );

        expect(call.connectOptions.microphone, isA<TrackDisabled>());
        expect(call.connectOptions.microphone.isDisabled, isTrue);
      },
    );

    test(
      'drops the camera intent when the call refuses to send video',
      () async {
        when(
          () => permissionManager.hasPermission(CallPermission.sendVideo),
        ).thenReturn(false);

        final call = await joinWith(
          CallConnectOptions(camera: TrackOption.enabled()),
        );

        expect(call.connectOptions.camera, isA<TrackDisabled>());
        expect(call.connectOptions.camera.isDisabled, isTrue);
      },
    );

    test('leaves the other device alone when only one is refused', () async {
      when(
        () => permissionManager.hasPermission(CallPermission.sendAudio),
      ).thenReturn(false);

      when(
        () => callSession.setCameraEnabled(
          any(),
          constraints: any(named: 'constraints'),
        ),
      ).thenAnswer((_) async => Result.success(MockRtcLocalTrack()));

      final call = await joinWith(
        CallConnectOptions(
          microphone: TrackOption.enabled(),
          camera: TrackOption.enabled(),
        ),
      );

      expect(call.connectOptions.microphone, isA<TrackDisabled>());
      expect(call.connectOptions.camera.isDisabled, isFalse);
    });

    test('keeps the intent when the apply succeeds', () async {
      when(
        () => callSession.setMicrophoneEnabled(
          any(),
          constraints: any(named: 'constraints'),
          stopTrackOnMute: any(named: 'stopTrackOnMute'),
        ),
      ).thenAnswer((_) async => Result.success(MockRtcLocalTrack()));

      final call = await joinWith(
        CallConnectOptions(microphone: TrackOption.enabled()),
      );

      expect(call.connectOptions.microphone.isDisabled, isFalse);
    });
  });
}
