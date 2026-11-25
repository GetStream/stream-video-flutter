import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_duration_timer.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  final start = DateTime.utc(2026, 11, 20, 10);

  CallState state({
    DateTime? startedAt,
    DateTime? liveStartedAt,
    DateTime? liveEndedAt,
  }) {
    return CallState(
      callCid: StreamCallCid.from(type: StreamCallType.liveStream(), id: 'id'),
      currentUserId: 'userId',
      preferences: DefaultCallPreferences(),
    ).copyWithSessionTimes(
      CallSessionData(
        startedAt: startedAt,
        liveStartedAt: liveStartedAt,
        liveEndedAt: liveEndedAt,
      ),
    );
  }

  /// Runs [body] in fake time that starts at [start].
  void inFakeTime(void Function(FakeAsync async) body) {
    fakeAsync(body, initialTime: start);
  }

  group('durationStream', () {
    test('counts from startedAt once a second', () {
      inFakeTime((async) {
        final timer = CallDurationTimer(
          state(startedAt: start.subtract(const Duration(minutes: 1))),
        );
        final durations = <Duration>[];
        timer.durationStream.listen(durations.add);

        async.elapse(const Duration(seconds: 2));

        expect(durations, const [
          Duration(minutes: 1, seconds: 1),
          Duration(minutes: 1, seconds: 2),
        ]);
        timer.dispose();
      });
    });

    test('stops once liveEndedAt is set', () {
      inFakeTime((async) {
        final timer = CallDurationTimer(state(startedAt: start));
        final durations = <Duration>[];
        timer.durationStream.listen(durations.add);
        async.elapse(const Duration(seconds: 1));

        timer.update(state(startedAt: start, liveEndedAt: clock.now()));
        async.elapse(const Duration(seconds: 3));

        expect(durations, const [Duration(seconds: 1)]);
        timer.dispose();
      });
    });
  });

  test('durationStream stays silent with only liveStartedAt set', () {
    inFakeTime((async) {
      final timer = CallDurationTimer(state(liveStartedAt: start));
      final durations = <Duration>[];
      timer.durationStream.listen(durations.add);

      async.elapse(const Duration(seconds: 3));

      expect(durations, isEmpty);
      timer.dispose();
    });
  });

  group('liveDurationStream', () {
    test('emits nothing before the call goes live', () {
      inFakeTime((async) {
        final timer = CallDurationTimer(state());
        final durations = <Duration>[];
        timer.liveDurationStream.listen(durations.add);

        async.elapse(const Duration(seconds: 3));

        expect(durations, isEmpty);
        timer.dispose();
      });
    });

    test('freezes when the live ends and restarts on going live again', () {
      inFakeTime((async) {
        final sessionStart = start.subtract(const Duration(hours: 1));
        final firstLive = start.subtract(const Duration(minutes: 10));
        final timer = CallDurationTimer(
          state(startedAt: sessionStart, liveStartedAt: firstLive),
        );
        final durations = <Duration>[];
        timer.liveDurationStream.listen(durations.add);

        async.flushMicrotasks();
        expect(durations, const [Duration(minutes: 10)]);

        async.elapse(const Duration(seconds: 1));
        timer.update(
          state(
            startedAt: sessionStart,
            liveStartedAt: firstLive,
            liveEndedAt: clock.now(),
          ),
        );
        async.flushMicrotasks();
        final frozen = durations.length;
        expect(durations.last, const Duration(minutes: 10, seconds: 1));

        async.elapse(const Duration(seconds: 5));
        expect(durations, hasLength(frozen));

        timer.update(
          state(startedAt: sessionStart, liveStartedAt: clock.now()),
        );
        async.flushMicrotasks();
        expect(durations.last, Duration.zero);

        async.elapse(const Duration(seconds: 2));
        expect(durations.last, const Duration(seconds: 2));

        timer.dispose();
      });
    });

    test('emits zero at once on going live while the call timer runs', () {
      inFakeTime((async) {
        final sessionStart = start.subtract(const Duration(minutes: 3));
        final timer = CallDurationTimer(state(startedAt: sessionStart));
        final durations = <Duration>[];
        timer.liveDurationStream.listen(durations.add);
        async.elapse(const Duration(milliseconds: 1500));

        timer.update(
          state(startedAt: sessionStart, liveStartedAt: clock.now()),
        );
        async.flushMicrotasks();

        expect(durations, const [Duration.zero]);
        timer.dispose();
      });
    });

    test('emits nothing for liveEndedAt without liveStartedAt', () {
      inFakeTime((async) {
        final timer = CallDurationTimer(state(liveEndedAt: start));
        final durations = <Duration>[];
        timer.liveDurationStream.listen(durations.add);

        async.elapse(const Duration(seconds: 3));

        expect(durations, isEmpty);
        timer.dispose();
      });
    });

    test('keeps an update that lands as the current value arrives', () {
      inFakeTime((async) {
        final liveStartedAt = start.subtract(const Duration(minutes: 4));
        final ended = state(
          liveStartedAt: liveStartedAt,
          liveEndedAt: start.add(const Duration(seconds: 30)),
        );
        final timer = CallDurationTimer(state(liveStartedAt: liveStartedAt));
        final durations = <Duration>[];
        timer.liveDurationStream.listen((duration) {
          // The live ends while the first value is being delivered.
          if (durations.isEmpty) timer.update(ended);
          durations.add(duration);
        });

        async.elapse(const Duration(seconds: 3));

        expect(durations, const [
          Duration(minutes: 4),
          Duration(minutes: 4, seconds: 30),
        ]);
        timer.dispose();
      });
    });

    test('starts with the frozen length when listened to after the live', () {
      inFakeTime((async) {
        final timer = CallDurationTimer(
          state(
            liveStartedAt: start.subtract(const Duration(minutes: 5)),
            liveEndedAt: start,
          ),
        );
        final durations = <Duration>[];
        timer.liveDurationStream.listen(durations.add);

        async.elapse(const Duration(seconds: 3));

        expect(durations, const [Duration(minutes: 5)]);
        timer.dispose();
      });
    });
  });

  test('dispose completes both streams', () {
    inFakeTime((async) {
      final timer = CallDurationTimer(state(startedAt: start));
      var done = 0;
      timer.durationStream.listen(null, onDone: () => done++);
      timer.liveDurationStream.listen(null, onDone: () => done++);

      timer.dispose();
      async.flushMicrotasks();

      expect(done, 2);
    });
  });
}
