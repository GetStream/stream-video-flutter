import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:synchronized/synchronized.dart';
import 'package:system_info2/system_info2.dart';

import '../../../globals.dart';
import '../../../open_api/video/coordinator/api.dart';
import '../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../../protobuf/video/sfu/models/models.pbenum.dart';
import '../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../disposable.dart';
import '../../errors/video_error.dart';
import '../../errors/video_error_composer.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../models/models.dart';
import '../../platform_detector/platform_detector.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../sfu/data/models/sfu_call_state.dart';
import '../../sfu/data/models/sfu_error.dart';
import '../../sfu/data/models/sfu_model_mapper_extensions.dart';
import '../../sfu/data/models/sfu_subscription_details.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../../sfu/sfu_client.dart';
import '../../sfu/sfu_extensions.dart';
import '../../sfu/ws/sfu_ws.dart';
import '../../shared_emitter.dart';
import '../../utils/debounce_buffer.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../webrtc/media/media_constraints.dart';
import '../../webrtc/model/rtc_model_mapper_extensions.dart';
import '../../webrtc/model/rtc_tracks_info.dart';
import '../../webrtc/peer_connection.dart';
import '../../webrtc/peer_type.dart';
import '../../webrtc/rtc_manager.dart';
import '../../webrtc/rtc_manager_factory.dart';
import '../../webrtc/rtc_media_device/rtc_media_device.dart';
import '../../webrtc/rtc_track/rtc_track.dart';
import '../../webrtc/sdp/editor/sdp_editor.dart';
import '../../ws/ws.dart';
import '../state/call_state_notifier.dart';
import '../stats/tracer.dart';
import 'call_session_config.dart';
import 'dynascale_manager.dart';

const _tag = 'SV:CallSession';

const _debounceDuration = Duration(milliseconds: 200);
const _migrationCompleteEventTimeout = Duration(seconds: 7);

class CallSession extends Disposable {
  CallSession({
    required this.callCid,
    required this.sessionSeq,
    required this.sessionId,
    required this.config,
    required this.stateManager,
    required this.dynascaleManager,
    required this.onReconnectionNeeded,
    required SdpEditor sdpEditor,
    required this.networkMonitor,
    required this.statsOptions,
    required Tracer tracer,
    this.clientPublishOptions,
    this.joinResponseTimeout = const Duration(seconds: 5),
  })  : _tracer = tracer,
        sfuClient = SfuClient(
          baseUrl: config.sfuUrl,
          sfuToken: config.sfuToken,
          sessionSeq: sessionSeq,
          tracer: tracer,
        ),
        sfuWS = SfuWebSocket(
          sessionSeq: sessionSeq,
          sfuUrl: config.sfuUrl,
          sfuWsEndpoint: config.sfuWsEndpoint,
          sessionId: sessionId,
          networkMonitor: networkMonitor,
        ),
        rtcManagerFactory = RtcManagerFactory(
          sessionId: sessionId,
          callCid: callCid,
          configuration: config.rtcConfig,
          sdpEditor: sdpEditor,
        ) {
    _logger.i(() => '<init> callCid: $callCid, sessionId: $sessionId');
    _observeNetworkStatus();
  }

  late final _logger = taggedLogger(tag: '$_tag-$sessionSeq');

  final StreamCallCid callCid;
  final int sessionSeq;
  final String sessionId;
  final CallSessionConfig config;
  final CallStateNotifier stateManager;
  final DynascaleManager dynascaleManager;
  final SfuClient sfuClient;
  final SfuWebSocket sfuWS;
  final RtcManagerFactory rtcManagerFactory;
  final OnReconnectionNeeded onReconnectionNeeded;
  final ClientPublishOptions? clientPublishOptions;
  final InternetConnection networkMonitor;
  final StatsOptions statsOptions;
  final Tracer _tracer;

  final Duration joinResponseTimeout;

  final Lock _sfuEventsLock = Lock();
  final Lock _negotiationLock = Lock();

  int zonedTracerSeq = 0;

