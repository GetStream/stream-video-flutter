import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../logger/stream_log.dart';
import 'connect/connect.dart'
    if (dart.library.html) 'package:stream_video/src/ws/connect/connect_html.dart'
    if (dart.library.io) 'package:stream_video/src/ws/connect/connect_io.dart'
    as platform;

export 'package:web_socket_channel/web_socket_channel.dart';

/// A simple wrapper around [WebSocketChannel] to make it easier to use.
abstract class StreamWebSocket {
  /// Creates a new instance of [StreamWebSocket].
  StreamWebSocket(
    this.url, {
    this.protocols,
  });

  /// The URI to connect to.
  final String url;

  /// The protocols to use.
  final Iterable<String>? protocols;

  WebSocketChannel? _ws;
  StreamSubscription? _wsSubscription;

  /// Returns true if the ws connection is in progress.
  bool get connectRequestInProgress => _connectRequestInProgress;
  bool _connectRequestInProgress = false;

  /// Creates a new websocket connection.
  ///
  /// Connects to [uri] using and returns a channel that can be used to
  /// communicate over the resulting socket.
  Future<void> connect() async {
    streamLog.i('SV:AbstractWS', () => '[connect] url: $url');
    try {
      if (_connectRequestInProgress) return;
      _connectRequestInProgress = true;

      final uri = Uri.parse(url);
      _ws = await platform.connect(uri, protocols: protocols);

      onOpen();

      _wsSubscription = _ws!.stream.listen(
        onMessage,
        onError: onError,
        onDone: () => onClose(_ws?.closeCode, _ws?.closeReason),
      );
    } catch (error, stackTrace) {
      onError(error, stackTrace);
    } finally {
      _connectRequestInProgress = false;
    }
  }

  /// Called when the websocket connection is opened.
  void onOpen();

  /// Called when the websocket connection is closed.
  void onClose(int? closeCode, String? closeReason);

  /// Called when an error is received.
  void onError(Object error, [StackTrace? stackTrace]);

  /// Called when a [message] is received.
  void onMessage(dynamic message);

  /// Closes the web socket connection.
  ///
  /// [closeCode] and [closeReason] are the [close code][] and [reason][] sent
  /// to the remote peer, respectively. If they are omitted, the peer will see
  /// a "no status received" code with no reason.
  ///
  /// [close code]: https://tools.ietf.org/html/rfc6455#section-7.1.5
  /// [reason]: https://tools.ietf.org/html/rfc6455#section-7.1.6
  Future<void> disconnect([int? closeCode, String? closeReason]) async {
    streamLog.i('SV:AbstractWS', () => '[disconnect] url: $url');
    await _ws?.sink.close(closeCode, closeReason);
    _ws = null;
    await _wsSubscription?.cancel();
    _wsSubscription = null;
  }

  /// Sends a [message] to the websocket.
  void send(covariant dynamic /*String|List<int>*/ message) {
    return _ws?.sink.add(message);
  }
}
