import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/ws/sfu_ws.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// A socket whose handshake never answers, as one opened with no network
/// does until the OS gives up on it — and whose close waits on that handshake.
class _UnansweredChannel implements WebSocketChannel {
  @override
  final Future<void> ready = Completer<void>().future;

  @override
  final Stream<dynamic> stream = StreamController<dynamic>().stream;

  // Never closes: that is the socket being modelled.
  @override
  // ignore: close_sinks
  final WebSocketSink sink = _UnansweredSink();

  @override
  String? get protocol => null;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;

  // The stream-channel plumbing, which nothing here calls.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnansweredSink implements WebSocketSink {
  @override
  Future<void> close([int? closeCode, String? closeReason]) =>
      Completer<void>().future;

  @override
  Future<void> get done => Completer<void>().future;

  @override
  void add(dynamic data) {}

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<void> addStream(Stream<dynamic> stream) async {}
}

/// A socket that opens, then fails the way a dropped network fails one: its
/// stream reports an error and closes.
class _FailingChannel implements WebSocketChannel {
  final _controller = StreamController<dynamic>();

  void fail(Object error) {
    _controller.addError(error);
    unawaited(_controller.close());
  }

  @override
  final Future<void> ready = Future<void>.value();

  @override
  Stream<dynamic> get stream => _controller.stream;

  @override
  // ignore: close_sinks
  final WebSocketSink sink = _UnansweredSink();

  @override
  String? get protocol => null;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

SfuWebSocket _socket({WebSocketProvider? wsProvider}) {
  return SfuWebSocket(
    sessionSeq: 0,
    sessionId: 'session-1',
    cid: 'default:call-1',
    userId: 'user-1',
    apiKey: 'test-key',
    sfuUrl: 'https://sfu.invalid/twirp',
    sfuWsEndpoint: 'wss://sfu.invalid/ws',
    wsProvider: wsProvider ?? (_) => _UnansweredChannel(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // What core's connect timeout does when it fires.
  void timeOut(SfuWebSocket socket) {
    unawaited(
      socket.client.disconnect(
        source: const DisconnectionSource.connectTimeout(),
      ),
    );
  }

  // Core's 30 s default outlasts the SFU's fast-reconnect window, so a
  // fast reconnect on an unanswered upgrade could only end in a rejoin.
  test('bounds an attempt by the SFU connect timeout', () async {
    WebSocketOptions? opened;
    final socket = _socket(
      wsProvider: (options) {
        opened = options;
        return _UnansweredChannel();
      },
    );

    unawaited(socket.connect());
    await pumpEventQueue();

    expect(opened?.connectTimeout, sfuConnectTimeout);
    expect(sfuConnectTimeout, lessThan(WebSocketOptions.defaultConnectTimeout));
  });

  // A fast reconnect recreates the socket and waits on it. When the handshake
  // went unanswered, it waited past the connect timeout for as long as the OS
  // took to give up, and every reconnect queued behind it waited too.
  group('an attempt the connect timeout closes', () {
    test('fails connect instead of holding it', () async {
      final socket = _socket();

      final result = socket.connect();
      expect(socket.client.connectionState.value, isA<Connecting>());
      timeOut(socket);

      expect(
        (await result.timeout(const Duration(seconds: 1))).isFailure,
        isTrue,
      );
    });

    test('fails recreate instead of holding it', () async {
      final socket = _socket();
      (socket.client.connectionState as MutableConnectionStateEmitter).value =
          const WebSocketConnectionState.disconnected(
            source: DisconnectionSource.unHealthyConnection(),
          );

      final result = socket.recreate();
      await pumpEventQueue();
      expect(socket.client.connectionState.value, isA<Connecting>());
      timeOut(socket);

      expect(
        (await result.timeout(const Duration(seconds: 1))).isFailure,
        isTrue,
      );
    });
  });

  // Core reports a socket error as a `SystemInitiated` closure; the call reads
  // nothing from it unless this layer turns it into an event.
  test('a socket error mid-call is reported as a failure', () async {
    final channel = _FailingChannel();
    final socket = _socket(wsProvider: (_) => channel);
    final emitted = socket.events.firstWhere((it) => it is SfuSocketFailed);

    unawaited(socket.connect());
    await pumpEventQueue();
    channel.fail(const SocketException('Connection reset by peer'));

    final event = await emitted.timeout(const Duration(seconds: 1));
    expect((event as SfuSocketFailed).isReconnectable, isTrue);
  });
}
