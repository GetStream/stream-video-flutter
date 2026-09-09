import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

const _builtInMic = RtcMediaDevice(
  id: 'mic-1',
  label: 'MacBook Pro Microphone',
  kind: RtcMediaDeviceKind.audioInput,
);

// The field is disabled until the microphone has been opened once, and its
// tooltip is the only text that tells the user why. It used to assert that a
// permission was required — a verdict nothing here has asked the platform for
// — so a call configured to start muted blamed permissions from the first
// frame, and a user who went to system settings found the permission granted.
void main() {
  late MockRtcMediaDeviceNotifier notifier;
  late StreamController<List<RtcMediaDevice>> deviceChanges;
  late Result<List<RtcMediaDevice>> enumeration;

  setUp(() {
    deviceChanges = StreamController<List<RtcMediaDevice>>.broadcast();
    enumeration = const Result.success(<RtcMediaDevice>[]);

    notifier = MockRtcMediaDeviceNotifier();
    when(() => notifier.onDeviceChange).thenAnswer((_) => deviceChanges.stream);
    when(notifier.enumerateDevices).thenAnswer((_) async => enumeration);
  });

  tearDown(() => deviceChanges.close());

  StreamLobbyController buildController({
    LobbyAudioTrackOpener? openMicrophoneTrack,
  }) {
    final callState = MockCallState();
    when(() => callState.settings).thenReturn(
      const CallSettings(
        audio: StreamAudioSettings(micDefaultOn: false),
        video: StreamVideoSettings(cameraDefaultOn: false),
      ),
    );

    final call = MockCall();
    stubLobbyCall(call, callState);
    when(call.get).thenAnswer(
      (_) async => Result.failure(StateError('no network'), StackTrace.empty),
    );

    final controller = StreamLobbyController(
      call: call,
      deviceNotifier: notifier,
      openMicrophoneTrack: openMicrophoneTrack,
    );
    addTearDown(controller.dispose);
    return controller;
  }

  /// Pumps the field over [controller] and returns its tooltip.
  ///
  /// The widget goes up first and every wait is a pump: `pumpEventQueue`
  /// outside a pump does not advance a widget test's fake clock.
  Future<String?> tooltipOf(
    WidgetTester tester,
    StreamLobbyController controller, {
    List<RtcMediaDevice> devices = const [],
  }) async {
    await tester.pumpWidget(
      TestWrapper(
        child: StreamLobbyScope(
          controller: controller,
          child: const SizedBox(
            width: 400,
            child: StreamLobbyMicrophoneSelect(),
          ),
        ),
      ),
    );
    deviceChanges.add(devices);
    await tester.pumpAndSettle();

    return tester.widget<Tooltip>(find.byType(Tooltip).first).message;
  }

  testWidgets('asks the user to turn the microphone on, not to grant a '
      'permission', (tester) async {
    final controller = buildController();

    // There is a microphone and nothing has failed: the field is waiting for
    // the device to be opened, which is all it may claim.
    expect(
      await tooltipOf(tester, controller, devices: const [_builtInMic]),
      'Turn the microphone on to choose a device',
    );
  });

  testWidgets('says the microphone was refused when it actually was', (
    tester,
  ) async {
    final controller = buildController(
      openMicrophoneTrack: () async =>
          throw Exception('NotAllowedError: Permission denied'),
    );
    await controller.toggleMicrophone();

    expect(
      await tooltipOf(tester, controller, devices: const [_builtInMic]),
      'Microphone access was refused — allow it in your system settings',
    );
  });

  testWidgets('says another app has it when the device is busy', (
    tester,
  ) async {
    final controller = buildController(
      openMicrophoneTrack: () async =>
          throw Exception('NotReadableError: Could not start audio source'),
    );
    await controller.toggleMicrophone();

    expect(
      await tooltipOf(tester, controller, devices: const [_builtInMic]),
      'Another app is using the microphone',
    );
  });

  testWidgets('says there is no microphone when the platform reports none', (
    tester,
  ) async {
    final controller = buildController();

    expect(await tooltipOf(tester, controller), 'No microphone found');
  });

  // An enumeration that could not run at all is not the same as one that ran
  // and found nothing, and both used to render as the same inert field.
  testWidgets('says the devices could not be read when the platform failed', (
    tester,
  ) async {
    enumeration = Result.failure(
      Exception('SecurityError: blocked by policy'),
      StackTrace.empty,
    );

    final controller = buildController();

    expect(
      await tooltipOf(tester, controller),
      'Your devices could not be read',
    );
  });
}
