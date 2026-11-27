import 'dart:async';

import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import 'fixtures/test_webrtc_engine_native.dart'
    if (dart.library.js_interop) 'fixtures/test_webrtc_engine_web.dart';

/// Registers an engine for every test, as stream_video_flutter does in an
/// app: the WebRTC plugin's, whose platform channels answer nothing unless a
/// test mocks them, such as with `FakeWebRtcPlatform`; the browser's on web.
/// A test that needs another engine registers it and restores this one
/// afterwards.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  WebRtcEngine.instance = createTestWebRtcEngine();
  await testMain();
}
