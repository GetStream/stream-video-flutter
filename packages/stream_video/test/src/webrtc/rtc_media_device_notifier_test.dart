import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

const _sources = [
  {
    'deviceId': '0',
    'groupId': 'camera',
    'kind': 'videoinput',
    'label': 'Camera 0, Facing back, Orientation 90',
  },
  {
    'deviceId': 'microphone-1',
    'groupId': 'microphone',
    'kind': 'audioinput',
    'label': 'Built-in microphone',
  },
  {
    'deviceId': 'speaker',
    'groupId': 'speaker',
    'kind': 'audiooutput',
    'label': 'Speakerphone',
  },
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('FlutterWebRTC.Method');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  var getSourcesCalls = 0;
  Completer<void>? getSourcesGate;

  late RtcMediaDeviceNotifier notifier;

  setUpAll(() async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'getSources':
          getSourcesCalls++;
          await getSourcesGate?.future;
          return {'sources': _sources};
        default:
          return null;
      }
    });

    notifier = RtcMediaDeviceNotifier.instance;
    // Let the enumeration started by the constructor finish.
    await notifier.onDeviceChange.first;
  });

  tearDownAll(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  setUp(() {
    getSourcesCalls = 0;
    getSourcesGate = null;
  });

  Future<void> waitForDebounce() {
    return Future<void>.delayed(
      RtcMediaDeviceNotifier.deviceChangeDebounce * 2,
    );
  }

  test('a burst of device-change events enumerates once', () async {
    for (var i = 0; i < 5; i++) {
      rtc.navigator.mediaDevices.ondevicechange?.call(null);
    }

    await waitForDebounce();

    expect(getSourcesCalls, 1);
  });

  test('concurrent calls share one platform enumeration', () async {
    getSourcesGate = Completer<void>();

    final results = [
      notifier.enumerateDevices(),
      notifier.audioOutputs(),
      notifier.videoInputs(),
    ];
    getSourcesGate!.complete();

    final [all, audioOutputs, videoInputs] = await Future.wait(results);

    expect(getSourcesCalls, 1);
    expect(all.getDataOrNull(), hasLength(3));
    expect(
      audioOutputs.getDataOrNull()?.map((d) => d.id),
      ['speaker'],
    );
    expect(videoInputs.getDataOrNull()?.map((d) => d.id), ['0']);
  });

  test('sequential calls each enumerate', () async {
    await notifier.enumerateDevices();
    await notifier.enumerateDevices();

    expect(getSourcesCalls, 2);
  });

  test(
    'a device change during an enumeration reads the devices again',
    () async {
      getSourcesGate = Completer<void>();

      final running = notifier.enumerateDevices();
      rtc.navigator.mediaDevices.ondevicechange?.call(null);

      // The debounced enumeration waits for the running one.
      await waitForDebounce();
      expect(getSourcesCalls, 1);

      getSourcesGate!.complete();
      await running;
      await pumpEventQueue();

      expect(getSourcesCalls, 2);
    },
  );
}
