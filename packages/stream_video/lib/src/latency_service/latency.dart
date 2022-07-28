import 'package:logging/logging.dart';
import 'package:stream_video/protobuf/video_models/models.pb.dart';
import 'package:http/http.dart' as http;

double toSeconds(int milliseconds) => milliseconds / 1000;

class LatencyService {
  final Logger? logger;
  LatencyService({this.logger});

  Future<Map<String, Latency>> measureLatencies(List<Edge> edges, [int tries = 1]) async {
    final latencies =
        await Future.wait(edges.map((edge) => _measureLatency(edge, tries)));

    return Map.fromEntries(latencies);
  }

  Future<MapEntry<String, Latency>> _measureLatency(Edge egde,
      [int tries = 1]) async {
    final latencyUrl = egde.latencyUrl;
    final url = Uri.tryParse(latencyUrl);
    final measurementsSeconds = <double>[];

    for (final _ in List<int>.generate(tries, (i) => i + 1)) {
      try {
        final stopwatch = Stopwatch()..start();
        final _ = await http.get(url!);
        stopwatch.stop();
        final durationInMs = stopwatch.elapsed.inSeconds;
        measurementsSeconds.add(toSeconds(durationInMs));
      } catch (e) {
        logger?.warning("failed to measure latency to ${url}");
      }
    }
    return MapEntry<String, Latency>(
        latencyUrl, Latency(measurementsSeconds: measurementsSeconds));
  }
}
