import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import 'fake_desktop_capturer.dart';

void main() {
  late FakeDesktopCapturer capturer;

  final screen = FakeDesktopCapturerSource(
    id: 'screen-1',
    name: 'Screen 1',
    type: SourceType.Screen,
  );
  final window = FakeDesktopCapturerSource(
    id: 'window-1',
    name: 'A window',
    type: SourceType.Window,
  );

  setUp(() {
    screen.thumbnail = null;
    window.thumbnail = null;
    capturer = FakeDesktopCapturer(sources: [screen, window]);
    addTearDown(capturer.close);
  });

  ScreenShareSourceController controller({
    SourceType sourceType = SourceType.Screen,
  }) {
    final controller = ScreenShareSourceController(
      capturer: capturer,
      sourceType: sourceType,
    );
    addTearDown(controller.dispose);
    return controller;
  }

  group('ScreenShareSourceController', () {
    test('loads both source types in a single call', () async {
      final subject = controller();
      await pumpEventQueue();

      expect(capturer.getSourcesCalls, [
        [SourceType.Screen, SourceType.Window],
      ]);
      expect(subject.value.sources, [screen, window]);
      expect(subject.value.isLoading, isFalse);
    });

    test('caps the resolution it asks the platform to capture', () async {
      controller();
      await pumpEventQueue();

      final size = capturer.requestedThumbnailSizes.single;
      expect(size, isNotNull);
      expect(
        size!.width,
        ScreenShareSourceController.defaultThumbnailSize.width,
      );
      expect(
        size.height,
        ScreenShareSourceController.defaultThumbnailSize.height,
      );
    });

    test(
      'skips the capture pass when the sources carry their bitmaps',
      () async {
        screen.thumbnail = blueThumbnail;
        window.thumbnail = greyThumbnail;

        final subject = controller();
        await pumpEventQueue();

        expect(capturer.updateSourcesCallCount, 0);
        expect(subject.value.thumbnailFor(screen), blueThumbnail);
      },
    );

    test('asks for the thumbnails once per load, never on a timer', () async {
      controller();
      await pumpEventQueue();

      expect(capturer.updateSourcesCallCount, 1);

      // Whatever the old picker's two-second timer would have fired by now.
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(Duration.zero);
        await pumpEventQueue();
      }

      expect(capturer.updateSourcesCallCount, 1);
    });

    test(
      'picks up a thumbnail the platform posts after the source list',
      () async {
        // macOS leaves the bitmaps out of the getSources result entirely.
        capturer.pendingThumbnails = {screen.id: blueThumbnail};
        final subject = controller();

        expect(subject.value.thumbnailFor(screen), isNull);

        await pumpEventQueue();

        expect(subject.value.thumbnailFor(screen), blueThumbnail);
      },
    );

    test('drops the thumbnail of a source that is gone', () async {
      capturer.pendingThumbnails = {screen.id: blueThumbnail};
      final subject = controller();
      await pumpEventQueue();
      expect(subject.value.thumbnails, hasLength(1));

      capturer
        ..sources = [window]
        ..pendingThumbnails = {};
      await subject.refresh();
      await pumpEventQueue();

      expect(subject.value.thumbnails, isEmpty);
    });

    test('switching source type filters rather than reloading', () async {
      final subject = controller();
      await pumpEventQueue();

      expect(subject.value.visibleSources, [screen]);

      subject.setSourceType(SourceType.Window);
      await pumpEventQueue();

      expect(subject.value.visibleSources, [window]);
      expect(capturer.getSourcesCalls, hasLength(1));
    });

    test('refresh reads the platform once more', () async {
      final subject = controller();
      await pumpEventQueue();

      await subject.refresh();

      expect(capturer.getSourcesCalls, hasLength(2));
    });

    test('drops a selection the platform no longer offers', () async {
      final subject = controller();
      await pumpEventQueue();

      subject.setSelectedSource(screen);
      expect(subject.value.selectedSource, screen);

      capturer.sources = [window];
      await subject.refresh();

      expect(subject.value.selectedSource, isNull);
    });

    test('reports a failed load without throwing', () async {
      final failing = _FailingDesktopCapturer();
      addTearDown(failing.close);
      final subject = ScreenShareSourceController(capturer: failing);
      addTearDown(subject.dispose);
      await pumpEventQueue();

      expect(subject.value.error, isNotNull);
      expect(subject.value.isLoading, isFalse);
      expect(subject.value.sources, isEmpty);
    });
  });
}

class _FailingDesktopCapturer extends FakeDesktopCapturer {
  @override
  Future<List<DesktopCapturerSource>> getSources({
    required List<SourceType> types,
    ThumbnailSize? thumbnailSize,
  }) async => throw Exception('no capturer here');
}
