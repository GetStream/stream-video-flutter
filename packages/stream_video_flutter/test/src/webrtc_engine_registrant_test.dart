// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/src/webrtc_engine_registrant.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

void main() {
  test('registers the WebRTC plugin engine', () {
    WebRtcEngine.debugUnregister();

    StreamVideoFlutterEngineRegistrant.registerWith();

    expect(WebRtcEngine.instance, isA<NativeWebRtcEngine>());
  });
}
