import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<WebSocketChannel> connect(Uri uri, {Iterable<String>? protocols}) async {
  try {
    final webSocket = WebSocket.connect(
      uri.toString(),
      protocols: protocols,
    );
    return IOWebSocketChannel(await webSocket);
  } on SocketException catch (err) {
    throw WebSocketChannelException.from(err);
  }
}
