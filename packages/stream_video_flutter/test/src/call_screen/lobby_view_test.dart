import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

const _builtInMic = RtcMediaDevice(
  id: 'mic-1',
  label: 'MacBook Pro Microphone',
  kind: RtcMediaDeviceKind.audioInput,
);
const _frontCamera = RtcMediaDevice(
  id: 'cam-1',
  label: 'FaceTime HD Camera',
  kind: RtcMediaDeviceKind.videoInput,
);

/// The three presets, each swept across the three breakpoints.
///
/// The sweep is what proves the two axes are independent: the preset decides
/// *which* widgets exist, the width decides *where* the control row sits and
/// how big the preview is. A `simple` lobby at 1440 must still overlay its
/// controls, and a `full` lobby at 375 must still stack them below the preview
/// and keep its settings row.
///
/// 500 stands for the narrow desktop window: below the breakpoint, so it lays
/// out like a phone, but still a pointer device, so a host gives it the `full`
/// preset — toggles below the feed *and* a settings row.
// Each width is paired with a height generous enough for the tallest preset
// at it. StreamParticipantTile has a LayoutBuilder inside — it sheds chrome to
// fit — and alchemist lays its scenarios out in a Table, which asks for
// intrinsic dimensions a LayoutBuilder cannot give. Tight constraints in both
// axes stop the Table descending that far.
const _widths = <String, Size>{
  '375': Size(375, 620),
  '500': Size(500, 760),
  '900': Size(900, 700),
  '1440': Size(1440, 700),
};

