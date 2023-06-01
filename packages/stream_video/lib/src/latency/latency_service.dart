import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../coordinator/models/coordinator_models.dart';
import '../logger/impl/tagged_logger.dart';
import '../utils/none.dart';
import 'latency_settings.dart';

final _logger = taggedLogger(tag: 'SV:LatencyService');

/// Measures latencies to SFU edges.
@internal
class LatencyService {
  const LatencyService({
    required this.settings,
    this.client = const LatencyClient(),
  });

  /// Latency measurement settings.
  final LatencySettings settings;

  /// Latency measurement client.
  final LatencyClient client;

  /// Measures the latencies to the given [edges].
  Future<Map<String, SfuLatency>> measureEdgeLatencies(
    List<SfuEdge> edges,
  ) async {
    _logger.d(
      () => '[measureEdgeLatencies] edges: ${edges.map((e) => e.name)}',
    );

    final rounds = settings.measurementRounds;
    final timeout = settings.measurementTimeout;

    final latencies = <String, SfuLatency>{
      // Fill with fallback values initially.
      for (final edge in edges) edge.name: SfuLatency.maxFinite(rounds),
    };

    await _fillWithRealValues(rounds, edges, latencies).timeout(
      timeout,
      onTimeout: () {
        _logger.w(() => '[measureEdgeLatencies] failed (timeout): $timeout');
      },
    );

    _logger.v(() => '[measureEdgeLatencies] completed: $latencies');
    return latencies;
  }

  Future<void> _fillWithRealValues(
    int rounds,
    List<SfuEdge> edges,
    Map<String, SfuLatency> out,
  ) async {
    _logger.d(() => '[fillWithRealValues] edges.length: ${edges.length}');
    for (var i = 0; i < rounds; i++) {
      final latencies = await _measureLatencies(edges);
      for (final edge in edges) {
        final latency = latencies[edge.name];
        if (latency == null) continue;

        out[edge.name]?.measurementsSeconds[i] = latency;
      }
    }
    _logger.v(() => '[fillWithRealValues] completed');
  }

  Future<Map<String, double>> _measureLatencies(List<SfuEdge> edges) {
    return Future.wait(edges.map(_measureLatency)).then(Map.fromEntries);
  }

  Future<MapEntry<String, double>> _measureLatency(SfuEdge edge) async {
    _logger.d(() => '[measureLatency] edge: ${edge.name}');

    final latencyUrl = Uri.tryParse(edge.latencyUrl);
    if (latencyUrl == null) {
      return MapEntry(edge.name, double.maxFinite);
    }

    final sw = Stopwatch()..start();
    try {
      await client.fetch(latencyUrl);
      sw.stop();
      _logger.v(() => '[measureLatency] completed(${edge.name})');
      final diff = sw.elapsedMilliseconds.toDouble();
      return MapEntry(edge.name, diff / 1000);
    } catch (e) {
      sw.stop();
      _logger.e(() => '[measureLatency] failed(${edge.name}): $e');
      return MapEntry(edge.name, double.maxFinite);
    }
  }
}

/// Wraps real http request.
@internal
class LatencyClient {
  const LatencyClient();

  Future<None> fetch(Uri url) {
    return http.get(url).then((_) => none);
  }
}
