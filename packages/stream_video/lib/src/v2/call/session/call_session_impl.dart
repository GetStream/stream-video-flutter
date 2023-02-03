import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../../../stream_video.dart';
import '../../../internal/events.dart';
import '../../../logger/stream_logger.dart';
import '../../action/call_control_action.dart';
import '../../action/sfu_action.dart';
import '../../call_state_manager.dart';
import '../../errors/video_error.dart';
import '../../errors/video_error_composer.dart';
import '../../model/call_cid.dart';
import '../../model/call_track_state.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../sfu/data/models/sfu_model_mapper_extensions.dart';
import '../../sfu/data/models/sfu_subscription_details.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../../sfu/sfu_client.dart';
import '../../sfu/sfu_client_impl.dart';
import '../../sfu/ws/sfu_event_listener.dart';
import '../../sfu/ws/sfu_ws.dart';
import '../../shared_emitter.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../utils/subscriptions.dart';
import '../../webrtc/media/constraints/camera_position.dart';
import '../../webrtc/model/rtc_model_mapper_extensions.dart';
import '../../webrtc/model/rtc_tracks_info.dart';
import '../../webrtc/peer_connection.dart';
import '../../webrtc/peer_type.dart';
import '../../webrtc/rtc_manager.dart';
import '../../webrtc/rtc_manager_factory.dart';
import '../../webrtc/rtc_track.dart';
import 'call_session.dart';
import 'call_session_config.dart';

const _tag = 'SV:CallSession';

int _sessionSeq = 1;