void main() {
  late StreamController<List<RtcMediaDevice>> deviceChanges;
  late StreamLobbyController controller;
  late MockCall call;

  setUp(() {
    deviceChanges = StreamController<List<RtcMediaDevice>>.broadcast();

    final notifier = MockRtcMediaDeviceNotifier();
    when(() => notifier.onDeviceChange).thenAnswer((_) => deviceChanges.stream);
    when(
      notifier.enumerateDevices,
    ).thenAnswer((_) async => const Result.success(<RtcMediaDevice>[]));

    final video = MockStreamVideo();
    when(
      () => video.currentUser,
    ).thenReturn(const UserInfo(id: 'local', name: 'Rene Floor'));
    when(() => video.events).thenAnswer((_) => const Stream.empty());

    final callState = MockCallState();
    // Both off, so no track is opened: RtcLocalTrack's factories are static
    // and there is no camera under `flutter test` anyway.
    when(() => callState.settings).thenReturn(
      const CallSettings(
        audio: StreamAudioSettings(micDefaultOn: false),
        video: StreamVideoSettings(cameraDefaultOn: false),
      ),
    );

    call = MockCall();
    when(() => call.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(callState, sync: true),
    );
    when(call.getOrCreate).thenAnswer(
      (_) async => Result.failure(StateError('no network'), StackTrace.empty),
    );

    controller = StreamLobbyController(
      call: call,
      streamVideo: video,
      deviceNotifier: notifier,
    );
    addTearDown(controller.dispose);
  });

  tearDown(() => deviceChanges.close());

  /// A controller whose microphone and camera both refuse to open, as they do
  /// on a simulator with no capture hardware.
  StreamLobbyController unavailableDevices() {
    final notifier = MockRtcMediaDeviceNotifier();
    when(() => notifier.onDeviceChange).thenAnswer((_) => deviceChanges.stream);
    when(
      notifier.enumerateDevices,
    ).thenAnswer((_) async => const Result.success(<RtcMediaDevice>[]));

    final video = MockStreamVideo();
    when(
      () => video.currentUser,
    ).thenReturn(const UserInfo(id: 'local', name: 'Rene Floor'));
    when(() => video.events).thenAnswer((_) => const Stream.empty());

    final callState = MockCallState();
    // Both on, so the lobby tries to open them and finds nothing.
    when(() => callState.settings).thenReturn(const CallSettings());

    final failing = MockCall();
    when(() => failing.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(callState, sync: true),
    );
    when(failing.getOrCreate).thenAnswer(
      (_) async => Result.failure(StateError('no network'), StackTrace.empty),
    );
    when(failing.ensureNativeFactory).thenThrow(StateError('no device'));

    final controller = StreamLobbyController(
      call: failing,
      streamVideo: video,
      deviceNotifier: notifier,
    );
    addTearDown(controller.dispose);
    return controller;
  }

  Widget lobbyWith(
    StreamLobbyController controller,
    StreamLobbyActions actions,
    double width,
  ) => MediaQuery(
    data: MediaQueryData(size: Size(width, 900)),
    child: SizedBox(
      width: width,
      child: StreamLobbyView(
        call: controller.call,
        controller: controller,
        actions: actions,
        onJoinCallPressed: (_) => true,
      ),
    ),
  );

  Widget lobby(StreamLobbyActions actions, double width) => MediaQuery(
    // StreamScreenSize reads MediaQuery.sizeOf, so sizing the alchemist
    // surface alone would leave every case reporting the same breakpoint.
    data: MediaQueryData(size: Size(width, 900)),
    child: SizedBox(
      width: width,
      child: StreamLobbyView(
        call: controller.call,
        controller: controller,
        actions: actions,
        onJoinCallPressed: (_) => true,
      ),
    ),
  );

  // What an iOS simulator shows: no camera at all, so opening one throws. The
  // control is badged but still pressable — a failed open is worth retrying —
  // which is what this snapshot pins.
  for (final brightness in Brightness.values) {
    streamGoldenTest(
      'StreamLobbyView marks an unavailable device',
      fileName: 'stream_lobby_view_unavailable',
      brightness: brightness,
      constraints: const BoxConstraints(maxWidth: 900),
      builder: () => GoldenTestGroup(
        columns: 1,
        children: [
          GoldenTestScenario(
            name: 'toggles',
            child: SizedBox(
              width: 900,
              height: 690,
              child: lobbyWith(
                unavailableDevices(),
                StreamLobbyActions.simple(),
                900,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'split buttons',
            child: SizedBox(
              width: 900,
              height: 690,
              child: lobbyWith(
                unavailableDevices(),
                StreamLobbyActions.regular(),
                900,
              ),
            ),
          ),
        ],
      ),
      pumpBeforeTest: (tester) async {
        await tester.pump();
        // The camera is opened on the first frame and fails; pump past it.
        await tester.pump(const Duration(milliseconds: 100));
      },
    );
  }

  for (final (preset, build) in <(String, StreamLobbyActions Function())>[
    ('simple', StreamLobbyActions.simple),
    ('regular', StreamLobbyActions.regular),
    ('full', StreamLobbyActions.full),
    // What dogfooding shows on a tablet, and the case that made the rule
    // necessary: four controls overlaid on the preview run into the
    // participant label, so the row drops below it instead.
    (
      'extras',
      () => StreamLobbyActions.regular(
        extraControls: const [
          StreamLobbyParticipantsControl(),
          StreamLobbyCameraToggle(),
        ],
      ),
    ),
  ]) {
    for (final brightness in Brightness.values) {
      streamGoldenTest(
        'StreamLobbyView $preset across the breakpoints',
        fileName: 'stream_lobby_view_$preset',
        brightness: brightness,
        constraints: const BoxConstraints(maxWidth: 1440),
        builder: () => GoldenTestGroup(
          columns: 1,
          children: [
            for (final MapEntry(key: name, value: size) in _widths.entries)
              GoldenTestScenario(
                name: '$preset @ $name',
                child: SizedBox.fromSize(
                  size: size,
                  child: lobby(build(), size.width),
                ),
              ),
          ],
        ),
      );
    }
  }

  // The lobby builds no Scaffold and does not scroll itself, so a host has to
  // give it somewhere to overflow — as the example app and dogfooding both do.
  Widget screen(StreamLobbyActions actions, double width) => MaterialApp(
    home: Material(
      child: SingleChildScrollView(child: lobby(actions, width)),
    ),
  );

  testWidgets('the settings lane is not drawn when it is empty', (
    tester,
  ) async {
    await tester.pumpWidget(screen(StreamLobbyActions.simple(), 1440));

    expect(find.byType(StreamSelectInput), findsNothing);
    expect(find.byType(StreamLobbyMicrophoneToggle), findsOneWidget);
  });

  testWidgets("the header carries the icon and the view's title", (
    tester,
  ) async {
    await tester.pumpWidget(
      TestWrapper(
        child: SingleChildScrollView(
          child: MediaQuery(
            data: const MediaQueryData(size: Size(900, 900)),
            child: SizedBox(
              width: 900,
              child: StreamLobbyView(
                call: controller.call,
                controller: controller,
                title: const Text('Set up your call'),
                onJoinCallPressed: (_) => true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(const StreamIcons().language), findsOneWidget);
    expect(find.text('Set up your call'), findsOneWidget);
  });

  // The design puts a single line under the icon, so a subtitle is drawn only
  // where a call site asks for one.
  testWidgets('the header draws no subtitle unless it is given one', (
    tester,
  ) async {
    await tester.pumpWidget(
      TestWrapper(
        child: SingleChildScrollView(
          child: lobby(StreamLobbyActions.simple(), 900),
        ),
      ),
    );

    final header = find.byType(DefaultStreamLobbyHeader);
    expect(header, findsOneWidget);
    expect(
      find.descendant(of: header, matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  // The header is the piece an app is most likely to want its own version of,
  // so it is replaceable app-wide rather than only per call site.
  testWidgets('a registered builder replaces the header', (tester) async {
    await tester.pumpWidget(
      TestWrapper(
        child: StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: [
              ...streamVideoComponentBuilders(
                lobbyHeader: (context, props) => const Text('Branded header'),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: lobby(StreamLobbyActions.simple(), 900),
          ),
        ),
      ),
    );

    expect(find.text('Branded header'), findsOneWidget);
    expect(find.byType(DefaultStreamLobbyHeader), findsNothing);
    expect(find.byIcon(const StreamIcons().language), findsNothing);
  });

  testWidgets('the footer sits between the controls and the join button', (
    tester,
  ) async {
    await tester.pumpWidget(
      TestWrapper(
        child: SingleChildScrollView(
          child: MediaQuery(
            data: const MediaQueryData(size: Size(900, 900)),
            child: SizedBox(
              width: 900,
              child: StreamLobbyView(
                call: controller.call,
                controller: controller,
                actions: StreamLobbyActions.simple(),
                footer: const Text('Shared key'),
                joinButtonLabel: const Text('Join'),
                onJoinCallPressed: (_) => true,
              ),
            ),
          ),
        ),
      ),
    );

    final footer = tester.getCenter(find.text('Shared key')).dy;
    expect(
      footer,
      greaterThan(
        tester.getCenter(find.byType(StreamLobbyMicrophoneToggle)).dy,
      ),
    );
    expect(footer, lessThan(tester.getCenter(find.text('Join')).dy));
  });

  // Without a footer and without a builder the slot is not built at all: the
  // body's Column spaces its children out, so an empty one would leave a gap.
  testWidgets('no footer is drawn when none is asked for', (tester) async {
    await tester.pumpWidget(
      TestWrapper(
        child: SingleChildScrollView(child: lobby(StreamLobbyActions.simple(), 900)),
      ),
    );

    expect(find.byType(StreamLobbyFooter), findsNothing);
  });

  // Registering a builder is also how an app puts a footer in a lobby whose
  // call site passed none.
  testWidgets('a registered builder supplies the footer', (tester) async {
    await tester.pumpWidget(
      TestWrapper(
        child: StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: [
              ...streamVideoComponentBuilders(
                lobbyFooter: (context, props) => const Text('App-wide footer'),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: lobby(StreamLobbyActions.simple(), 900),
          ),
        ),
      ),
    );

    expect(find.text('App-wide footer'), findsOneWidget);
    expect(find.byType(DefaultStreamLobbyFooter), findsNothing);
  });

  // A device that cannot be opened is not a user choice: the control is
  // badged rather than drawn in the state a deliberate mute gets, so a
  // permission problem is not mistaken for something the user did.
  testWidgets('a device that would not open is badged but still retryable', (
    tester,
  ) async {
    final controller = unavailableDevices();
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: SingleChildScrollView(
            child: lobbyWith(controller, StreamLobbyActions.simple(), 900),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(controller.cameraUnavailable, isTrue);
    expect(controller.microphoneUnavailable, isTrue);

    final buttons = tester
        .widgetList<CallControlButton>(find.byType(CallControlButton))
        .toList();
    expect(buttons, hasLength(2));
    for (final button in buttons) {
      expect(button.showErrorBadge, isTrue);
      // Neutral, not negative: red would read as "you muted this".
      expect(button.state, CallControlState.neutral);
      // Pressable, because opening again is the only thing that clears the
      // failure — the device may have been busy, or permission since granted.
      expect(button.onPressed, isNotNull);
    }
    expect(controller.microphoneMissing, isFalse);
    expect(controller.cameraMissing, isFalse);
  });

  // "Joining remains possible with the unavailable device disabled."
  testWidgets('an unavailable device does not block joining', (tester) async {
    var joined = false;
    final controller = unavailableDevices();

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: SingleChildScrollView(
            child: MediaQuery(
              data: const MediaQueryData(size: Size(900, 900)),
              child: SizedBox(
                width: 900,
                child: StreamLobbyView(
                  call: controller.call,
                  controller: controller,
                  actions: StreamLobbyActions.simple(),
                  onJoinCallPressed: (_) {
                    joined = true;
                    return true;
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text('Join call'));
    await tester.pump();

    expect(joined, isTrue);
  });

  // Nothing reports a local audio level before joining, so an indicator here
  // would sit permanently idle.
  testWidgets('the preview shows no sound indicator', (tester) async {
    await tester.pumpWidget(screen(StreamLobbyActions.simple(), 900));

    expect(find.byType(StreamParticipantLabel), findsOneWidget);
    expect(find.byType(StreamAudioIndicator), findsNothing);
  });

  // An app that registers a `participantTile` builder adding an overflow menu
  // to every tile — as dogfooding does — would otherwise get one on the
  // preview, offering to pin or mute someone who has not joined anything.
  testWidgets('the preview shows no overflow menu', (tester) async {
    await tester.pumpWidget(
      TestWrapper(
        child: StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: [
              ...streamVideoComponentBuilders(
                participantTile: (context, props) =>
                    DefaultStreamParticipantTile(
                      props: props.copyWith(
                        actionsBuilder: (context, participant) => [
                          StreamParticipantTileAction(
                            icon: context.streamIcons.pin,
                            label: 'Pin',
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: lobby(StreamLobbyActions.simple(), 900),
          ),
        ),
      ),
    );

    expect(find.text('Pin'), findsNothing);
    expect(
      find.descendant(
        of: find.byType(DefaultStreamParticipantTile),
        matching: find.byIcon(const StreamIcons().moreHorizontal),
      ),
      findsNothing,
    );
  });

  // The preview is a participant tile, so theming the call's tiles has to
  // theme it too — that is the whole point of using the tile rather than a
  // copy of it.
  testWidgets('the preview follows StreamParticipantTileTheme', (tester) async {
    await tester.pumpWidget(
      TestWrapper(
        child: StreamParticipantTileTheme(
          data: const StreamParticipantTileThemeData(
            style: StreamParticipantTileStyle(
              backgroundColor: Color(0xFF00FF00),
            ),
          ),
          child: SingleChildScrollView(
            child: lobby(StreamLobbyActions.simple(), 900),
          ),
        ),
      ),
    );

    final decoration = tester
        .widget<Container>(
          find
              .descendant(
                of: find.byType(DefaultStreamParticipantTile),
                matching: find.byType(Container),
              )
              .first,
        )
        .decoration;

    expect((decoration! as BoxDecoration).color, const Color(0xFF00FF00));
  });

  // The overlaid row shares the preview's bottom edge with the participant
  // label, so it only ever holds a few buttons.
  testWidgets('a long control row drops below the preview', (tester) async {
    final tall = StreamLobbyActions.regular(
      extraControls: const [
        StreamLobbyParticipantsControl(),
        StreamLobbyCameraToggle(),
      ],
    );

    await tester.pumpWidget(screen(tall, 1440));

    final preview = tester.getRect(find.byType(StreamParticipantTile));
    final controls = tester.getRect(
      find.byType(StreamLobbyMicrophoneSplitButton),
    );

    expect(controls.top, greaterThanOrEqualTo(preview.bottom));
  });

  testWidgets('a short control row stays on the preview', (tester) async {
    await tester.pumpWidget(screen(StreamLobbyActions.simple(), 1440));

    final preview = tester.getRect(find.byType(StreamParticipantTile));
    final controls = tester.getRect(find.byType(StreamLobbyMicrophoneToggle));

    expect(controls.top, lessThan(preview.bottom));
  });

  testWidgets('full keeps its settings row at the small breakpoint', (
    tester,
  ) async {
    await tester.pumpWidget(screen(StreamLobbyActions.full(), 375));
    deviceChanges.add(const [_builtInMic, _frontCamera]);
    await tester.pumpAndSettle();

    expect(find.byType(StreamSelectInput), findsNWidgets(2));
  });
}
