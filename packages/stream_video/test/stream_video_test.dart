import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video/stream_video_method_channel.dart';
import 'package:stream_video/stream_video_platform_interface.dart';

class MockStreamVideoPlatform
    with MockPlatformInterfaceMixin
    implements StreamVideoPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final StreamVideoPlatform initialPlatform = StreamVideoPlatform.instance;

  test('$MethodChannelStreamVideo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelStreamVideo>());
  });

  test('getPlatformVersion', () async {
    StreamVideo streamVideoPlugin = StreamVideo.new('apikey');
    MockStreamVideoPlatform fakePlatform = MockStreamVideoPlatform();
    StreamVideoPlatform.instance = fakePlatform;

    expect(await streamVideoPlugin.getPlatformVersion(), '42');
  });
}
