import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/coordinator/models/coordinator_models.dart';
import 'package:stream_video/src/latency/latency_service.dart';
import 'package:stream_video/src/latency/latency_settings.dart';
import 'package:stream_video/src/logger/impl/tagged_logger.dart';
import 'package:stream_video/src/logger/stream_log.dart';
import 'package:stream_video/src/logger/stream_logger.dart';
import 'package:stream_video/src/utils/none.dart';

import '../logger/impl/test_logger.dart';
import 'latency_client_mock.dart';

final _logger = taggedLogger(tag: 'SV:DebounceBufferTest');

class UriFake extends Fake implements Uri {}

Future<void> main() async {
  const settings = LatencySettings(
    measurementRounds: 3,
    measurementTimeout: Duration(milliseconds: 400),
  );

  late LatencyService service;
  late LatencyClient client;

  setUpAll(() {
    StreamLog().logger = TestStreamLogger();
    StreamLog().priority = Priority.verbose;
    //_logger.i(() => '[setUp] edges: $edges');
    client = LatencyClientMock();
    service = LatencyService(settings: settings, client: client);

    // Needed for Mocktail to work with Uri.
    registerFallbackValue(UriFake());
  });

  tearDownAll(() {
    _logger.i(() => '[tearDown]');
  });

  test(
    'When completed successfully, all latencies should be provided',
    () async {
      /* Given */
      const fetchDuration = Duration(milliseconds: 100);
      const edgeCount = 4;
      final measurementCount = edgeCount * settings.measurementRounds;
      final edges = _generateEdges(count: edgeCount);
      when(
        () => client.fetch(any()),
      ).thenAnswer((_) => Future.delayed(fetchDuration, () => none));

      /* When */
      final latencies = (await service.measureEdgeLatencies(edges))
          .values
          .map((it) => it.measurementsSeconds)
          .flattened;

      /* Then */
      verify(() => client.fetch(any())).called(measurementCount);
      expect(latencies.length, measurementCount);
      for (final latency in latencies) {
        expect(latency, isNot(equals(double.maxFinite)));
      }
    },
  );

  test(
    'When finished due to request failure, all latencies should be filled with fallback values',
    () async {
      /* Given */
      const fetchDuration = Duration(milliseconds: 100);
      const edgeCount = 4;
      final measurementCount = edgeCount * settings.measurementRounds;
      final edges = _generateEdges(count: edgeCount);
      when(
        () => client.fetch(any()),
      ).thenThrow(TestFailure('request failed'));

      /* When */
      final latencies = (await service.measureEdgeLatencies(edges))
          .values
          .map((it) => it.measurementsSeconds)
          .flattened;

      /* Then */
      verify(() => client.fetch(any())).called(measurementCount);
      expect(latencies.length, measurementCount);
      for (final latency in latencies) {
        expect(latency, equals(double.maxFinite));
      }
    },
  );

  test(
    'When finished due to timeout, unmeasured latencies should be filled with fallback values',
    () async {
      /* Given */
      const fetchDuration = Duration(milliseconds: 150);
      const edgeCount = 4;
      final measurementCount = edgeCount * settings.measurementRounds;
      final edges = _generateEdges(count: edgeCount);
      when(
        () => client.fetch(any()),
      ).thenAnswer((_) => Future.delayed(fetchDuration, () => none));

      /* When */
      final latencies = (await service.measureEdgeLatencies(edges))
          .values
          .map((it) => it.measurementsSeconds);

      /* Then */
      expect(latencies.flattened.length, measurementCount);

      verify(() => client.fetch(any())).called(measurementCount);

      for (final edgeLatencies in latencies) {
        final lastIndex = edgeLatencies.length - 1;
        for (var index = 0; index < edgeLatencies.length; index++) {
          if (index == lastIndex) {
            expect(edgeLatencies[index], double.maxFinite);
          } else {
            expect(edgeLatencies[index], isNot(equals(double.maxFinite)));
          }
        }
      }

      await Future.delayed(fetchDuration);
    },
  );
}

List<SfuEdge> _generateEdges({required int count}) {
  return List.generate(count, (index) {
    return SfuEdge(name: 'name_$index', latencyUrl: '$index');
  });
}