class CallSessionImpl extends CallSession implements SfuEventListener {
  CallSessionImpl({
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
        ) {
    _logger.i(() => '<init> callCid: $callCid, sessionId: $sessionId');
  }

  final _logger = taggedLogger(tag: '$_tag-${_sessionSeq++}');

  final StreamCallCid callCid;
  @override
  final String sessionId;
  final CallSessionConfig config;
  final CallStateManager stateManager;
  final SfuClientV2 sfuClient;
  final SfuWebSocket sfuWS;
  final RtcManagerFactory rtcManagerFactory;
  RtcManager? rtcManager;

  @override
  SharedEmitter<SfuEventV2> get events => sfuWS.events;

  @override
  Future<Result<None>> start() async {
    try {
      _logger.d(() => '[start] no args');
      sfuWS.addEventListener(this);
      await sfuWS.connect();
      _logger.v(() => '[start] sfu connected');
      final genericSdp = await RtcManager.getGenericSdp();
      _logger.v(() => '[start] genericSdp.len: ${genericSdp.length}');
      sfuWS.send(
        sfu_events.SfuRequest(
          joinRequest: sfu_events.JoinRequest(
            token: config.sfuToken,
            sessionId: sessionId,
            subscriberSdp: genericSdp,
          ),
        ),
      );
      _logger.v(() => '[start] wait for SfuJoinResponseEvent');
      final event = await sfuWS.events.waitFor<SfuJoinResponseEvent>(
        timeLimit: const Duration(seconds: 30),
      );

      _logger.v(() => '[start] sfu joined: $event');
      final currentUserId = stateManager.state.value.currentUserId;
      final localParticipant = event.callState.participants.firstWhere(
        (it) => it.userId == currentUserId,
      );
      final localTrackId = localParticipant.trackLookupPrefix;
      _logger.v(() => '[start] localTrackId: $localTrackId');
      rtcManager = await rtcManagerFactory.makeRtcManager(
        publisherId: localTrackId,
      )
        ..onPublisherIceCandidate = _onLocalIceCandidate
        ..onSubscriberIceCandidate = _onLocalIceCandidate
        ..onPublisherTrackMuted = _onPublisherTrackMuted
        ..onPublisherNegotiationNeeded = _onPublisherNegotiationNeeded
        ..onSubscriberTrackReceived = _onSubscriberTrackReceived;

      _logger.v(() => '[start] completed');
      return Result.success(None());
    } catch (e, stk) {
      _logger.e(() => '[start] failed: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<void> dispose() async {
    _logger.d(() => '[dispose] no args');
    sfuWS.removeEventListener(this);
    await sfuWS.disconnect();
    await rtcManager?.dispose();
    rtcManager = null;
    return await super.dispose();
  }

  @override
  RtcTrack? getTrack(String trackIdPrefix, SfuTrackType trackType) {
    final trackId = '$trackIdPrefix:$trackType';
    return rtcManager?.getTrack(trackId);
  }

  @override
  List<RtcTrack> getTracks(String trackIdPrefix) {
    return [...?rtcManager?.getTracks(trackIdPrefix)];
  }

  @override
  Future<Result<None>> apply(SessionControlAction action) async {
    _logger.d(() => '[apply] action: $action');
    if (action is SetCameraEnabled) {
      return _onSetCameraEnabled(action.enabled);
    } else if (action is SetMicrophoneEnabled) {
      return _onSetMicrophoneEnabled(action.enabled);
    } else if (action is SetScreenShareEnabled) {
      return _onSetScreenShareEnabled(action.enabled);
    } else if (action is SetCameraPosition) {
      return _onSetCameraPosition(action.cameraPosition);
    } else if (action is UpdateSubscriptions) {
      return _updateSubscriptions(action.actions);
    } else if (action is UpdateSubscription) {
      return _updateSubscriptions([action]);
    } else if (action is RemoveSubscription) {
      return _updateSubscriptions([action]);
    } else if (action is SetSubscription) {
      return _setSubscriptions([action]);
    } else if (action is SetSubscriptions) {
      return _setSubscriptions(action.actions);
    }
    return Result.error('Action not supported: $action');
  }

  @override
  Future<void> onSfuError(VideoError error) async {
    _logger.e(() => '[onSfuError] error: $error');
    // TODO: implement onError
  }

  @override
  Future<void> onSfuEvent(SfuEventV2 event) async {
    _logger.v(() => '[onSfuEvent] event: $event');
    if (event is SfuSubscriberOfferEvent) {
      await _onSubscriberOffer(event);
    } else if (event is SfuIceTrickleEvent) {
      await _onRemoteIceCandidate(event);
    }
    await stateManager.onSfuEvent(event);
  }

  Future<void> _onSubscriberOffer(SfuSubscriberOfferEvent event) async {
    final offerSdp = event.sdp;
    _logger.i(() => '[onSubscriberOffer] event: $event');
    final answerSdp = await rtcManager?.onSubscriberOffer(offerSdp);
    if (answerSdp == null) {
      _logger.w(() => '[onSubscriberOffer] rejected (answerSdp is null)');
      return;
    }

    final result = await sfuClient.sendAnswer(
      sfu.SendAnswerRequest(
        sdp: answerSdp,
        sessionId: sessionId,
        peerType: sfu_models.PeerType.PEER_TYPE_SUBSCRIBER,
      ),
    );
    _logger.v(() => '[onSubscriberOffer] result: $result');
  }

  void _onPublisherTrackMuted(RtcLocalTrack track, bool muted) {
    _logger.d(() => '[onPublisherTrackMuted] track: $track');

    sfuClient.updateMuteState(
      sfu.UpdateMuteStatesRequest(
        sessionId: sessionId,
        muteStates: [
          sfu.TrackMuteState(
            trackType: track.trackType.toDTO(),
            muted: muted,
          )
        ],
      ),
    );
  }

  Future<void> _onRemoteIceCandidate(SfuIceTrickleEvent event) async {
    _logger.d(() => '[onRemoteIceCandidate] event: $event');
    final result = await rtcManager?.onRemoteIceCandidate(
      peerType: event.peerType,
      iceCandidate: event.iceCandidate,
    );
    _logger.v(() => '[onRemoteIceCandidate] result: $result');
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

    final result = sfuClient.sendIceCandidate(
      sfu_models.ICETrickle(
        peerType: peerType,
        sessionId: sessionId,
        iceCandidate: encodedIceCandidate,
      ),
    );
    _logger.v(() => '[onLocalIceCandidate] result: $result');
  }

  Future<void> _onPublisherNegotiationNeeded(StreamPeerConnection pc) async {
    _logger.d(
      () => '[onPubNegotiationNeeded] type: ${pc.type}',
    );

    final offer = await pc.createOffer();
    if (offer is! Success<rtc.RTCSessionDescription>) return;

    final tracksInfo = rtcManager?.getPublisherTrackInfos();
    if (tracksInfo == null || tracksInfo.isEmpty) {
      _logger.w(() => '[onPubNegotiationNeeded] rejected(tracksInfo '
          'is null/empty): $tracksInfo');
      return;
    }

    _logger.v(() => '[onPubNegotiationNeeded] tracksInfo: $tracksInfo');

    final pubResult = await sfuClient.setPublisher(
      sfu.SetPublisherRequest(
        sdp: offer.data.sdp,
        sessionId: sessionId,
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

  Future<void> _onSubscriberTrackReceived(
    StreamPeerConnection pc,
    RtcRemoteTrack remoteTrack,
  ) async {
    _logger.d(
      () => '[onSubscriberTrackReceived] remoteTrack: $remoteTrack',
    );
    stateManager.onSubscriberTrackReceived(
      remoteTrack.trackIdPrefix,
      remoteTrack.trackType,
    );
  }

  Future<Result<None>> _setSubscriptions(
    List<SetSubscription> actions,
  ) async {
    final participants = stateManager.state.value.callParticipants;
    _logger.d(() => '[setSubscriptions] actions: $actions');
    final subscriptions = <String, SfuSubscriptionDetails>{};
    final exclude = {SfuTrackType.video, SfuTrackType.screenShare};
    participants.getSubscriptions(subscriptions, exclude);
    _logger.v(() => '[setSubscriptions] source: $subscriptions');
    for (final action in actions) {
      action.getSubscriptions(subscriptions);
    }
    _logger.v(() => '[setSubscriptions] updated: $subscriptions');
    final result = await sfuClient.update(
      sessionId: sessionId,
      subscriptions: subscriptions.values,
    );
    _logger.v(() => '[setSubscriptions] result: $result');
    return result;
  }

  Future<Result<None>> _updateSubscriptions(
    List<SubscriptionAction> actions,
  ) async {
    _logger.d(() => '[updateSubscriptions] actions: $actions');
    final participants = stateManager.state.value.callParticipants;
    final subscriptions = <String, SfuSubscriptionDetails>{};
    participants.getSubscriptions(subscriptions);
    _logger.v(() => '[updateSubscriptions] source: $subscriptions');
    for (final action in actions) {
      if (action is UpdateSubscription) {
        subscriptions[action.trackId] = action.toSubscription();
      } else if (action is RemoveSubscription) {
        subscriptions.remove(action.trackId);
      }
    }
    _logger.v(() => '[updateSubscriptions] updated: $subscriptions');
    final result = await sfuClient.update(
      sessionId: sessionId,
      subscriptions: subscriptions.values,
    );
    _logger.v(() => '[updateSubscriptions] result: $result');
    return result;
  }

  Future<Result<None>> _onSetCameraEnabled(bool enabled) async {
    final track = await rtcManager?.setCameraEnabled(enabled: enabled);
    if (track == null) {
      return Result.error('Unable to enable/disable camera, Track not found');
    }

    return Result.success(None());
  }

  Future<Result<None>> _onSetMicrophoneEnabled(bool enabled) async {
    final track = await rtcManager?.setMicrophoneEnabled(enabled: enabled);
    if (track == null) {
      return Result.error(
        'Unable to enable/disable microphone, Track not found',
      );
    }

    return Result.success(None());
  }

  Future<Result<None>> _onSetScreenShareEnabled(bool enabled) async {
    final track = await rtcManager?.setScreenShareEnabled(enabled: enabled);
    if (track == null) {
      return Result.error(
        'Unable to enable/disable screen-share, Track not found',
      );
    }
    return Result.success(None());
  }

  Future<Result<None>> _onSetCameraPosition(CameraPositionV2 position) async {
    final track = await rtcManager?.setCameraPosition(cameraPosition: position);
    if (track == null) {
      return Result.error('Unable to set camera position, Track not found');
    }

    return Result.success(None());
  }
}

extension RtcTracksInfoMapper on List<RtcTrackInfo> {
  List<sfu_models.TrackInfo> toDTO() {
    return map((info) {
      return sfu_models.TrackInfo(
        trackId: info.trackId,
        trackType: info.trackType?.toDTO(),
        mid: info.mid,
        layers: info.layers?.map((layer) {
          return sfu_models.VideoLayer(
            rid: layer.rid,
            videoDimension: sfu_models.VideoDimension(
              width: layer.videoDimension?.width,
              height: layer.videoDimension?.height,
            ),
            bitrate: layer.bitrate,
          );
        }),
      );
    }).toList();
  }
}

extension on SfuClientV2 {
  Future<Result<None>> update({
    required String sessionId,
    required Iterable<SfuSubscriptionDetails> subscriptions,
  }) async {
    final result = await updateSubscriptions(
      sfu.UpdateSubscriptionsRequest(
        sessionId: sessionId,
        tracks: subscriptions.map(
          (it) => sfu.TrackSubscriptionDetails(
            userId: it.userId,
            sessionId: it.sessionId,
            trackType: it.trackType.toDTO(),
            dimension: it.dimension?.toDTO(),
          ),
        ),
      ),
    );
    if (result is Success<sfu.UpdateSubscriptionsResponse>) {
      if (result.data.hasError()) {
        final error = result.data.error;
        return Result.error('${error.code} - ${error.message}');
      }
    }
    if (result is Failure) {
      return result;
    }
    return Result.success(None());
  }
}

extension on UpdateSubscription {
  SfuSubscriptionDetails toSubscription() {
    return SfuSubscriptionDetails(
      userId: userId,
      sessionId: sessionId,
      trackIdPrefix: trackIdPrefix,
      trackType: trackType,
      dimension: videoDimension,
    );
  }
}

extension on SetSubscription {
  void getSubscriptions(Map<String, SfuSubscriptionDetails> output) {
    trackTypes.forEach((trackType, videoDimension) {
      final trackId = '$trackIdPrefix:$trackType';
      output[trackId] = SfuSubscriptionDetails(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
        dimension: videoDimension,
      );
    });
  }
}

extension on List<CallParticipantStateV2> {
  void getSubscriptions(
    Map<String, SfuSubscriptionDetails> output, [
    Set<SfuTrackType>? exclude,
  ]) {
    for (final participant in this) {
      if (participant.isLocal) continue;
      streamLog.v(
        _tag,
        () => '[getSubscriptions] userId: ${participant.userId}, '
            'published: ${participant.publishedTracks.keys}',
      );
      participant.getSubscriptions(output, exclude);
    }
  }
}

extension on CallParticipantStateV2 {
  void getSubscriptions(
    Map<String, SfuSubscriptionDetails> output, [
    Set<SfuTrackType>? exclude,
  ]) {
    publishedTracks.forEach((trackType, trackState) {
      final atLeastSubscribed = trackState is RemoteTrackState &&
          (trackState.subscribed || trackState.received);
      streamLog.v(
        _tag,
        () => '[getSubscriptions] trackType: $trackType, '
            'trackState: $trackState',
      );
      final shouldExclude = exclude != null && exclude.contains(trackType);
      if (atLeastSubscribed && !shouldExclude) {
        final detail = SfuSubscriptionDetails(
          userId: userId,
          sessionId: sessionId,
          trackIdPrefix: trackIdPrefix,
          trackType: trackType,
          dimension: trackState.videoDimension,
        );
        output[detail.trackId] = detail;
      }
    });
  }
}