  RtcManager? rtcManager;
  BehaviorSubject<RtcManager>? _rtcManagerSubject;
  StreamSubscription<SfuEvent>? _eventsSubscription;
  StreamSubscription<InternetStatus>? _networkStatusSubscription;

  Timer? _peerConnectionCheckTimer;

  sfu_models.ClientDetails? _clientDetails;

  SharedEmitter<SfuEvent> get events => sfuWS.events;

  late final _vvBuffer = DebounceBuffer<VisibilityChange, Result<None>>(
    duration: _debounceDuration,
    onBuffered: updateViewportVisibilities,
    onCancel: () => Result.error('UpdateViewportVisibility cancelled'),
  );

  TraceSlice getTrace() {
    return _tracer.take();
  }

  void setTraceEnabled(bool enabled) {
    _tracer.setEnabled(enabled);
  }

  void _observeNetworkStatus() {
    _networkStatusSubscription = networkMonitor.onStatusChange.listen((status) {
      _tracer.trace('network.changed', status.name);
    });
  }

  Future<void> _ensureClientDetails() async {
    if (_clientDetails != null) return;

    try {
      sfu_models.Device? device;
      sfu_models.Browser? browser;

      var os = sfu_models.OS(
        name: CurrentPlatform.name,
      );

      if (CurrentPlatform.isAndroid) {
        final deviceInfo = await DeviceInfoPlugin().androidInfo;
        os = sfu_models.OS(
          name: CurrentPlatform.name,
          version: deviceInfo.version.release,
          architecture: SysInfo.rawKernelArchitecture,
        );
        device = sfu_models.Device(
          name: '${deviceInfo.manufacturer} : ${deviceInfo.model}',
        );
      } else if (CurrentPlatform.isIos) {
        final deviceInfo = await DeviceInfoPlugin().iosInfo;
        os = sfu_models.OS(
          name: CurrentPlatform.name,
          version: deviceInfo.systemVersion,
        );
        device = sfu_models.Device(
          name: deviceInfo.utsname.machine,
        );
      } else if (CurrentPlatform.isWeb) {
        final browserInfo = await DeviceInfoPlugin().webBrowserInfo;
        browser = sfu_models.Browser(
          name: browserInfo.browserName.name,
          version: browserInfo.vendorSub,
        );
      } else if (CurrentPlatform.isMacOS) {
        final deviceInfo = await DeviceInfoPlugin().macOsInfo;
        os = sfu_models.OS(
          name: CurrentPlatform.name,
          version:
              '${deviceInfo.majorVersion}.${deviceInfo.minorVersion}.${deviceInfo.patchVersion}',
          architecture: deviceInfo.arch,
        );
        device = sfu_models.Device(
          name: deviceInfo.model,
          version: deviceInfo.osRelease,
        );
      } else if (CurrentPlatform.isWindows) {
        final deviceInfo = await DeviceInfoPlugin().windowsInfo;
        os = sfu_models.OS(
          name: CurrentPlatform.name,
          version:
              '${deviceInfo.majorVersion}.${deviceInfo.minorVersion}.${deviceInfo.buildNumber}',
          architecture: deviceInfo.buildLabEx,
        );
      } else if (CurrentPlatform.isLinux) {
        final deviceInfo = await DeviceInfoPlugin().linuxInfo;
        os = sfu_models.OS(
          name: CurrentPlatform.name,
          version: '${deviceInfo.name} ${deviceInfo.version}',
        );
      }

      final versionSplit = streamVideoVersion.split('.');
      _clientDetails = sfu_models.ClientDetails(
        sdk: sfu_models.Sdk(
          type: sfu_models.SdkType.SDK_TYPE_FLUTTER,
          major: versionSplit.first,
          minor: versionSplit.skip(1).first,
          patch: versionSplit.last,
        ),
        os: os,
        device: device,
        browser: browser,
      );
    } catch (e) {
      _logger.e(() => '[_ensureClientDetails] failed: $e');
    }
  }

