import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/src/renderer/video_renderer.dart';

void main() {
  const landscape = 1920 / 1080;
  const portrait = 1080 / 1920;
  const portraitPhone = Size(390, 844);
  const landscapePhone = Size(844, 390);

  group('resolveVideoFit', () {
    test('returns cover and contain unchanged', () {
      for (final fit in [VideoFit.cover, VideoFit.contain]) {
        expect(
          resolveVideoFit(
            fit,
            videoAspectRatio: landscape,
            viewSize: portraitPhone,
          ),
          fit,
        );
      }
    });

    group('adaptive', () {
      VideoFit resolve(double aspectRatio, Size? viewSize) => resolveVideoFit(
        VideoFit.adaptive,
        videoAspectRatio: aspectRatio,
        viewSize: viewSize,
      );

      test('letterboxes a landscape feed on a portrait screen', () {
        expect(resolve(landscape, portraitPhone), VideoFit.contain);
      });

      test('letterboxes a portrait feed on a landscape screen', () {
        expect(resolve(portrait, landscapePhone), VideoFit.contain);
      });

      test('fills when the feed and the screen share an orientation', () {
        expect(resolve(portrait, portraitPhone), VideoFit.cover);
        expect(resolve(landscape, landscapePhone), VideoFit.cover);
      });

      test('treats a square feed or view as landscape', () {
        expect(resolve(1, landscapePhone), VideoFit.cover);
        expect(resolve(1, portraitPhone), VideoFit.contain);
        expect(resolve(landscape, const Size(500, 500)), VideoFit.cover);
      });

      test('follows the video alone when the view cannot be measured', () {
        for (final viewSize in [null, Size.infinite, Size.zero]) {
          expect(resolve(landscape, viewSize), VideoFit.cover);
          expect(resolve(portrait, viewSize), VideoFit.contain);
        }
      });
    });
  });
}
