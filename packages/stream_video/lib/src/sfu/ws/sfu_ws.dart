import 'dart:async';
import 'dart:math' as math;

import '../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../errors/video_error_composer.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../logger/stream_log.dart';
import '../../shared_emitter.dart';
import '../../types/other.dart';
import '../../ws/health/health_monitor.dart';
import '../../ws/ws.dart';
import '../data/events/sfu_event_mapper_extensions.dart';
import '../data/events/sfu_events.dart';

const _tag = 'SV:Sfu-WS';
int _sfuSeq = 1;

const _maxJitter = Duration(milliseconds: 500);
const _defaultDelay = Duration(milliseconds: 250);
const _retryMaxBackoff = Duration(seconds: 5);
final _rnd = math.Random();

/// TODO
class SfuWebSocket extends StreamWebSocket
    with ConnectionStateMixin
    implements HealthListener {
  /// TODO
  factory SfuWebSocket({
    required String sessionId,
    required String sfuUrl,
    Iterable<String>? protocols,
  }) {
    streamLog.i(_tag, () => '<factory> sessionId: $sessionId');
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
    String url, {
    Iterable<String>? protocols,
    required this.sessionId,
  }) : super(url, protocols: protocols, tag: _tag) {
    _logger.i(() => '<init> sessionId: $sessionId');
  }

  late final HealthMonitor healthMonitor = HealthMonitorImpl('Sfu', this);

  final _logger = taggedLogger(tag: '$_tag-${_sfuSeq++}');

  final String sessionId;

  bool _manuallyClosed = false;

  SharedEmitter<SfuEvent> get events => _events;
  final _events = MutableSharedEmitterImpl<SfuEvent>();

  @override
  Future<void> connect() {
    _logger.i(() => '[connect] connectionState: $connectionState');
    connectionState = ConnectionState.connecting;

    healthMonitor.start();

    return super.connect();
  }

  @override
  void onOpen() {
    _logger.i(() => '[onOpen] url: $url');
    connectionState = ConnectionState.connected;
    _reconnectAttempt = 0;

    _events.emit(SfuSocketConnected(sessionId: sessionId, url: url));
  }

  @override
  void onError(Object error, [StackTrace? stackTrace]) {
    _logger.w(() => '[onError] error: $error, stackTrace: $stackTrace');
    healthMonitor.onSocketError(error);

    _events.emit(
      SfuSocketFailed(
        sessionId: sessionId,
        url: url,
        error: VideoErrors.compose(error, stackTrace),
      ),
    );

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

    _logger.v(() => '[onRawMessage] message: $rawEvent');

    final event = rawEvent.toDomain();
    _handleEvent(event);
    _events.emit(event);
  }

  void _handleEvent(SfuEvent event) {
    if (event is SfuJoinResponseEvent) {
      _logger.d(() => '[handleEvent] event.type: SfuJoinResponseEvent');
      connectionState = ConnectionState.connected;
      healthMonitor.onPongReceived();
    } else if (event is SfuHealthCheckResponseEvent) {
      _logger.d(() => '[handleEvent] event.type: SfuHealthCheckResponseEvent');
      healthMonitor.onPongReceived();
    }
  }

  @override
  void onClose(int? closeCode, String? closeReason) {
    _logger.i(
      () => '[onClose] closeCode: $closeCode, closeReason: $closeReason, '
          'manuallyClosed: $_manuallyClosed',
    );
    healthMonitor.onSocketClose();
    if (_manuallyClosed) {
      connectionState = ConnectionState.disconnected;
      return;
    }

    _events.emit(
      SfuSocketDisconnected(
        sessionId: sessionId,
        url: url,
        closeCode: closeCode,
        closeReason: closeReason,
      ),
    );

    _reconnect();
  }

  @override
  Future<void> disconnect([int? closeCode, String? closeReason]) async {
    _logger.i(
      () => '[disconnect] closeCode: $closeCode, closeReason: $closeReason',
    );
    if (connectionState == ConnectionState.disconnected) {
      _logger.w(() => '[disconnect] rejected (already disconnected)');
      return;
    }

    // Stop sending keep alive messages.
    healthMonitor.stop();

    // If no close code is provided,
    // means we are manually closing the connection.
    if (closeCode == null) {
      _logger.v(() => '[disconnect] mark as "manuallyClosed"');
      _manuallyClosed = true;
    }

    return super.disconnect(closeCode, closeReason);
  }

  void sendPing() {
    _logger.d(() => '[sendPing] no args');
    send(
      sfu_events.SfuRequest(
        healthCheckRequest: sfu_events.HealthCheckRequest(),
      ),
    );
  }

  @override
  void send(sfu_events.SfuRequest message) {
    _logger.d(() => '[send] message: $message');
    super.send(message.writeToBuffer());
  }

  int _reconnectAttempt = 0;

  Future<void> _reconnect() async {
    if (isConnecting || isReconnecting) return;
    _logger.d(() => '[_reconnect] _reconnectAttempt: $_reconnectAttempt');
    _reconnectAttempt += 1;

    final delay = _calculateDelay(_reconnectAttempt);

    Future.delayed(delay, () async {
      _logger.v(() => '[reconnect] triggered');
      connectionState = ConnectionState.reconnecting;
      await super.connect();
      _logger.v(() => '[reconnect] completed');
    });
  }

  Duration get jitter {
    return Duration(milliseconds: _rnd.nextInt(_maxJitter.inMilliseconds));
  }

  Duration _calculateDelay(int retryAttempt) {
    if (retryAttempt == 0) {
      return Duration.zero;
    }
    final calculated = _defaultDelay * retryAttempt + jitter;
    if (calculated < _retryMaxBackoff) {
      return calculated;
    }
    return _retryMaxBackoff;
  }

  @override
  Future<void> onPongTimeout(Duration timeout) async {
    _logger.d(() => '[onPongTimeout] timeout: $timeout');

    await super.disconnect();
    unawaited(_reconnect());
  }

  @override
  void onPingRequested() {
    _logger.d(() => '[onPingRequested] no args');
    sendPing();
  }

  @override
  void onNetworkDisconnected() {
    _logger.i(() => '[onNetworkDisconnected] no args');
  }

  @override
  void onNetworkConnected() {
    _logger.i(() => '[onNetworkConnected] no args');
  }
}
