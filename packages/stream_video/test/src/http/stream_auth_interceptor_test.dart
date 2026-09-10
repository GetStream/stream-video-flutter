import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/errors/stream_video_exception.dart';
import 'package:stream_video/src/errors/stream_video_exception_composer.dart';
import 'package:stream_video/src/http/stream_auth_interceptor.dart';
import 'package:stream_video/src/token/token_source.dart';

/// Replays a scripted sequence of responses, recording every request so the
/// signing and the replacement attempt can both be asserted.
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this._script);

  final List<ResponseBody> _script;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return _script.isEmpty ? _ok() : _script.removeAt(0);
  }

  @override
  void close({bool force = false}) {}
}

final _json = {
  Headers.contentTypeHeader: [Headers.jsonContentType],
};

ResponseBody _ok() => ResponseBody.fromString('{}', 200, headers: _json);

/// A refusal carrying a Stream error [code], the way the coordinator sends one.
ResponseBody _refused(int code, {int status = 401}) {
  return ResponseBody.fromString(
    jsonEncode({
      'code': code,
      'details': <int>[],
      'duration': '1ms',
      'message': 'refused',
      'more_info': '',
      'StatusCode': status,
    }),
    status,
    headers: _json,
  );
}

/// An unsigned JWT claiming [userId], which is all `UserToken` reads: it parses
/// claims without verifying the signature.
String _jwt(String userId) {
  String segment(Map<String, Object?> claims) {
    return base64Url
        .encode(utf8.encode(jsonEncode(claims)))
        .replaceAll('=', '');
  }

  final header = segment({'alg': 'HS256', 'typ': 'JWT'});
  final payload = segment({'user_id': userId});
  // Never verified, but it still has to decode as base64url.
  final signature = base64Url.encode(utf8.encode('sig')).replaceAll('=', '');
  return '$header.$payload.$signature';
}

const _userId = 'u1';

/// A manager whose provider can mint another token, so a refusal is worth
/// replacing. A dynamic provider only accepts JWTs.
TokenManager _refreshable() {
  return TokenManager(
    userId: _userId,
    tokenProvider: TokenProvider.dynamic((id) async => UserToken(_jwt(id))),
  );
}

