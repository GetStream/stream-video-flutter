// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
// The library itself, not the barrel, which needs a browser.
// ignore: implementation_imports
import 'package:stream_dart_webrtc/src/speech_activity_detector.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

void main() {
  const interval = Duration(milliseconds: 500);

  late _FakeLevelSource source;
  late SampledSpeechActivityDetector detector;
  late List<SpeechActivity> activity;

  /// Builds the detector inside the fake zone, so its timer runs on the fake
  /// clock.
  void setUpDetector() {
    source = _FakeLevelSource();
    detector = SampledSpeechActivityDetector(source.open);
    activity = [];
    detector.activity.listen(activity.add);
  }

  /// Samples [levels], one per detection interval.
  void play(FakeAsync async, List<int> levels) {
    for (final level in levels) {
      source.level = level;
      async.elapse(interval);
    }
  }

  test('reports each transition once', () {
    fakeAsync((async) {
      setUpDetector();
      unawaited(detector.start(deviceId: 'mic-1'));
      async.flushMicrotasks();

      play(async, [0, 200, 220, 150, 149, 0, 180]);

      expect(source.openedWith, ['mic-1']);
      expect(activity, [
        SpeechActivity.started,
        SpeechActivity.ended,
        SpeechActivity.started,
      ]);
    });
  });

  test('stop closes the source and ends ongoing speech', () {
    fakeAsync((async) {
      setUpDetector();
      unawaited(detector.start());
      async.flushMicrotasks();
      play(async, [255]);

      unawaited(detector.stop());
      async.flushMicrotasks();
      play(async, [255, 255]);

      expect(source.closeCount, 1);
      expect(activity, [SpeechActivity.started, SpeechActivity.ended]);
    });
  });

  test('a second start while running does nothing', () {
    fakeAsync((async) {
      setUpDetector();
      unawaited(detector.start());
      unawaited(detector.start());
      async.flushMicrotasks();

      expect(source.openedWith, [null]);
    });
  });

  test('a stop while the source opens closes it once it is open', () {
    fakeAsync((async) {
      setUpDetector();
      final gate = source.openGate = Completer<void>();
      unawaited(detector.start());
      async.flushMicrotasks();

      unawaited(detector.stop());
      async.flushMicrotasks();
      expect(source.closeCount, 0);

      gate.complete();
      async.flushMicrotasks();
      play(async, [255]);

      expect(source.closeCount, 1);
      expect(activity, isEmpty);
    });
  });

  test('a source that fails to open is rethrown and can start again', () {
    fakeAsync((async) {
      setUpDetector();
      source.openError = StateError('denied');
      Object? error;
      unawaited(
        detector.start().catchError((Object e) {
          error = e;
        }),
      );
      async.flushMicrotasks();
      expect(error, isA<StateError>());

      source.openError = null;
      unawaited(detector.start());
      async.flushMicrotasks();
      play(async, [255]);

      expect(source.openedWith, [null, null]);
      expect(activity, [SpeechActivity.started]);
    });
  });

  test('a start after a stop while opening keeps its own capture open', () {
    fakeAsync((async) {
      setUpDetector();
      final gate = source.openGate = Completer<void>();
      unawaited(detector.start(deviceId: 'mic-1'));
      async.flushMicrotasks();
      unawaited(detector.stop());
      async.flushMicrotasks();

      source.openGate = null;
      unawaited(detector.start(deviceId: 'mic-2'));
      async.flushMicrotasks();
      gate.complete();
      async.flushMicrotasks();
      play(async, [255]);

      expect(
        {for (final c in source.captures) c.deviceId: c.closed},
        {
          'mic-1': true,
          'mic-2': false,
        },
      );
      expect(activity, [SpeechActivity.started]);
    });
  });

  test('a sample that throws ends speech and stops sampling', () {
    fakeAsync((async) {
      setUpDetector();
      unawaited(detector.start());
      async.flushMicrotasks();
      play(async, [255]);

      source.sampleError = StateError('closed');
      play(async, [0, 0]);

      expect(source.sampleCount, 2);
      expect(activity, [SpeechActivity.started, SpeechActivity.ended]);
    });
  });

  test('two detectors run on their own', () {
    fakeAsync((async) {
      setUpDetector();
      final other = SampledSpeechActivityDetector(source.open);
      unawaited(detector.start(deviceId: 'mic-1'));
      unawaited(other.start(deviceId: 'mic-2'));
      async.flushMicrotasks();

      unawaited(detector.stop());
      async.flushMicrotasks();

      expect(source.openedWith, ['mic-1', 'mic-2']);
      expect(source.captures.map((c) => c.closed), [true, false]);
      unawaited(other.stop());
      async.flushMicrotasks();
    });
  });
}

class _FakeLevelSource {
  int level = 0;
  final openedWith = <String?>[];
  final captures = <_FakeCapture>[];
  Completer<void>? openGate;
  Error? openError;
  Error? sampleError;
  int sampleCount = 0;

  int get closeCount => captures.where((capture) => capture.closed).length;

  Future<AudioLevelCapture> open({String? deviceId}) async {
    openedWith.add(deviceId);
    if (openGate case final gate?) await gate.future;
    if (openError case final error?) throw error;
    final capture = _FakeCapture(this, deviceId);
    captures.add(capture);
    return capture;
  }
}

class _FakeCapture implements AudioLevelCapture {
  _FakeCapture(this._source, this.deviceId);

  final _FakeLevelSource _source;
  final String? deviceId;
  bool closed = false;

  @override
  int sample() {
    _source.sampleCount++;
    if (_source.sampleError case final error?) throw error;
    return _source.level;
  }

  @override
  Future<void> close() async => closed = true;
}
