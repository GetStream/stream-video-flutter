import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/logger/impl/tagged_logger.dart';
import 'package:stream_video/src/logger/stream_log.dart';
import 'package:stream_video/src/logger/stream_logger.dart';
import 'package:stream_video/src/utils/debounce_buffer.dart';

import '../logger/impl/test_logger.dart';

final _logger = taggedLogger(tag: 'SV:DebounceBufferTest');

Future<void> main() async {
  late DebounceBuffer<int, List<int>> buffer;

  var failOnCancellation = false;
  List<int> onCancel() {
    if (failOnCancellation) {
      throw TestFailure('failed on cancellation');
    } else {
      return [];
    }
  }

  setUp(() {
    StreamLog().logger = TestStreamLogger();
    StreamLog().priority = Priority.verbose;
    _logger.i(() => '[setUp]');
    buffer = DebounceBuffer<int, List<int>>(
      duration: const Duration(milliseconds: 200),
      onBuffered: (items) async {
        return Future.delayed(const Duration(milliseconds: 100), () => items);
      },
      onCancel: onCancel,
    );
  });

  tearDown(() {
    _logger.i(() => '[tearDown]');
    buffer.cancel();
  });

  test('test already completed', () async {
    failOnCancellation = false;
    final futures = <Future<List<int>>>[];
    const number = 7;
    futures.add(
      buffer.post(number).onError((error, stackTrace) {
        _logger.e(() => '[alreadyCompleted] failed: $number = $error');
        return [-1];
      }).whenComplete(() {
        _logger.v(() => '[alreadyCompleted] completed: $number');
      }),
    );
    _logger.v(() => '[alreadyCompleted] posted: $number');
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await buffer.cancel();
    final results = await Future.wait(futures);
    _logger.v(() => '[alreadyCompleted] results: $results');
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _logger.v(() => '[alreadyCompleted] completed');


    final firstResult = results.first;
    for (final eachResult in results) {
      expect(eachResult.length, 0);
      expect(identical(firstResult, eachResult), true);
    }
  });

  test('test debouncing', () async {
    failOnCancellation = false;
    final futures = <Future<List<int>>>[];
    for (var i = 0; i < 4; i++) {
      futures.add(
        buffer.post(i).whenComplete(() {
          _logger.v(() => '[debouncing] completed: $i');
        }),
      );
      _logger.v(() => '[debouncing] posted: $i');
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }

    final results = await Future.wait(futures);
    _logger.v(() => '[debouncing] results: $results');

    final firstResult = results.first;
    for (final eachResult in results) {
      expect(eachResult.length, 4);
      expect(identical(firstResult, eachResult), true);
    }
  });

  test('test cancellation fallback', () async {
    failOnCancellation = false;
    final futures = <Future<List<int>>>[];
    for (var i = 0; i < 4; i++) {
      futures.add(
        buffer.post(i).whenComplete(() {
          _logger.v(() => '[cFallback] completed: $i');
        }),
      );
      _logger.v(() => '[cFallback] posted: $i');
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }

    await buffer.cancel();
    _logger.v(() => '[cFallback] canceled');

    final results = await Future.wait(futures);
    _logger.v(() => '[cFallback] results: $results');

    final firstResult = results.first;
    for (final eachResult in results) {
      expect(eachResult.length, 0);
      expect(identical(firstResult, eachResult), true);
    }
  });

  test('test cancellation failure', () async {
    failOnCancellation = true;
    final futures = <Future<List<int>>>[];
    for (var i = 0; i < 4; i++) {
      futures.add(
        buffer.post(i).onError((error, stackTrace) {
          _logger.e(() => '[cFailure] failed: $i = $error');
          return [-1];
        }).whenComplete(() => _logger.v(() => '[cFailure] completed: $i')),
      );
      _logger.v(() => '[cFailure] posted: $i');
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }

    await buffer.cancel();
    _logger.v(() => '[cFailure] canceled');

    final results = await Future.wait(futures);
    _logger.v(() => '[cFailure] results: $results');

    final firstResult = results.first;
    for (final eachResult in results) {
      expect(eachResult.length, 1);
      expect(eachResult.first, -1);
      expect(firstResult, eachResult);
    }
  });
}
