import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:stream_video/protobuf/video/coordinator/edge_v1/edge.pb.dart';
import 'package:stream_video/src/core/utils/utils.dart';

class LatencyService {
  LatencyService({this.logger});
  final Logger? logger;

  Future<Map<String, Latency>> measureLatencies(
    List<Edge> edges, [
    int tries = 1,
  ]) async {
    if (edges.isEmpty) logger?.warning("received empty list of edges");
    final latencies =
        await Future.wait(edges.map((edge) => _measureLatency(edge, tries)));

    return Map.fromEntries(latencies);
  }

  Future<MapEntry<String, Latency>> _measureLatency(
    Edge edge, [
    int tries = 1,
  ]) async {
    final latencyUrl = "http://192.168.1.17:5764"; //egde.latencyUrl;
    logger?.info("measuring latencyUrl: $latencyUrl");
    final url = Uri.tryParse(latencyUrl);
    final measurementsSeconds = <double>[];

    for (final _ in List<int>.generate(tries, (i) => i + 1)) {
      try {
        final stopwatch = Stopwatch()..start();
        final _ = await http.get(url!);
        stopwatch.stop();
        final durationInMs = stopwatch.elapsed.inMilliseconds;
        measurementsSeconds.add(toSeconds(durationInMs));
      } catch (e) {
        logger?.warning('failed to measure latency to $url');
      }
    }
    return MapEntry<String, Latency>(
      latencyUrl,
      Latency(measurementsSeconds: measurementsSeconds),
    );
  }
}
