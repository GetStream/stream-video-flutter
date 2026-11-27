// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/webrtc_engine.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import '../../fixtures/fake_webrtc_engine.dart';

void main() {
  late WebRtcEngine registered;

  setUp(() => registered = WebRtcEngine.instance);
  tearDown(() => WebRtcEngine.instance = registered);

  test('is the registered engine', () {
    final engine = FakeWebRtcEngine();
    WebRtcEngine.instance = engine;

    expect(webRtcEngine, same(engine));
  });

  test('throws a StateError naming stream_video_flutter when no engine is '
      'registered on a native platform', () {
    WebRtcEngine.debugUnregister();

    ensureWebRtcEngine();

    expect(WebRtcEngine.isRegistered, isFalse);
    expect(
      () => webRtcEngine,
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('stream_video_flutter'),
        ),
      ),
    );
  });
}
