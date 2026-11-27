import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the web files include the runtime and the model', () {
    final files = [
      'video_filters_web.js',
      'mediapipe/wasm/vision_wasm_internal.wasm',
      'mediapipe/wasm/vision_wasm_internal.js',
      'mediapipe/models/selfie_segmenter_landscape.tflite',
    ];

    for (final file in files) {
      expect(File('web_files/$file').existsSync(), isTrue, reason: file);
    }
  });
}
