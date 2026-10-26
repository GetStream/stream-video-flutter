import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:stream_webrtc_flutter/src/native/media_stream_track_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('FlutterWebRTC.Method');

  const originalSettings = {
    'width': 1280,
    'height': 2560,
    'sensorOrientation': 90,
  };

  void mockClone(Map<String, dynamic> response) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'trackClone') return response;
          return null;
        });
  }

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  MediaStreamTrackNative original() => MediaStreamTrackNative(
    'original',
    'original',
    'video',
    true,
    '',
    originalSettings,
  );

  test(
    'a clone without settings inherits the original track settings',
    () async {
      // Android returns no settings for clones.
      mockClone({
        'id': 'clone',
        'label': 'clone',
        'kind': 'video',
        'enabled': true,
      });

      final clone = await original().clone();

      expect(clone.id, 'clone');
      expect(clone.getSettings(), originalSettings);
    },
  );

  test('a clone keeps the settings the platform reports for it', () async {
    mockClone({
      'id': 'clone',
      'label': 'clone',
      'kind': 'video',
      'enabled': true,
      'settings': {'width': 640, 'height': 480},
    });

    final clone = await original().clone();

    expect(clone.getSettings(), {'width': 640, 'height': 480});
  });
}
