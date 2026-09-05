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
          builder: (context, _) => StreamCameraSplitButton(
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
}
