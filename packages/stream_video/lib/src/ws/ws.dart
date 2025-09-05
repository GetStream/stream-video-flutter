import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../errors/video_error_composer.dart';
import '../logger/impl/tagged_logger.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import 'connect/connect.dart'
    if (dart.library.html) 'package:stream_video/src/ws/connect/connect_html.dart'
    if (dart.library.io) 'package:stream_video/src/ws/connect/connect_io.dart'
    as platform;
import 'health/connection_state.dart';

export 'package:web_socket_channel/web_socket_channel.dart';

export 'health/connection_state.dart';
export 'health/network_monitor.dart';

enum StreamWebSocketCloseCode {
  // /**
  //  * The normal closure code. Used for controlled shutdowns.
  //  */
  normalClosure(1000),

  // /**
  //  * The going away code. Used when the server is going down.
  //  */
  goingAway(1001),

  // /**
  //  * The error code used when the SFU connection is unhealthy.
  //  * Usually, this means that no message has been received from the SFU for
  //  * a certain amount of time (`connectionCheckTimeout`).
  //  */
  errorConnectionUnhealthy(4001),

  // /**
  //  * The error code used when the SFU connection is disposed because a new
  //  * connection is established or is about to be established.
  //  * Here, we don't use 1000 (normal closure) because we don't want the
  //  * SFU to clean up the resources associated with the current participant.
  //  */
  disposeOldSocket(4002);

  const StreamWebSocketCloseCode(this.value);
  final int value;

  static bool isIntentionalClosure(int? code) =>
      code == normalClosure.value || code == goingAway.value;
}

/// Typedef used for connecting to a websocket. Method returns a
/// [WebSocketChannel] and accepts a connection url and an optional
/// [Iterable] of `protocols`.
typedef WebSocketChannelConnector =
    Future<WebSocketChannel> Function(
      Uri uri, {
      Iterable<String>? protocols,
    });

/// A simple wrapper around [WebSocketChannel] to make it easier to use.
abstract class StreamWebSocket with ConnectionStateMixin {
  /// Creates a new instance of [StreamWebSocket].
  StreamWebSocket(
    this.url, {
    this.protocols,
    WebSocketChannelConnector? webSocketChannelConnector,
    String tag = 'SV:AbstractWS',
  }) : _webSocketChannelConnector =
           webSocketChannelConnector ?? platform.connect,
       _logger = taggedLogger(tag: tag);

  /// The URI to connect to.
  final String url;

  /// The protocols to use.
  final Iterable<String>? protocols;

  /// The descendant tag.
  final TaggedLogger _logger;

  final WebSocketChannelConnector _webSocketChannelConnector;
  WebSocketChannel? _ws;
  StreamSubscription<dynamic>? _wsSubscription;

  /// Returns true if the ws connection is in progress.
  bool get connectRequestInProgress => _connectRequestInProgress;
  bool _connectRequestInProgress = false;

  Future<Result<None>> recreate() async {
    await disconnect(StreamWebSocketCloseCode.disposeOldSocket.value);
    return connect();
  }

  /// Creates a new websocket connection.
  ///
  /// Connects to [url] using and returns a channel that can be used to
  /// communicate over the resulting socket.
  Future<Result<None>> connect() async {
    _logger.i(
      () =>
          '[connect] connectRequestInProgress: '
          '$_connectRequestInProgress, url: $url',
    );
    try {
      if (_connectRequestInProgress) {
        return const Result.success(none);
      }
      _connectRequestInProgress = true;

      final uri = Uri.parse(url);
      _ws = await _webSocketChannelConnector(uri, protocols: protocols);

      onOpen();

      _wsSubscription = _ws!.stream.listen(
        onMessage,
        onError: onError,
        onDone: () => onClose(_ws?.closeCode, _ws?.closeReason),
      );
      return const Result.success(none);
    } catch (error, stackTrace) {
      _logger.e(() => '[connect] failed: $error');
      onError(error, stackTrace);
      return Result.failure(VideoErrors.compose(error));
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
  Future<Result<None>> disconnect([int? closeCode, String? closeReason]) async {
    try {
      _logger.i(
        () =>
            '[disconnect] connectRequestInProgress: '
            '$_connectRequestInProgress, url: $url',
      );
      await _ws?.sink.close(closeCode, closeReason);
      _ws = null;
      await _wsSubscription?.cancel();
      _wsSubscription = null;
      return const Result.success(none);
    } catch (error, stackTrace) {
      _logger.e(() => '[disconnect] failed: $error');
      return Result.failure(VideoErrors.compose(error, stackTrace));
    }
  }

  /// Sends a [message] to the websocket.
  void send(covariant dynamic /*String|List<int>*/ message) {
    _logger.v(() => '[send] hasWS: ${_ws != null}');
    return _ws?.sink.add(message);
  }
}
