import 'dart:async';

import 'package:stream_core/stream_core.dart';

import '../logger/impl/tagged_logger.dart';

/// Resolves the connection id to attach to a request, waiting only while one is
/// on its way.
///
/// Returns `null` when there is none and none is coming.
typedef ConnectionIdResolver = FutureOr<String?> Function();

/// Attaches the coordinator socket's `connection_id` to every request that can
/// carry one.
class StreamConnectionIdInterceptor extends Interceptor {
  /// Creates a [StreamConnectionIdInterceptor] resolving ids through
  /// [resolveConnectionId].
  StreamConnectionIdInterceptor(
    this.resolveConnectionId, {
    String tag = 'SV:HttpConnectionId',
  }) : _logger = taggedLogger(tag: tag);

  /// Supplies the id, waiting for it when one is on its way.
  final ConnectionIdResolver resolveConnectionId;

  final TaggedLogger _logger;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final connectionId = await resolveConnectionId();

    if (connectionId != null && connectionId.isNotEmpty) {
      options.queryParameters['connection_id'] = connectionId;
    } else {
      options.queryParameters.remove('connection_id');
      _logger.d(() => '[onRequest] ${options.path} goes out with no id');
    }

    handler.next(options);
  }
}
