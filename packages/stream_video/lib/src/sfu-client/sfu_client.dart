import 'dart:async';

import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart';
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart';
import 'package:stream_video/src/core/utils/event_emitter.dart';
import 'package:stream_video/src/sfu-client/rpc/signal.dart';
import 'package:stream_video/src/sfu-client/rpc/signal_ws.dart';
import 'package:stream_video/src/types/other.dart';
import 'package:uuid/uuid.dart';

const localUrl = 'http://192.168.1.6:3031/twirp';

class SfuClient with EventEmitterMixin<SfuEvent> {
  ///
  SfuClient({
    String? sessionId,
    required String url,
    required String token,
  }) {
    // url = localUrl;

    this.sessionId = sessionId ??= const Uuid().v4();

    rpc = Signal(
      baseUrl: url,
      authToken: token,
    );

    // TODO: remove once everything is deployed
    var wsEndpoint = 'ws://$url:3031/ws';
    if (!['localhost', '127.0.0.1'].contains(url)) {
      final sfuUrl = Uri.parse(url);
      wsEndpoint = sfuUrl
          .replace(
            scheme: 'wss',
            path: '/ws',
          )
          .toString();
    }

    print(wsEndpoint);

    _signal = SignalWebSocket(
      wsEndpoint,
      sessionId: sessionId,
    )..listen((data) {
        final event = data.whichEventPayload();
        emitter.emit(event.name, data);
      });
  }

  late final String sessionId;
  late final Signal rpc;
  late final SignalWebSocket _signal;

  /// Connection state of the [Call].
  ConnectionState get connectionState => _signal.connectionState;

  // set onConnectionStateUpdated(OnConnectionStateUpdated handler) {
  //   return _signal.onConnectionStateUpdated = handler;
  // }

  Future<void> connect() async {
    return _signal.connect();
  }

  Future<void> disconnect() async {
    return _signal.disconnect();
  }

  Future<UpdateMuteStateResponse> updateAudioMuteState({
    bool muted = false,
  }) async {
    final response = await rpc.updateMuteState(
      UpdateMuteStateRequest(
        sessionId: sessionId,
        audioMuteChanged: AudioMuteChanged(
          muted: muted,
        ),
      ),
    );

    return response;
  }

  Future<UpdateMuteStateResponse> updateVideoMuteState({
    bool muted = false,
  }) async {
    final response = await rpc.updateMuteState(
      UpdateMuteStateRequest(
        sessionId: sessionId,
        videoMuteChanged: VideoMuteChanged(
          muted: muted,
        ),
      ),
    );

    return response;
  }

  Future<UpdateSubscriptionsResponse> updateSubscriptions({
    required Map<String, VideoDimension> subscriptions,
  }) async {
    final response = await rpc.updateSubscriptions(
      UpdateSubscriptionsRequest(
        sessionId: sessionId,
        subscriptions: subscriptions,
      ),
    );

    return response;
  }

  Future<SetPublisherResponse> setPublisher({
    required String sdp,
  }) async {
    final response = await rpc.setPublisher(
      SetPublisherRequest(
        sdp: sdp,
        sessionId: sessionId,
      ),
    );

    return response;
  }

  Future<SendAnswerResponse> sendAnswer({
    required String sdp,
    required PeerType peerType,
  }) async {
    final response = await rpc.sendAnswer(
      SendAnswerRequest(
        sdp: sdp,
        peerType: peerType,
        sessionId: sessionId,
      ),
    );

    return response;
  }

  Future<ICETrickleResponse> iceTrickle({
    required PeerType peerType,
    required String iceCandidate,
  }) async {
    final response = await rpc.iceTrickle(
      ICETrickle(
        peerType: peerType,
        sessionId: sessionId,
        iceCandidate: iceCandidate,
      ),
    );

    return response;
  }

  void send({
    required SfuRequest request,
    bool enqueueIfConnecting = true,
  }) {
    return _signal.send(
      request,
      enqueueIfConnecting: enqueueIfConnecting,
    );
  }
}