void main() {
  /// A client whose adapter replays [script], signed by a refreshing
  /// interceptor over [manager].
  ({Dio dio, _ScriptedAdapter adapter}) client(
    TokenManager manager,
    List<ResponseBody> script,
  ) {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.invalid'));
    final adapter = _ScriptedAdapter(script);
    dio.httpClientAdapter = adapter;

    final source = TokenSource(manager);
    dio.interceptors.add(
      StreamAuthInterceptor.refreshing(
        () async => (await source.getToken()).getOrThrow(),
        dio: dio,
        tokenSource: source,
      ),
    );

    return (dio: dio, adapter: adapter);
  }

  group('StreamAuthInterceptor signs requests', () {
    test('attaches the auth type, and no empty Authorization', () async {
      // An anonymous session with no caller-supplied JWT.
      final manager = TokenManager(
        userId: User.anonymousUserId,
        tokenProvider: TokenProvider.static(UserToken.anonymous()),
      );

      final c = client(manager, [_ok()]);

      await c.dio.get<dynamic>('/x');

      final sent = c.adapter.requests.single;
      expect(sent.headers['stream-auth-type'], isNotNull);
      // An anonymous session carries no JWT unless the caller supplied one, and
      // an empty Authorization header is not the same as none. This is why the
      // core AuthInterceptor cannot simply be swapped in here.
      expect(sent.headers.containsKey('Authorization'), isFalse);
    });

    test('attaches a token the caller did supply', () async {
      final raw = _jwt(User.anonymousUserId);
      final manager = TokenManager(
        userId: User.anonymousUserId,
        tokenProvider: TokenProvider.static(
          UserToken.anonymous(rawValue: raw),
        ),
      );

      final c = client(manager, [_ok()]);
      await c.dio.get<dynamic>('/x');

      expect(c.adapter.requests.single.headers['Authorization'], raw);
    });
  });

  group('StreamAuthInterceptor replaces an expired token', () {
    test('refreshes and retries once', () async {
      final c = client(_refreshable(), [
        _refused(StreamErrorCode.tokenExpired),
        _ok(),
      ]);

      final response = await c.dio.get<dynamic>('/x');

      expect(response.statusCode, 200);
      expect(
        c.adapter.requests,
        hasLength(2),
        reason: 'the refusal is retried carrying a replacement token',
      );
    });

    test('reports a replacement that is refused too', () async {
      final c = client(_refreshable(), [
        _refused(StreamErrorCode.tokenExpired),
        _refused(StreamErrorCode.tokenExpired),
      ]);

      await expectLater(c.dio.get<dynamic>('/x'), throwsA(isA<DioException>()));

      expect(
        c.adapter.requests,
        hasLength(2),
        reason: 'one replacement is tried, not a loop of them',
      );
    });

    test('leaves a refused token signature alone', () async {
      final c = client(_refreshable(), [
        _refused(StreamErrorCode.tokenSignatureInvalid),
      ]);

      await expectLater(c.dio.get<dynamic>('/x'), throwsA(isA<DioException>()));

      expect(
        c.adapter.requests,
        hasLength(1),
        reason: 'a replacement from the same signer is signed the same way',
      );
    });

    test('leaves an unknown API key alone', () async {
      final c = client(_refreshable(), [
        _refused(StreamErrorCode.apiKeyInvalid),
      ]);

      await expectLater(c.dio.get<dynamic>('/x'), throwsA(isA<DioException>()));

      expect(c.adapter.requests, hasLength(1));
    });

    test('leaves a 401 that carried no Stream code alone', () async {
      final c = client(_refreshable(), [
        ResponseBody.fromString('gateway says no', 401),
      ]);

      await expectLater(c.dio.get<dynamic>('/x'), throwsA(isA<DioException>()));

      expect(
        c.adapter.requests,
        hasLength(1),
        reason: 'nothing in the answer says the token was the problem',
      );
    });

    test('does not refresh a static provider', () async {
      final manager = TokenManager(
        userId: _userId,
        tokenProvider: TokenProvider.static(UserToken(_jwt(_userId))),
      );

      final c = client(manager, [_refused(StreamErrorCode.tokenExpired)]);

      await expectLater(c.dio.get<dynamic>('/x'), throwsA(isA<DioException>()));

      expect(
        c.adapter.requests,
        hasLength(1),
        reason: 'the provider has nothing fresher to give — a guest included',
      );
    });
  });

  // Whatever this interceptor rejects with is classified downstream by
  // `DioException.toStreamException()`, which reads the failure's `error` only
  // when that is a StreamException. A wrapper it cannot recognise falls through
  // to the mapper's network default — so a tokenProvider that threw was
  // reported as "device offline", and telemetry filed it as NETWORK_OFFLINE.
  group('StreamAuthInterceptor rejects with a classifiable failure', () {
    /// Sends one request signed by [getToken] and returns how the failure it
    /// produced is classified.
    Future<StreamException> classifyFailureFrom(GetToken getToken) async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.invalid'));
      dio.httpClientAdapter = _ScriptedAdapter([]);
      dio.interceptors.add(StreamAuthInterceptor(getToken));

      try {
        await dio.get<dynamic>('/x');
      } on DioException catch (exception) {
        return exception.toStreamException();
      }
      fail('the request should not have gone out');
    }

    test('unwraps the core exception a video failure wraps', () async {
      // The shape token_manager_extension produces: TokenManager classifies a
      // throwing provider, and the Result wrapper composes it.
      final composed = StreamVideoExceptions.compose(
        const StreamAuthenticationException(message: 'tokenProvider threw'),
      );

      final exception = await classifyFailureFrom(() => throw composed);

      expect(exception, isA<StreamAuthenticationException>());
      expect(exception.message, 'tokenProvider threw');
    });

    test('passes a core exception through as itself', () async {
      final exception = await classifyFailureFrom(
        () => throw const StreamApiException(
          message: 'no token for this user',
          statusCode: 401,
        ),
      );

      expect(exception, isA<StreamApiException>());
      expect((exception as StreamApiException).statusCode, 401);
    });

    // Signing is what this block is about, so that is the category — not the
    // network, which is what elimination would have picked.
    test(
      'names the category when the failure carries no core exception',
      () async {
        final exception = await classifyFailureFrom(
          () => throw StateError('no user configured'),
        );

        expect(exception, isA<StreamAuthenticationException>());
        expect(exception.cause, isA<StateError>());
      },
    );

    test('a bare video failure still reads as a credentials failure', () async {
      final exception = await classifyFailureFrom(
        () => throw const StreamVideoException(message: 'nope'),
      );

      expect(exception, isA<StreamAuthenticationException>());
    });
  });

  group('StreamAuthInterceptor built to sign only', () {
    test('signs but never retries', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.invalid'));
      final adapter = _ScriptedAdapter([
        _refused(StreamErrorCode.tokenExpired),
      ]);
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(const StreamAuthInterceptor(UserToken.anonymous));

      await expectLater(dio.get<dynamic>('/x'), throwsA(isA<DioException>()));

      expect(
        adapter.requests,
        hasLength(1),
        reason: 'the guest-creation client has no token to replace',
      );
    });
  });
}
