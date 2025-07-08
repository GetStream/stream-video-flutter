import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/ws/ws.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';

void main() {
  late WebSocketChannel webSocketChannel;
  late WebSocketSink webSocketSink;
  late StreamWebSocket webSocket;

  Future<WebSocketChannel> defaultChannelProvider(
    Uri uri, {
    Iterable<String>? protocols,
  }) async =>
      webSocketChannel;

  setUp(() {
    webSocketChannel = MockWebSocketChannel();

    webSocketSink = MockWebSocketSink();
    when(() => webSocketChannel.sink).thenReturn(webSocketSink);

    var webSocketController = StreamController<String>.broadcast();
    when(() => webSocketChannel.stream).thenAnswer(
      (_) => webSocketController.stream,
    );
    when(() => webSocketSink.add(any<dynamic>())).thenAnswer((invocation) {
      webSocketController.add(invocation.positionalArguments.first);
    });
    when(() => webSocketSink.close(any(), any())).thenAnswer(
      (_) async {
        await webSocketController.close();
        // re-initializing for future events
        webSocketController = StreamController<String>.broadcast();
      },
    );
  });

  tearDown(() {
    webSocket.disconnect();
  });

  test('connect successfully', () async {
    webSocket = TestWebSocket(
      'ws://<local-ip>:8800',
      webSocketChannelConnector: defaultChannelProvider,
    );

    final result = await webSocket.connect();
    expect(result, isA<Success<None>>());
  });

  test('connect fails', () async {
    Future<WebSocketChannel> failingChannelProvider(
      Uri uri, {
      Iterable<String>? protocols,
    }) async =>
        throw Exception('test');

    webSocket = TestWebSocket(
      'ws://<local-ip>:8800',
      webSocketChannelConnector: failingChannelProvider,
    );

    final result = await webSocket.connect();
    expect(result, isA<Failure>());
  });

  test('Websocket forwards messages', () async {
    Object? receivedMessage;

    webSocket = TestWebSocket(
      'ws://<local-ip>:8800',
      webSocketChannelConnector: defaultChannelProvider,
      onMessageCallback: (message) {
        receivedMessage = message;
      },
    );

    await webSocket.connect();
    webSocketSink.add('test');
    await Future<void>.delayed(Duration.zero);

    expect(receivedMessage, 'test');
  });
}

class TestWebSocket extends StreamWebSocket {
  TestWebSocket(
    super.url, {
    required WebSocketChannelConnector webSocketChannelConnector,
    this.onMessageCallback,
    this.onErrorCallback,
    this.onOpenCallback,
    this.onCloseCallback,
  }) : super(webSocketChannelConnector: webSocketChannelConnector);

  void Function(dynamic)? onMessageCallback;
  void Function(Object, [StackTrace?])? onErrorCallback;
  void Function()? onOpenCallback;
  void Function(int?, String?)? onCloseCallback;

  @override
  void onClose(int? closeCode, String? closeReason) {
    onCloseCallback?.call(closeCode, closeReason);
  }

  @override
  void onError(Object error, [StackTrace? stackTrace]) {
    onErrorCallback?.call(error, stackTrace);
  }

  @override
  void onMessage(dynamic message) {
    onMessageCallback?.call(message);
  }

  @override
  void onOpen() {
    onOpenCallback?.call();
  }
}
