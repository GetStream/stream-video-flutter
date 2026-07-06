import 'dart:async';

import 'package:stream_core/stream_core.dart';
import 'package:uuid/uuid.dart';

import '../../globals.dart';

/// Resolves the current user token for authenticated Stream API requests.
typedef GetToken = FutureOr<UserToken> Function();

/// Attaches the Stream auth headers (`stream-auth-type` + `Authorization`) for
/// the current user token, rejecting the request if the token can't be
/// resolved. Shared by the coordinator client and the telemetry transport.
class StreamAuthInterceptor extends Interceptor {
  const StreamAuthInterceptor(this.getToken);

  final GetToken getToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final userToken = await getToken();
      options.headers['stream-auth-type'] = userToken.authType.name;
      if (userToken.rawValue.isNotEmpty) {
        options.headers['Authorization'] = userToken.rawValue;
      }
      handler.next(options);
    } catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}

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