  Future<sfu_events.ReconnectDetails> getReconnectDetails(
    SfuReconnectionStrategy strategy, {
    String? migratingFromSfuId,
    int? reconnectAttempts,
  }) async {
    final announcedTracks = await rtcManager?.getAnnouncedTracksForReconnect();

    final subscribedTracks = dynascaleManager
        .getTrackSubscriptions(ignoreOverride: true)
        .values
        .toList()
        .toDTO();

    return sfu_events.ReconnectDetails(
      strategy: strategy.toDto(),
      announcedTracks: announcedTracks?.toDTO(),
      subscriptions: subscribedTracks,
      previousSessionId:
          strategy == SfuReconnectionStrategy.rejoin ? sessionId : null,
      fromSfuId: migratingFromSfuId,
      reconnectAttempt: reconnectAttempts,
    );
  }

  Future<
      Result<
          ({
            SfuCallState callState,
            Duration fastReconnectDeadline,
          })>> start({
    sfu_events.ReconnectDetails? reconnectDetails,
    FutureOr<void> Function(RtcManager)? onRtcManagerCreatedCallback,
    bool isAnonymousUser = false,
  }) async {
    try {
      _logger.d(
        () => '[start] reconnectDetails: $reconnectDetails, '
            'isAnonymousUser: $isAnonymousUser',
      );

      await _ensureClientDetails();

      await _eventsSubscription?.cancel();
      await _rtcManagerSubject?.close();

      _rtcManagerSubject = BehaviorSubject();

      // Buffer sfu events until rtc manager is set
      final bufferedStream = sfuWS.events
          .asStream()
          .takeWhile((_) => !_rtcManagerSubject!.hasValue)
          .buffer(_rtcManagerSubject!)
          .expand((event) => event);

      // Delay rest of the sfu events until rtc manager is set
      final delayedStream = Rx.combineLatest2(
        _rtcManagerSubject!,
        sfuWS.events.asStream(),
        (_, event) => event,
      ).skip(1);

      // Handle buffered events and then listen to sfu events as normal
      _eventsSubscription =
          bufferedStream.mergeWith([delayedStream]).listen(_onSfuEvent);

      final wsResult = await sfuWS.connect();
      if (wsResult.isFailure) {
        _logger.e(() => '[start] ws connect failed: $wsResult');
        return const Result.failure(
          VideoError(message: 'Failed to connect to WS'),
        );
      }

      _logger.v(() => '[start] sfu connected');

      final subscriberSdp =
          await RtcManager.getGenericSdp(rtc.TransceiverDirection.RecvOnly);
      final publisherSdp =
          await RtcManager.getGenericSdp(rtc.TransceiverDirection.SendOnly);

      _logger.v(
        () => '[start] subscriberSdp.len: ${subscriberSdp.length}, '
            'publisherSdp.len: ${publisherSdp.length}',
      );

      final isReconnecting = reconnectDetails != null &&
          reconnectDetails.strategy !=
              WebsocketReconnectStrategy
                  .WEBSOCKET_RECONNECT_STRATEGY_UNSPECIFIED;

      final preferredPublishOptions = isReconnecting
          ? rtcManager?.publishOptions.map((o) => o.toDTO())
          : clientPublishOptions?.getPreferredPublishOptions();

      final preferredSubscribeOptions = isReconnecting
          ? null
          : clientPublishOptions?.getPreferredSubscriberOptions();

      final joinRequest = sfu_events.JoinRequest(
        clientDetails: _clientDetails,
        token: config.sfuToken,
        sessionId: sessionId,
        subscriberSdp: subscriberSdp,
        publisherSdp: publisherSdp,
        reconnectDetails: reconnectDetails,
        preferredPublishOptions: preferredPublishOptions,
        preferredSubscribeOptions: preferredSubscribeOptions,
      );

      _tracer.trace('joinRequest', joinRequest.toJson());

      sfuWS.send(
        sfu_events.SfuRequest(
          joinRequest: joinRequest,
        ),
      );

      _logger.v(() => '[start] wait for SfuJoinResponseEvent');
      final event = await sfuWS.events.waitFor<SfuJoinResponseEvent>(
        timeLimit: joinResponseTimeout,
      );

      _logger.v(() => '[start] sfu joined: $event');

      if (isAnonymousUser) {
        rtcManager = await rtcManagerFactory.makeRtcManager(
          sfuClient: sfuClient,
          clientDetails: _clientDetails,
          sessionSequence: sessionSeq,
          statsOptions: statsOptions,
        )
          ..onSubscriberIceCandidate = _onLocalIceCandidate
          ..onRenegotiationNeeded = _onRenegotiationNeeded
          ..onReconnectionNeeded = onReconnectionNeeded
          ..onRemoteTrackReceived = _onRemoteTrackReceived;
      } else {
        final currentUserId = stateManager.callState.currentUserId;
        final localParticipant = event.callState.participants.firstWhere(
          (it) => it.userId == currentUserId && it.sessionId == sessionId,
        );
        final localTrackId = localParticipant.trackLookupPrefix;

        _logger.v(() => '[start] localTrackId: $localTrackId');

        rtcManager = await rtcManagerFactory.makeRtcManager(
          sfuClient: sfuClient,
          publisherId: localTrackId,
          publishOptions: event.publishOptions,
          clientDetails: _clientDetails,
          sessionSequence: sessionSeq,
          statsOptions: statsOptions,
          callSessionConfig: config,
        )
          ..onPublisherIceCandidate = _onLocalIceCandidate
          ..onSubscriberIceCandidate = _onLocalIceCandidate
          ..onLocalTrackMuted = _onLocalTrackMuted
          ..onLocalTrackPublished = _onLocalTrackPublished
          ..onReconnectionNeeded = onReconnectionNeeded
          ..onRenegotiationNeeded = _onRenegotiationNeeded
          ..onRemoteTrackReceived = _onRemoteTrackReceived;
      }

      await onRtcManagerCreatedCallback?.call(rtcManager!);
      _rtcManagerSubject!.add(rtcManager!);

      stateManager.sfuPinsUpdated(event.callState.pins);

      _logger.d(() => '[start] completed');
      return Result.success(
        (
          callState: event.callState,
          fastReconnectDeadline: event.fastReconnectDeadline
        ),
      );
    } catch (e, stk) {
      _logger.e(() => '[start] failed: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<None>> waitForMigrationComplete() async {
    try {
      _logger.v(() => '[waitForMigrationComplete] no args');

      await sfuWS.events.waitFor<SfuParticipantMigrationCompleteEvent>(
        timeLimit: _migrationCompleteEventTimeout,
      );

      _logger.d(() => '[waitForMigrationComplete] completed');
      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[waitForMigrationComplete] failed: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<({SfuCallState callState, Duration fastReconnectDeadline})?>>
      fastReconnect() async {
    try {
      _logger.d(() => '[fastReconnect] no args');

      final reconnectDetails =
          await getReconnectDetails(SfuReconnectionStrategy.fast);

      _tracer.trace('fastReconnect', reconnectDetails.toJson());

      final subscriberSdp =
          await RtcManager.getGenericSdp(rtc.TransceiverDirection.RecvOnly);
      final publisherSdp =
          await RtcManager.getGenericSdp(rtc.TransceiverDirection.SendOnly);

      await _ensureClientDetails();

      Result<({SfuCallState callState, Duration fastReconnectDeadline})?>?
          result;

      _logger.d(() => '[fastReconnect] sfu not connected, recreating');
      await sfuWS.recreate();

      _logger.d(() => '[fastReconnect] sfu connected, sending join request');
      sfuWS.send(
        sfu_events.SfuRequest(
          joinRequest: sfu_events.JoinRequest(
            clientDetails: _clientDetails,
            token: config.sfuToken,
            sessionId: sessionId,
            subscriberSdp: subscriberSdp,
            publisherSdp: publisherSdp,
            reconnectDetails: reconnectDetails,
            preferredPublishOptions:
                rtcManager?.publishOptions.map((o) => o.toDTO()),
          ),
        ),
      );

      _logger.v(() => '[fastReconnect] wait for SfuJoinResponseEvent');
      final event = await sfuWS.events.waitFor<SfuJoinResponseEvent>(
        timeLimit: const Duration(seconds: 30),
      );

      if (event.isReconnected) {
        _logger.v(() => '[fastReconnect] fast-reconnect done');

        stateManager.sfuPinsUpdated(event.callState.pins);

        result = Result.success(
          (
            callState: event.callState,
            fastReconnectDeadline: event.fastReconnectDeadline
          ),
        );
      } else {
        _logger.v(() => '[fastReconnect] fast-reconnect not possible');
        return const Result.failure(
          VideoError(message: 'Fast reconnect not possible'),
        );
      }

      _logger.v(() => '[fastReconnect] restarting ICE');
      await rtcManager?.publisher?.pc.restartIce();

      final remoteTracks =
          rtcManager!.tracks.values.whereType<RtcRemoteTrack>().toList();

      for (final track in remoteTracks) {
        await _onRemoteTrackReceived(rtcManager!.subscriber, track);
      }

      if (result.isSuccess) {
        _tracer.trace('fastReconnect.success', null);
      } else {
        _tracer.trace(
          'fastReconnect.failure',
          result.getErrorOrNull()?.toString(),
        );
      }

      return result;
    } catch (e, stk) {
      _logger.e(() => '[fastReconnect] failed: $e');
      _tracer.trace('fastReconnect.failure', e.toString());
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  void leave({String? reason}) {
    _logger.d(() => '[leave] no args');
    sfuWS.leave(sessionId: sessionId, reason: reason);
  }

  Future<void> close(
    StreamWebSocketCloseCode code, {
    String? closeReason,
  }) async {
    _logger.d(() => '[close] code: $code, closeReason: $closeReason');

    await _eventsSubscription?.cancel();
    await _networkStatusSubscription?.cancel();

    await sfuWS.disconnect(
      code.value,
      'dart-client: $closeReason',
    );

    await rtcManager?.dispose();
    rtcManager = null;
    _tracer.dispose();
    _peerConnectionCheckTimer?.cancel();
  }

  @override
  Future<void> dispose() async {
    _logger.d(() => '[dispose] no args');

    await close(StreamWebSocketCloseCode.normalClosure);
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

  SfuTrackType? getTrackType(String trackId) {
    return rtcManager?.getTrack(trackId)?.trackType;
  }

  Future<void> _onSfuEvent(SfuEvent event) async {
    _logger.log(event.logPriority, () => '[onSfuEvent] event: $event');

    await _sfuEventsLock.synchronized(() async {
      if (event is SfuSubscriberOfferEvent) {
        await _onSubscriberOffer(event);
      } else if (event is SfuIceTrickleEvent) {
        await _onRemoteIceCandidate(event);
      } else if (event is SfuParticipantLeftEvent) {
        await _onParticipantLeft(event);
      } else if (event is SfuTrackPublishedEvent) {
        _tracer.trace('TrackPublished', event.toJson());
        await _onTrackPublished(event);
      } else if (event is SfuTrackUnpublishedEvent) {
        _tracer.trace('TrackUnpublish', event.toJson());
        await _onTrackUnpublished(event);
      } else if (event is SfuChangePublishQualityEvent) {
        _tracer.trace('PublishQualityChanged', event.toJson());
        await _onPublishQualityChanged(event);
      } else if (event is SfuChangePublishOptionsEvent) {
        _tracer.trace('PublishOptionsChanged', event.toJson());
        await _onPublishOptionsChanged(event);
      } else if (event is SfuGoAwayEvent) {
        _tracer.trace('GoAway', event.toJson());
      } else if (event is SfuErrorEvent) {
        _tracer.trace('Error', event.toJson());
      } else if (event is SfuCallEndedEvent) {
        _tracer.trace('CallEnded', event.toJson());
      }

      if (event is SfuJoinResponseEvent) {
        stateManager.sfuJoinResponse(event);
      } else if (event is SfuParticipantJoinedEvent) {
        stateManager.sfuParticipantJoined(event);
      } else if (event is SfuParticipantUpdatedEvent) {
        stateManager.sfuParticipantUpdated(event);
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
      } else if (event is SfuPinsUpdatedEvent) {
        stateManager.sfuPinsUpdated(event.pins);
      }
    });
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

  Future<void> _onPublishQualityChanged(
    SfuChangePublishQualityEvent event,
  ) async {
    _logger.d(() => '[onPublishQualityChanged] event: $event');

    final usedCodec =
        stateManager.callState.publisherStats?.videoCodec?.firstOrNull;

    for (final videoSender in event.videoSenders) {
      await rtcManager?.onPublishQualityChanged(videoSender, usedCodec);
    }
  }

  Future<void> _onPublishOptionsChanged(
    SfuChangePublishOptionsEvent event,
  ) async {
    _logger.d(() => '[_onPublishOptionsChanged] event: $event');

    return await rtcManager?.onPublishOptionsChanged(event.publishOptions);
  }

  Future<void> _onSubscriberOffer(SfuSubscriberOfferEvent event) async {
    final offerSdp = event.sdp;
    _logger.v(() => '[onSubscriberOffer] event: $event');

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
          ),
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

    final result = sfuClient.iceTrickle(
      sfu_models.ICETrickle(
        peerType: peerType,
        sessionId: sessionId,
        iceCandidate: encodedIceCandidate,
      ),
    );

    _logger.v(() => '[onLocalIceCandidate] result: $result');
  }

  Future<void> _onRenegotiationNeeded(StreamPeerConnection pc) async {
    if (stateManager.callState.status.isDisconnected) {
      _logger.w(() => '[negotiate] call is disconnected');
      return;
    }

    await _negotiationLock.synchronized(() async {
      _logger.d(() => '[negotiate] type: ${pc.type}');

      final offer = await pc.createOffer();
      if (offer is! Success<rtc.RTCSessionDescription>) return;

      final sdp = offer.data.sdp;
      final tracksInfo = await rtcManager?.getAnnouncedTracks(sdp: sdp) ?? [];

      if (tracksInfo.isEmpty) {
        _logger
            .w(() => '[negotiate] rejected(tracksInfo is empty): $tracksInfo');
        return;
      }

      _logger.v(() => '[negotiate] announcing tracks: $tracksInfo');

      final pubResult = await sfuClient.setPublisher(
        sfu.SetPublisherRequest(
          sdp: sdp,
          sessionId: sessionId,
          tracks: tracksInfo.toDTO(),
        ),
      );

      if (pubResult is! Success<sfu.SetPublisherResponse>) {
        _logger.w(() => '[negotiate] #setPublisher; failed: $pubResult');
        return;
      }

      if (pubResult.data.hasSdp()) {
        final ansResult = await pc.setRemoteAnswer(pubResult.data.sdp);
        if (ansResult is! Success<void>) {
          _logger.w(() => '[negotiate] #setRemoteAnswer; failed: $ansResult');
        }
      }
    });
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
      trackIdPrefix: remoteTrack.trackIdPrefix,
      trackType: remoteTrack.trackType,
    );
  }

  Future<void> _applyCurrentAudioOutputDevice() async {
    final state = stateManager.callStateStream.valueOrNull;
    final audioOutputDevice = state?.audioOutputDevice;
    if (audioOutputDevice != null) {
      await setAudioOutputDevice(audioOutputDevice);
    }
  }

  Future<Result<None>> updateViewportVisibility(
    VisibilityChange visibilityChange,
  ) async {
    _logger.d(
      () => '[updateViewportVisibility] visibilityChange: $visibilityChange',
    );

    if (!_vvBuffer.isClosed) {
      return _vvBuffer.post(visibilityChange);
    }

    //Ignore the visibility change if the buffer is closed
    return const Result.success(none);
  }

  Future<Result<None>> updateViewportVisibilities(
    List<VisibilityChange> visibilityChanges,
  ) async {
    _logger.d(
      () => '[updateViewportVisibilities] changes: $visibilityChanges',
    );
    // Nothing to do here, this is handled by the UI
    return const Result.success(none);
  }

  Future<Result<None>> setAudioOutputDevice(RtcMediaDevice device) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set speaker device, Call not connected');
    }

    return rtcManager.setAudioOutputDevice(device: device);
  }

  Future<Result<RtcLocalTrack>> setCameraEnabled(
    bool enabled, {
    CameraConstraints? constraints,
  }) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set camera, Call not connected');
    }

    final result = TracerZone.run(
      _tracer,
      ++zonedTracerSeq,
      () async {
        return rtcManager.setCameraEnabled(
          enabled: enabled,
          constraints: constraints,
        );
      },
    );

    return result;
  }

  Future<Result<RtcLocalTrack>> setMicrophoneEnabled(
    bool enabled, {
    AudioConstraints? constraints,
  }) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set microphone, Call not connected');
    }

    final result = TracerZone.run(
      _tracer,
      ++zonedTracerSeq,
      () async {
        return rtcManager.setMicrophoneEnabled(
          enabled: enabled,
          constraints: constraints,
        );
      },
    );

    return result;
  }

