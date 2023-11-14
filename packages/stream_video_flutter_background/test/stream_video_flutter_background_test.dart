import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter_background/stream_video_flutter_background_method_channel.dart';
import 'package:stream_video_flutter_background/stream_video_flutter_background_platform_interface.dart';

void main() {
  final StreamVideoFlutterBackgroundPlatform initialPlatform =
      StreamVideoFlutterBackgroundPlatform.instance;

  test('$MethodChannelStreamVideoFlutterBackground is the default instance',
      () {
    expect(initialPlatform,
        isInstanceOf<MethodChannelStreamVideoFlutterBackground>());
  });
}
