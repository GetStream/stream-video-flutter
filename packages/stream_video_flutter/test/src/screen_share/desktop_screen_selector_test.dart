import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';
import 'fake_desktop_capturer.dart';

void main() {
  late FakeDesktopCapturer capturer;

  final screen1 = FakeDesktopCapturerSource(
    id: 'screen-1',
    name: 'Screen 1',
    type: SourceType.Screen,
    thumbnail: blueThumbnail,
  );
  final screen2 = FakeDesktopCapturerSource(
    id: 'screen-2',
    name: 'Screen 2',
    type: SourceType.Screen,
    thumbnail: greyThumbnail,
  );
  final window = FakeDesktopCapturerSource(
    id: 'window-1',
    name: 'Notes',
    type: SourceType.Window,
    thumbnail: greyThumbnail,
  );

  setUp(() {
    capturer = FakeDesktopCapturer(sources: [screen1, screen2, window]);
  });

  Future<ScreenShareSourceController> pumpSelector(WidgetTester tester) async {
    final controller = ScreenShareSourceController(capturer: capturer);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      TestWrapper(
        child: SizedBox(
          width: 720,
          height: 500,
          child: StreamScreenShareSelector(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return controller;
  }

  group('StreamScreenShareSelector', () {
    testWidgets('shows the screens of the selected tab', (tester) async {
      await pumpSelector(tester);

      expect(find.text('Screen 1'), findsOneWidget);
      expect(find.text('Screen 2'), findsOneWidget);
      expect(find.text('Notes'), findsNothing);
    });

    testWidgets('switching to the window tab shows windows, and reloads '
        'nothing', (tester) async {
      await pumpSelector(tester);

      await tester.tap(find.text('Window'));
      await tester.pumpAndSettle();

      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('Screen 1'), findsNothing);
      expect(
        capturer.getSourcesCalls,
        hasLength(1),
        reason: 'both types were loaded up front',
      );
    });

    testWidgets('tapping a thumbnail selects its source', (tester) async {
      final controller = await pumpSelector(tester);

      await tester.tap(find.text('Screen 2'));
      await tester.pumpAndSettle();

      expect(controller.value.selectedSource, screen2);
    });

    testWidgets('says so when the platform offers nothing', (tester) async {
      capturer.sources = [];
      await pumpSelector(tester);

      expect(find.text('Nothing to share here.'), findsOneWidget);
    });

    testWidgets('never polls the platform while it is open', (tester) async {
      await pumpSelector(tester);
      // A leaked Timer.periodic would also fail the test outright, at
      // teardown; this says which one it was.
      await tester.pump(const Duration(seconds: 10));

      expect(capturer.updateSourcesCallCount, 0);
    });
  });

  group('StreamScreenShareDialog', () {
    Future<ScreenShareSourceController> pumpDialog(WidgetTester tester) async {
      final controller = ScreenShareSourceController(capturer: capturer);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        TestWrapper(
          child: StreamScreenShareDialog(controller: controller),
        ),
      );
      await tester.pumpAndSettle();
      return controller;
    }

    testWidgets('the refresh action re-reads the platform', (tester) async {
      await pumpDialog(tester);
      expect(capturer.getSourcesCalls, hasLength(1));

      await tester.tap(find.byIcon(const StreamIcons().refresh));
      await tester.pumpAndSettle();

      expect(capturer.getSourcesCalls, hasLength(2));
    });

    testWidgets('Share is disabled until a source is picked', (tester) async {
      await pumpDialog(tester);

      StreamButton shareButton() => tester.widget<StreamButton>(
        find.ancestor(
          of: find.text('Share'),
          matching: find.byType(StreamButton),
        ),
      );

      expect(shareButton().props.onPressed, isNull);

      await tester.tap(find.text('Screen 1'));
      await tester.pumpAndSettle();

      expect(shareButton().props.onPressed, isNotNull);
    });
  });

  group('showDefaultScreenSelectionDialog', () {
    testWidgets('opens the modal and cancels with nothing', (tester) async {
      // The real entry point, on the real global capturer: there is no
      // platform behind it under `flutter test`, so the load fails and the
      // grid says it has nothing — which is enough to prove the dialog opens,
      // dismisses, and returns null.
      DesktopCapturerSource? result;
      var popped = false;

      await tester.pumpWidget(
        TestWrapper(
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await showDefaultScreenSelectionDialog(context);
                popped = true;
              },
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      // Explicit pumps rather than pumpAndSettle: the loading spinner repeats
      // forever, and there is no platform here to finish the load.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Choose what to share'), findsOneWidget);
      expect(find.text('Entire Screen'), findsOneWidget);
      expect(find.text('Window'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(popped, isTrue);
      expect(result, isNull);
    });

    testWidgets('shares the picked source and cancels with nothing', (
      tester,
    ) async {
      // The dialog builds its own controller off the global capturer, which a
      // test cannot reach, so the dialog chrome is exercised around a selector
      // driven by the fake.
      final controller = ScreenShareSourceController(capturer: capturer);
      addTearDown(controller.dispose);

      DesktopCapturerSource? result;
      var popped = false;

      await tester.pumpWidget(
        TestWrapper(
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await showStreamModalDialog<DesktopCapturerSource>(
                  context: context,
                  builder: (context) => ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (context, state, _) => StreamModalDialog(
                      title: const Text('Choose what to share'),
                      actions: [
                        StreamButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        StreamButton(
                          onPressed: state.selectedSource == null
                              ? null
                              : () => Navigator.pop(
                                  context,
                                  state.selectedSource,
                                ),
                          child: const Text('Share'),
                        ),
                      ],
                      child: StreamScreenShareSelector(controller: controller),
                    ),
                  ),
                );
                popped = true;
              },
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Choose what to share'), findsOneWidget);

      // Nothing picked yet, so Share does nothing.
      await tester.tap(find.text('Share'));
      await tester.pumpAndSettle();
      expect(popped, isFalse);

      await tester.tap(find.text('Screen 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Share'));
      await tester.pumpAndSettle();

      expect(popped, isTrue);
      expect(result, screen1);
    });
  });
}
