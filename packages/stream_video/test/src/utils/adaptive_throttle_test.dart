import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/utils/adaptive_throttle.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  test('interval grows with the size of the collection', () {
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

  test('emits the last value of a burst', () async {
    final controller = StreamController<List<int>>();
    final received = <List<int>>[];

    final subscription = controller.stream
        .throttleByCollectionSize(
          interval: (_) => const Duration(milliseconds: 50),
        )
        .listen(received.add);

    controller
      ..add([1])
      ..add([2])
      ..add([3]);

    await Future<void>.delayed(const Duration(milliseconds: 120));

    expect(received, [
      [3],
    ]);

    await subscription.cancel();
    await controller.close();
  });

  test('emits once per window under a continuous source', () async {
    final controller = StreamController<List<int>>();
    final received = <List<int>>[];

    final subscription = controller.stream
        .throttleByCollectionSize(
          interval: (_) => const Duration(milliseconds: 100),
        )
        .listen(received.add);

    var value = 0;
    final timer = Timer.periodic(
      const Duration(milliseconds: 10),
      (_) => controller.add([value++]),
    );
    await Future<void>.delayed(const Duration(milliseconds: 520));
    timer.cancel();

    // Five 100ms windows over ~500ms. A leading emission on top of the
    // trailing one would roughly double this.
    expect(received.length, inInclusiveRange(4, 6));

    await subscription.cancel();
    await controller.close();
  });

  test('a larger collection is throttled for longer', () async {
    final controller = StreamController<List<int>>();
    final received = <List<int>>[];

    final subscription = controller.stream
        .throttleByCollectionSize(
          interval: (size) => Duration(milliseconds: size < 3 ? 20 : 300),
        )
        .listen(received.add);

    // A small list opens a short window, so its value lands quickly.
    controller.add([1]);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(received, [
      [1],
    ]);

    // A large list opens a long window that holds everything behind it.
    controller
      ..add([1, 2, 3])
      ..add([1, 2, 3, 4])
      ..add([1, 2, 3, 4, 5]);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(received.length, 1);

    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(received.last, [1, 2, 3, 4, 5]);

    await subscription.cancel();
    await controller.close();
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
