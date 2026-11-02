import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannelStreamVideoFlutter platform;
  late List<MethodCall> calls;

  setUp(() {
    platform = MethodChannelStreamVideoFlutter();
    calls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, (call) async {
          calls.add(call);
          // Nothing is running yet, so a start goes through.
          if (call.method == 'isBackgroundServiceRunning') return false;
          return true;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, null);
  });

  MethodCall startCall() =>
      calls.singleWhere((call) => call.method == 'startBackgroundService');

  test('starts a call in the regular call service by default', () async {
    await platform.startBackgroundService(
      payload: const NotificationPayload(callCid: 'default:1'),
      type: ServiceType.call,
    );

    expect(startCall().arguments, containsPair('serviceKind', 'call'));
    expect(startCall().arguments, containsPair('type', 'call'));
  });

  test('starts a livestream viewer in the viewer service', () async {
    await platform.startBackgroundService(
      payload: const NotificationPayload(callCid: 'livestream:1'),
      type: ServiceType.call,
      kind: AndroidCallServiceKind.livestreamViewer,
    );

    expect(
      startCall().arguments,
      containsPair('serviceKind', 'livestreamViewer'),
    );
  });
}
