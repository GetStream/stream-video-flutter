import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/model/rtc_video_dimension.dart';

void main() {
  group('orientedLike', () {
    const landscape = RtcVideoDimension(width: 2560, height: 1280);
    const portrait = RtcVideoDimension(width: 1280, height: 2560);
    const portraitScreen = RtcVideoDimension(width: 1080, height: 2400);
    const landscapeScreen = RtcVideoDimension(width: 2400, height: 1080);

    test('swaps a landscape dimension for a portrait reference', () {
      expect(landscape.orientedLike(portraitScreen), portrait);
    });

    test('swaps a portrait dimension for a landscape reference', () {
      expect(portrait.orientedLike(landscapeScreen), landscape);
    });

    test('keeps a dimension that already matches the reference', () {
      expect(landscape.orientedLike(landscapeScreen), landscape);
      expect(portrait.orientedLike(portraitScreen), portrait);
    });

    test('is idempotent', () {
      expect(
        landscape.orientedLike(portraitScreen).orientedLike(portraitScreen),
        portrait,
      );
    });

    test('keeps the dimension for a square or empty reference', () {
      const square = RtcVideoDimension(width: 1000, height: 1000);
      expect(landscape.orientedLike(square), landscape);
      expect(landscape.orientedLike(const RtcVideoDimension.zero()), landscape);
    });

    test('keeps a square or empty dimension', () {
      const square = RtcVideoDimension(width: 720, height: 720);
      expect(square.orientedLike(portraitScreen), square);
      expect(
        const RtcVideoDimension.zero().orientedLike(portraitScreen),
        const RtcVideoDimension.zero(),
      );
    });
  });
}
