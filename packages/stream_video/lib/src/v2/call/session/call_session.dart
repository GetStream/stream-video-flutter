import 'dart:convert';

import '../../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;

import '../../../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart'
    as rpc;
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import '../../../../protobuf/video/coordinator/edge_v1/edge.pb.dart' as edge;
import '../../../core/utils.dart';
import '../../../disposable.dart';
import '../../../latency_service/latency.dart';
import '../../../logger/stream_logger.dart';
import '../../../sfu-client/sfu_client.dart';
import '../../action/user_action.dart';
import '../../call_state_manager.dart';
import '../../coordinator/coordinator_client.dart';
import '../../coordinator/ws/coordinator_ws.dart';
import '../../errors/video_error.dart';
import '../../errors/video_error_composer.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../sfu/data/models/sfu_call_state.dart';
import '../../sfu/data/models/sfu_model_mapper_extensions.dart';
import '../../sfu/data/models/sfu_model_parser.dart';
import '../../sfu/sfu_client.dart';
import '../../sfu/sfu_client_impl.dart';
import '../../sfu/ws/sfu_event_listener.dart';
import '../../sfu/ws/sfu_ws.dart';
import '../../shared_emitter.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../utils/result_converters.dart';
import '../../webrtc/media/audio_constraints.dart';
import '../../webrtc/media/camera_constraints.dart';
import '../../webrtc/media/screen_share_constraints.dart';
import '../../webrtc/model/rtc_tracks_info.dart';
import '../../webrtc/peer_connection.dart';
import '../../webrtc/peer_type.dart';
import '../../webrtc/rtc_manager.dart';
import '../../webrtc/rtc_manager_factory.dart';
import '../../webrtc/rtc_track.dart';
import 'call_session_config.dart';

class CallSession extends SfuEventListener with Disposable {
  CallSession({
    required this.currentUserId,
    required this.callCid,
    required this.sessionId,
    required this.config,
    required this.stateManager,
  })  : sfuClient = SfuClientImpl(
          baseUrl: config.sfuUrl,
          authToken: config.sfuToken,
        ),
        sfuWS = SfuWebSocket(
          sfuUrl: config.sfuUrl,
          sessionId: sessionId,
        ),
        rtcManagerFactory = RtcManagerFactory(
          sessionId: sessionId,
          callCid: callCid,
          configuration: config.rtcConfig,
        );

  final _logger = taggedLogger(tag: 'SV:CallSession');

  bool _established = false;

  final String currentUserId;
  final String callCid;
  final String sessionId;
  final CallSessionConfig config;
  final CallStateManager stateManager;
  final SfuClientV2 sfuClient;
  final SfuWebSocket sfuWS;
  final RtcManagerFactory rtcManagerFactory;
  late RtcManager rtcManager;

  SharedEmitter<SfuEventV2> get events => sfuWS.events;

  Future<Result<None>> start() async {
    try {
      sfuWS.addEventListener(this);
      await sfuWS.connect();
      final genericSdp = await RtcManager.getGenericSdp();

      sfuWS.send(
        sfu_events.SfuRequest(
          joinRequest: sfu_events.JoinRequest(
            token: config.sfuToken,
            sessionId: sessionId,
            subscriberSdp: genericSdp,
          ),
        ),
      );

      final event = await sfuWS.events.waitFor<SfuJoinResponseEvent>(
        timeLimit: const Duration(seconds: 30),
      );
      final localParticipant = event.callState.participants.firstWhere(
        (it) => it.userId == currentUserId,
      );
      final localTrackId = localParticipant.trackLookupPrefix;

      rtcManager = await rtcManagerFactory.makeRtcManager(localTrackId)
        ..onLocalIceCandidate = _onLocalIceCandidate
        ..onPublisherNegotiationNeeded = _onPublisherNegotiationNeeded;

      return None().toSuccess();
    } catch (e, stk) {
      _logger.e(() => '[establish] failed: $e');
      return VideoErrors.compose(e, stk).toFailure();
    }
  }

  Future<void> dispose() async {
    sfuWS.removeEventListener(this);
    await sfuWS.disconnect();
    await rtcManager.dispose();
    return await super.dispose();
  }

