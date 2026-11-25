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
  late SpeechActivityDetector detector;
  late List<SpeechActivity> activity;

  /// Builds the detector inside the fake zone, so its timer runs on the fake
  /// clock.
  void setUpDetector() {
    source = _FakeLevelSource();
    detector = SpeechActivityDetector(source);
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
}

class _FakeLevelSource implements AudioLevelSource {
  int level = 0;
  final openedWith = <String?>[];
  int closeCount = 0;
  Completer<void>? openGate;
  Error? openError;

  @override
  Future<void> open({String? deviceId}) async {
    openedWith.add(deviceId);
    if (openGate case final gate?) await gate.future;
    if (openError case final error?) throw error;
  }

  @override
  int sample() => level;

  @override
  Future<void> close() async => closeCount++;
}
