import 'package:http/http.dart' as http;

import '../logger/stream_log.dart';

const _tag = 'SV:LocationService';

class LocationService {
  LocationService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> getLocation({
    Duration timeout = const Duration(milliseconds: 2000),
    int maxAttempts = 3,
  }) async {
    var attempt = 0;
    var locationHint = 'ERR';

    do {
      attempt++;
      streamLog.d(_tag, () => '[getLocation] attempt $attempt of $maxAttempts');

      try {
        final uri = Uri(
          scheme: 'https',
          host: 'hint.stream-io-video.com',
        );
        final response = await _client.head(uri).timeout(timeout);
        streamLog.v(_tag, () => '[getLocation] response: $response');
        streamLog.v(_tag, () => '[getLocation] headers: ${response.headers}');
        final awsPop = response.headers['x-amz-cf-pop'] ?? 'ERR';
        streamLog.d(_tag, () => '[getLocation] Location header: $awsPop');
        locationHint = awsPop.substring(0, 3); // AMS1-P2 -> AMS
      } catch (e, stk) {
        streamLog.w(
          _tag,
          () => '[getLocation] attempt $attempt failed: $e; $stk',
        );
        locationHint = 'ERR';
      }
    } while (locationHint == 'ERR' && attempt < maxAttempts);

    return locationHint;
  }
}
