import 'package:stream_core/stream_core.dart';

import '../http/stream_api_interceptors.dart';
import '../logger/impl/tagged_logger.dart';
import 'client_event.dart';

const _tag = 'SV:ClientEventTransport';
const _endpointPath = '/api/v2/video/call_client_event';

class ClientEventRetryConfig {
  const ClientEventRetryConfig({
    this.maxAttempts = 5,
    this.baseDelay = const Duration(milliseconds: 500),
    this.maxDelay = const Duration(seconds: 8),
  });

  final int maxAttempts;
  final Duration baseDelay;
  final Duration maxDelay;

  Duration delayForAttempt(int attempt) {
    final scaled = baseDelay.inMilliseconds * (1 << attempt);
    final capped = scaled.clamp(0, maxDelay.inMilliseconds);
    return Duration(milliseconds: capped);
  }
}

/// Dio-based transport for client call event telemetry.
class ClientEventTransport {
  ClientEventTransport({
    required String baseUrl,
    required String apiKey,
    required GetToken getToken,
    Dio? client,
    this.retryConfig = const ClientEventRetryConfig(),
  }) : _client =
           client ??
           StreamCoreHttpClient(
             options: BaseOptions(baseUrl: baseUrl),
             interceptors: [
               ApiKeyInterceptor(apiKey),
               StreamAuthInterceptor(getToken),
               const StreamClientInfoInterceptor(),
             ],
           );

  final Dio _client;
  final ClientEventRetryConfig retryConfig;

  final _logger = taggedLogger(tag: _tag);

  /// Sends a batch of events.
  Future<void> send(List<ClientEvent> events) async {
    if (events.isEmpty) return;

    final data = {'events': events.map((e) => e.toJson()).toList()};

    for (var attempt = 0; attempt < retryConfig.maxAttempts; attempt++) {
      try {
        await _client.post<void>(_endpointPath, data: data);
        _logger.v(() => '[send] ok');
        return;
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        // Validation errors are never retried.
        if (status != null && status >= 400 && status < 500) {
          _logger.w(
            () => '[send] dropped (client error $status): ${e.response?.data}',
          );
          return;
        }
        _logger.w(
          () =>
              '[send] attempt ${attempt + 1} failed '
              '(${status ?? e.type.name})',
        );
      } catch (e) {
        _logger.w(() => '[send] attempt ${attempt + 1} error: $e');
      }

      if (attempt + 1 < retryConfig.maxAttempts) {
        await Future<void>.delayed(retryConfig.delayForAttempt(attempt));
      }
    }

    _logger.e(
      () => '[send] giving up after ${retryConfig.maxAttempts} attempts',
    );
  }

  void close() => _client.close();
}