  @override
  void onSfuError(VideoError error) {
    // TODO: implement onError
  }

  @override
  void onSfuEvent(SfuEventV2 event) async {
    await stateManager.onSfuEvent(event);
    if (event is SfuSubscriberOfferEvent) {
      await _onSubscriberOffer(event);
    } else if (event is SfuIceTrickleEvent) {
      await _onRemoteIceCandidate(event);
    }
  }

  Future<void> _onSubscriberOffer(SfuSubscriberOfferEvent event) async {
    final offerSdp = event.sdp;
    _logger.i(() => '[onSfuSubscriberOfferEvent] event: $event');
    final result = await rtcManager.onSubscriberOffer(offerSdp);
    if (result is! Success<String>) {
      return;
    }
    final answerSdp = result.data;

    await sfuClient.sendAnswer(
      sfu.SendAnswerRequest(
        sdp: answerSdp,
        peerType: sfu_models.PeerType.PEER_TYPE_SUBSCRIBER,
      ),
    );
  }

  Future<void> _onRemoteIceCandidate(SfuIceTrickleEvent event) async {
    _logger.d(() => '[onRemoteIceCandidate] event: $event');
    rtcManager.onRemoteIceCandidate(
      peerType: event.peerType,
      iceCandidate: event.iceCandidate,
    );
  }

  void _onLocalIceCandidate(
    StreamPeerConnection pc,
    rtc.RTCIceCandidate candidate,
  ) {
    _logger.d(
      () => '[onLocalIceCandidate] type: ${pc.type}, candidate: $candidate',
    );

    final encodedIceCandidate = json.encode(candidate.toMap());
    final peerType = pc.type == StreamPeerType.publisher
        ? sfu_models.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED
        : sfu_models.PeerType.PEER_TYPE_SUBSCRIBER;

    sfuClient.sendIceCandidate(
      sfu_models.ICETrickle(
        peerType: peerType,
        sessionId: sessionId,
        iceCandidate: encodedIceCandidate,
      ),
    );
  }

  Future<void> _onPublisherNegotiationNeeded(StreamPeerConnection pc) async {
    _logger.d(
      () => '[onPubNegotiationNeeded] type: ${pc.type}',
    );

    final offer = await pc.createOffer();
    if (offer is! Success<rtc.RTCSessionDescription>) return;

    final tracksInfo = await rtcManager.getPublisherTracks();
    _logger.v(() => '[onPubNegotiationNeeded] tracksInfo: $tracksInfo');

    final pubResult = await sfuClient.setPublisher(
      sfu.SetPublisherRequest(
        sdp: offer.data.sdp,
        tracks: tracksInfo.toDTO(),
      ),
    );
    if (pubResult is! Success<sfu.SetPublisherResponse>) {
      _logger.w(
        () => '[onPubNegotiationNeeded] #setPublisher; failed: $pubResult',
      );
      return;
    }
    final ansResult = await pc.setRemoteAnswer(pubResult.data.sdp);
    if (ansResult is! Success<void>) {
      _logger.w(
        () => '[onPubNegotiationNeeded] #setRemoteAnswer; failed: $ansResult',
      );
    }
  }

  RtcTrack? getTrack(String trackId) {
    return rtcManager.getTrack(trackId);
  }

  @override
  Future<Result<None>> apply(UpdateCall action) async {
    return None().toSuccess();
  }
}

extension RtcTracksInfoMapper on RtcTracksInfo {
  List<sfu_models.TrackInfo> toDTO() {
    return trackInfoList.map((info) {
      final trackType = SfuTrackTypeParser.parseRtcName(info.trackType).toDTO();
      return sfu_models.TrackInfo(
        trackId: info.trackId,
        trackType: trackType,
        layers: info.layers?.map((layer) {
          return sfu_models.VideoLayer(
            rid: layer.rid,
            videoDimension: sfu_models.VideoDimension(
              width: layer.videoDimension?.width,
              height: layer.videoDimension?.height,
            ),
            bitrate: layer.bitrate,
          );
        }).toList(),
      );
    }).toList();
  }
}
