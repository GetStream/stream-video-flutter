import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  test('interval grows with the size of the collection', () {
    expect(
      defaultCollectionThrottleInterval(1),
      const Duration(milliseconds: 16),
    );
    expect(
      defaultCollectionThrottleInterval(20),
      const Duration(milliseconds: 250),
    );
    expect(
      defaultCollectionThrottleInterval(60),
      const Duration(milliseconds: 500),
    );
    expect(
      defaultCollectionThrottleInterval(500),
      const Duration(seconds: 1),
    );
  });

  test('emits the first and the last value of a burst', () async {
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
      [1],
      [3],
    ]);

    await subscription.cancel();
    await controller.close();
  });

  test('a larger collection is throttled for longer', () async {
    final controller = StreamController<List<int>>();
    final received = <List<int>>[];

    final subscription = controller.stream
        .throttleByCollectionSize(
          interval: (size) => Duration(milliseconds: size < 3 ? 10 : 200),
        )
        .listen(received.add);

    // A small list opens a short window, so the next value is let through.
    controller.add([1]);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    controller.add([1, 2]);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(received, [
      [1],
      [1, 2],
    ]);

    // A large list opens a long window that holds back the values behind it.
    controller
      ..add([1, 2, 3])
      ..add([1, 2, 3, 4])
      ..add([1, 2, 3, 4, 5]);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(received.length, 3);

    await Future<void>.delayed(const Duration(milliseconds: 250));
    expect(received.last, [1, 2, 3, 4, 5]);

    await subscription.cancel();
    await controller.close();
  });
}
