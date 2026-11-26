// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
// The library itself, not the barrel, which needs a browser.
// ignore: implementation_imports
import 'package:stream_dart_webrtc/src/audio_playback_watchdog.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

void main() {
  late _FakeElement element;
  late bool blocked;
  late List<(String, Object?)> traces;
  late int recoveringChanges;
  late AudioPlaybackWatchdog watchdog;

  /// Builds the watchdog inside the fake zone, so its timers run on the fake
  /// clock. Its first `play()` runs right away.
  void startWatchdog() {
    watchdog = AudioPlaybackWatchdog(
      trackId: 'alice',
      element: element,
      isBlocked: () => blocked,
      markBlocked: () {
        if (blocked) return false;
        blocked = true;
        return true;
      },
      markUnblocked: () {
        if (!blocked) return false;
        blocked = false;
        return true;
      },
      onRecoveringChanged: () => recoveringChanges++,
      onTrace: (trace) => traces.add((trace.tag, trace.data)),
    );
  }

  List<String> tags() => [for (final (tag, _) in traces) tag];

  setUp(() {
    element = _FakeElement();
    blocked = false;
    traces = [];
    recoveringChanges = 0;
  });

  test('plays once on start and traces nothing when it plays', () {
    fakeAsync((async) {
      startWatchdog();
      async.flushMicrotasks();

      expect(element.playCount, 1);
      expect(traces, isEmpty);
    });
  });

  test('an autoplay rejection marks it blocked once, without retrying', () {
    fakeAsync((async) {
      element.failures.addAll([_autoplay, _autoplay]);
      startWatchdog();
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 30));

      expect(blocked, isTrue);
      expect(element.playCount, 1);
      expect(tags(), [AudioRendererTraceTag.blocked]);
    });
  });

  test('resume retries a blocked element and unblocks it', () {
    fakeAsync((async) {
      element.failures.add(_autoplay);
      startWatchdog();
      async.flushMicrotasks();

      unawaited(watchdog.resume());
      async.flushMicrotasks();

      expect(element.playCount, 2);
      expect(blocked, isFalse);
    });
  });

  test('other failures are retried with a backoff from 250ms to 5s', () {
    fakeAsync((async) {
      element.failures.addAll(List.filled(8, StateError('decode')));
      startWatchdog();
      async.flushMicrotasks();

      final playTimes = <Duration>[];
      var last = element.playCount;
      for (var i = 0; i < 600; i++) {
        async.elapse(const Duration(milliseconds: 50));
        if (element.playCount != last) {
          last = element.playCount;
          playTimes.add(async.elapsed);
        }
      }

      final gaps = [
        for (var i = 1; i < playTimes.length; i++)
          (playTimes[i] - playTimes[i - 1]).inMilliseconds,
      ];
      expect(playTimes.first.inMilliseconds, 250);
      expect(gaps, [500, 1000, 2000, 4000, 5000, 5000, 5000]);
      expect(watchdog.isRecovering, isFalse);
      expect(tags().last, AudioRendererTraceTag.recovered);
    });
  });

  test('reports a sustained outage as stalled once', () {
    fakeAsync((async) {
      element.failures.addAll(List.filled(12, StateError('decode')));
      startWatchdog();
      async.flushMicrotasks();
      async.elapse(const Duration(minutes: 2));

      expect(
        tags().where((tag) => tag == AudioRendererTraceTag.stalled),
        hasLength(1),
      );
      // Retries go on past the stall, until the 13th play succeeds.
      expect(element.playCount, 13);
      expect(tags().last, AudioRendererTraceTag.recovered);
    });
  });

  test('a pause on a paused element is recovered and traced', () {
    fakeAsync((async) {
      startWatchdog();
      async.flushMicrotasks();

      element.paused = true;
      element.onPauseOrSuspend!('pause');
      element.onPauseOrSuspend!('suspend');
      async.flushMicrotasks();

      expect(tags(), [AudioRendererTraceTag.paused]);
      expect(watchdog.isRecovering, isTrue);

      element.paused = false;
      async.elapse(Duration.zero);
      async.flushMicrotasks();

      expect(element.playCount, 2);
      expect(watchdog.isRecovering, isFalse);
      expect(tags(), [
        AudioRendererTraceTag.paused,
        AudioRendererTraceTag.recovered,
      ]);
    });
  });

  test('a suspend on a playing element is ignored', () {
    fakeAsync((async) {
      startWatchdog();
      async.flushMicrotasks();

      element.onPauseOrSuspend!('suspend');
      async.elapse(const Duration(seconds: 5));

      expect(traces, isEmpty);
      expect(element.playCount, 1);
    });
  });

  test('dispose stops listening and retrying', () {
    fakeAsync((async) {
      element.failures.add(StateError('decode'));
      startWatchdog();
      async.flushMicrotasks();

      watchdog.dispose();
      async.elapse(const Duration(seconds: 10));

      expect(element.playCount, 1);
      expect(element.onPauseOrSuspend, isNull);
    });
  });
  test('a `playing` event ends the recovery and its retries', () {
    fakeAsync((async) {
      element.failures.addAll(List.filled(3, StateError('decode')));
      startWatchdog();
      async.flushMicrotasks();
      expect(watchdog.isRecovering, isTrue);

      element.paused = false;
      element.onPlaying!();
      async.elapse(const Duration(seconds: 30));

      expect(watchdog.isRecovering, isFalse);
      expect(element.playCount, 1);
      expect(tags(), [AudioRendererTraceTag.recovered]);
      expect(recoveringChanges, 2);
    });
  });

  test('resume while recovering plays right away', () {
    fakeAsync((async) {
      element.failures.addAll(List.filled(5, StateError('decode')));
      startWatchdog();
      async.flushMicrotasks();
      async.elapse(const Duration(milliseconds: 250 + 500 + 1000));
      expect(element.playCount, 4);

      element.failures.clear();
      unawaited(watchdog.resume());
      async.flushMicrotasks();

      expect(element.playCount, 5);
      expect(watchdog.isRecovering, isFalse);

      async.elapse(const Duration(seconds: 30));
      expect(element.playCount, 5);
    });
  });

  test('a dispose while play runs neither retries nor traces', () {
    fakeAsync((async) {
      final gate = element.playGate = Completer<void>();
      element.failures.add(StateError('decode'));
      startWatchdog();
      async.flushMicrotasks();

      watchdog.dispose();
      gate.complete();
      async.elapse(const Duration(seconds: 30));

      expect(element.playCount, 1);
      expect(traces, isEmpty);
      expect(watchdog.isRecovering, isFalse);
    });
  });

  test('a play that succeeds after dispose is not reported', () {
    fakeAsync((async) {
      element.failures.add(_autoplay);
      startWatchdog();
      async.flushMicrotasks();
      expect(blocked, isTrue);

      final gate = element.playGate = Completer<void>();
      unawaited(watchdog.resume());
      async.flushMicrotasks();
      watchdog.dispose();
      gate.complete();
      async.flushMicrotasks();

      expect(blocked, isTrue, reason: 'only the renderer clears it on dispose');
    });
  });
}

final _autoplay = StateError('NotAllowedError: play() needs a gesture');

class _FakeElement implements PlaybackElement {
  int playCount = 0;

  /// Thrown by the next plays, in order.
  final failures = <Object>[];

  @override
  bool paused = false;

  void Function(String type)? onPauseOrSuspend;
  void Function()? onPlaying;

  /// When set, plays wait for it.
  Completer<void>? playGate;

  @override
  Future<void> play() async {
    playCount++;
    if (playGate case final gate?) await gate.future;
    if (failures.isNotEmpty) {
      paused = true;
      throw failures.removeAt(0);
    }
    paused = false;
  }

  @override
  bool get hasSource => true;

  @override
  bool get ended => false;

  @override
  int get readyState => 4;

  @override
  bool isAutoplayBlocked(Object error) => '$error'.contains('NotAllowedError');

  @override
  void listen({
    required void Function(String type) onPauseOrSuspend,
    required void Function() onPlaying,
  }) {
    this.onPauseOrSuspend = onPauseOrSuspend;
    this.onPlaying = onPlaying;
  }

  @override
  void unlisten() {
    onPauseOrSuspend = null;
    onPlaying = null;
  }
}