  Future<Result<None>> setAudioInputDevice(RtcMediaDevice device) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set audioInput, Call not connected');
    }

    final result = await rtcManager.setAudioInputDevice(device: device);
    return result.map((_) => none);
  }

  Future<Result<RtcLocalTrack>> setScreenShareEnabled(
    bool enabled, {
    ScreenShareConstraints? constraints,
  }) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to set ScreenShare, Call not connected');
    }

    final result = await rtcManager.setScreenShareEnabled(
      enabled: enabled,
      constraints: constraints,
    );

    return result;
  }

  Future<Result<RtcLocalTrack<CameraConstraints>>> flipCamera() async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return Result.error('Unable to flip camera, Call not connected');
    }

    final result = await rtcManager.flipCamera();
    return result;
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

  Future<Result<None>> notifyNoiseCancellationStarted() async {
    final result = await sfuClient.startNoiseCancellation(
      sfu.StartNoiseCancellationRequest(
        sessionId: sessionId,
      ),
    );

    return result.map((_) => none);
  }

  Future<Result<None>> notifyNoiseCancellationStopped() async {
    final result = await sfuClient.stopNoiseCancellation(
      sfu.StopNoiseCancellationRequest(
        sessionId: sessionId,
      ),
    );

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
        publishOptionId: info.publishOptionId,
        codec: info.codec?.toDTO(),
        layers: info.layers?.map((layer) {
          return sfu_models.VideoLayer(
            rid: layer.rid,
            videoDimension: sfu_models.VideoDimension(
              width: layer.parameters.dimension.width,
              height: layer.parameters.dimension.height,
            ),
            bitrate: layer.parameters.encoding.maxBitrate,
            fps: layer.parameters.encoding.maxFramerate,
            quality: layer.parameters.encoding.quality.toDTO(),
          );
        }),
      );
    }).toList();
  }
}

