import 'dart:async';

import 'package:stream_core/stream_core.dart';

import '../errors/stream_video_exception.dart';
import '../logger/impl/tagged_logger.dart';
import '../token/token_source.dart';

final _logger = taggedLogger(tag: 'SV:HttpAuth');

/// Resolves the current user token for authenticated Stream API requests.
typedef GetToken = FutureOr<UserToken> Function();

/// Attaches the Stream auth headers (`stream-auth-type` + `Authorization`) for
/// the current user token, rejecting the request if the token can't be
/// resolved. Shared by the coordinator client and the telemetry transport.
///
/// Built with [StreamAuthInterceptor.refreshing], it also replaces a token the
/// server refuses as expired and retries the request once with the replacement,
/// so a token that lapses mid-session costs one round trip instead of surfacing
/// as a failure.
class StreamAuthInterceptor extends Interceptor {
  /// Signs every request with the token [getToken] returns.
  const StreamAuthInterceptor(this.getToken) : _dio = null, _tokenSource = null;

  /// Signs every request, and replaces a token the server refuses as expired.
  const StreamAuthInterceptor.refreshing(
    this.getToken, {
    required Dio dio,
    required TokenSource tokenSource,
  }) : _dio = dio,
       _tokenSource = tokenSource;

  final GetToken getToken;
  final Dio? _dio;
  final TokenSource? _tokenSource;

  /// Marks a request that has already been retried with a replacement token, so
  /// a second refusal is reported rather than refreshed again.
  static const _retriedKey = 'stream_video.auth_token_retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final userToken = await getToken();
      options.headers['stream-auth-type'] = userToken.authType.headerValue;

      // An anonymous session carries no JWT unless the caller supplied one, and
      // an empty `Authorization` is not the same as none.
      if (userToken.rawValue.isNotEmpty) {
        options.headers['Authorization'] = userToken.rawValue;
      }

      handler.next(options);
    } catch (error, stackTrace) {
      final exception =
          StreamException.tryFrom(error) ??
          (error is StreamVideoException ? error.streamException : null) ??
          StreamAuthenticationException(
            message: 'The request could not be signed',
            cause: error,
          );

      handler.reject(
        DioException(
          requestOptions: options,
          error: exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final dio = _dio;
    final tokenSource = _tokenSource;
    if (dio == null || tokenSource == null) return handler.next(err);

    // Only an expired token is fixed by loading another one.
    final error = err.toStreamException();
    if (error is! StreamApiException || !error.isTokenExpired) {
      return handler.next(err);
    }

    final options = err.requestOptions;

    // A provider that always returns the same token has nothing fresher to
    // give — a guest's access token included.
    if (tokenSource.usesStaticProvider) return handler.next(err);

    // The replacement was refused too, so another one will be as well.
    if (options.extra[_retriedKey] == true) {
      _logger.e(
        () =>
            '[${options.path}] the replacement token was refused too, '
            'reporting the refusal',
      );
      return handler.next(err);
    }

    final refreshed = await tokenSource.refreshToken();
    if (refreshed is! Success<UserToken>) {
      // Reported here as well as by `TokenManager`, because this is the only
      // place the two halves meet: what the caller receives is the server's
      // `token expired`, and on its own that reads as an expiry rather than as
      // an app token endpoint that is failing.
      //
      // Not attached to the rejected failure as a cause: the retry interceptor
      // decides from its type, and a credentials failure there is retryable
      // where an expired token is not — so swapping it in would spend five
      // more attempts minting tokens that cannot help.
      _logger.e(
        () =>
            '[${options.path}] could not replace the refused token, '
            'reporting the refusal: ${refreshed.exceptionOrNull()}',
      );
      return handler.next(err);
    }

    final data = options.data;
    final retry = options.copyWith(
      extra: {...options.extra, _retriedKey: true},
      data: data is FormData ? data.clone() : data,
    );

    try {
      final response = await dio.fetch<dynamic>(retry);
      return handler.resolve(response);
    } on DioException catch (exception) {
      return handler.reject(exception);
    }
  }
}
