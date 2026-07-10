import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../globals.dart';
import '../logger/impl/tagged_logger.dart';
import 'client_event.dart';

const _tag = 'SV:ClientEventTransport';

/// Resolves the Stream auth headers (`stream-auth-type` + `Authorization`) for
/// the telemetry request.
typedef ClientEventAuthHeadersProvider = Future<Map<String, String>> Function();

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

class ClientEventTransport {
  ClientEventTransport({
    required String baseUrl,
    required String apiKey,
    this.authHeadersProvider,
    http.Client? httpClient,
    this.retryConfig = const ClientEventRetryConfig(),
  }) : _endpoint = Uri.parse(
         '$baseUrl/api/v2/video/call_client_event',
       ).replace(queryParameters: {'api_key': apiKey}),
       _httpClient = httpClient ?? http.Client(),
       _ownsClient = httpClient == null;

  final Uri _endpoint;
  final http.Client _httpClient;
  final bool _ownsClient;
  final ClientEventRetryConfig retryConfig;

  /// Supplies the Stream auth headers per request.
  final ClientEventAuthHeadersProvider? authHeadersProvider;

  final _logger = taggedLogger(tag: _tag);
  final _uuid = const Uuid();

  /// Sends a batch of events.
  Future<void> send(List<ClientEvent> events) async {
    if (events.isEmpty) return;

    final body = jsonEncode({
      'events': events.map((e) => e.toJson()).toList(),
    });

    final authHeaders = await authHeadersProvider?.call() ?? const {};
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'X-Stream-Client': xStreamClientHeader,
      'x-client-request-id': _uuid.v4(),
      ...authHeaders,
    };

    for (var attempt = 0; attempt < retryConfig.maxAttempts; attempt++) {
      try {
        final response = await _httpClient.post(
          _endpoint,
          headers: headers,
          body: body,
        );

        final status = response.statusCode;
        if (status >= 200 && status < 300) {
          _logger.v(() => '[send] ok ($status)');
          return;
        }

        if (status >= 400 && status < 500) {
          _logger.w(
            () => '[send] dropped (client error $status): ${response.body}',
          );
          return;
        }

        _logger.w(
          () => '[send] attempt ${attempt + 1} failed (status $status)',
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

  void close() {
    if (_ownsClient) _httpClient.close();
  }
}