extension SfuSubscriptionDetailsEx on List<SfuSubscriptionDetails> {
  List<sfu.TrackSubscriptionDetails> toDTO() {
    return map((sub) {
      return sfu.TrackSubscriptionDetails(
        userId: sub.userId,
        sessionId: sub.sessionId,
        trackType: sub.trackType.toDTO(),
        dimension: sub.dimension?.toDTO(),
      );
    }).toList();
  }
}

extension on ClientPublishOptions {
  List<sfu_models.PublishOption>? getPreferredPublishOptions() {
    if (preferredCodec == null) return null;

    return [
      sfu_models.PublishOption(
        codec: sfu_models.Codec(
          name: preferredCodec?.name,
          fmtp: fmtpLine,
        ),
        bitrate: preferredBitrate,
        maxSpatialLayers: maxSimulcastLayers,
        trackType: sfu_models.TrackType.TRACK_TYPE_VIDEO,
      ),
    ];
  }

  List<sfu_models.SubscribeOption>? getPreferredSubscriberOptions() {
    if (subscriberCodec == null) return null;

    return [
      sfu_models.SubscribeOption(
        codecs: [
          sfu_models.Codec(
            name: subscriberCodec?.name,
            fmtp: subscriberFmtpLine,
          ),
        ],
        trackType: sfu_models.TrackType.TRACK_TYPE_VIDEO,
      ),
    ];
  }
}
