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
    capturer = FakeDesktopCapturer(sources: [screen, window]);
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

    test('never polls the platform for updates', () async {
      controller();
      await pumpEventQueue();

      expect(capturer.updateSourcesCallCount, 0);
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
      final subject = ScreenShareSourceController(capturer: failing);
      addTearDown(subject.dispose);
      await pumpEventQueue();

      expect(subject.value.error, isNotNull);
      expect(subject.value.isLoading, isFalse);
      expect(subject.value.sources, isEmpty);
    });
  });
}

class _FailingDesktopCapturer extends DesktopCapturer {
  @override
  Future<List<DesktopCapturerSource>> getSources({
    required List<SourceType> types,
    ThumbnailSize? thumbnailSize,
  }) async => throw Exception('no capturer here');

  @override
  Future<bool> updateSources({required List<SourceType> types}) async => false;
}
