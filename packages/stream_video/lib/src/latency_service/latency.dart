import 'package:http/http.dart' as http;
import '../../protobuf/video/coordinator/edge_v1/edge.pb.dart';

/// A service that provides the latency of a given [edge] server in seconds.
///
/// [rounds] is the number of times to ping the server to get an average
/// latency.
///
/// The latency is determined by sending a request to the edge server and
/// measuring the time it takes to receive a response.
Future<Latency> measureEdgeLatency({
  required Edge edge,
  int rounds = 3,
}) async {
  final latencyUrl = Uri.tryParse(edge.latencyUrl);
  if (latencyUrl == null) {
    return Latency(measurementsSeconds: [double.maxFinite]);
  }

  final measurementsSeconds = <double>[];
  for (var i = 0; i < rounds; i++) {
    final sw = Stopwatch()..start();
    try {
      final _ = await http.get(latencyUrl);
      sw.stop();
      final diff = sw.elapsedMilliseconds.toDouble();
      final diffInSeconds = diff / 1000;
      measurementsSeconds.add(diffInSeconds);
    } catch (_) {
      sw.stop();
      measurementsSeconds.add(double.maxFinite);
    }
  }

  return Latency(measurementsSeconds: measurementsSeconds);
}
