import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/logger/impl/tagged_logger.dart';
import 'package:stream_video/src/logger/stream_log.dart';
import 'package:stream_video/src/logger/stream_logger.dart';
import 'package:stream_video/src/utils/debounce_buffer.dart';

import '../logger/impl/test_logger.dart';

final _logger = taggedLogger(tag: 'SV:DebounceBufferTest');

Future<void> main() async {
  StreamLog().logger = const TestStreamLogger();
  StreamLog().priority = Priority.verbose;

  late DebounceBuffer<int, List<int>> buffer;

  setUp(() {
    _logger.i(() => '[setUp]');
    buffer = DebounceBuffer<int, List<int>>(
      duration: const Duration(milliseconds: 200),
      consumer: (items) async {
        _logger.d(() => '[buffer.consumer] completed: $items');
        return items;
      },
    );
  });

  test('test debouncing', () async {
    final futures = <Future<List<int>>>[];
    for (var i = 0; i < 4; i++) {
      futures.add(
        buffer
            .post(i)
            .whenComplete(() => _logger.v(() => '[test] completed: $i')),
      );
      _logger.v(() => '[test] posted: $i');
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final results = await Future.wait(futures);
    _logger.v(() => '[test] results: $results');

    final firstResult = results.first;
    for (final eachResult in results) {
      expect(identical(firstResult, eachResult), true);
    }
  });
}
