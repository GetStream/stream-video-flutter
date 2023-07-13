import 'dart:async';

import '../../../composed_version.dart';
import '../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../errors/video_error_composer.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../logger/stream_log.dart';
import '../../shared_emitter.dart';
import '../../types/other.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../ws/health/health_monitor.dart';
import '../../ws/ws.dart';
import '../data/events/sfu_event_mapper_extensions.dart';
import '../data/events/sfu_events.dart';

const _tag = 'SV:Sfu-WS';

class SfuWebSocket extends StreamWebSocket
    with ConnectionStateMixin
    implements HealthListener {
  factory SfuWebSocket({
    required int sessionSeq,
    required String sessionId,
    required String sfuUrl,
    required String sfuWsEndpoint,
    Iterable<String>? protocols,
  }) {
    final tag = '$_tag-$sessionSeq';
    streamLog.i(tag, () => '<factory> sessionId: $sessionId');
    final sfuUri = Uri.parse(sfuUrl);
    streamLog.i(tag, () => '<factory> sfuUri: $sfuUri');
    final String wsEndpoint;
    if (sfuUri.host.startsWith('localhost') ||
        sfuUri.host.startsWith('127.0.0.1') ||
        sfuUri.host.startsWith('192.')) {
      wsEndpoint = 'ws://${sfuUri.host}:3031/ws';
    } else {
      wsEndpoint = sfuUri
          .replace(
            scheme: 'wss',
            path: '/ws',
          )
          .toString();
    }
    final finalWsEndpoint =
        '$sfuWsEndpoint?X-Stream-Client=$streamClientVersion';
    streamLog.i(tag, () => '<factory> wsEndpoint: $wsEndpoint');
    streamLog.i(tag, () => '<factory> sfuWsEndpoint: $sfuWsEndpoint');
    streamLog.i(tag, () => '<factory> finalWsEndpoint: $finalWsEndpoint');
    return SfuWebSocket._(
      finalWsEndpoint,
      protocols: protocols,
      sessionSeq: sessionSeq,
      sessionId: sessionId,
    );
  }

  /// TODO
  SfuWebSocket._(
    String url, {
    Iterable<String>? protocols,
    required this.sessionSeq,
    required this.sessionId,
  }) : super(url, protocols: protocols, tag: '$_tag-$sessionSeq') {
    _logger.i(() => '<init> sessionId: $sessionId');

    onConnectionStateUpdated = (it) {};
  }

  late final _logger = taggedLogger(tag: '$_tag-$sessionSeq');

  late final HealthMonitor healthMonitor = HealthMonitorImpl('Sfu', this);

  final int sessionSeq;
  final String sessionId;

  bool _manuallyClosed = false;

  SharedEmitter<SfuEvent> get events => _events;
  final _events = MutableSharedEmitterImpl<SfuEvent>();

  @override
  Future<Result<None>> connect() {
    _logger.i(() => '[connect] connectionState: $connectionState');
    connectionState = ConnectionState.connecting;
    healthMonitor.start();
    return super.connect();
  }

  @override
  void onOpen() {
    _logger.i(() => '[onOpen] url: $url');
    connectionState = ConnectionState.connected;
    healthMonitor.onSocketOpen();

    _events.emit(SfuSocketConnected(sessionId: sessionId, url: url));
  }

  @override
  void onError(Object error, [StackTrace? stackTrace]) {
    _logger.w(() => '[onError] error: $error');
    healthMonitor.onSocketError(error);

    _events.emit(
      SfuSocketFailed(
        sessionId: sessionId,
        url: url,
        error: VideoErrors.compose(error),
      ),
    );
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
          reason: DisconnectionReason(
            closeCode: closeCode,
            closeReason: closeReason,
          )),
    );
  }

  @override
  Future<Result<None>> disconnect([int? closeCode, String? closeReason]) async {
    _logger.i(
      () => '[disconnect] closeCode: $closeCode, closeReason: $closeReason',
    );
    if (connectionState == ConnectionState.disconnected) {
      _logger.w(() => '[disconnect] rejected (already disconnected)');
      return const Result.success(none);
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

  @override
  Future<void> onPongTimeout(Duration timeout) async {
    _logger.d(() => '[onPongTimeout] timeout: $timeout');

    await super.disconnect();
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
