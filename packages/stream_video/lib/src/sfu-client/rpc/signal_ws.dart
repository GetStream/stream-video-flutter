import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import '../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../core/video_error.dart';
import '../../event_emitter.dart';
import '../../events.dart';
import '../../internal/events.dart';
import '../../logger/logger.dart';
import '../../types/other.dart';
import '../../ws/keep_alive.dart';
import '../../ws/ws.dart';

class SignalWebSocket extends StreamWebSocket
    with KeepAlive, ConnectionStateMixin, EventEmittable<SfuEvent> {
  SignalWebSocket(
    super.url, {
    super.protocols,
    required this.sessionId,
  });

  final String sessionId;

  final _requestQueue = Queue<sfu_events.SfuRequest>();

  @override
  OnConnectionStateUpdated get onConnectionStateUpdated {
    void onConnectionStateUpdated(ConnectionStateUpdatedEvent state) {
      if (state.didConnected) {
        _sendQueuedRequests();
      }
      // Emit connection state updated event
      events.emit(state);
    }

    return onConnectionStateUpdated;
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
    events.on<SFUJoinResponseEvent>(limit: 1, (data) {
      logger.info('Starting signal ping pong timer');
      startPingPong();
    });
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
    sfu_events.SfuEvent? event;
    try {
      event = sfu_events.SfuEvent.fromBuffer(message);
    } catch (e, stk) {
      logger.warning('Error parsing an event: $e');
      logger.warning('Stack trace: $stk');
    }

    if (event == null) return;

    final eventType = event.whichEventPayload();
    logger.info('Signal event received: $eventType');

    if (eventType == sfu_events.SfuEvent_EventPayload.healthCheckResponse) {
      _handleHealthCheckEvent(event.healthCheckResponse);
    }

    return events.emitSignalEventFromSfu(event);
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
    return send(
      sfu_events.SfuRequest(
        healthCheckRequest: healthCheck,
      ),
    );
  }

  int _reconnectAttempt = 0;

  Future<void> _reconnect() async {
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

extension on EventEmitter<SfuEvent> {
  void emitSignalEventFromSfu(sfu_events.SfuEvent event) {
    final eventType = event.whichEventPayload();
    switch (eventType) {
      case sfu_events.SfuEvent_EventPayload.joinResponse:
        final joinResponse = event.joinResponse;
        return emit(SFUJoinResponseEvent(response: joinResponse));
      case sfu_events.SfuEvent_EventPayload.subscriberOffer:
        final subscriberOffer = event.subscriberOffer;
        return emit(SFUSubscriberOfferEvent(offer: subscriberOffer));
      case sfu_events.SfuEvent_EventPayload.publisherAnswer:
        final publisherAnswer = event.publisherAnswer;
        return emit(SFUPublisherAnswerEvent(answer: publisherAnswer));
      case sfu_events.SfuEvent_EventPayload.connectionQualityChanged:
        final connectionQualityChanged = event.connectionQualityChanged;
        return emit(
          SFUConnectionQualityChangedEvent(
            connectionQualityChanged: connectionQualityChanged,
          ),
        );
      case sfu_events.SfuEvent_EventPayload.audioLevelChanged:
        final audioLevelChanged = event.audioLevelChanged;
        return emit(
          SFUAudioLevelChangedEvent(
            audioLevelChanged: audioLevelChanged,
          ),
        );
      case sfu_events.SfuEvent_EventPayload.iceTrickle:
        final iceTrickle = event.iceTrickle;
        return emit(SFUIceTrickleEvent(iceTrickle: iceTrickle));
      case sfu_events.SfuEvent_EventPayload.changePublishQuality:
        final changePublishQuality = event.changePublishQuality;
        return emit(
          SFUChangePublishQualityEvent(
            changePublishQuality: changePublishQuality,
          ),
        );
      case sfu_events.SfuEvent_EventPayload.participantJoined:
        final participantJoined = event.participantJoined;
        return emit(
          SFUParticipantJoinedEvent(
            participantJoined: participantJoined,
          ),
        );
      case sfu_events.SfuEvent_EventPayload.participantLeft:
        final participantLeft = event.participantLeft;
        return emit(
          SFUParticipantLeftEvent(
            participantLeft: participantLeft,
          ),
        );
      case sfu_events.SfuEvent_EventPayload.dominantSpeakerChanged:
        final dominantSpeakerChanged = event.dominantSpeakerChanged;
        return emit(
          SFUDominantSpeakerChangedEvent(
            dominantSpeakerChanged: dominantSpeakerChanged,
          ),
        );
      case sfu_events.SfuEvent_EventPayload.trackPublished:
        final trackPublished = event.trackPublished;
        return emit(SFUTrackPublishedEvent(trackPublished: trackPublished));
      case sfu_events.SfuEvent_EventPayload.trackUnpublished:
        final trackUnpublished = event.trackUnpublished;
        return emit(
          SFUTrackUnpublishedEvent(
            trackUnpublished: trackUnpublished,
          ),
        );
      case sfu_events.SfuEvent_EventPayload.healthCheckResponse:
        final healthCheckResponse = event.healthCheckResponse;
        return emit(
          SFUHealthCheckResponseEvent(
            healthCheckResponse: healthCheckResponse,
          ),
        );
      case sfu_events.SfuEvent_EventPayload.error:
        final error = event.error;
        return emit(SFUErrorEvent(error: error));
      case sfu_events.SfuEvent_EventPayload.notSet:
        logger.info('Received an signal event with no payload');
        break;
    }
  }
}
