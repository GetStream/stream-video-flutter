import 'dart:async';
import 'dart:math' as math;

import '../../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../../logger/impl/tagged_logger.dart';
import '../../../types/other.dart';
import '../../../ws/keep_alive.dart';
import '../../../ws/ws.dart';
import '../../errors/video_error.dart';
import '../../errors/video_error_composer.dart';
import '../../shared_emitter.dart';
import '../data/events/sfu_event_mapper_extensions.dart';
import '../data/events/sfu_events.dart';
import 'sfu_event_listener.dart';

/// TODO
class SfuWebSocket extends StreamWebSocket
    with KeepAlive, ConnectionStateMixin {
  /// TODO
  factory SfuWebSocket({
    required String sessionId,
    required String sfuUrl,
    Iterable<String>? protocols,
  }) {
    var wsEndpoint = 'ws://$sfuUrl:3031/ws';
    if (!['localhost', '127.0.0.1'].contains(sfuUrl)) {
      final wsUrl = Uri.parse(sfuUrl);
      wsEndpoint = wsUrl
          .replace(
            scheme: 'wss',
            path: '/ws',
          )
          .toString();
    }
    return SfuWebSocket._(
      wsEndpoint,
      protocols: protocols,
      sessionId: sessionId,
    );
  }

  /// TODO
  SfuWebSocket._(
    super.url, {
    super.protocols,
    required this.sessionId,
  });

  final _logger = taggedLogger(tag: 'SV:Sfu-WS');

  final String sessionId;

  final Set<SfuEventListener> _eventListeners = {};
  bool _manuallyClosed = false;

  SharedEmitter<SfuEventV2> get events => _events;
  final _events = MutableSharedEmitterImpl<SfuEventV2>();

  void addEventListener(SfuEventListener listener) {
    _eventListeners.add(listener);
  }

  void removeEventListener(SfuEventListener listener) {
    _eventListeners.remove(listener);
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
    _logger.i(() => '[onOpen] url: $url');
    connectionState = ConnectionState.connected;
    _reconnectAttempt = 0;
  }

  @override
  void onError(Object error, [StackTrace? stackTrace]) {
    _logger.w(() => '[onError] error: $error, stackTrace: $stackTrace');

    _notifyError(VideoErrors.compose(error, stackTrace));

    _reconnect();
  }

  @override
  void onMessage(dynamic message) {
    sfu_events.SfuEvent? rawEvent;
    try {
      rawEvent = sfu_events.SfuEvent.fromBuffer(message);
    } catch (e, stk) {
      _logger.w(() => '[onMessage] failed: $e, stacktrace: $stk');
    }

    if (rawEvent == null) return;

    final eventType = rawEvent.whichEventPayload();
    _logger.v(() => '[onMessage] eventType: $eventType');

    final event = rawEvent.toDomain();
    _handleEvent(event);
    _notifyEvent(event);
  }

  void _handleEvent(SfuEventV2 event) {
    if (event is SfuJoinResponseEvent) {
      if (!isKeepAliveStarted) {
        _logger.d(() => '[handleEvent] start PingPong');
        startPingPong();
      }
    } else if (event is SfuHealthCheckResponseEvent) {
      _logger.d(() => '[handleEvent] ack Pong');
      ackPong(event);
    }
  }

  @override
  void onClose(int? closeCode, String? closeReason) {
    _logger.i(
      () => '[onClose] closeCode: $closeCode, closeReason: $closeReason',
    );

    if (_manuallyClosed) {
      connectionState = ConnectionState.disconnected;
      return;
    }

    _reconnect();
  }

  @override
  Future<void> disconnect([int? closeCode, String? closeReason]) async {
    _logger.i(
      () => '[disconnect] closeCode: $closeCode, closeReason: $closeReason',
    );
    // return if already disconnected.
    if (connectionState == ConnectionState.disconnected) return;

    // Stop sending keep alive messages.
    stopPingPong();

    // If no close code is provided,
    // means we are manually closing the connection.
    if (closeCode == null) _manuallyClosed = true;

    return super.disconnect(closeCode, closeReason);
  }

  @override
  void send(sfu_events.SfuRequest request) {
    _logger.d(() => '[send] request: $request');
    super.send(request.writeToBuffer());
  }

  @override
  void sendPing() {
    _logger.d(() => '[sendPing] no args');
    send(
      sfu_events.SfuRequest(
        healthCheckRequest: sfu_events.HealthCheckRequest(),
      ),
    );
  }

  int _reconnectAttempt = 0;

  void _reconnect() async {
    if (isConnecting || isReconnecting) return;
    _logger.d(() => '[_reconnect] _reconnectAttempt: $_reconnectAttempt');
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

  void _notifyEvent(SfuEventV2 event) {
    _events.emit(event);
    for (final listener in _eventListeners) {
      listener.onSfuEvent(event);
    }
  }

  void _notifyError(VideoError error) {
    for (final listener in _eventListeners) {
      listener.onSfuError(error);
    }
  }
}
