import 'package:stream_core/stream_core.dart';
import 'package:uuid/uuid.dart';

import '../../globals.dart';

/// Adds the `X-Stream-Client` header and a unique per-request id header.
class StreamClientInfoInterceptor extends Interceptor {
  const StreamClientInfoInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.headers['X-Stream-Client'] = xStreamClientHeader;
    options.headers['x-client-request-id'] = const Uuid().v4();
    handler.next(options);
  }
}
