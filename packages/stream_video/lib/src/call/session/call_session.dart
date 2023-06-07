import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../../stream_video.dart';
import '../../action/internal/rtc_action.dart';
import '../../disposable.dart';
import '../../errors/video_error_composer.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../sfu/data/models/sfu_model_mapper_extensions.dart';
import '../../sfu/data/models/sfu_subscription_details.dart';
import '../../sfu/sfu_client.dart';
import '../../sfu/sfu_client_impl.dart';
import '../../sfu/ws/sfu_ws.dart';
import '../../shared_emitter.dart';
import '../../utils/debounce_buffer.dart';
import '../../utils/none.dart';
import '../../webrtc/model/rtc_model_mapper_extensions.dart';
import '../../webrtc/model/rtc_tracks_info.dart';
import '../../webrtc/model/stats/rtc_printable_stats.dart';
import '../../webrtc/model/stats/rtc_raw_stats.dart';
import '../../webrtc/peer_connection.dart';
import '../../webrtc/rtc_manager.dart';
import '../../webrtc/rtc_manager_factory.dart';
import '../../webrtc/sdp/editor/sdp_editor.dart';
import '../state/call_state_notifier.dart';
import 'call_session_config.dart';

const _tag = 'SV:CallSession';

const _debounceDuration = Duration(milliseconds: 200);

class CallSession extends Disposable {
  CallSession({
    required this.callCid,
    required this.sessionSeq,
    required this.sessionId,
    required this.config,
    required this.stateManager,
    required SdpEditor sdpEditor,
  })  : sfuClient = SfuClientImpl(
          baseUrl: config.sfuUrl,
          sfuToken: config.sfuToken,
        ),
        sfuWS = SfuWebSocket(
          sessionSeq: sessionSeq,
          sfuUrl: config.sfuUrl,
          sfuWsEndpoint: config.sfuWsEndpoint,
          sessionId: sessionId,
        ),
        rtcManagerFactory = RtcManagerFactory(
          sessionId: sessionId,
          callCid: callCid,
          configuration: config.rtcConfig,
          sdpEditor: sdpEditor,
        ) {
    _logger.i(() => '<init> callCid: $callCid, sessionId: $sessionId');
  }

  late final _logger = taggedLogger(tag: '$_tag-$sessionSeq');

  final StreamCallCid callCid;
  final int sessionSeq;
  final String sessionId;
  final CallSessionConfig config;
  final CallStateNotifier stateManager;
  final SfuClient sfuClient;
  final SfuWebSocket sfuWS;
  final RtcManagerFactory rtcManagerFactory;
  RtcManager? rtcManager;
  StreamSubscription<SfuEvent>? eventsSubscription;

  SharedEmitter<CallStats> get stats => _stats;
  late final _stats = MutableSharedEmitterImpl<CallStats>();

  SharedEmitter<SfuEvent> get events => sfuWS.events;

  late final _saBuffer = DebounceBuffer<SubscriptionAction, Result<None>>(
    duration: _debounceDuration,
    onBuffered: updateSubscriptions,
    onCancel: () => Result.error('SubscriptionAction cancelled'),
  );

  late final _vvBuffer = DebounceBuffer<UpdateViewportVisibility, Result<None>>(
    duration: _debounceDuration,
    onBuffered: updateViewportVisibilities,
    onCancel: () => Result.error('UpdateViewportVisibility cancelled'),
  );

