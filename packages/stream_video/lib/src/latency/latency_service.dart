import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../coordinator/models/coordinator_models.dart';
import '../logger/impl/tagged_logger.dart';
import '../utils/map.dart';
import '../utils/none.dart';
import '../utils/pair.dart';
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
    final timeout = settings.measurementTimeout;
    final result = <String, SfuLatency>{};
    _fillWithFallbackValues(edges, settings.measurementRounds, result);
    await _fillWithRealValues(edges, result).timeout(
      timeout,
      onTimeout: () {
        _logger.w(() => '[measureEdgeLatencies] failed (timeout): $timeout');
      },
    );
    _logger.v(() => '[measureEdgeLatencies] completed: $result');
    return result;
  }

  void _fillWithFallbackValues(
    List<SfuEdge> edges,
    int rounds,
    Map<String, SfuLatency> out,
  ) {
    for (final edge in edges) {
      out[edge.name] = SfuLatency(
        measurementsSeconds: List.filled(
          rounds,
          double.maxFinite,
        ),
      );
    }
  }

  Future<void> _fillWithRealValues(
    List<SfuEdge> edges,
    Map<String, SfuLatency> out,
  ) async {
    _logger.d(() => '[fillWithRealValues] edges.length: ${edges.length}');
    for (var i = 0; i < settings.measurementRounds; i++) {
      final latencies = await _measureLatencies(edges);
      for (final edge in edges) {
        out[edge.name]?.measurementsSeconds[i] =
            latencies[edge.name] ?? double.maxFinite;
      }
    }
    _logger.v(() => '[fillWithRealValues] completed');
  }

  Future<Map<String, double>> _measureLatencies(
    List<SfuEdge> edges,
  ) async {
    return Future.wait(edges.map(_measureLatency))
        .then((value) => value.toMap());
  }

  Future<Pair<String, double>> _measureLatency(SfuEdge edge) async {
    _logger.d(() => '[measureLatency] edge: ${edge.name}');
    final sw = Stopwatch()..start();
    try {
      await client.fetch(edge.latencyUrl);
      sw.stop();
      _logger.v(() => '[measureLatency] completed(${edge.name})');
      final diff = sw.elapsedMilliseconds.toDouble();
      return Pair(first: edge.name, second: diff / 1000);
    } catch (e) {
      sw.stop();
      _logger.e(() => '[measureLatency] failed(${edge.name}): $e');
      return Pair(first: edge.name, second: double.maxFinite);
    }
  }
}

/// Wraps real http request.
@internal
class LatencyClient {
  const LatencyClient();

  Future<None> fetch(String url) {
    return http.get(Uri.parse(url)).then((_) => None());
  }
}
