import 'dart:async';

import '../../../globals.dart';
import '../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../../stream_video.dart';
import '../../errors/video_error_composer.dart';
import '../../ws/ws.dart' show StreamWebSocketCloseCode;
import '../data/events/sfu_events.dart';
import 'sfu_message_codec.dart';

const _tag = 'SV:Sfu-WS';

class SfuWebSocket {
  factory SfuWebSocket({
    required int sessionSeq,
    required String sessionId,
    required String cid,
    required String userId,
    required String apiKey,
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
        '$sfuWsEndpoint?X-Stream-Client=$xStreamClientHeader&attempt=${++sessionSeq}&cid=$cid&user_id=$userId&api_key=$apiKey&user_session_id=$sessionId';

    streamLog.i(tag, () => '<factory> wsEndpoint: $wsEndpoint');
    streamLog.i(tag, () => '<factory> sfuWsEndpoint: $sfuWsEndpoint');
    streamLog.i(tag, () => '<factory> finalWsEndpoint: $finalWsEndpoint');

    return SfuWebSocket._(
      sessionSeq: sessionSeq,
      sessionId: sessionId,
      url: finalWsEndpoint,
      protocols: protocols,
    );
  }

  SfuWebSocket._({
    required this.sessionSeq,
    required this.sessionId,
    required String url,
    Iterable<String>? protocols,
  }) {
    _logger.i(() => '<init> sessionId: $sessionId');
    _client = StreamWebSocketClient(
      options: WebSocketOptions(url: url, protocols: protocols),
      messageCodec: const SfuMessageCodec(),
      pingRequestBuilder: ([_]) => SfuWsRequest(
        sfu_events.SfuRequest(
          healthCheckRequest: sfu_events.HealthCheckRequest(),
        ),
      ),
    );
    _client.connectionState.listen(_onConnectionStateChanged);
    _client.events.listen(_onWsEvent);
  }

  late final _logger = taggedLogger(tag: '$_tag-$sessionSeq');

  final int sessionSeq;
  final String sessionId;

  late final StreamWebSocketClient _client;
  String get url => _client.options.url;

  SharedEmitter<SfuEvent> get events => _events;
  final _events = MutableSharedEmitter<SfuEvent>();

  bool get isConnected => _client.connectionState.value.isConnected;

  Future<Result<None>> connect() async {
    _logger.i(
      () => '[connect] connectionState: ${_client.connectionState.value}',
    );
    await _client.connect();
    return const Result.success(none);
  }

  Future<Result<None>> disconnect([int? closeCode, String? closeReason]) async {
    _logger.i(
      () => '[disconnect] closeCode: $closeCode, closeReason: $closeReason',
    );
    if (_client.connectionState.value is Disconnected) {
      _logger.w(() => '[disconnect] rejected (already disconnected)');
      return const Result.success(none);
    }
    await _client.disconnect(
      closeCode: closeCode != null
          ? CloseCode(closeCode)
          : CloseCode.normalClosure,
      source: closeCode != null
          ? const DisconnectionSource.systemInitiated()
          : const DisconnectionSource.userInitiated(),
    );
    return const Result.success(none);
  }

  Future<Result<None>> recreate() async {
    _logger.i(() => '[recreate] no args');
    await _client.disconnect(
      closeCode: CloseCode(StreamWebSocketCloseCode.disposeOldSocket.value),
      source: const DisconnectionSource.systemInitiated(),
    );

    // disconnect() uses unawaited engine.close() internally
    // wait for Disconnected with timeout
    await _client.connectionState
        .firstWhere((s) => s is Disconnected)
        .timeout(const Duration(seconds: 10))
        .catchError((_) => _client.connectionState.value);

    await _client.connect();
    return const Result.success(none);
  }

  void leave({String? sessionId, String? reason}) {
    _logger.d(() => '[leave] no args');
    send(
      sfu_events.SfuRequest(
        leaveCallRequest: sfu_events.LeaveCallRequest(
          sessionId: sessionId,
          reason: reason,
        ),
      ),
    );
  }

  void sendPing() {
    _logger.v(() => '[sendPing] no args');
    send(
      sfu_events.SfuRequest(
        healthCheckRequest: sfu_events.HealthCheckRequest(),
      ),
    );
  }

  void send(sfu_events.SfuRequest message) {
    _logger.v(() => '[send] message: $message');
    _client.send(SfuWsRequest(message));
  }

  void _onWsEvent(WsEvent wsEvent) {
    if (wsEvent is! SfuWsEvent) return;
    _events.emit(wsEvent.event);
  }

  void _onConnectionStateChanged(WebSocketConnectionState state) {
    _logger.d(() => '[onConnectionStateChanged] state: $state');
    switch (state) {
      case Authenticating():
        _events.emit(SfuSocketConnected(sessionId: sessionId, url: url));
      case Disconnected(:final source):
        _handleDisconnected(source);
      default:
        break;
    }
  }

  void _handleDisconnected(DisconnectionSource source) {
    switch (source) {
      case ServerInitiated(:final error?):
        if (error.error != null) {
          _events.emit(
            SfuSocketFailed(
              sessionId: sessionId,
              url: url,
              error: VideoErrors.compose(error.error),
            ),
          );
        } else {
          _events.emit(
            SfuSocketDisconnected(
              sessionId: sessionId,
              url: url,
              reason: DisconnectionReason(
                closeCode: error.code != 0 ? error.code : null,
                closeReason: error.reason != 'Unknown' ? error.reason : null,
              ),
            ),
          );
        }
      case UnHealthyConnection():
        _events.emit(
          SfuSocketDisconnected(
            sessionId: sessionId,
            url: url,
            reason: const DisconnectionReason(
              closeReason: 'Unhealthy connection',
            ),
          ),
        );
      case UserInitiated() || SystemInitiated() || ServerInitiated():
        break; // manual close or recreate — suppress
    }
  }
}
