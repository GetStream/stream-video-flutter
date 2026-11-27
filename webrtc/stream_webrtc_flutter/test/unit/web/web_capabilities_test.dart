@TestOn('browser')
library;

// ignore_for_file: invalid_use_of_visible_for_testing_member, implementation_imports

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_dart_webrtc/src/web_capabilities.dart';

void main() {
  group('supportsAudioOutputSelectionFor', () {
    const safari =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/605.1.15 '
        '(KHTML, like Gecko) Version/17.5 Safari/605.1.15';
    const chrome =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36';

    test('is false on WebKit', () {
      expect(supportsAudioOutputSelectionFor(safari), isFalse);
    });

    // Chrome, which runs these tests, has `setSinkId`.
    test('is true elsewhere where the browser has setSinkId', () {
      expect(supportsAudioOutputSelectionFor(chrome), isTrue);
    });
  });
}
