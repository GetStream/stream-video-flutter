import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
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
const _widths = <String, double>{'375': 375, '900': 900, '1440': 1440};

void main() {
  late StreamController<List<RtcMediaDevice>> deviceChanges;
  late StreamLobbyController controller;

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

    final call = MockCall();
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

  Widget lobby(LobbyActions actions, double width) => MediaQuery(
    // StreamScreenSize reads MediaQuery.sizeOf, so sizing the alchemist
    // surface alone would leave every case reporting the same breakpoint.
    data: MediaQueryData(size: Size(width, 900)),
    child: SizedBox(
      width: width,
      child: StreamLobbyView(
        call: controller.call,
        controller: controller,
        actions: actions,
        onJoinCallPressed: (_) {},
      ),
    ),
  );

  for (final (preset, build) in <(String, LobbyActions Function())>[
    ('simple', LobbyActions.simple),
    ('regular', LobbyActions.regular),
    ('full', LobbyActions.full),
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
            for (final MapEntry(key: name, value: width) in _widths.entries)
              GoldenTestScenario(
                name: '$preset @ $name',
                child: lobby(build(), width),
              ),
          ],
        ),
      );
    }
  }

  // The lobby builds no Scaffold and does not scroll itself, so a host has to
  // give it somewhere to overflow — as the example app and dogfooding both do.
  Widget screen(LobbyActions actions, double width) => MaterialApp(
    home: Material(
      child: SingleChildScrollView(child: lobby(actions, width)),
    ),
  );

  testWidgets('the settings lane is not drawn when it is empty', (
    tester,
  ) async {
    await tester.pumpWidget(screen(LobbyActions.simple(), 1440));

    expect(find.byType(StreamSelectInput), findsNothing);
    expect(find.byType(StreamLobbyMicrophoneToggle), findsOneWidget);
  });

  testWidgets('full keeps its settings row at the small breakpoint', (
    tester,
  ) async {
    await tester.pumpWidget(screen(LobbyActions.full(), 375));
    deviceChanges.add(const [_builtInMic, _frontCamera]);
    await tester.pumpAndSettle();

    expect(find.byType(StreamSelectInput), findsNWidgets(2));
  });
}
