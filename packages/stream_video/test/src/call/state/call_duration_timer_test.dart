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
        final firstLive = start.subtract(const Duration(minutes: 10));
        final timer = CallDurationTimer(state(liveStartedAt: firstLive));
        final durations = <Duration>[];
        timer.liveDurationStream.listen(durations.add);

        async.flushMicrotasks();
        expect(durations, const [Duration(minutes: 10)]);

        async.elapse(const Duration(seconds: 1));
        timer.update(
          state(liveStartedAt: firstLive, liveEndedAt: clock.now()),
        );
        async.elapse(const Duration(seconds: 5));
        expect(durations.last, const Duration(minutes: 10, seconds: 1));

        timer.update(state(liveStartedAt: clock.now()));
        async.elapse(const Duration(seconds: 2));
        expect(durations.last, const Duration(seconds: 2));

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
