import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';

import '../../../globals.dart';
import '../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../../stream_video.dart';
import '../../errors/stream_video_exception_composer.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../sfu/data/models/sfu_call_state.dart';
import '../../sfu/sfu_client.dart';
import '../../sfu/sfu_extensions.dart';
import '../../sfu/ws/sfu_ws.dart';
import '../../telemetry/client_event.dart';
import '../../telemetry/client_event_types.dart';
import '../../webrtc/peer_connection.dart';
import '../../webrtc/peer_connection_factory.dart';
import '../../webrtc/rtc_manager.dart';
import '../../webrtc/rtc_manager_factory.dart';
import '../../webrtc/sdp/editor/sdp_editor.dart';
import '../state/call_state_notifier.dart';
import '../stats/stats_reporter.dart';
import '../stats/trace_tag.dart';
import '../stats/tracer.dart';
import 'call_session_config.dart';
import 'publisher_connection_watchdog.dart';
import 'publisher_negotiator.dart';
import 'session_signaling.dart';
import 'session_track_controller.dart';
import 'sfu_event_router.dart';
import 'sfu_join_request_builder.dart';

part 'call_session_media.dart';

const _tag = 'SV:CallSession';

const _migrationCompleteEventTimeout = Duration(seconds: 7);

/// A fast reconnect the SFU answered with `reconnected: false`.
///
/// The SFU no longer held the session, so it seated the join as a brand-new
/// participant, one it never subscribes to anything. Another fast reconnect
/// would resume that participant and report success over a subscriber that
/// can never receive media. Only a rejoin recovers from this.
class SfuSessionNotResumedException extends StreamVideoException {
  const SfuSessionNotResumedException()
    : super(
        message: 'The SFU no longer holds this session (reconnected: false)',
      );
}

class CallSession extends Disposable with _CallSessionMedia {
  CallSession({
    required this.callCid,
    required this.sessionSeq,
    required this.sessionId,
    required this.config,
    required this.stateManager,
    required this.dynascaleManager,
    required this.onReconnectionNeeded,
    required this.onIceConnected,
    required this.onSuspendedAudioTrackRecorded,
    required SdpEditor sdpEditor,
    required this.networkMonitor,
    required this.statsOptions,
    required CallHost host,
    required Tracer tracer,
    required StreamPeerConnectionFactory pcFactory,
    required RetryPolicy retryPolicy,
    this.clientPublishOptions,
    this.e2eeManager,
    this.joinResponseTimeout = const Duration(seconds: 5),
    this.fastReconnectJoinResponseTimeout = const Duration(seconds: 15),
    @visibleForTesting SfuClient? sfuClient,
    @visibleForTesting SfuWebSocket? sfuWS,
    @visibleForTesting RtcManagerFactory? rtcManagerFactory,
  }) : _tracer = tracer,
       _host = host,
       sfuClient =
           sfuClient ??
           SfuClient(
             baseUrl: config.sfuUrl,
             sfuToken: config.sfuToken,
             sessionSeq: sessionSeq,
             tracer: tracer,
             retryPolicy: retryPolicy,
           ),
       sfuWS =
           sfuWS ??
           SfuWebSocket(
             sessionSeq: sessionSeq,
             sfuUrl: config.sfuUrl,
             sfuWsEndpoint: config.sfuWsEndpoint,
             sessionId: sessionId,
             cid: callCid.value,
             userId: host.currentUser.id,
             apiKey: host.apiKey,
           ),
       rtcManagerFactory =
           rtcManagerFactory ??
           RtcManagerFactory(
             sessionId: sessionId,
             callCid: callCid,
             configuration: config.rtcConfig,
             sdpEditor: sdpEditor,
             pcFactory: pcFactory,
           ) {
    _logger.i(() => '<init> callCid: $callCid, sessionId: $sessionId');
    _observeNetworkStatus();
  }

  @override
  late final _logger = taggedLogger(tag: '$_tag-$sessionSeq');

  late final _negotiator = PublisherNegotiator(
    sfuClient: sfuClient,
    sessionId: sessionId,
    rtcManager: () => rtcManager,
    isLeavingOrClosed: () => _isLeavingOrClosed,
    isCallDisconnected: () => stateManager.callState.status.isDisconnected,
    isSfuConnected: () => sfuWS.isConnected,
    onReconnectionNeeded: onReconnectionNeeded,
    logTag: '$_tag-$sessionSeq',
  );

