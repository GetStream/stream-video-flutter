import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter_background/stream_video_flutter_background_method_channel.dart';

void main() {
  MethodChannelStreamVideoFlutterBackground platform =
      MethodChannelStreamVideoFlutterBackground();
  const MethodChannel channel =
      MethodChannel('stream_video_flutter_background');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
