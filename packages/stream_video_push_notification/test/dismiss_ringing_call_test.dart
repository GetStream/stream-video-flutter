import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelStreamVideoPushNotification();
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, (call) async {
          calls.add(call);
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, null);
  });

  test('sends the cid and the reason', () async {
    await platform.dismissRingingCall(
      'default:abc',
      reason: CallDismissReason.remoteCancelled,
    );

    expect(calls.single.method, 'dismissRingingCall');
    expect(calls.single.arguments, {
      'id': 'default:abc',
      'reason': 'remoteCancelled',
    });
  });

  test('sends accepted when no reason is given', () async {
    await platform.dismissRingingCall('default:abc');

    expect(calls.single.arguments, {'id': 'default:abc', 'reason': 'accepted'});
  });
}
