import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../../stream_video.dart';
import '../../call_state_manager.dart';
import '../../errors/video_error.dart';
import '../../errors/video_error_composer.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../sfu/data/models/sfu_model_mapper_extensions.dart';
import '../../sfu/data/models/sfu_subscription_details.dart';
import '../../sfu/sfu_client.dart';
import '../../sfu/sfu_client_impl.dart';
import '../../sfu/ws/sfu_event_listener.dart';
import '../../sfu/ws/sfu_ws.dart';
import '../../shared_emitter.dart';
import '../../utils/none.dart';
import '../../webrtc/model/rtc_model_mapper_extensions.dart';
import '../../webrtc/model/rtc_tracks_info.dart';
import '../../webrtc/model/stats/rtc_printable_stats.dart';
import '../../webrtc/model/stats/rtc_raw_stats.dart';
import '../../webrtc/peer_connection.dart';
import '../../webrtc/rtc_manager.dart';
import '../../webrtc/rtc_manager_factory.dart';
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
  final SfuClient sfuClient;
  final SfuWebSocket sfuWS;
  final RtcManagerFactory rtcManagerFactory;
  RtcManager? rtcManager;

  @override
  SharedEmitter<CallStats> get stats => _stats;
  late final _stats = MutableSharedEmitterImpl<CallStats>();

  @override
  SharedEmitter<SfuEvent> get events => sfuWS.events;

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
        ..onLocalTrackMuted = _onLocalTrackMuted
        ..onLocalTrackPublished = _onLocalTrackPublished
        ..onRenegotiationNeeded = _onRenegotiationNeeded
        ..onRemoteTrackReceived = _onRemoteTrackReceived
        ..onStatsReceived = _onStatsReceived;

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
    await _stats.close();
    sfuWS.removeEventListener(this);
    await sfuWS.disconnect();
    await rtcManager?.dispose();
    rtcManager = null;
    return await super.dispose();
  }

  @override
  Future<Result<None>> setLocalTrack(RtcLocalTrack track) async {
    _logger.d(() => '[setLocalTrack] track: $track');

    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set local track, Call not connected');
    }

    final result = await rtcManager.publishTrack(track);
    return result.map((_) => None());
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
    } else if (action is SetAudioInputDevice) {
      return _onSetAudioInputDevice(action.device);
    } else if (action is SetScreenShareEnabled) {
      return _onSetScreenShareEnabled(action.enabled);
    } else if (action is FlipCamera) {
      return _onFlipCamera();
    } else if (action is SetVideoInputDevice) {
      return _onSetVideoInputDevice(action.device);
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
    } else if (action is SetAudioOutputDevice) {
      return _onSetAudioOutputDevice(action.device);
    }
    return Result.error('Action not supported: $action');
  }

  @override
  Future<void> onSfuError(VideoError error) async {
    _logger.e(() => '[onSfuError] error: $error');
    // TODO: implement onError
  }

  @override
  Future<void> onSfuEvent(SfuEvent event) async {
    _logger.v(() => '[onSfuEvent] event: $event');
    if (event is SfuSubscriberOfferEvent) {
      await _onSubscriberOffer(event);
    } else if (event is SfuIceTrickleEvent) {
      await _onRemoteIceCandidate(event);
    } else if (event is SfuParticipantLeftEvent) {
      await _onParticipantLeft(event);
    } else if (event is SfuTrackPublishedEvent) {
      await _onTrackPublished(event);
    } else if (event is SfuTrackUnpublishedEvent) {
      await _onTrackUnpublished(event);
    }

    return stateManager.onSfuEvent(event);
  }

  Future<void> _onParticipantLeft(SfuParticipantLeftEvent event) async {
    _logger.v(() => '[onParticipantLeft] event: $event');
    final participant = event.participant;
    final trackIdPrefix = participant.trackLookupPrefix;
    await rtcManager?.removeSubscriber(trackIdPrefix);
  }

  Future<Result<RtcTrack>> _getTrackForParticipant(
    String userId,
    String sessionId,
    SfuTrackType trackType,
  ) async {
    bool matchParticipant(CallParticipantState participant) {
      return participant.userId == userId && participant.sessionId == sessionId;
    }

    final callParticipants = stateManager.state.value.callParticipants;
    final participant = callParticipants.firstWhereOrNull(matchParticipant);

    if (participant == null) {
      return Result.error('Participant not found: $userId:$sessionId');
    }

    final trackIdPrefix = participant.trackIdPrefix;
    final track = getTrack(trackIdPrefix, trackType);

    // If the track is not found, return an error.
    if (track == null) {
      return Result.error('Track not found: $trackIdPrefix:$trackType');
    }

    // If the track is found, return it.
    return Result.success(track);
  }

  Future<void> _onTrackPublished(
    SfuTrackPublishedEvent event,
  ) async {
    _logger.v(() => '[onTrackPublished] event: $event');

    final trackResult = await _getTrackForParticipant(
      event.userId,
      event.sessionId,
      event.trackType,
    );

    final track = trackResult.getDataOrNull();
    if (track == null) return;

    // Only start remote tracks. Local tracks are started by the user.
    if (track is! RtcRemoteTrack) return;

    await track.start();
  }

  Future<void> _onTrackUnpublished(
    SfuTrackUnpublishedEvent event,
  ) async {
    _logger.v(() => '[onTrackUnpublished] event: $event');

    final trackResult = await _getTrackForParticipant(
      event.userId,
      event.sessionId,
      event.trackType,
    );

    final track = trackResult.getDataOrNull();
    if (track == null) return;

    // Only stop remote tracks. Local tracks are stopped by the user.
    if (track is! RtcRemoteTrack) return;

    await track.stop();
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

  void _onLocalTrackMuted(RtcLocalTrack track, bool muted) {
    _logger.d(() => '[onPublisherTrackMuted] track: $track');

    // Send a mute state update to the server.
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

  Future<void> _onLocalTrackPublished(RtcLocalTrack track) async {
    _logger.d(() => '[onPublisherTrackPublished] track: $track');

    // Start the track.
    await track.start();

    // If the track is an audioTrack, apply the current audio output device.
    if (track.isAudioTrack) {
      await _applyCurrentAudioOutputDevice();
    }

    // Send a mute state update to the server.
    _onLocalTrackMuted(track, false);
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

  Future<void> _onRenegotiationNeeded(StreamPeerConnection pc) async {
    _logger.d(() => '[negotiate] type: ${pc.type}');

    final offer = await pc.createOffer();

    if (offer is! Success<rtc.RTCSessionDescription>) return;

    final tracksInfo = rtcManager?.getPublisherTrackInfos();
    if (tracksInfo == null || tracksInfo.isEmpty) {
      _logger.w(
        () => '[negotiate] rejected(tracksInfo is null/empty): $tracksInfo',
      );
      return;
    }

    for (final track in tracksInfo) {
      _logger.v(
        () => '[negotiate] track.id: ${track.trackId}, '
            'track.type: ${track.trackType}',
      );
      for (final layer in [...?track.layers]) {
        _logger.v(() => '[negotiate] layer: $layer');
      }
    }

    final pubResult = await sfuClient.setPublisher(
      sfu.SetPublisherRequest(
        sdp: offer.data.sdp,
        sessionId: sessionId,
        tracks: tracksInfo.toDTO(),
      ),
    );
    if (pubResult is! Success<sfu.SetPublisherResponse>) {
      _logger.w(
        () => '[negotiate] #setPublisher; failed: $pubResult',
      );
      return;
    }
    final ansResult = await pc.setRemoteAnswer(pubResult.data.sdp);
    if (ansResult is! Success<void>) {
      _logger.w(
        () => '[negotiate] #setRemoteAnswer; failed: $ansResult',
      );
    }
  }

  Future<void> _onRemoteTrackReceived(
    StreamPeerConnection pc,
    RtcRemoteTrack remoteTrack,
  ) async {
    _logger.d(() => '[onRemoteTrackReceived] remoteTrack: $remoteTrack');

    // Start the track.
    await remoteTrack.start();

    // If the track is an audioTrack, apply the current audio output device.
    if (remoteTrack.isAudioTrack) {
      await _applyCurrentAudioOutputDevice();
    }

    return stateManager.onSubscriberTrackReceived(
      remoteTrack.trackIdPrefix,
      remoteTrack.trackType,
    );
  }

  Future<void> _applyCurrentAudioOutputDevice() async {
    final state = stateManager.state.valueOrNull;
    final audioOutputDevice = state?.audioOutputDevice;
    if (audioOutputDevice != null) {
      await _onSetAudioOutputDevice(audioOutputDevice);
    }
  }

  void _onStatsReceived(
    StreamPeerConnection pc,
    RtcPrintableStats rtcStats,
  ) {
    _stats.emit(
      CallStats(
        peerType: pc.type,
        printable: rtcStats,
        // TODO implement raw stats
        raw: RtcRawStats(),
      ),
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

  Future<Result<None>> _onSetAudioOutputDevice(RtcMediaDevice device) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set speaker device, Call not connected');
    }

    return rtcManager.setAudioOutputDevice(device: device);
  }

  Future<Result<None>> _onSetCameraEnabled(bool enabled) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set camera, Call not connected');
    }

    final result = await rtcManager.setCameraEnabled(enabled: enabled);
    return result.map((_) => None());
  }

  Future<Result<None>> _onSetMicrophoneEnabled(bool enabled) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set microphone, Call not connected');
    }

    final result = await rtcManager.setMicrophoneEnabled(enabled: enabled);
    return result.map((_) => None());
  }

  Future<Result<None>> _onSetAudioInputDevice(RtcMediaDevice device) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set audioInput, Call not connected');
    }

    final result = await rtcManager.setAudioInputDevice(device: device);
    return result.map((_) => None());
  }

  Future<Result<None>> _onSetScreenShareEnabled(bool enabled) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set ScreenShare, Call not connected');
    }

    final result = await rtcManager.setScreenShareEnabled(enabled: enabled);
    return result.map((_) => None());
  }

  Future<Result<None>> _onFlipCamera() async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to flip camera, Call not connected');
    }

    final result = await rtcManager.flipCamera();
    return result.map((_) => None());
  }

  Future<Result<None>> _onSetVideoInputDevice(RtcMediaDevice device) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set video input, Call not connected');
    }

    final result = await rtcManager.setVideoInputDevice(device: device);
    return result.map((_) => None());
  }

  Future<Result<None>> _onSetCameraPosition(CameraPosition position) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set camera position, Call not connected');
    }

    final result = await rtcManager.setCameraPosition(cameraPosition: position);
    return result.map((_) => None());
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
              width: layer.parameters.dimension.width,
              height: layer.parameters.dimension.height,
            ),
            bitrate: layer.parameters.encoding.maxBitrate,
            fps: layer.parameters.encoding.maxFramerate,
          );
        }),
      );
    }).toList();
  }
}

extension on SfuClient {
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

    return result.fold(
      failure: (it) => it,
      success: (it) {
        if (it.data.hasError()) {
          final error = it.data.error;
          return Result.error('${error.code} - ${error.message}');
        }
        return Result.success(None());
      },
    );
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

extension on List<CallParticipantState> {
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

extension on CallParticipantState {
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