  late final _signaling = SessionSignaling(
    sfuClient: sfuClient,
    sessionId: sessionId,
    rtcManager: () => rtcManager,
    negotiator: _negotiator,
    isLeavingOrClosed: () => _isLeavingOrClosed,
    isCallDisconnected: () => stateManager.callState.status.isDisconnected,
    logTag: '$_tag-$sessionSeq',
  );

  late final _watchdog = PublisherConnectionWatchdog(
    publisher: () => rtcManager?.publisher,
    negotiator: _negotiator,
    onReconnectionNeeded: onReconnectionNeeded,
    tracer: _tracer,
    isClosed: () => _isLeavingOrClosed,
    logTag: '$_tag-$sessionSeq',
  );

  late final _tracks = SessionTrackController(
    rtcManager: () => rtcManager,
    getTrack: getTrack,
    isAudioSuspended: () => stateManager.callState.isAudioSuspended,
    localParticipant: () => stateManager.callState.localParticipant,
    participants: () => stateManager.callState.callParticipants,
    audioOutputSelectedByUser: () => stateManager.audioOutputSelectedByUser,
    audioOutputDevice: () =>
        stateManager.callStateStream.value.audioOutputDevice,
    videoInputDevice: () => stateManager.callStateStream.value.videoInputDevice,
    onSuspendedAudioTrackRecorded: onSuspendedAudioTrackRecorded,
    setAudioOutputDevice: setAudioOutputDevice,
    setVideoInputDevice: setVideoInputDevice,
    setScreenShareEnabled: setScreenShareEnabled,
    sendMuteState: _signaling.sendMuteState,
    updateSubscriberTrack: stateManager.rtcUpdateSubscriberTrack,
    logTag: '$_tag-$sessionSeq',
  );

  late final _events = SfuEventRouter(
    stateManager: stateManager,
    rtcManager: () => rtcManager,
    signaling: _signaling,
    tracks: _tracks,
    statsReporter: () => statsReporter,
    tracer: _tracer,
    logTag: '$_tag-$sessionSeq',
  );

  late final _joinRequestBuilder = SfuJoinRequestBuilder(
    sessionId: sessionId,
    sfuToken: config.sfuToken,
    pcFactory: rtcManagerFactory.pcFactory,
    clientPublishOptions: clientPublishOptions,
  );

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

  /// {@macro onIceConnected}
  final OnIceConnected onIceConnected;
  final ClientPublishOptions? clientPublishOptions;
  final InternetConnection networkMonitor;
  final StatsOptions statsOptions;

  /// End-to-end encryption for this session, or `null` when the call is
  /// unencrypted. Handed to every [RtcManager] this session builds.
  final EncryptionManager? e2eeManager;

  final Tracer _tracer;
  @override
  final Tracer _zonedTracer = Tracer(null);
  final CallHost _host;

  final Duration joinResponseTimeout;

  /// How long a fast reconnect waits for the SFU to answer its join.
  final Duration fastReconnectJoinResponseTimeout;

  @override
  int zonedTracerSeq = 0;

  @override
  RtcManager? rtcManager;
  StreamSubscription<InternetStatus>? _networkStatusSubscription;

  StatsReporter? statsReporter;

  /// Called by [SessionTrackController] when an audio track arrives while
  /// audio is suspended. The owning [Call] uses this to record the track in
  /// its tracking map.
  final void Function(String trackId) onSuspendedAudioTrackRecorded;

  bool _isLeavingOrClosed = false;

  SharedEmitter<SfuEvent> get events => sfuWS.events;

  /// Whether the SFU signalling socket is connected.
  bool get isSfuConnected => sfuWS.isConnected;

  List<TraceSlice> getTrace() {
    return [_tracer.take(), _zonedTracer.take()];
  }

  void setTraceEnabled(bool enabled) {
    _tracer.setEnabled(enabled);
    _zonedTracer.setEnabled(enabled);
  }

  void trace(String tag, dynamic data) {
    _tracer.trace(tag, data);
  }

  void _observeNetworkStatus() {
    _networkStatusSubscription = networkMonitor.onStatusChange.listen((status) {
      _tracer.trace(TraceTag.networkChanged, status.name);
    });
  }

