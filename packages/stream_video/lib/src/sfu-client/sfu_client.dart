import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as signal;
import '../event_emitter.dart';
import '../events.dart';
import '../types/other.dart';
import 'rpc/signal_client.dart';
import 'rpc/signal_ws.dart';

const _localUrl = 'http://192.168.1.7:3031/twirp';

class SfuClient with EventEmittable<SfuEvent> {
  ///
  SfuClient({
    String? sessionId,
    required String url,
    required String token,
  }) {
    // url = _localUrl;

    this.sessionId = sessionId ??= const Uuid().v4();

    rpc = SignalClient(
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
    )..events.listen(events.emit);
  }

  late final String sessionId;
  late final SignalClient rpc;
  late final SignalWebSocket _signal;

  /// Connection state of the [Call].
  ConnectionState get connectionState => _signal.connectionState;

  Future<void> connect() async {
    return _signal.connect();
  }

  Future<void> disconnect() async {
    return _signal.disconnect();
  }

  Future<signal.UpdateMuteStatesResponse> updateMuteStates({
    required Iterable<signal.TrackMuteState> muteStates,
  }) async {
    print('updateMuteStates: $muteStates');
    final response = await rpc.updateMuteStates(
      signal.UpdateMuteStatesRequest(
        sessionId: sessionId,
        muteStates: muteStates,
      ),
    );

    return response;
  }

  Future<signal.UpdateSubscriptionsResponse> updateSubscriptions({
    required Iterable<signal.TrackSubscriptionDetails>? tracks,
  }) async {
    final response = await rpc.updateSubscriptions(
      signal.UpdateSubscriptionsRequest(
        sessionId: sessionId,
        tracks: tracks,
      ),
    );

    return response;
  }

  Future<signal.SetPublisherResponse> setPublisher({
    required String sdp,
    Iterable<sfu_models.TrackInfo>? tracks,
  }) async {
    final response = await rpc.setPublisher(
      signal.SetPublisherRequest(
        sdp: sdp,
        sessionId: sessionId,
        tracks: tracks,
      ),
    );

    return response;
  }

  Future<signal.SendAnswerResponse> sendAnswer({
    required String sdp,
    required sfu_models.PeerType peerType,
  }) async {
    final response = await rpc.sendAnswer(
      signal.SendAnswerRequest(
        sdp: sdp,
        peerType: peerType,
        sessionId: sessionId,
      ),
    );

    return response;
  }

  Future<signal.ICETrickleResponse> iceTrickle({
    required sfu_models.PeerType peerType,
    required String iceCandidate,
  }) async {
    final response = await rpc.iceTrickle(
      sfu_models.ICETrickle(
        peerType: peerType,
        sessionId: sessionId,
        iceCandidate: iceCandidate,
      ),
    );

    return response;
  }

  void send({
    required sfu_events.SfuRequest request,
    bool enqueueIfConnecting = true,
  }) {
    return _signal.send(
      request,
      enqueueIfConnecting: enqueueIfConnecting,
    );
  }
}
