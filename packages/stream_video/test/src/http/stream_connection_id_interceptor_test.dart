import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/http/stream_connection_id_interceptor.dart';
import 'package:stream_video/src/http/stream_retry_interceptor.dart';
import 'package:stream_video/src/retry/retry_policy.dart';

/// Records what each request carried, and always answers 200.
class _RecordingAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      '{}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  ({Dio dio, _RecordingAdapter adapter}) client(
    ConnectionIdResolver resolve,
  ) {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.invalid'));
    final adapter = _RecordingAdapter();
    dio.httpClientAdapter = adapter;
    dio.interceptors.add(StreamConnectionIdInterceptor(resolve));
    return (dio: dio, adapter: adapter);
  }

  group('StreamConnectionIdInterceptor', () {
    test('attaches an id that is already there', () async {
      final c = client(() => 'conn-1');

      await c.dio.get<dynamic>('/x');

      expect(
        c.adapter.requests.single.queryParameters['connection_id'],
        'conn-1',
      );
    });

    test('waits for an id that is on its way', () async {
      final pending = Completer<String?>();
      final c = client(() => pending.future);

      final request = c.dio.get<dynamic>('/x');
      // Nothing has gone out while the id is still pending.
      expect(c.adapter.requests, isEmpty);

      pending.complete('conn-late');
      await request;

      expect(
        c.adapter.requests.single.queryParameters['connection_id'],
        'conn-late',
      );
    });

    // The request is worth making regardless: the watches it registers are
    // registered again once the socket connects, so failing here would turn a
    // slow socket into a failed call for no gain.
    test('sends the request anyway when there is no id', () async {
      final c = client(() => null);

      final response = await c.dio.get<dynamic>('/x');

      expect(response.statusCode, 200);
      expect(
        c.adapter.requests.single.queryParameters.containsKey('connection_id'),
        isFalse,
      );
    });

    test('treats an empty id as no id', () async {
      final c = client(() => '');

      await c.dio.get<dynamic>('/x');

      expect(
        c.adapter.requests.single.queryParameters.containsKey('connection_id'),
        isFalse,
      );
    });

    // A plain Interceptor is not a QueuedInterceptor, so one request waiting
    // for an id must not hold up another.
    test('does not hold up a concurrent request', () async {
      var calls = 0;
      final gate = Completer<String?>();
      final c = client(() {
        calls++;
        // Only the first request waits.
        return calls == 1 ? gate.future : 'conn-fast';
      });

      final slow = c.dio.get<dynamic>('/slow');
      final fast = await c.dio.get<dynamic>('/fast');

      expect(fast.statusCode, 200, reason: 'the second request went through');
      expect(c.adapter.requests.single.path, '/fast');

      gate.complete('conn-slow');
      await slow;
      expect(c.adapter.requests.map((it) => it.path), ['/fast', '/slow']);
    });
  });

  // A retry re-runs the request interceptors against the options the refused
  // attempt carried, and `copyWith` brings its query parameters along. So an id
  // written by an earlier attempt is already present, and the resolver saying
  // "no id" has to mean the parameter goes away — not merely that nothing new
  // is written.
  group('StreamConnectionIdInterceptor on a retried request', () {
    Duration noBackoff(RetryConfig config, int retryAttempt) => Duration.zero;

    test('drops an id the refused attempt carried', () async {
      final ids = <String?>['conn-a', null];
      final seen = <Object?>[];

      final dio = Dio(BaseOptions(baseUrl: 'https://example.invalid'));
      dio.httpClientAdapter = _ScriptedStatusAdapter([503], seen);
      dio.interceptors.addAll([
        StreamConnectionIdInterceptor(() => ids.removeAt(0)),
        const ApiErrorInterceptor(),
        StreamRetryInterceptor(
          dio: dio,
          policy: RetryPolicy(
            config: const RetryConfig(rpcMaxRetries: 2),
            backoff: noBackoff,
          ),
        ),
      ]);

      await dio.get<dynamic>('/calls', queryParameters: {'watch': true});

      expect(
        seen,
        ['conn-a', null],
        reason: 'the retry must not register a watch against a dead socket',
      );
    });

    test('replaces it when the socket came back with a new id', () async {
      final ids = <String?>['conn-a', 'conn-b'];
      final seen = <Object?>[];

      final dio = Dio(BaseOptions(baseUrl: 'https://example.invalid'));
      dio.httpClientAdapter = _ScriptedStatusAdapter([503], seen);
      dio.interceptors.addAll([
        StreamConnectionIdInterceptor(() => ids.removeAt(0)),
        const ApiErrorInterceptor(),
        StreamRetryInterceptor(
          dio: dio,
          policy: RetryPolicy(
            config: const RetryConfig(rpcMaxRetries: 2),
            backoff: noBackoff,
          ),
        ),
      ]);

      await dio.get<dynamic>('/calls');

      expect(seen, ['conn-a', 'conn-b']);
    });
  });
}

/// Answers each request with the next status in [_script], recording the
/// `connection_id` it carried.
class _ScriptedStatusAdapter implements HttpClientAdapter {
  _ScriptedStatusAdapter(this._script, this._seen);

  final List<int> _script;
  final List<Object?> _seen;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    _seen.add(options.queryParameters['connection_id']);
    final status = _script.isEmpty ? 200 : _script.removeAt(0);
    return ResponseBody.fromString(
      '{}',
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
