import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/utils/adaptive_throttle.dart';
import 'package:stream_video/stream_video.dart';

/// Drives a source through the throttle inside a `fakeAsync` zone and hands the
/// body a recorder for what came out.
void _throttled(
  CollectionThrottleInterval interval,
  void Function(
    FakeAsync async,
    StreamController<List<int>> source,
    List<List<int>> received,
    List<bool> done,
  )
  body,
) {
  fakeAsync((async) {
    // Closed by the caller where it matters; these all end with the zone.
    // ignore: close_sinks
    final source = StreamController<List<int>>();
    final received = <List<int>>[];
    final done = <bool>[];

    final subscription = source.stream
        .throttleByCollectionSize(interval: interval)
        .listen(received.add, onDone: () => done.add(true));

    body(async, source, received, done);

    subscription.cancel();
    async.flushMicrotasks();
  });
}

void main() {
  group('interval tiers', () {
    test('grow with the size of the collection', () {
      expect(
        defaultParticipantsThrottleInterval(1),
        const Duration(milliseconds: 16),
      );
      expect(
        defaultParticipantsThrottleInterval(20),
        const Duration(milliseconds: 250),
      );
      expect(
        defaultParticipantsThrottleInterval(60),
        const Duration(milliseconds: 500),
      );
      expect(
        defaultParticipantsThrottleInterval(500),
        const Duration(seconds: 1),
      );
    });

    test('change on the documented boundaries', () {
      expect(
        defaultParticipantsThrottleInterval(15),
        const Duration(milliseconds: 16),
      );
      expect(
        defaultParticipantsThrottleInterval(16),
        const Duration(milliseconds: 250),
      );
      expect(
        defaultParticipantsThrottleInterval(49),
        const Duration(milliseconds: 250),
      );
      expect(
        defaultParticipantsThrottleInterval(50),
        const Duration(milliseconds: 500),
      );
      expect(
        defaultParticipantsThrottleInterval(99),
        const Duration(milliseconds: 500),
      );
      expect(
        defaultParticipantsThrottleInterval(100),
        const Duration(seconds: 1),
      );
    });
  });

  group('throttleByCollectionSize', () {
    test('emits the last value of a burst, once the window closes', () {
      _throttled((_) => const Duration(milliseconds: 50), (
        async,
        source,
        received,
        _,
      ) {
        source
          ..add([1])
          ..add([2])
          ..add([3]);

        async.elapse(const Duration(milliseconds: 49));
        expect(received, isEmpty, reason: 'window has not closed yet');

        async.elapse(const Duration(milliseconds: 1));
        expect(received, [
          [3],
        ]);
      });
    });

    test('emits exactly once per window under a continuous source', () {
      _throttled((_) => const Duration(milliseconds: 100), (
        async,
        source,
        received,
        _,
      ) {
        for (var tick = 0; tick < 50; tick++) {
          source.add([tick]);
          async.elapse(const Duration(milliseconds: 10));
        }

        // 500ms of source at 10ms intervals, 100ms windows. A leading emission
        // on top of the trailing one would roughly double this.
        expect(received.length, 5);
      });
    });

    test('measures the window from the list that opened it', () {
      _throttled((size) => Duration(milliseconds: size < 3 ? 20 : 300), (
        async,
        source,
        received,
        _,
      ) {
        // A small list opens a short window.
        source.add([1]);
        async.elapse(const Duration(milliseconds: 20));
        expect(received, [
          [1],
        ]);

        // A large list opens a long one, and growing mid-window does not
        // re-measure it.
        source
          ..add([1, 2, 3])
          ..add([1, 2, 3, 4])
          ..add([1, 2, 3, 4, 5]);

        async.elapse(const Duration(milliseconds: 299));
        expect(received.length, 1, reason: 'still inside the long window');

        async.elapse(const Duration(milliseconds: 1));
        expect(received.last, [1, 2, 3, 4, 5]);
      });
    });

    // Completion is about ordering, not timing, so these run on the real event
    // loop; `fakeAsync` does not turn this transformer's close path.
    test('completes when the source closes while idle', () async {
      final source = StreamController<List<int>>();
      final received = <List<int>>[];
      var done = false;

      source.stream
          .throttleByCollectionSize(
            interval: (_) => const Duration(milliseconds: 20),
          )
          .listen(received.add, onDone: () => done = true);

      source.add([1]);
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(received, [
        [1],
      ]);
      expect(done, isFalse);

      await source.close();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(done, isTrue, reason: 'an idle throttle must still close');
    });

    test('emits the held value when the source closes mid-window', () async {
      final source = StreamController<List<int>>();
      final received = <List<int>>[];
      var done = false;

      source.stream
          .throttleByCollectionSize(
            interval: (_) => const Duration(seconds: 10),
          )
          .listen(received.add, onDone: () => done = true);

      source.add([1]);
      await source.close();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(received, [
        [1],
      ], reason: 'a single held value must not be swallowed on close');
      expect(done, isTrue);
    });

    test('emits the latest of several held values on close', () async {
      final source = StreamController<List<int>>();
      final received = <List<int>>[];
      var done = false;

      source.stream
          .throttleByCollectionSize(
            interval: (_) => const Duration(seconds: 10),
          )
          .listen(received.add, onDone: () => done = true);

      source
        ..add([1])
        ..add([1, 2]);
      await source.close();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(received, [
        [1, 2],
      ]);
      expect(done, isTrue);
    });

    test('forwards errors', () {
      fakeAsync((async) {
        final source = StreamController<List<int>>();
        final errors = <Object>[];

        final subscription = source.stream
            .throttleByCollectionSize(
              interval: (_) => const Duration(milliseconds: 50),
            )
            .listen(null, onError: errors.add);

        source.addError('boom');
        async.elapse(Duration.zero);

        expect(errors, ['boom']);

        subscription.cancel();
        source.close();
        async.elapse(Duration.zero);
      });
    });

    test('stops its window when the listener cancels', () {
      fakeAsync((async) {
        // ignore: close_sinks
        final source = StreamController<List<int>>();
        final received = <List<int>>[];

        final subscription = source.stream
            .throttleByCollectionSize(
              interval: (_) => const Duration(milliseconds: 50),
            )
            .listen(received.add);

        source.add([1]);
        subscription.cancel();
        async.elapse(const Duration(milliseconds: 100));

        expect(received, isEmpty);
        expect(async.pendingTimers, isEmpty);
      });
    });
  });

  group('CallPreferences.participantsThrottleInterval', () {
    test('defaults to the size-based tiers', () {
      expect(
        DefaultCallPreferences().participantsThrottleInterval,
        defaultParticipantsThrottleInterval,
      );
    });

    test('can be overridden with a fixed interval', () {
      const fixed = Duration(milliseconds: 100);
      final preferences = DefaultCallPreferences(
        participantsThrottleInterval: (_) => fixed,
      );

      expect(preferences.participantsThrottleInterval!(1), fixed);
      expect(preferences.participantsThrottleInterval!(500), fixed);
    });

    test('can be turned off', () {
      final preferences = DefaultCallPreferences(
        participantsThrottleInterval: null,
      );

      expect(preferences.participantsThrottleInterval, isNull);
    });
  });
}
