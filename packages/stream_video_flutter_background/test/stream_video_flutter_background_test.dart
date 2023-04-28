import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:stream_video_flutter_background/model/notification_payload.dart';
import 'package:stream_video_flutter_background/stream_video_flutter_background_method_channel.dart';
import 'package:stream_video_flutter_background/stream_video_flutter_background_platform_interface.dart';

class MockStreamVideoFlutterBackgroundPlatform
    with MockPlatformInterfaceMixin
    implements StreamVideoFlutterBackgroundPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> get isServiceRunning => Future.value(true);

  @override
  Future<bool> startService(NotificationPayload options) {
    return Future.value(true);
  }

  @override
  Future<bool> updateService(NotificationPayload options) {
    return Future.value(true);
  }

  @override
  Future<bool> stopService() {
    return Future.value(true);
  }

  @override
  Function(String buttonType, String callCid)? onButtonClick;

  @override
  Function(String callCid)? onContentClick;

  @override
  Function(String callCid)? onUiLayerDestroyed;
}

void main() {
  final StreamVideoFlutterBackgroundPlatform initialPlatform =
      StreamVideoFlutterBackgroundPlatform.instance;

  test('$MethodChannelStreamVideoFlutterBackground is the default instance',
      () {
    expect(initialPlatform,
        isInstanceOf<MethodChannelStreamVideoFlutterBackground>());
  });
}
