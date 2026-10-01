import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/src/webrtc/rtc_media_device/device_enumeration_trigger.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

const _camera = {
  'deviceId': '0',
  'groupId': 'camera',
  'kind': 'videoinput',
  'label': 'Camera 0, Facing back, Orientation 90',
};

const _sources = [
  _camera,
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
  var sources = _sources;
  Completer<void>? getSourcesGate;

  late RtcMediaDeviceNotifier notifier;

  setUpAll(() async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'getSources':
          getSourcesCalls++;
          await getSourcesGate?.future;
          return {'sources': sources};
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
    sources = _sources;
    // Drop the traces of earlier tests.
    notifier.getTrace();
  });

  void fireDeviceChange() {
    rtc.navigator.mediaDevices.ondevicechange?.call(null);
  }

  /// The data of every enumeration-trigger trace recorded since the last call.
  List<Object?> takeTriggerTraces() {
    return notifier
        .getTrace()
        .snapshot
        .where((record) => record.tag == TraceTag.enumerateDevicesTrigger)
        .map((record) => record.data)
        .toList();
  }

  group('device-change events', () {
    const debounce = RtcMediaDeviceNotifier.deviceChangeDebounce;

    test('a burst enumerates once, after the debounce', () {
      fakeAsync((async) {
        for (var i = 0; i < 5; i++) {
          fireDeviceChange();
          async.elapse(debounce ~/ 5);
        }

        // The last event restarted the debounce.
        expect(getSourcesCalls, 0);

        async.elapse(debounce);
        expect(getSourcesCalls, 1);
      });
    });

    test('events further apart than the debounce each enumerate', () {
      fakeAsync((async) {
        fireDeviceChange();
        async.elapse(debounce);
        fireDeviceChange();
        async.elapse(debounce);

        expect(getSourcesCalls, 2);
      });
    });

    test('an event during an enumeration reads the devices again', () {
      fakeAsync((async) {
        getSourcesGate = Completer<void>();

        notifier.enumerateDevices();
        async.flushMicrotasks();
        fireDeviceChange();

        // The debounced enumeration waits for the running one.
        async.elapse(debounce);
        expect(getSourcesCalls, 1);

        getSourcesGate!.complete();
        async.flushMicrotasks();

        expect(getSourcesCalls, 2);
      });
    });
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
    expect(audioOutputs.getDataOrNull()?.map((d) => d.id), ['speaker']);
    expect(videoInputs.getDataOrNull()?.map((d) => d.id), ['0']);
  });

  test(
    'callers get their own list and listeners an unmodifiable one',
    () async {
      getSourcesGate = Completer<void>();

      final first = notifier.enumerateDevices();
      final second = notifier.enumerateDevices();
      getSourcesGate!.complete();

      final firstDevices = (await first).getDataOrNull()!;
      final secondDevices = (await second).getDataOrNull()!;
      firstDevices.removeLast();

      expect(secondDevices, hasLength(3));

      final emitted = await notifier.onDeviceChange.first;
      expect(emitted, hasLength(3));
      expect(emitted.clear, throwsUnsupportedError);
    },
  );

  test('sequential calls each enumerate', () async {
    await notifier.enumerateDevices();
    await notifier.enumerateDevices();

    expect(getSourcesCalls, 2);
  });

  group('errors', () {
    test('an empty device list fails with a message for each call', () async {
      sources = [];

      final all = await notifier.enumerateDevices();
      final audioOutputs = await notifier.audioOutputs();

      expect((all as Failure).error.message, 'No devices found');
      expect(
        (audioOutputs as Failure).error.message,
        'No devices found for kind: ${RtcMediaDeviceKind.audioOutput}',
      );
    });

    test('a kind with no devices fails while the full list succeeds', () async {
      sources = [_camera];

      final all = await notifier.enumerateDevices();
      final audioOutputs = await notifier.audioOutputs();

      expect(all.getDataOrNull()?.map((d) => d.id), ['0']);
      expect(
        (audioOutputs as Failure).error.message,
        'No devices found for kind: ${RtcMediaDeviceKind.audioOutput}',
      );
    });
  });

  group('trace', () {
    test('records the trigger of each call', () async {
      await notifier.enumerateDevices();
      await notifier.enumerateDevicesFor(DeviceEnumerationTrigger.flipCamera);

      expect(takeTriggerTraces(), [
        {'trigger': 'explicit', 'coalesced': false},
        {'trigger': 'flipCamera', 'coalesced': false},
      ]);
    });

    test('marks calls that joined a running enumeration', () async {
      getSourcesGate = Completer<void>();

      final first = notifier.enumerateDevicesFor(
        DeviceEnumerationTrigger.callSettings,
      );
      final second = notifier.audioOutputs();
      getSourcesGate!.complete();
      await Future.wait([first, second]);

      expect(takeTriggerTraces(), [
        {'trigger': 'callSettings', 'coalesced': false},
        {'trigger': 'explicit', 'coalesced': true},
      ]);
    });

    test('records device-change enumerations', () {
      fakeAsync((async) {
        fireDeviceChange();
        async.elapse(RtcMediaDeviceNotifier.deviceChangeDebounce);

        expect(takeTriggerTraces(), [
          {'trigger': 'deviceChange', 'coalesced': false},
        ]);
      });
    });

    test('records each enumeration result once', () async {
      getSourcesGate = Completer<void>();

      final first = notifier.enumerateDevices();
      final second = notifier.enumerateDevices();
      getSourcesGate!.complete();
      await Future.wait([first, second]);

      final results = notifier.getTrace().snapshot.where(
        (record) => record.tag == TraceTag.enumerateDevices,
      );
      expect(results, hasLength(1));
    });
  });
}
