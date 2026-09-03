import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

void main() {
  // The icons the widget resolves off `context.streamIcons`; the defaults are
  // what TestWrapper's theme installs.
  const icons = StreamIcons();

  testWidgets('StreamMicrophoneButton', (tester) async {
    var isAudioEnabled = true;

    final localParticipant = MockCallParticipantState();
    final call = MockCall();

    when(() => localParticipant.isAudioEnabled).thenReturn(isAudioEnabled);
    when(
      () => call.setMicrophoneEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer(
      (invocation) async {
        isAudioEnabled =
            invocation.namedArguments[const Symbol('enabled')] as bool;
        return const Result.success(none);
      },
    );

    // Microphone is enabled
    await tester.pumpWidget(
      TestWrapper(
        child: StreamMicrophoneButton(
          localParticipant: localParticipant,
          call: call,
        ),
      ),
    );

    expect(find.byIcon(icons.voiceFill), findsOneWidget);
    expect(find.byIcon(icons.voiceOffFill), findsNothing);

    await tester.tap(find.byIcon(icons.voiceFill));
    await tester.pumpAndSettle();

    verify(() => call.setMicrophoneEnabled(enabled: false)).called(1);

    // Microphone is disabled
    when(() => localParticipant.isAudioEnabled).thenReturn(isAudioEnabled);
    await tester.pumpWidget(
      TestWrapper(
        child: StreamMicrophoneButton(
          localParticipant: localParticipant,
          call: call,
        ),
      ),
    );
    expect(find.byIcon(icons.voiceFill), findsNothing);
    expect(find.byIcon(icons.voiceOffFill), findsOneWidget);
  });

  // The refusal used to be dropped on the floor: `setMicrophoneEnabled`
  // returns a Result, and the button's state comes from the call's own
  // participant state, which does not change on failure. A viewer without
  // `sendAudio` pressed the button and got no movement, no message, no log.
  testWidgets('StreamMicrophoneButton reports a refusal', (tester) async {
    final localParticipant = MockCallParticipantState();
    final call = MockCall();
    Object? reported;

    when(() => localParticipant.isAudioEnabled).thenReturn(true);
    when(
      () => call.setMicrophoneEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async => const Result.failure(_refused));

    await tester.pumpWidget(
      TestWrapper(
        child: StreamMicrophoneButton(
          localParticipant: localParticipant,
          call: call,
          onError: (error) => reported = error,
        ),
      ),
    );

    await tester.tap(find.byIcon(icons.voiceFill));
    await tester.pumpAndSettle();

    expect(reported, _refused);
  });

  testWidgets('StreamCameraButton reports a refusal', (tester) async {
    final localParticipant = MockCallParticipantState();
    final call = MockCall();
    Object? reported;

    when(() => localParticipant.isVideoEnabled).thenReturn(true);
    when(
      () => call.setCameraEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async => const Result.failure(_refused));

    await tester.pumpWidget(
      TestWrapper(
        child: StreamCameraButton(
          localParticipant: localParticipant,
          call: call,
          onError: (error) => reported = error,
        ),
      ),
    );

    await tester.tap(find.byIcon(icons.videoFill));
    await tester.pumpAndSettle();

    expect(reported, _refused);
  });

  // A control with no listener still has to survive the refusal rather than
  // throw out of the button's callback.
  testWidgets('StreamMicrophoneButton survives a refusal unwatched', (
    tester,
  ) async {
    final localParticipant = MockCallParticipantState();
    final call = MockCall();

    when(() => localParticipant.isAudioEnabled).thenReturn(true);
    when(
      () => call.setMicrophoneEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async => const Result.failure(_refused));

    await tester.pumpWidget(
      TestWrapper(
        child: StreamMicrophoneButton(
          localParticipant: localParticipant,
          call: call,
        ),
      ),
    );

    await tester.tap(find.byIcon(icons.voiceFill));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  // The plain toggles had no way to say a device was missing, so a phone bar
  // using them lost the badge the split buttons show. `devices` is opt-in:
  // enumerating devices to draw a mic button is a cost a screen chooses.
  group('with devices', () {
    late StreamController<List<RtcMediaDevice>> deviceChanges;
    late StreamMediaDevicesController devices;

    setUp(() {
      deviceChanges = StreamController<List<RtcMediaDevice>>.broadcast();

      final notifier = MockRtcMediaDeviceNotifier();
      when(
        () => notifier.onDeviceChange,
      ).thenAnswer((_) => deviceChanges.stream);
      when(
        notifier.enumerateDevices,
      ).thenAnswer((_) async => const Result.success(<RtcMediaDevice>[]));

      devices = StreamMediaDevicesController(deviceNotifier: notifier);
      addTearDown(devices.dispose);
    });

    tearDown(() => deviceChanges.close());

    Future<void> pump(WidgetTester tester) async {
      final localParticipant = MockCallParticipantState();
      when(() => localParticipant.isAudioEnabled).thenReturn(true);

      await tester.pumpWidget(
        TestWrapper(
          child: StreamMicrophoneButton(
            localParticipant: localParticipant,
            call: MockCall(),
            devices: devices,
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    CallControlButton button(WidgetTester tester) =>
        tester.widget<CallControlButton>(find.byType(CallControlButton));

    testWidgets('badges and disables a microphone the platform lacks', (
      tester,
    ) async {
      await pump(tester);
      deviceChanges.add(const []);
      await tester.pumpAndSettle();

      expect(button(tester).showErrorBadge, isTrue);
      expect(button(tester).onPressed, isNull);
      // Badged, not muted: an absent device is not a choice the user made.
      expect(button(tester).tone, CallControlTone.neutral);
    });

    testWidgets('says nothing until the platform has answered', (tester) async {
      await pump(tester);

      expect(button(tester).showErrorBadge, isFalse);
      expect(button(tester).onPressed, isNotNull);
    });

    testWidgets('clears the badge once a microphone appears', (tester) async {
      await pump(tester);
      deviceChanges.add(const []);
      await tester.pumpAndSettle();
      deviceChanges.add(const [
        RtcMediaDevice(
          id: 'mic-1',
          label: 'MacBook Pro Microphone',
          kind: RtcMediaDeviceKind.audioInput,
        ),
      ]);
      await tester.pumpAndSettle();

      expect(button(tester).showErrorBadge, isFalse);
      expect(button(tester).onPressed, isNotNull);
    });
  });

  // A typedef to a class carries its constructors, so an unmigrated call site
  // keeps compiling rather than only the type annotation surviving.
  testWidgets('the deprecated name still builds one', (tester) async {
    final localParticipant = MockCallParticipantState();
    when(() => localParticipant.isAudioEnabled).thenReturn(true);

    await tester.pumpWidget(
      TestWrapper(
        // ignore: deprecated_member_use_from_same_package
        child: ToggleMicrophoneOption(
          localParticipant: localParticipant,
          call: MockCall(),
        ),
      ),
    );

    expect(find.byType(StreamMicrophoneButton), findsOneWidget);
  });
}

const _refused = 'the call refused';
