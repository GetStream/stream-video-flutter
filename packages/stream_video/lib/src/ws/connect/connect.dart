import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

Future<WebSocketChannel> connect(Uri uri, {Iterable<String>? protocols}) {
  throw UnsupportedError('No implementation of the connect api provided');
}