  Future<sfu_events.ReconnectDetails> getReconnectDetails(
    SfuReconnectionStrategy strategy, {
    String? migratingFromSfuId,
    int? reconnectAttempts,
    String? reason,
  }) async {
    return _joinRequestBuilder.buildReconnectDetails(
      strategy,
      announcedTracks: await rtcManager?.getAnnouncedTracksForReconnect(),
      subscriptions: dynascaleManager
          .getTrackSubscriptions(ignoreOverride: true)
          .values
          .toList(),
      migratingFromSfuId: migratingFromSfuId,
      reconnectAttempts: reconnectAttempts,
      reason: reason,
    );
  }

  Future<Result<({SfuCallState callState, Duration fastReconnectDeadline})>>
  start({
    sfu_events.ReconnectDetails? reconnectDetails,
    Set<SfuClientCapability> capabilities = const {},
    FutureOr<void> Function(RtcManager)? onRtcManagerCreatedCallback,
    bool isAnonymousUser = false,
    String? unifiedSessionId,
    int clientEventRetryCount = 0,
  }) async {
    final reporter = _host.clientEventReporter;
    final wsJoinDetails = ClientEventDetails(sfuId: config.sfuName);
    var wsJoinStageId = '';

    try {
      _logger.d(
        () =>
            '[start] reconnectDetails: $reconnectDetails, '
            'isAnonymousUser: $isAnonymousUser',
      );

      await _events.listen(sfuWS.events);
      // A close during the listen found nothing to dispose yet.
      if (_isLeavingOrClosed) {
        await _events.dispose();
        return _rejectClosedStart('during listen');
      }

      wsJoinStageId = reporter.beginStage(
        callCid,
        ClientEventStage.wsJoin,
        details: wsJoinDetails,
      );

      final wsResult = await sfuWS.connect();
      if (wsResult is Failure) {
        reporter.failStageWithError(
          wsJoinStageId,
          wsResult.error,
          details: wsJoinDetails,
          retryCount: clientEventRetryCount,
        );
        _logger.e(() => '[start] ws connect failed: $wsResult');
        return const Result.failure(
          StreamVideoException(message: 'Failed to connect to WS'),
        );
      }

      _logger.v(() => '[start] sfu connected');

      final joinRequest = await _joinRequestBuilder.build(
        reconnectDetails: reconnectDetails,
        capabilities: capabilities,
        unifiedSessionId: unifiedSessionId,
        currentPublishOptions: rtcManager?.publishOptions,
      );

      _logger.v(
        () =>
            '[start] subscriberSdp.len: ${joinRequest.subscriberSdp.length}, '
            'publisherSdp.len: ${joinRequest.publisherSdp.length}',
      );

      _tracer.trace(TraceTag.joinRequest, joinRequest.toJson());

      _logger.v(() => '[start] wait for SfuJoinResponseEvent');
      final joined = await _joinSfu(
        joinRequest,
        timeLimit: joinResponseTimeout,
      );
      if (joined is Failure) {
        _failJoinStage(
          joined.videoError,
          stageId: wsJoinStageId,
          details: wsJoinDetails,
          retryCount: clientEventRetryCount,
        );
        return Result.failure(joined.videoError);
      }

      final event = joined.getDataOrNull()!;

      reporter.completeStage(
        wsJoinStageId,
        outcome: ClientEventOutcome.success,
        details: wsJoinDetails,
        retryCount: clientEventRetryCount,
      );

      _logger.v(() => '[start] sfu joined: $event');

      // Ensure WebRTC initialization completes before creating rtcManager
      await _host.webrtcInitialized;

      if (_isLeavingOrClosed) return _rejectClosedStart('before rtcManager');

      final createdRtcManager = await _makeRtcManager(
        event,
        isAnonymousUser: isAnonymousUser,
        clientEventRetryCount: clientEventRetryCount,
      );

      // A close during its creation found no rtcManager to dispose, so this
      // one would be left running.
      if (_isLeavingOrClosed) {
        await createdRtcManager.dispose().catchError((Object e) {
          _logger.w(() => '[start] rtcManager.dispose failed: $e');
        });
        return _rejectClosedStart('during rtcManager creation');
      }

      rtcManager = createdRtcManager;

      await onRtcManagerCreatedCallback?.call(createdRtcManager);

      if (_isLeavingOrClosed) return _rejectClosedStart('after rtcManager');

      _events.attachManager(createdRtcManager);
      _events.applyJoinedCallState(event.callState);
      statsReporter = _makeStatsReporter(createdRtcManager);

      _logger.d(() => '[start] completed');
      return Result.success(
        (
          callState: event.callState,
          fastReconnectDeadline: event.fastReconnectDeadline,
        ),
      );
    } catch (e, stk) {
      reporter.failStageWithError(
        wsJoinStageId,
        e,
        details: wsJoinDetails,
        retryCount: clientEventRetryCount,
      );
      _logger.e(() => '[start] failed: $e');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Makes the manager for the joined session and wires it to this session.
  ///
  /// An anonymous user gets a manager without a publisher connection, so
  /// nothing it publishes is sent.
  Future<RtcManager> _makeRtcManager(
    SfuJoinResponseEvent event, {
    required bool isAnonymousUser,
    required int clientEventRetryCount,
  }) async {
    final publisherId = isAnonymousUser ? null : _localTrackLookupPrefix(event);

    final created = await rtcManagerFactory.makeRtcManager(
      sfuClient: sfuClient,
      host: _host,
      stateManager: stateManager,
      publisherId: publisherId,
      publishOptions: event.publishOptions,
      clientDetails: clientDetails,
      sessionSequence: sessionSeq,
      statsOptions: statsOptions,
      callSessionConfig: config,
      clientEventRetryCount: clientEventRetryCount,
      e2eeManager: e2eeManager,
    );

    return created
      ..onPublisherIceCandidate = _signaling.onLocalIceCandidate
      ..onSubscriberIceCandidate = _signaling.onLocalIceCandidate
      ..onLocalTrackMuted = _signaling.sendMuteState
      ..onLocalTrackPublished = _tracks.onLocalTrackPublished
      ..onReconnectionNeeded = onReconnectionNeeded
      ..onIceConnected = onIceConnected
      ..onRenegotiationNeeded = _negotiator.negotiateOrRecover
      ..onRemoteTrackReceived = _tracks.onRemoteTrackReceived;
  }

  /// The track lookup prefix the SFU gave this session's participant.
  String _localTrackLookupPrefix(SfuJoinResponseEvent event) {
    final currentUserId = stateManager.callState.currentUserId;
    final localParticipant = event.callState.participants.firstWhere(
      (it) => it.userId == currentUserId && it.sessionId == sessionId,
    );
    final localTrackId = localParticipant.trackLookupPrefix;

    _logger.v(() => '[start] localTrackId: $localTrackId');
    return localTrackId;
  }

  StatsReporter _makeStatsReporter(RtcManager rtcManager) {
    final environment = ClientEnvironment(
      sfu: config.sfuUrl,
      sdkVersion: streamVideoVersion,
      webRtcVersion: switch (CurrentPlatform.type) {
        PlatformType.android => androidWebRTCVersion,
        PlatformType.ios => iosWebRTCVersion,
        PlatformType.macOS => macOsWebRTCVersion,
        PlatformType.windows => windowsWebRTCVersion,
        PlatformType.linux => linuxWebRTCVersion,
        _ => '',
      },
    );

    return StatsReporter(
      rtcManager: rtcManager,
      clientEnvironment: environment,
    );
  }

  Result<T> _rejectClosedStart<T>(String step) {
    _logger.w(() => '[start] rejected (session closed $step)');
    return failureWithError<T>('session closed $step');
  }

  /// Sends [request] and waits up to [timeLimit] for the SFU to answer it.
  ///
  /// Fails at once when the request cannot be sent, the SFU answers with an
  /// error or the socket closes; a timeout fails with a [TimeoutException]
  /// cause.
  Future<Result<SfuJoinResponseEvent>> _joinSfu(
    sfu_events.JoinRequest request, {
    required Duration timeLimit,
  }) {
    final sent = sfuWS.send(sfu_events.SfuRequest(joinRequest: request));
    if (sent is Failure) {
      return Future.value(
        failureWithError('Join request not sent: ${sent.videoError.message}'),
      );
    }

    // Nothing is awaited between sending and subscribing, so the answer
    // cannot slip past.
    return sfuWS.waitForJoinResponse(timeLimit: timeLimit);
  }

  /// Fails the `wsJoin` stage with [error], as a request timeout when the SFU
  /// did not answer in time.
  void _failJoinStage(
    StreamVideoException error, {
    required String stageId,
    required ClientEventDetails details,
    required int retryCount,
  }) {
    final reporter = _host.clientEventReporter;
    final cause = error is StreamVideoExceptionWithCause ? error.cause : null;

    if (cause is TimeoutException) {
      reporter.failStage(
        stageId,
        failure: ClientEventFailure.requestTimeout(error.message),
        details: details,
        retryCount: retryCount,
      );
      _tracer.trace(TraceTag.joinRequestTimeout, error.message);
    } else {
      reporter.failStageWithError(
        stageId,
        error,
        details: details,
        retryCount: retryCount,
      );
    }

    _logger.e(() => '[start] join failed: $error');
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
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Resumes this session on a new socket.
  ///
  /// Fails when the socket cannot be recreated, the join is not answered, or
  /// the SFU did not resume the session. A resumed join restarts the
  /// publisher's ICE, renegotiates it and replays the remote tracks; the
  /// result is the renegotiation's failure if it failed, else the join.
  Future<Result<({SfuCallState callState, Duration fastReconnectDeadline})?>>
  fastReconnect({
    required sfu_events.ReconnectDetails reconnectDetails,
    Set<SfuClientCapability> capabilities = const {},
    String? unifiedSessionId,
  }) async {
    rtcManager?.subscriber.setReconnecting(true);
    rtcManager?.publisher?.setReconnecting(true);

    try {
      _logger.d(() => '[fastReconnect] no args');

      _tracer.trace(TraceTag.fastReconnect, reconnectDetails.toJson());

      final joined = await _rejoinSfu(
        reconnectDetails: reconnectDetails,
        capabilities: capabilities,
        unifiedSessionId: unifiedSessionId,
      );
      if (joined is Failure) {
        final error = joined.videoError;
        _logger.w(() => '[fastReconnect] failed: $error');
        _tracer.trace(TraceTag.fastReconnectFailure, error.toString());
        return Result.failure(error);
      }

      final event = joined.getDataOrNull()!;
      _logger.v(() => '[fastReconnect] fast-reconnect done');
      _events.applyJoinedCallState(event.callState);

      final renegotiation = await _restartPublisher();
      await _tracks.replayRemoteTracks();

      final result = renegotiation is Failure
          ? renegotiation
          : Result.success(
              (
                callState: event.callState,
                fastReconnectDeadline: event.fastReconnectDeadline,
              ),
            );

      if (result.isSuccess) {
        _tracer.trace(TraceTag.fastReconnectSuccess, null);
      } else {
        _tracer.trace(
          TraceTag.fastReconnectFailure,
          result.getErrorOrNull()?.toString(),
        );
      }

      return result;
    } catch (e, stk) {
      _logger.e(() => '[fastReconnect] failed: $e');
      _tracer.trace(TraceTag.fastReconnectFailure, e.toString());
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    } finally {
      rtcManager?.subscriber.setReconnecting(false);
      rtcManager?.publisher?.setReconnecting(false);
    }
  }

  /// Recreates the socket and joins on it, failing unless the SFU resumed
  /// this session.
  Future<Result<SfuJoinResponseEvent>> _rejoinSfu({
    required sfu_events.ReconnectDetails reconnectDetails,
    required Set<SfuClientCapability> capabilities,
    required String? unifiedSessionId,
  }) async {
    // Fails before the socket is touched when the SDPs cannot be made.
    await _joinRequestBuilder.prepareSdps();

    _logger.d(() => '[fastReconnect] sfu not connected, recreating');
    final wsResult = await sfuWS.recreate();
    if (wsResult is Failure) {
      return failureWithError(
        'SFU WS reconnect failed: ${wsResult.videoError.message}',
      );
    }

    _logger.d(() => '[fastReconnect] sfu connected, sending join request');
    // Reads the publish options as they are once the socket is back.
    final joinRequest = await _joinRequestBuilder.build(
      reconnectDetails: reconnectDetails,
      capabilities: capabilities,
      unifiedSessionId: unifiedSessionId,
      currentPublishOptions: rtcManager?.publishOptions,
    );

    _logger.v(() => '[fastReconnect] wait for SfuJoinResponseEvent');
    final joinResponse = await _joinSfu(
      joinRequest,
      timeLimit: fastReconnectJoinResponseTimeout,
    );
    if (joinResponse is Failure) return joinResponse;

    final event = joinResponse.getDataOrNull()!;
    if (!event.isReconnected) {
      return const Result.failure(SfuSessionNotResumedException());
    }

    return joinResponse;
  }

  /// Restarts the publisher's ICE and renegotiates it, if there is one.
  Future<Result<void>> _restartPublisher() async {
    _logger.v(() => '[fastReconnect] restarting ICE');
    await rtcManager?.publisher?.pc.restartIce();

    final publisher = rtcManager?.publisher;
    if (publisher == null) return const Result.success(null);

    _logger.v(() => '[fastReconnect] triggering publisher renegotiation');
    final renegotiation = await _negotiator.negotiate(publisher);
    if (renegotiation is Failure) {
      _logger.w(
        () =>
            '[fastReconnect] publisher renegotiation failed: '
            '${renegotiation.error}',
      );
    }

    return renegotiation;
  }

  /// Arms the [PublisherConnectionWatchdog] check that the publisher
  /// finished connecting.
  void startPublisherConnectionCheck() => _watchdog.start();

  void leave({String? reason}) {
    _logger.d(() => '[leave] reason: $reason');
    _isLeavingOrClosed = true;
    _tracer.trace(TraceTag.callLeave, reason);
    sfuWS.leave(sessionId: sessionId, reason: reason);
  }

  Future<void> close(
    CloseCode code, {
    String? closeReason,
  }) async {
    _logger.d(
      () => '[close] code: $code, closeReason: $closeReason',
    );
    _isLeavingOrClosed = true;

    _watchdog.cancel();

    await _events.dispose();
    await _networkStatusSubscription?.cancel();

    statsReporter?.dispose();
    statsReporter = null;

    _tracer.dispose();

    unawaited(
      sfuWS
          .disconnect(
            code,
            'dart-client: $closeReason',
          )
          .catchError((Object e, StackTrace stk) {
            _logger.w(() => '[close] sfuWS.disconnect failed: $e');
            return const Result.success(none);
          }),
    );

    if (rtcManager != null) {
      await rtcManager!.dispose().catchError((
        Object e,
        StackTrace stk,
      ) {
        _logger.w(() => '[close] rtcManager.dispose failed: $e');
      });

      rtcManager = null;
      // Held only to be compared against, so it must not outlive what it names.
      _events.forgetJoinedManager();
    }
  }

  @override
  Future<void> dispose() async {
    _logger.d(() => '[dispose] no args');
    _isLeavingOrClosed = true;

    await close(CloseCode.normalClosure);
    return await super.dispose();
  }

  /// Whether the subject that holds SFU events back until `start` sets the
  /// manager is closed; `true` before the first `start`. Tests only.
  @visibleForTesting
  bool get debugIsRtcManagerSubjectClosed => _events.isManagerSubjectClosed;

  /// Routes [event] through the SFU event handling. Tests only.
  @visibleForTesting
  Future<void> debugHandleSfuEvent(SfuEvent event) => _events.onEvent(event);

  /// Negotiates [pc], escalating an unresolved track mid.
  @visibleForTesting
  Future<void> negotiateOrRecover(StreamPeerConnection pc) =>
      _negotiator.negotiateOrRecover(pc);

  /// Re-applies the audio session configuration last applied, if any.
  @internal
  Future<Result<None>> restoreAudioSession() async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) {
      return failureWithError('Call not connected');
    }

    return rtcManager.restoreAudioSession();
  }

  /// Re-applies the audio output the user selected, if any.
  @internal
  Future<void> applyCurrentAudioOutputDevice() =>
      _tracks.applyCurrentAudioOutputDevice();

  /// Resumes audio tracks that were suspended or arrived during suspension.
  Future<void> resumeSuspendedAudioTracks(
    Map<String, SuspendedTrackState> priorStates,
  ) => _tracks.resumeSuspendedAudioTracks(priorStates);

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
