@TestOn('!ios')
library;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the broadcast picker and stop are unsupported off iOS', () async {
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('FlutterWebRTC.Method'), (
          call,
        ) async {
          calls.add(call);
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('FlutterWebRTC.Method'),
            null,
          ),
    );

    await expectLater(presentiOSBroadcastPicker(), throwsUnsupportedError);
    await expectLater(stopiOSBroadcast(), throwsUnsupportedError);
    expect(calls, isEmpty);
  });
}
