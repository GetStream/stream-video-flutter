import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

// The camera half of what stream_microphone_button_test.dart pins for the
// microphone. The two buttons are separate implementations rather than one
// generic, so nothing here is covered transitively.
void main() {
  // The icons the widget resolves off `context.streamIcons`; the defaults are
  // what TestWrapper's theme installs.
  const icons = StreamIcons();

  testWidgets('StreamCameraButton toggles the call camera', (tester) async {
    var isVideoEnabled = true;

    final localParticipant = MockCallParticipantState();
    final call = MockCall();

    when(() => localParticipant.publishedTracks).thenReturn({
      SfuTrackType.video: TrackState.local(muted: !isVideoEnabled),
    });
    when(
      () => call.setCameraEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer((invocation) async {
      isVideoEnabled = invocation.namedArguments[const Symbol('enabled')]
          as bool;
      return const Result.success(none);
    });

    await tester.pumpWidget(
      TestWrapper(
        child: StreamCameraButton(
          localParticipant: localParticipant,
          call: call,
        ),
      ),
    );

    expect(find.byIcon(icons.videoFill), findsOneWidget);

    await tester.tap(find.byIcon(icons.videoFill));
    await tester.pumpAndSettle();

    verify(() => call.setCameraEnabled(enabled: false)).called(1);
  });

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
      when(
        () => localParticipant.publishedTracks,
      ).thenReturn({SfuTrackType.video: TrackState.local()});

      await tester.pumpWidget(
        TestWrapper(
          child: StreamCameraButton(
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

    // Reads videoInputs, not audioInputs: pointing this at the microphone's
    // list is the copy-paste slip the two separate implementations invite.
    testWidgets('badges and disables a camera the platform lacks', (
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

    testWidgets('is unmoved by a microphone the platform lacks', (tester) async {
      await pump(tester);
      deviceChanges.add(const [
        RtcMediaDevice(
          id: 'cam-1',
          label: 'FaceTime HD Camera',
          kind: RtcMediaDeviceKind.videoInput,
        ),
      ]);
      await tester.pumpAndSettle();

      expect(button(tester).showErrorBadge, isFalse);
      expect(button(tester).onPressed, isNotNull);
    });

    testWidgets('says nothing until the platform has answered', (tester) async {
      await pump(tester);

      expect(button(tester).showErrorBadge, isFalse);
      expect(button(tester).onPressed, isNotNull);
    });

    testWidgets('clears the badge once a camera appears', (tester) async {
      await pump(tester);
      deviceChanges.add(const []);
      await tester.pumpAndSettle();
      deviceChanges.add(const [
        RtcMediaDevice(
          id: 'cam-1',
          label: 'FaceTime HD Camera',
          kind: RtcMediaDeviceKind.videoInput,
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
    when(
      () => localParticipant.publishedTracks,
    ).thenReturn({SfuTrackType.video: TrackState.local()});

    await tester.pumpWidget(
      TestWrapper(
        // ignore: deprecated_member_use_from_same_package
        child: ToggleCameraOption(
          localParticipant: localParticipant,
          call: MockCall(),
        ),
      ),
    );

    expect(find.byType(StreamCameraButton), findsOneWidget);
  });

  group('while the track has not been reported', () {
    late MockCall call;
    late MockCallState callState;

    void givenLocalParticipant(Map<SfuTrackType, TrackState> tracks) {
      final participant = MockCallParticipantState();
      when(() => participant.publishedTracks).thenReturn(tracks);
      when(() => callState.localParticipant).thenReturn(participant);
    }

    setUp(() {
      call = MockCall();
      callState = MockCallState();

      final emitter = MutableStateEmitter<CallState>(callState, sync: true);
      when(() => call.state).thenAnswer((_) => emitter);
      when(() => call.partialState<bool?>(any())).thenAnswer((invocation) {
        final CallStateSelector<bool?> selector =
            invocation.positionalArguments[0];
        return Stream.value(selector(callState));
      });
    });

    Future<CallControlButton> pumpButton(
      WidgetTester tester, {
      required TrackOption camera,
    }) async {
      when(() => call.connectOptions).thenReturn(
        CallConnectOptions(camera: camera),
      );

      await tester.pumpWidget(
        TestWrapper(child: StreamCameraButton(call: call)),
      );
      await tester.pumpAndSettle();

      return tester.widget<CallControlButton>(find.byType(CallControlButton));
    }

    testWidgets('draws a call joined with the camera on as on', (tester) async {
      when(() => callState.localParticipant).thenReturn(null);

      final button = await pumpButton(tester, camera: TrackOption.enabled());

      expect(button.tone, CallControlTone.neutral);
      expect(find.byIcon(icons.videoFill), findsOneWidget);
    });

    // A track handed over from the lobby, which only provides one for a device
    // it actually opened.
    testWidgets('counts a provided track as on', (tester) async {
      when(() => callState.localParticipant).thenReturn(null);

      final button = await pumpButton(
        tester,
        camera: TrackOption.provided(MockRtcLocalVideoTrack()),
      );

      expect(button.tone, CallControlTone.neutral);
    });

    testWidgets('draws a call joined with the camera off as off', (
      tester,
    ) async {
      when(() => callState.localParticipant).thenReturn(null);

      final button = await pumpButton(tester, camera: TrackOption.disabled());

      expect(button.tone, CallControlTone.negative);
      expect(find.byIcon(icons.videoOffFill), findsOneWidget);
    });

    // The local participant can exist before its tracks do, which is the
    // window the flash actually happened in.
    testWidgets('falls back for a participant with no tracks yet', (
      tester,
    ) async {
      givenLocalParticipant(const {});

      final button = await pumpButton(tester, camera: TrackOption.enabled());

      expect(button.tone, CallControlTone.neutral);
    });

    // Reads connectOptions.camera, not .microphone.
    testWidgets('ignores the microphone intent', (tester) async {
      when(() => callState.localParticipant).thenReturn(null);
      when(() => call.connectOptions).thenReturn(
        CallConnectOptions(
          camera: TrackOption.disabled(),
          microphone: TrackOption.enabled(),
        ),
      );

      await tester.pumpWidget(
        TestWrapper(child: StreamCameraButton(call: call)),
      );
      await tester.pumpAndSettle();

      final button = tester.widget<CallControlButton>(
        find.byType(CallControlButton),
      );
      expect(button.tone, CallControlTone.negative);
    });

    // The half that must not regress: once the track exists, it decides.
    testWidgets('a reported mute wins over the intent', (tester) async {
      givenLocalParticipant({
        SfuTrackType.video: TrackState.local(muted: true),
      });

      final button = await pumpButton(tester, camera: TrackOption.enabled());

      expect(button.tone, CallControlTone.negative);
      expect(find.byIcon(icons.videoOffFill), findsOneWidget);
    });

    testWidgets('a reported unmute wins over a disabled intent', (
      tester,
    ) async {
      givenLocalParticipant({SfuTrackType.video: TrackState.local()});

      final button = await pumpButton(tester, camera: TrackOption.disabled());

      expect(button.tone, CallControlTone.neutral);
    });
  });
}
