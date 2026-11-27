import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  group('VideoModerationConfig.copyWith', () {
    const blur = VideoModerationConfig.blur(
      filter: _FakeVideoFilter(),
      duration: Duration(seconds: 5),
    );

    test('keeps the fields it is not given', () {
      final copy = blur.copyWith(muteAudio: true);

      expect(copy.muteAudio, isTrue);
      expect(copy.filter, same(blur.filter));
      expect(copy.duration, const Duration(seconds: 5));
    });

    test('replaces a nullable field', () {
      final copy = blur.copyWith(duration: () => const Duration(seconds: 9));

      expect(copy.duration, const Duration(seconds: 9));
    });

    test('clears a nullable field', () {
      void onClear() {}
      final copy = blur
          .copyWith(onClear: () => onClear)
          .copyWith(
            filter: () => null,
            duration: () => null,
            onClear: () => null,
          );

      expect(copy.filter, isNull);
      expect(copy.duration, isNull);
      expect(copy.onClear, isNull);
      expect(copy.isDisabled, isTrue);
    });
  });
}

final class _FakeVideoFilter extends VideoFilter {
  const _FakeVideoFilter();

  @override
  Future<MediaStreamFilterResult> apply(MediaStreamFilterInput input) async {
    return MediaStreamFilterResult(input.stream);
  }
}
