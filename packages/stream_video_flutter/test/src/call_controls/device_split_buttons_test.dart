import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

const _camera = RtcMediaDevice(
  id: 'cam-1',
  label: 'FaceTime HD Camera',
  kind: RtcMediaDeviceKind.videoInput,
);
const _microphone = RtcMediaDevice(
  id: 'mic-1',
  label: 'MacBook Pro Microphone',
  kind: RtcMediaDeviceKind.audioInput,
);

void main() {
  late StreamController<List<RtcMediaDevice>> deviceChanges;
  late StreamMediaDevicesController devices;

  setUp(() {
    deviceChanges = StreamController<List<RtcMediaDevice>>.broadcast();

    final notifier = MockRtcMediaDeviceNotifier();
    when(() => notifier.onDeviceChange).thenAnswer((_) => deviceChanges.stream);
    when(
      notifier.enumerateDevices,
    ).thenAnswer((_) async => const Result.success(<RtcMediaDevice>[]));

    devices = StreamMediaDevicesController(deviceNotifier: notifier);
    addTearDown(devices.dispose);
  });

  tearDown(() => deviceChanges.close());

  Future<void> pump(
    WidgetTester tester, {
    StreamMenuDirection direction = StreamMenuDirection.down,
  }) async {
    await tester.pumpWidget(
      TestWrapper(
        platform: TargetPlatform.macOS,
        child: ListenableBuilder(
          listenable: devices,
          builder: (context, _) => StreamCameraSplitButton.withDevices(
            devices: devices,
            enabled: false,
            menuDirection: direction,
            onPressed: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  // What an iOS simulator reports: no camera at all. The caret used to open a
  // menu whose only entry was "System default", which could pick nothing.
  testWidgets('offers no menu when the platform names no device', (
    tester,
  ) async {
    await pump(tester);

    expect(devices.videoInputs, isEmpty);

    await tester.tap(find.byIcon(const StreamIcons().caretDown));
    await tester.pumpAndSettle();

    expect(find.text('System default'), findsNothing);
    expect(find.byType(StreamContextMenuAction<void>), findsNothing);
  });

  // Closed, the caret points where the menu will appear; open, it points back
  // at the anchor, which is the way to close it again.
  group('caret', () {
    const icons = StreamIcons();

    testWidgets('points down, then up, for a menu that opens below', (
      tester,
    ) async {
      await pump(tester);
      deviceChanges.add(const [_camera]);
      await tester.pumpAndSettle();

      expect(find.byIcon(icons.caretDown), findsOneWidget);

      await tester.tap(find.byIcon(icons.caretDown));
      await tester.pumpAndSettle();

      expect(find.byIcon(icons.caretUp), findsOneWidget);
    });

    testWidgets('points up, then down, for a menu that opens above', (
      tester,
    ) async {
      await pump(tester, direction: StreamMenuDirection.up);
      deviceChanges.add(const [_camera]);
      await tester.pumpAndSettle();

      expect(find.byIcon(icons.caretUp), findsOneWidget);

      await tester.tap(find.byIcon(icons.caretUp));
      await tester.pumpAndSettle();

      expect(find.byIcon(icons.caretDown), findsOneWidget);
    });
  });

  testWidgets('offers the system default once there is a device', (
    tester,
  ) async {
    await pump(tester);

    deviceChanges.add(const [_camera]);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(const StreamIcons().caretDown));
    await tester.pumpAndSettle();

    expect(find.text('System default'), findsOneWidget);
    expect(find.text('FaceTime HD Camera'), findsOneWidget);
  });

  // The call-driven constructor is what an in-call bar reaches for: it reads
  // the call's camera state, toggles it, and disables itself when the
  // platform names no camera — the wiring every app was repeating.
  group('over a call', () {
    late MockCall call;
    late MockCallState callState;
    late MockCallParticipantState localParticipant;

    setUp(() {
      call = MockCall();
      callState = MockCallState();
      localParticipant = MockCallParticipantState();

      // The map the enabled state is derived from, rather than the derived
      // getter: the control reads the track so it can tell an unreported one
      // from a muted one.
      when(() => localParticipant.publishedTracks).thenReturn({
        SfuTrackType.video: TrackState.local(),
      });
      when(() => callState.localParticipant).thenReturn(localParticipant);
      when(() => call.connectOptions).thenReturn(const CallConnectOptions());

      final emitter = MutableStateEmitter<CallState>(callState, sync: true);
      when(() => call.state).thenAnswer((_) => emitter);
      when(() => call.partialState<bool?>(any())).thenAnswer((invocation) {
        final CallStateSelector<bool?> selector =
            invocation.positionalArguments[0];
        return Stream.value(selector(callState));
      });
      when(
        () => call.setCameraEnabled(enabled: any(named: 'enabled')),
      ).thenAnswer((_) async => const Result.success(none));
    });

    Future<void> pumpCall(
      WidgetTester tester, {
      StreamMediaDevicesController? shared,
    }) async {
      await tester.pumpWidget(
        TestWrapper(
          platform: TargetPlatform.macOS,
          child: StreamCameraSplitButton(call: call, devices: shared),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets("turns the call's camera off", (tester) async {
      await pumpCall(tester, shared: devices);
      deviceChanges.add(const [_camera]);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(const StreamIcons().videoFill));
      await tester.pumpAndSettle();

      verify(() => call.setCameraEnabled(enabled: false)).called(1);
    });

    // What an iOS simulator reports. Badging is appearance only, so the
    // button has to be disabled as well or it looks pressable and is.
    testWidgets('disables itself when the platform names no camera', (
      tester,
    ) async {
      await pumpCall(tester, shared: devices);
      // An empty enumeration, rather than none yet: before the platform has
      // answered the lists are empty because nothing has been asked.
      deviceChanges.add(const []);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(const StreamIcons().videoFill));
      await tester.pumpAndSettle();

      verifyNever(() => call.setCameraEnabled(enabled: any(named: 'enabled')));
    });

    // Before the first enumeration the lists are empty because nothing has
    // been asked; a button that read them straight away would badge itself as
    // the call opens.
    testWidgets('stays live until the platform has answered', (tester) async {
      await pumpCall(tester, shared: devices);

      await tester.tap(find.byIcon(const StreamIcons().videoFill));
      await tester.pumpAndSettle();

      verify(() => call.setCameraEnabled(enabled: false)).called(1);
    });

    // Owns a controller when none is given, and disposes it — a leak here
    // would keep a device subscription alive for every bar ever built.
    testWidgets('builds and disposes a controller of its own', (tester) async {
      // A live stream, not Stream.empty(): the assertion below depends on
      // being able to notify the controller after the widget is gone.
      final ownedDeviceChanges =
          StreamController<List<RtcMediaDevice>>.broadcast();
      addTearDown(ownedDeviceChanges.close);

      final notifier = MockRtcMediaDeviceNotifier();
      when(
        () => notifier.onDeviceChange,
      ).thenAnswer((_) => ownedDeviceChanges.stream);
      when(
        notifier.enumerateDevices,
      ).thenAnswer((_) async => const Result.success(<RtcMediaDevice>[]));
      RtcMediaDeviceNotifier.instance = notifier;
      addTearDown(() => RtcMediaDeviceNotifier.instance = null);

      await pumpCall(tester);
      expect(find.byType(StreamCameraSplitButton), findsOneWidget);

      // The controller it built subscribed to the device stream, which is the
      // thing a leak would keep alive.
      expect(ownedDeviceChanges.hasListener, isTrue);

      await tester.pumpWidget(const TestWrapper(child: SizedBox()));
      await tester.pumpAndSettle();

      // Disposing the controller cancels that subscription. Notifying it
      // instead proves nothing: dispose cancels first, so a leaked controller
      // would be just as silent.
      expect(ownedDeviceChanges.hasListener, isFalse);
    });
  });

  // The microphone half of 'over a call'. The two split buttons are separate
  // implementations rather than one generic, so the camera group above gives
  // this none of its coverage.
  group('a microphone over a call', () {
    late MockCall call;
    late MockCallState callState;
    late MockCallParticipantState localParticipant;

    setUp(() {
      call = MockCall();
      callState = MockCallState();
      localParticipant = MockCallParticipantState();

      when(() => localParticipant.publishedTracks).thenReturn({
        SfuTrackType.audio: TrackState.local(),
      });
      when(() => callState.localParticipant).thenReturn(localParticipant);
      when(() => call.connectOptions).thenReturn(const CallConnectOptions());

      final emitter = MutableStateEmitter<CallState>(callState, sync: true);
      when(() => call.state).thenAnswer((_) => emitter);
      when(() => call.partialState<bool?>(any())).thenAnswer((invocation) {
        final CallStateSelector<bool?> selector =
            invocation.positionalArguments[0];
        return Stream.value(selector(callState));
      });
      when(
        () => call.setMicrophoneEnabled(
          enabled: any(named: 'enabled'),
          stopTrackOnMute: any(named: 'stopTrackOnMute'),
        ),
      ).thenAnswer((_) async => const Result.success(none));
    });

    Future<void> pumpCall(WidgetTester tester, {bool? stopTrackOnMute}) async {
      await tester.pumpWidget(
        TestWrapper(
          platform: TargetPlatform.macOS,
          child: StreamMicrophoneSplitButton(
            call: call,
            devices: devices,
            stopTrackOnMute: stopTrackOnMute,
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    // Reads audioInputs and the call's audio track, not the camera's.
    testWidgets("turns the call's microphone off", (tester) async {
      await pumpCall(tester);
      deviceChanges.add(const [_microphone]);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(const StreamIcons().voiceFill));
      await tester.pumpAndSettle();

      verify(
        () => call.setMicrophoneEnabled(
          enabled: false,
          stopTrackOnMute: any(named: 'stopTrackOnMute'),
        ),
      ).called(1);
    });

    testWidgets('disables itself when the platform names no microphone', (
      tester,
    ) async {
      await pumpCall(tester);
      deviceChanges.add(const []);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(const StreamIcons().voiceFill));
      await tester.pumpAndSettle();

      verifyNever(
        () => call.setMicrophoneEnabled(
          enabled: any(named: 'enabled'),
          stopTrackOnMute: any(named: 'stopTrackOnMute'),
        ),
      );
    });

    testWidgets('a camera the platform lacks leaves it alone', (tester) async {
      await pumpCall(tester);
      deviceChanges.add(const [_microphone]);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(const StreamIcons().voiceFill));
      await tester.pumpAndSettle();

      verify(
        () => call.setMicrophoneEnabled(
          enabled: false,
          stopTrackOnMute: any(named: 'stopTrackOnMute'),
        ),
      ).called(1);
    });

    // Speaking-while-muted detection needs the track kept alive on iOS and
    // macOS, so the flag has to reach the call rather than being dropped.
    testWidgets('passes stopTrackOnMute through to the call', (tester) async {
      await pumpCall(tester, stopTrackOnMute: false);
      deviceChanges.add(const [_microphone]);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(const StreamIcons().voiceFill));
      await tester.pumpAndSettle();

      verify(
        () => call.setMicrophoneEnabled(
          enabled: false,
          stopTrackOnMute: false,
        ),
      ).called(1);
    });
  });
}
