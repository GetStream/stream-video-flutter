import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart';
import 'package:stream_video/src/core/error/video_error.dart';
import 'package:stream_video/src/core/logger/logger.dart';
import 'package:stream_video/src/core/utils/event_emitter.dart';
import 'package:stream_video/src/types/other.dart';
import 'package:stream_video/src/ws/keep_alive.dart';
import 'package:stream_video/src/ws/ws.dart';

export 'package:stream_video/src/core/utils/event_emitter.dart' show Listener;

class SignalWebSocket extends StreamWebSocket
    with KeepAlive, ConnectionStateMixin, EventEmitterMixin<SfuEvent> {
  SignalWebSocket(
    super.url, {
    super.protocols,
    required this.sessionId,
  });

  final String sessionId;

  final _requestQueue = Queue<SfuRequest>();

  @override
  set onConnectionStateUpdated(OnConnectionStateUpdated? handler) {
    void _onConnectionStateUpdated(ConnectionStateUpdated state) {
      if (state.didConnected) {
        _sendQueuedRequests();
      }
      return handler?.call(state);
    }

    super.onConnectionStateUpdated = _onConnectionStateUpdated;
  }

  @override
  Future<void> connect({bool reconnect = false}) {
    connectionState = reconnect //
        ? ConnectionState.reconnecting
        : ConnectionState.connecting;

    return super.connect();
  }

  @override
  void onOpen() {
    logger.info('Signal connection opened: $url');

    // Mark connected once the connection is opened.
    connectionState = ConnectionState.connected;

    // Reset the reconnect attempts.
    _reconnectAttempt = 0;

    // Waiting for the join event to start the keep alive.
    // This is to avoid sending keep alive messages before the connection is
    // established.
    once(
      SfuEvent_EventPayload.joinResponse.name,
      (_) {
        logger.info('Starting signal ping pong timer');
        startPingPong();
      },
    );
  }

  @override
  void onError(Object error, [StackTrace? stackTrace]) {
    logger.warning('Signal connection error occurred', error, stackTrace);

    StreamVideoWebSocketError wsError;
    if (error is WebSocketChannelException) {
      wsError = StreamVideoWebSocketError.fromWebSocketChannelError(error);
    } else {
      wsError = StreamVideoWebSocketError(error.toString());
    }

    _reconnect();
  }

  @override
  void onMessage(dynamic message) {
    SfuEvent? event;
    try {
      event = SfuEvent.fromBuffer(message);
    } catch (e, stk) {
      logger.warning('Error parsing an event: $e');
      logger.warning('Stack trace: $stk');
    }

    if (event == null) return;

    final eventType = event.whichEventPayload();
    logger.info('Signal event received: $eventType');

    if (eventType == SfuEvent_EventPayload.healthCheckResponse) {
      _handleHealthCheckEvent(event.healthCheckResponse);
    }

    return emitter.emit(eventType.name, event);
  }

  void _handleHealthCheckEvent(HealthCheckResponse event) {
    ackPong(event);
  }

  bool _manuallyClosed = false;

  @override
  void onClose(int? closeCode, String? closeReason) {
    logger.warning('Signal connection closed: $url');

    // check if we manually closed the connection
    if (_manuallyClosed) {
      connectionState = ConnectionState.disconnected;
      return;
    }

    _reconnect();
  }

  @override
  Future<void> disconnect([int? closeCode, String? closeReason]) async {
    // return if already disconnected.
    if (connectionState == ConnectionState.disconnected) return;

    // Stop sending keep alive messages.
    stopPingPong();

    // Clear the request queue.
    _requestQueue.clear();

    // If no close code is provided,
    // means we are manually closing the connection.
    if (closeCode == null) _manuallyClosed = true;

    return super.disconnect(closeCode, closeReason);
  }

  @override
  void send(
    SfuRequest request, {
    bool enqueueIfConnecting = true,
  }) {
    if (isDisconnected) {
      logger.warning('Cannot send signal message, connection is disconnected');
      return;
    }

    if ((isConnecting || isReconnecting) && enqueueIfConnecting) {
      logger.info('Signal connection is in progress, enqueuing the request');
      _requestQueue.add(request);
      return;
    }

    logger.info('Sending signal request: $request');
    super.send(request.writeToBuffer());
  }

  @override
  void sendPing() {
    final healthCheck = HealthCheckRequest(sessionId: sessionId);
    return send(SfuRequest(
      healthCheckRequest: healthCheck,
    ));
  }

  int _reconnectAttempt = 0;

  void _reconnect() async {
    if (isConnecting || isReconnecting) return;

    logger.info('Signal reconnecting: $_reconnectAttempt');
    _reconnectAttempt += 1;

    final delay = _getReconnectInterval(_reconnectAttempt);

    Future.delayed(
      Duration(milliseconds: delay),
      () => connect(reconnect: true),
    );
  }

  // returns the reconnect interval based on `reconnectAttempt` in milliseconds
  int _getReconnectInterval(int reconnectAttempt) {
    // try to reconnect in 0.25-25 seconds
    // (random to spread out the load from failures)
    final max = math.min(500 + reconnectAttempt * 2000, 25000);
    final min = math.min(math.max(250, (reconnectAttempt - 1) * 2000), 25000);
    return (math.Random().nextDouble() * (max - min) + min).floor();
  }

  void _sendQueuedRequests() {
    logger.info('Sending all queued signal requests');

    while (_requestQueue.isNotEmpty) {
      final request = _requestQueue.removeFirst();
      send(request, enqueueIfConnecting: false);
    }
  }
}
