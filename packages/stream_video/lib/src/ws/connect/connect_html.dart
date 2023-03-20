import 'dart:async';
import 'dart:html';

import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<WebSocketChannel> connect(Uri uri, {Iterable<String>? protocols}) async {
  final completer = Completer<HtmlWebSocketChannel>();
  final webSocket = WebSocket(uri.toString())
    ..binaryType = BinaryType.list.value;

  unawaited(
    webSocket.onOpen.first.then((value) {
      completer.complete(HtmlWebSocketChannel(webSocket));
    }),
  );

  unawaited(
    webSocket.onError.first.then((err) {
      completer.completeError(WebSocketChannelException.from(err));
    }),
  );

  return completer.future;
}