  Future<Result<None>> start() async {
    try {
      _logger.d(() => '[start] no args');
      await eventsSubscription?.cancel();
      eventsSubscription = sfuWS.events.listen(_onSfuEvent);
      final wsResult = await sfuWS.connect();
      if (wsResult.isFailure) {
        _logger.e(() => '[start] ws connect failed: $wsResult');
        return wsResult;
      }
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
      final currentUserId = stateManager.callState.currentUserId;
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
      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[start] failed: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  @override
  Future<void> dispose() async {
    _logger.d(() => '[dispose] no args');
    await _stats.close();
    await _saBuffer.cancel();
    await eventsSubscription?.cancel();
    eventsSubscription = null;
    await sfuWS.disconnect();
    await rtcManager?.dispose();
    rtcManager = null;
    return await super.dispose();
  }

  Future<Result<None>> setLocalTrack(RtcLocalTrack track) async {
    _logger.d(() => '[setLocalTrack] track: $track');

    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set local track, Call not connected');
    }

    final result = await rtcManager.publishTrack(track);
    return result.map((_) => none);
  }

  RtcTrack? getTrack(String trackIdPrefix, SfuTrackType trackType) {
    final trackId = '$trackIdPrefix:$trackType';
    return rtcManager?.getTrack(trackId);
  }

  List<RtcTrack> getTracks(String trackIdPrefix) {
    return [...?rtcManager?.getTracks(trackIdPrefix)];
  }

  Future<void> _onSfuEvent(SfuEvent event) async {
    _logger.log(event.logPriority, () => '[onSfuEvent] event: $event');
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
    } else if (event is SfuChangePublishQualityEvent) {
      await _onPublishQualityChanged(event);
    }

    if (event is SfuJoinResponseEvent) {
      stateManager.sfuJoinResponse(event);
    } else if (event is SfuParticipantJoinedEvent) {
      stateManager.sfuParticipantJoined(event);
    } else if (event is SfuParticipantLeftEvent) {
      stateManager.sfuParticipantLeft(event);
    } else if (event is SfuConnectionQualityChangedEvent) {
      stateManager.sfuConnectionQualityChanged(event);
    } else if (event is SfuAudioLevelChangedEvent) {
      stateManager.sfuUpdateAudioLevelChanged(event);
    } else if (event is SfuTrackPublishedEvent) {
      stateManager.sfuTrackPublished(event);
    } else if (event is SfuTrackUnpublishedEvent) {
      stateManager.sfuTrackUnpublished(event);
    } else if (event is SfuDominantSpeakerChangedEvent) {
      stateManager.sfuDominantSpeakerChanged(event);
    }
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

    final callParticipants = stateManager.callState.callParticipants;
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

  Future<void> _onPublishQualityChanged(SfuChangePublishQualityEvent event) async {
    _logger.d(() => '[onPublishQualityChanged] event: $event');

    final enabledRids = event.videoSenders.firstOrNull?.layers
        .where((e) => e.active)
        .map((e) => e.name)
        .toSet() ?? {};

    _logger.v(() => '[onPublishQualityChanged] Enabled RIDs: $enabledRids');

    return await rtcManager?.onPublishQualityChanged(enabledRids);
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

  Future<void> _applyCurrentVideoInputDevice() async {
    final state = stateManager.callStateStream.valueOrNull;
    final videoInputDevice = state?.videoInputDevice;
    if (videoInputDevice != null) {
      await setVideoInputDevice(videoInputDevice);
    }
  }

  Future<void> _onLocalTrackPublished(RtcLocalTrack track) async {
    _logger.d(() => '[onPublisherTrackPublished] track: $track');

    // Start the track.
    await track.start();

    // If the track is an audioTrack, apply the current audio output device.
    if (track.isAudioTrack) {
      await _applyCurrentAudioOutputDevice();
    }

    if (track.isVideoTrack) {
      await _applyCurrentVideoInputDevice();
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

    final tracksInfo = rtcManager!.getPublisherTrackInfos();
    if (tracksInfo.isEmpty) {
      _logger.w(() => '[negotiate] rejected(tracksInfo is empty): $tracksInfo');
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
      _logger.w(() => '[negotiate] #setPublisher; failed: $pubResult');
      return;
    }

    final ansResult = await pc.setRemoteAnswer(pubResult.data.sdp);
    if (ansResult is! Success<void>) {
      _logger.w(() => '[negotiate] #setRemoteAnswer; failed: $ansResult');
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

    return stateManager.rtcUpdateSubscriberTrack(
      UpdateSubscriberTrack(
        trackIdPrefix: remoteTrack.trackIdPrefix,
        trackType: remoteTrack.trackType,
      ),
    );
  }

  Future<void> _applyCurrentAudioOutputDevice() async {
    final state = stateManager.callStateStream.valueOrNull;
    final audioOutputDevice = state?.audioOutputDevice;
    if (audioOutputDevice != null) {
      await setAudioOutputDevice(audioOutputDevice);
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

  Future<Result<None>> setParticipantPinned(
    SetParticipantPinned action,
  ) async {
    _logger.d(() => '[setParticipantPinned] action: $action');
    // Nothing to do here, this is handled by the UI
    return const Result.success(none);
  }

  Future<Result<None>> updateViewportVisibility(
    UpdateViewportVisibility action,
  ) async {
    _logger.d(() => '[updateViewportVisibility] action: $action');
    return _vvBuffer.post(action);
  }

  Future<Result<None>> updateViewportVisibilities(
    List<UpdateViewportVisibility> actions,
  ) async {
    _logger.d(() => '[updateViewportVisibilities] actions: $actions');
    // Nothing to do here, this is handled by the UI
    return const Result.success(none);
  }

  Future<Result<None>> setSubscriptions(
    List<SetSubscription> actions,
  ) async {
    _logger.d(() => '[setSubscriptions] actions: $actions');

    final participants = stateManager.callState.callParticipants;
    final exclude = {SfuTrackType.video, SfuTrackType.screenShare};
    final subscriptions = <String, SfuSubscriptionDetails>{
      ...participants.getSubscriptions(exclude: exclude),
    };
    _logger.v(() => '[setSubscriptions] source: $subscriptions');
    for (final action in actions) {
      final actionSubscriptions = action.getSubscriptions();
      subscriptions.addAll(actionSubscriptions);
    }

    _logger.v(() => '[setSubscriptions] updated: $subscriptions');
    final result = await sfuClient.update(
      sessionId: sessionId,
      subscriptions: subscriptions.values,
    );

    _logger.v(() => '[setSubscriptions] result: $result');
    return result;
  }

  Future<Result<None>> updateSubscription(
    SubscriptionAction action,
  ) async {
    _logger.d(() => '[updateSubscription] action: $action');
    return _saBuffer.post(action);
  }

  Future<Result<None>> updateSubscriptions(
    List<SubscriptionAction> actions,
  ) async {
    _logger.d(() => '[updateSubscriptions] actions: $actions');
    final participants = stateManager.callState.callParticipants;
    final subscriptions = <String, SfuSubscriptionDetails>{
      ...participants.getSubscriptions(),
    };
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

  Future<Result<None>> setAudioOutputDevice(RtcMediaDevice device) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set speaker device, Call not connected');
    }

    return rtcManager.setAudioOutputDevice(device: device);
  }

  Future<Result<None>> setCameraEnabled(bool enabled) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set camera, Call not connected');
    }

    final result = await rtcManager.setCameraEnabled(enabled: enabled);
    return result.map((_) => none);
  }

  Future<Result<None>> setMicrophoneEnabled(bool enabled) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set microphone, Call not connected');
    }

    final result = await rtcManager.setMicrophoneEnabled(enabled: enabled);
    return result.map((_) => none);
  }

  Future<Result<None>> setAudioInputDevice(RtcMediaDevice device) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set audioInput, Call not connected');
    }

