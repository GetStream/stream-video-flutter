import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide Finder;
import 'package:flutter_test/flutter_test.dart' as ft show Finder;
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

const _builtInMic = RtcMediaDevice(
  id: 'mic-1',
  label: 'MacBook Pro Microphone',
  kind: RtcMediaDeviceKind.audioInput,
);
const _headset = RtcMediaDevice(
  id: 'mic-2',
  label: 'Jabra Evolve2 65',
  kind: RtcMediaDeviceKind.audioInput,
);

// The whole point of StreamMediaDevicesController is that the split button on
// a toggle's caret and the select input in the settings lane are two views of
// one selection. A lobby showing both must never disagree with itself.
void main() {
  late MockCall call;
  late MockRtcMediaDeviceNotifier notifier;
  late StreamController<List<RtcMediaDevice>> deviceChanges;
  late StreamLobbyController controller;

  setUp(() {
    deviceChanges = StreamController<List<RtcMediaDevice>>.broadcast();

    notifier = MockRtcMediaDeviceNotifier();
    when(() => notifier.onDeviceChange).thenAnswer((_) => deviceChanges.stream);
    when(
      notifier.enumerateDevices,
    ).thenAnswer((_) async => const Result.success(<RtcMediaDevice>[]));

    final callState = MockCallState();
    when(() => callState.settings).thenReturn(
      const CallSettings(
        audio: StreamAudioSettings(micDefaultOn: false),
        video: StreamVideoSettings(cameraDefaultOn: false),
      ),
    );

    call = MockCall();
    stubLobbyCall(call, callState);
    // The participant list plays no part here.
    when(call.get).thenAnswer(
      (_) async => Result.failure(
        StateError('not needed for this test'),
        StackTrace.empty,
      ),
    );

    controller = StreamLobbyController(
      call: call,
      deviceNotifier: notifier,
    );
    addTearDown(controller.dispose);
  });

  tearDown(() => deviceChanges.close());

  Future<void> pumpLobby(WidgetTester tester) async {
    await tester.pumpWidget(
      TestWrapper(
        // macOS so both controls open the anchored menu, which can be driven
        // without a sheet route in the way.
        platform: TargetPlatform.macOS,
        child: StreamLobbyScope(
          controller: controller,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamLobbyMicrophoneSplitButton(),
              SizedBox(width: 220, child: StreamLobbyMicrophoneSelect()),
            ],
          ),
        ),
      ),
    );

    deviceChanges.add(const [_builtInMic, _headset]);
    await tester.pumpAndSettle();
  }

  testWidgets('a device picked on the split button shows on the select input', (
    tester,
  ) async {
    // The select input only enables once the microphone has been opened, which
    // is what populates device labels.
    await controller.devices.selectAudioInput(_builtInMic);
    await pumpLobby(tester);

    expect(find.text(_builtInMic.label), findsOneWidget);

    // The select input draws a caret of its own, so target the split
    // button's.
    await tester.tap(splitButtonCaret(tester));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_headset.label).last);
    await tester.pumpAndSettle();

    expect(controller.devices.selectedAudioInput, _headset);
    // The select input is the only thing rendering the label now the menu is
    // closed, so finding it proves it followed the split button.
    expect(find.text(_headset.label), findsOneWidget);
  });

  testWidgets('both controls offer the same devices', (tester) async {
    await pumpLobby(tester);

    await tester.tap(splitButtonCaret(tester));
    await tester.pumpAndSettle();

    expect(find.text(_builtInMic.label), findsOneWidget);
    expect(find.text(_headset.label), findsOneWidget);
    // Twice: the menu's row for it, and the select input's placeholder, which
    // says the same thing while the platform's choice is the one in effect.
    expect(find.text('Default'), findsNWidgets(2));
  });
}

ft.Finder splitButtonCaret(WidgetTester tester) {
  final icons = tester.element(find.byType(StreamLobbyScope)).streamIcons;
  return find.descendant(
    of: find.byType(StreamLobbyMicrophoneSplitButton),
    matching: find.byIcon(icons.caretDown),
  );
}
