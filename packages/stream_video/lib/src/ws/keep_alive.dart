import 'dart:async';

import 'package:web_socket_channel/status.dart' as status;

import 'ws.dart';

/// The time duration to ping connection to keep it alive.
const _pingDuration = Duration(seconds: 25);

/// The time duration for pong timeout.
const _pongTimeoutDuration = Duration(seconds: 3);

/// A mixin to keep the websocket connection alive.
mixin KeepAlive on StreamWebSocket {
  Timer? _pingTimer;
  Timer? _pongTimer;

  bool isKeepAliveStarted = false;

  /// Sends a ping signal to the WS.
  void sendPing();

  /// Acknowledges the pong message.
  void ackPong(dynamic pong) {
    _pongTimer?.cancel();
    _pongTimer = null;
  }

  /// Starts the ping pong timer.
  ///
  /// Sends a ping signal every [_pingDuration] and waits for a pong message
  /// within [_pongTimeoutDuration].
  ///
  /// If a pong message is not [ack] within [_pongTimeoutDuration], the
  /// connection is closed.
  void startPingPong() {
    isKeepAliveStarted = true;
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(
      _pingDuration,
      (_) {
        sendPing();
        _pongTimer = Timer(
          _pongTimeoutDuration,
          () {
            _pingTimer?.cancel();
            _pingTimer = null;
            disconnect(status.normalClosure, 'Pong timeout');
          },
        );
      },
    );
  }

  /// Stops the ping pong timer.
  void stopPingPong() {
    isKeepAliveStarted = false;
    _pingTimer?.cancel();
    _pingTimer = null;
    _pongTimer?.cancel();
    _pongTimer = null;
  }
}
