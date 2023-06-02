import 'package:http/http.dart' as http;

import '../logger/stream_log.dart';

const _tag = 'SV:LocationService';

class LocationService {
  Future<String> getLocation() async {
    try {
      streamLog.d(_tag, () => '[getLocation] no args');
      final uri = Uri(
        scheme: 'https',
        host: 'hint.stream-io-video.com',
      );
      final response = await http.head(uri);
      streamLog.v(_tag, () => '[getLocation] response: $response');
      streamLog.v(_tag, () => '[getLocation] headers: ${response.headers}');
      final location = response.headers['x-amz-cf-pop'] ?? 'ERR';
      return location.substring(0, 3); // AMS1-P2 -> AMS
    } catch (e, stk) {
      streamLog.e(_tag, () => '[getLocation] failed: $e; $stk');
      return 'ERR';
    }
  }
}
