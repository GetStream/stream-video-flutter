import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart'
    as sfu_events;
import 'package:stream_video/src/core/video_error.dart';
import 'package:stream_video/src/events.dart';
import 'package:stream_video/src/internal/events.dart';
import 'package:stream_video/src/logger/logger.dart';
import 'package:stream_video/src/types/other.dart';
import 'package:stream_video/src/v2/sfu/ws/sfu_mapper_extensions.dart';
import 'package:stream_video/src/ws/keep_alive.dart';
import 'package:stream_video/src/ws/ws.dart';

/// TODO
class SfuWebSocket extends StreamWebSocket
    with KeepAlive, ConnectionStateMixin {
  /// TODO
  SfuWebSocket(
    super.url, {
    super.protocols,
    required this.sessionId,
  });

  final String sessionId;

  final _requestQueue = Queue<sfu_events.SfuRequest>();

  @override
  OnConnectionStateUpdated get onConnectionStateUpdated {
    void _onConnectionStateUpdated(ConnectionStateUpdatedEvent state) {
      if (state.didConnected) {
        _sendQueuedRequests();
      }
      // Emit connection state updated event
      /* TODO
      events.emit(state);*/
    }

    return _onConnectionStateUpdated;
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
    /* TODO
    events.on<SFUJoinResponseEvent>(limit: 1, (data) {
      logger.info('Starting signal ping pong timer');
      startPingPong();
    });*/
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
    sfu_events.SfuEvent? rawEvent;
    try {
      rawEvent = sfu_events.SfuEvent.fromBuffer(message);
    } catch (e, stk) {
      logger.warning('Error parsing an rawEvent: $e');
      logger.warning('Stack trace: $stk');
    }

    if (rawEvent == null) return;

    final eventType = rawEvent.whichEventPayload();
    logger.info('Signal rawEvent received: $eventType');

    if (eventType == sfu_events.SfuEvent_EventPayload.healthCheckResponse) {
      _handleHealthCheckEvent(rawEvent.healthCheckResponse);
    }

    final event = rawEvent.toDomain();
    /* TODO
    events.emitSignalEventFromSfu(event);*/
  }

  void _handleHealthCheckEvent(sfu_events.HealthCheckResponse event) {
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
    sfu_events.SfuRequest request, {
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
    final healthCheck =
        sfu_events.HealthCheckRequest(/* sessionId: sessionId */);
    return send(sfu_events.SfuRequest(
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
