import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart' show RTCConfiguration;

void main() {
  test('Verify default configurations', () {
    const sut = RTCConfiguration();
    final map = sut.toMap();

    expect(map['sdpSemantics'], 'unified-plan');
    expect(map['bundlePolicy'], 'max-bundle');
  });
}