    final result = await rtcManager.setAudioInputDevice(device: device);
    return result.map((_) => none);
  }

  Future<Result<None>> setScreenShareEnabled(bool enabled) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set ScreenShare, Call not connected');
    }

    final result = await rtcManager.setScreenShareEnabled(enabled: enabled);
    return result.map((_) => none);
  }

  Future<Result<None>> flipCamera() async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to flip camera, Call not connected');
    }

    final result = await rtcManager.flipCamera();
    return result.map((_) => none);
  }

  Future<Result<None>> setVideoInputDevice(RtcMediaDevice device) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set video input, Call not connected');
    }

    final result = await rtcManager.setVideoInputDevice(device: device);
    return result.map((_) => none);
  }

  Future<Result<None>> setCameraPosition(CameraPosition position) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set camera position, Call not connected');
    }

    final result = await rtcManager.setCameraPosition(cameraPosition: position);
    return result.map((_) => none);
  }

  @override
  String toString() => 'CallSession{seq: $sessionSeq, id: $sessionId}';
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
        return const Result.success(none);
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
  Map<String, SfuSubscriptionDetails> getSubscriptions() {
    final subscriptions = <String, SfuSubscriptionDetails>{};

    for (final trackType in trackTypes.keys) {
      final dimension = trackTypes[trackType];

      final detail = SfuSubscriptionDetails(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
        dimension: dimension,
      );

      subscriptions[detail.trackId] = detail;
    }

    return subscriptions;
  }
}

extension on List<CallParticipantState> {
  Map<String, SfuSubscriptionDetails> getSubscriptions({
    Set<SfuTrackType> exclude = const {},
  }) {
    final subscriptions = <String, SfuSubscriptionDetails>{};

    for (final participant in this) {
      // We only care about remote participants.
      if (participant.isLocal) continue;

      streamLog.v(
        _tag,
        () => '[getSubscriptions] userId: ${participant.userId}, '
            'published: ${participant.publishedTracks.keys}',
      );

      subscriptions.addAll(
        participant.getSubscriptions(exclude: exclude),
      );
    }

    return subscriptions;
  }
}

extension on CallParticipantState {
  Map<String, SfuSubscriptionDetails> getSubscriptions({
    Set<SfuTrackType> exclude = const {},
  }) {
    final subscriptions = <String, SfuSubscriptionDetails>{};

    for (final trackType in publishedTracks.keys) {
      final trackState = publishedTracks[trackType];

      streamLog.v(
        _tag,
        () => '[getSubscriptions] trackType: $trackType, '
            'trackState: $trackState',
      );

      // We only care about remote tracks.
      if (trackState is! RemoteTrackState) continue;

      // Continue if we should exclude this trackType.
      final shouldExclude = exclude.contains(trackType);
      if (shouldExclude) continue;

      // We only care about tracks that are subscribed.
      if (!trackState.subscribed) continue;

      final detail = SfuSubscriptionDetails(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
        dimension: trackState.videoDimension,
      );

      subscriptions[detail.trackId] = detail;
    }

    return subscriptions;
  }
}
