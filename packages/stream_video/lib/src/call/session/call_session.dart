import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:synchronized/synchronized.dart';

import '../../../globals.dart';
import '../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../../stream_video.dart';
import '../../errors/stream_video_exception_composer.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../sfu/data/models/sfu_call_state.dart';
import '../../sfu/data/models/sfu_model_mapper_extensions.dart';
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
import 'publisher_negotiator.dart';
import 'sfu_join_request_builder.dart';

part 'call_session_media.dart';

const _tag = 'SV:CallSession';

const _migrationCompleteEventTimeout = Duration(seconds: 7);
const _publisherConnectionCheckDelay = Duration(seconds: 15);

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

  final Lock _sfuEventsLock = Lock();

  @override
  int zonedTracerSeq = 0;

  @override
  RtcManager? rtcManager;
  BehaviorSubject<RtcManager>? _rtcManagerSubject;
  StreamSubscription<SfuEvent>? _eventsSubscription;
  StreamSubscription<InternetStatus>? _networkStatusSubscription;

  StatsReporter? statsReporter;

  /// Called by [_onLocalTrackPublished] and [_onRemoteTrackReceived] when an
  /// audio track arrives while audio is suspended. The owning [Call] uses this
  /// to record the track in its tracking map.
  final void Function(String trackId) onSuspendedAudioTrackRecorded;

  Timer? _publisherConnectionCheckTimer;

  bool _isLeavingOrClosed = false;

  /// The manager whose subscriber the last join response was applied against.
  RtcManager? _joinedRtcManager;

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

      await _eventsSubscription?.cancel();
      await _rtcManagerSubject?.close();

      _rtcManagerSubject = BehaviorSubject();

      // Buffer sfu events until rtc manager is set
      final bufferedStream = sfuWS.events
          .takeWhile((_) => !_rtcManagerSubject!.hasValue)
          .buffer(_rtcManagerSubject!)
          .expand((event) => event);

      // Delay rest of the sfu events until rtc manager is set
      final delayedStream = Rx.combineLatest2(
        _rtcManagerSubject!,
        sfuWS.events,
        (_, event) => event,
      ).skip(1);

      // Handle buffered events and then listen to sfu events as normal
      _eventsSubscription = bufferedStream
          .mergeWith([delayedStream])
          .listen(_onSfuEvent);

      wsJoinStageId = reporter.beginStage(
        callCid,
        ClientEventStage.wsJoin,
        details: wsJoinDetails,
      );

      final wsResult = await sfuWS.connect();
      if (wsResult.isFailure) {
        reporter.failStageWithError(
          wsJoinStageId,
          (wsResult as Failure).error,
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

      final RtcManager createdRtcManager;
      if (isAnonymousUser) {
        createdRtcManager =
            await rtcManagerFactory.makeRtcManager(
                sfuClient: sfuClient,
                host: _host,
                stateManager: stateManager,
                clientDetails: clientDetails,
                sessionSequence: sessionSeq,
                statsOptions: statsOptions,
                callSessionConfig: config,
                publishOptions: event.publishOptions,
                clientEventRetryCount: clientEventRetryCount,
                e2eeManager: e2eeManager,
              )
              ..onSubscriberIceCandidate = _onLocalIceCandidate
              ..onRenegotiationNeeded = _negotiator.negotiateOrRecover
              ..onReconnectionNeeded = onReconnectionNeeded
              ..onIceConnected = onIceConnected
              ..onRemoteTrackReceived = _onRemoteTrackReceived;
      } else {
        final currentUserId = stateManager.callState.currentUserId;
        final localParticipant = event.callState.participants.firstWhere(
          (it) => it.userId == currentUserId && it.sessionId == sessionId,
        );
        final localTrackId = localParticipant.trackLookupPrefix;

        _logger.v(() => '[start] localTrackId: $localTrackId');

        createdRtcManager =
            await rtcManagerFactory.makeRtcManager(
                sfuClient: sfuClient,
                host: _host,
                stateManager: stateManager,
                publisherId: localTrackId,
                publishOptions: event.publishOptions,
                clientDetails: clientDetails,
                sessionSequence: sessionSeq,
                statsOptions: statsOptions,
                callSessionConfig: config,
                clientEventRetryCount: clientEventRetryCount,
                e2eeManager: e2eeManager,
              )
              ..onPublisherIceCandidate = _onLocalIceCandidate
              ..onSubscriberIceCandidate = _onLocalIceCandidate
              ..onLocalTrackMuted = _onLocalTrackMuted
              ..onLocalTrackPublished = _onLocalTrackPublished
              ..onReconnectionNeeded = onReconnectionNeeded
              ..onIceConnected = onIceConnected
              ..onRenegotiationNeeded = _negotiator.negotiateOrRecover
              ..onRemoteTrackReceived = _onRemoteTrackReceived;
      }

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

      _rtcManagerSubject!.add(createdRtcManager);

      _applyJoinResponse(event);

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

      statsReporter = StatsReporter(
        rtcManager: createdRtcManager,
        clientEnvironment: environment,
      );

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

  void _applyJoinResponse(SfuJoinResponseEvent event) {
    stateManager.sfuPinsUpdated(event.callState.pins);
    stateManager.sfuE2eeEnabledUpdated(event.callState.e2eeEnabled);
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

      Result<({SfuCallState callState, Duration fastReconnectDeadline})?>?
      result;

      // Every way out of here before the join settles is a failure worth
      // seeing in the trace: these are the ones that left no mark before.
      Result<Never> failed(StreamVideoException error) {
        _logger.w(() => '[fastReconnect] failed: $error');
        _tracer.trace(TraceTag.fastReconnectFailure, error.toString());
        return Result.failure(error);
      }

      // Fails before the socket is touched when the SDPs cannot be made.
      await _joinRequestBuilder.prepareSdps();

      _logger.d(() => '[fastReconnect] sfu not connected, recreating');
      final wsResult = await sfuWS.recreate();
      if (wsResult is Failure) {
        return failed(
          StreamVideoException(
            message: 'SFU WS reconnect failed: ${wsResult.videoError.message}',
          ),
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
      if (joinResponse is Failure) {
        return failed(joinResponse.videoError);
      }

      final event = joinResponse.getDataOrNull()!;
      if (!event.isReconnected) {
        return failed(const SfuSessionNotResumedException());
      }

      _logger.v(() => '[fastReconnect] fast-reconnect done');

      _applyJoinResponse(event);

      result = Result.success(
        (
          callState: event.callState,
          fastReconnectDeadline: event.fastReconnectDeadline,
        ),
      );

      _logger.v(() => '[fastReconnect] restarting ICE');
      await rtcManager?.publisher?.pc.restartIce();

      final publisher = rtcManager?.publisher;
      if (publisher != null) {
        _logger.v(() => '[fastReconnect] triggering publisher renegotiation');
        final renegotiation = await _negotiator.negotiate(publisher);
        if (renegotiation is Failure) {
          _logger.w(
            () =>
                '[fastReconnect] publisher renegotiation failed: '
                '${renegotiation.error}',
          );
          result = renegotiation;
        }
      }

      final remoteTracks = rtcManager!.remoteTracks.values;

      for (final track in remoteTracks) {
        await _onRemoteTrackReceived(rtcManager!.subscriber, track);
      }

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

  /// Checks after [_publisherConnectionCheckDelay] that the publisher finished
  /// connecting.
  ///
  /// Recovers two stalls: ICE still `new` (likely no SDP answer) → rejoin;
  /// signaling `have-local-offer` (SetPublisher incomplete, no further
  /// negotiation) → renegotiate, then rejoin if needed.
  void startPublisherConnectionCheck() {
    _publisherConnectionCheckTimer?.cancel();

    _publisherConnectionCheckTimer = Timer(
      _publisherConnectionCheckDelay,
      () async {
        if (_isLeavingOrClosed) return;

        final publisher = rtcManager?.publisher;
        if (publisher == null) return;

        final iceState = publisher.pc.iceConnectionState;
        if (iceState == rtc.RTCIceConnectionState.RTCIceConnectionStateNew) {
          _logger.w(
            () =>
                '[publisherConnectionCheck] publisher ICE still in "new" '
                'state after ${_publisherConnectionCheckDelay.inSeconds}s '
                '— triggering reconnection',
          );
          _tracer.trace(TraceTag.publisherConnectionCheckStalled, {
            'iceState': iceState.toString(),
            'timeoutSeconds': _publisherConnectionCheckDelay.inSeconds,
          });

          onReconnectionNeeded(
            publisher,
            SfuReconnectionStrategy.rejoin,
            ReconnectionNeededReason.stuck,
          );
          return;
        }

        // Signaling stall: local offer created but SetPublisher never completed,
        // leaving the peer connection wedged in `have-local-offer`. Negotiation
        // won't resume on its own, so renegotiate and fall back to a reconnect
        // if the recovery fails.
        final signalingState = publisher.pc.signalingState;
        if (signalingState ==
            rtc.RTCSignalingState.RTCSignalingStateHaveLocalOffer) {
          _logger.w(
            () =>
                '[publisherConnectionCheck] publisher stuck in '
                '"have-local-offer" after '
                '${_publisherConnectionCheckDelay.inSeconds}s — renegotiating',
          );
          _tracer.trace(TraceTag.publisherConnectionCheckStalled, {
            'signalingState': signalingState.toString(),
            'timeoutSeconds': _publisherConnectionCheckDelay.inSeconds,
          });

          final result = await _negotiator.negotiate(publisher);
          if (result.isFailure && !_isLeavingOrClosed) {
            _logger.w(
              () =>
                  '[publisherConnectionCheck] recovery renegotiation failed '
                  '(${result.getErrorOrNull()}) — triggering fast reconnect',
            );
            onReconnectionNeeded(
              publisher,
              SfuReconnectionStrategy.fast,
              ReconnectionNeededReason.stuck,
            );
          }
          return;
        }

        _logger.v(
          () =>
              '[publisherConnectionCheck] publisher ICE state: '
              '$iceState — OK',
        );
      },
    );
  }

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

    _publisherConnectionCheckTimer?.cancel();

    await _eventsSubscription?.cancel();
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
      _joinedRtcManager = null;
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
  bool get debugIsRtcManagerSubjectClosed =>
      _rtcManagerSubject?.isClosed ?? true;

  /// Routes [event] through the SFU event handling. Tests only.
  @visibleForTesting
  Future<void> debugHandleSfuEvent(SfuEvent event) => _onSfuEvent(event);

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
        _tracer.trace(TraceTag.trackPublished, event.toJson());
        await _onTrackPublished(event);
      } else if (event is SfuTrackUnpublishedEvent) {
        _tracer.trace(TraceTag.trackUnpublished, event.toJson());
        await _onTrackUnpublished(event);
      } else if (event is SfuChangePublishQualityEvent) {
        _tracer.trace(TraceTag.changePublishQuality, event.toJson());
        await _onPublishQualityChanged(event);
      } else if (event is SfuChangePublishOptionsEvent) {
        _tracer.trace(TraceTag.changePublishOptions, event.toJson());
        await _onPublishOptionsChanged(event);
      } else if (event is SfuIceRestartEvent) {
        await _onIceRestart(event);
      } else if (event is SfuGoAwayEvent) {
        _tracer.trace(TraceTag.goAway, event.toJson());
      } else if (event is SfuErrorEvent) {
        _tracer.trace(TraceTag.error, event.toJson());
      } else if (event is SfuCallEndedEvent) {
        _tracer.trace(TraceTag.callEnded, event.toJson());
      }

      if (event is SfuJoinResponseEvent) {
        final manager = rtcManager;
        stateManager.sfuJoinResponse(
          event,
          subscriberReused:
              event.isReconnected &&
              manager != null &&
              identical(manager, _joinedRtcManager),
        );
        _joinedRtcManager = manager;
        // The participant list just landed, so tracks that arrived before it
        // can finally resolve a user id and attach their decryptor.
        await rtcManager?.flushPendingDecryptors();
      } else if (event is SfuParticipantJoinedEvent) {
        stateManager.sfuParticipantJoined(event);
        await rtcManager?.flushPendingDecryptors();
      } else if (event is SfuParticipantUpdatedEvent) {
        stateManager.sfuParticipantUpdated(event);
      } else if (event is SfuTrackPublishedEvent) {
        stateManager.sfuTrackPublished(event);
        await rtcManager?.flushPendingDecryptors();
      } else if (event is SfuParticipantLeftEvent) {
        stateManager.sfuParticipantLeft(event);
        rtcManager?.discardPendingDecryptors(
          event.participant.trackLookupPrefix,
        );
      } else if (event is SfuConnectionQualityChangedEvent) {
        _tracer.trace(TraceTag.connectionQualityChanged, event.toJson());
        stateManager.sfuConnectionQualityChanged(event);
      } else if (event is SfuAudioLevelChangedEvent) {
        stateManager.sfuUpdateAudioLevelChanged(event);
      } else if (event is SfuTrackUnpublishedEvent) {
        stateManager.sfuTrackUnpublished(event);
      } else if (event is SfuDominantSpeakerChangedEvent) {
        stateManager.sfuDominantSpeakerChanged(event);
      } else if (event is SfuPinsUpdatedEvent) {
        stateManager.sfuPinsUpdated(event.pins);
      } else if (event is SfuInboundStateNotificationEvent) {
        _tracer.trace(TraceTag.inboundVideoState, event.toJson());
        stateManager.sfuInboundStateNotification(event);
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
      return failureWithError('Participant not found: $userId:$sessionId');
    }

    final trackIdPrefix = participant.trackIdPrefix;
    final track = getTrack(trackIdPrefix, trackType);

    // If the track is not found, return an error.
    if (track == null) {
      return failureWithError('Track not found: $trackIdPrefix:$trackType');
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

    if (track.isAudioTrack && stateManager.callState.isAudioSuspended) {
      _logger.d(
        () =>
            '[onTrackPublished] audio suspended, '
            'disabling and skipping start for audio track ${track.trackId}',
      );
      _suspendAudioTrack(track);
    } else {
      await track.start();

      if (track.isAudioTrack) {
        await applyCurrentAudioOutputDevice();
      }
    }
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
    if (track is! RtcRemoteTrack) {
      final localTrack = rtcManager?.getTrack(track.trackId);
      if (localTrack != null &&
          localTrack.isScreenShareTrack &&
          localTrack.mediaTrack.enabled) {
        // If the unpublished track is a local screen share track and it's still enabled,
        // disable screen sharing. It means the screen sharing was muted by the server.
        await setScreenShareEnabled(false);
      }

      return;
    }

    await track.stop(disposeWebAudioPlayer: false);
  }

  Future<void> _onPublishQualityChanged(
    SfuChangePublishQualityEvent event,
  ) async {
    _logger.d(() => '[onPublishQualityChanged] event: $event');

    final usedCodec =
        statsReporter?.currentMetrics?.publisher?.videoCodec?.firstOrNull;

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
    if (_isLeavingOrClosed || stateManager.callState.status.isDisconnected) {
      _logger.w(
        () => '[onSubscriberOffer] rejected (session is disconnecting)',
      );
      return;
    }

    final offerSdp = event.sdp;
    _logger.v(() => '[onSubscriberOffer] event: $event');

    final answerSdp = await rtcManager?.onSubscriberOffer(offerSdp);
    if (answerSdp == null) {
      _logger.w(() => '[onSubscriberOffer] rejected (answerSdp is null)');
      return;
    }

    // The session can leave or close while the answer is created; the SFU no
    // longer expects one then.
    if (_isLeavingOrClosed) {
      _logger.w(() => '[onSubscriberOffer] dropped (session left mid-offer)');
      return;
    }

    final result = await sfuClient.sendAnswer(
      sfu.SendAnswerRequest(
        sdp: answerSdp,
        sessionId: sessionId,
        peerType: sfu_models.PeerType.PEER_TYPE_SUBSCRIBER,
        negotiationId: event.negotiationId,
      ),
    );
    _logger.v(() => '[onSubscriberOffer] result: $result');
  }

  Future<void> _onIceRestart(SfuIceRestartEvent event) async {
    _logger.d(() => '[onIceRestart] event: $event');

    final peerType = event.peerType;

    if (peerType == StreamPeerType.publisher) {
      final publisher = rtcManager?.publisher;
      if (publisher == null) {
        _logger.w(() => '[onIceRestart] publisher peer connection is null');
        return;
      }

      _logger.i(() => '[onIceRestart] restarting ICE for publisher');
      final result = await publisher.restartIce();
      _logger.d(() => '[onIceRestart] publisher ICE restart result: $result');

      // After marking ICE restart, explicitly trigger renegotiation to create
      // a new offer with fresh ICE credentials and send it to the SFU.
      // pc.restartIce() only sets a flag; we must create and send the offer.
      //
      // Use unawaited so we don't hold _sfuEventsLock during the SetPublisher
      // HTTP call.
      _logger.i(() => '[onIceRestart] triggering publisher renegotiation');
      unawaited(
        _negotiator.negotiateOrRecover(publisher).catchError((
          Object e,
          StackTrace stk,
        ) {
          _logger.e(
            () => '[onIceRestart] publisher renegotiation error: $e\n$stk',
          );
        }),
      );
    } else if (peerType == StreamPeerType.subscriber) {
      final subscriber = rtcManager?.subscriber;
      if (subscriber == null) {
        _logger.w(() => '[onIceRestart] subscriber peer connection is null');
        return;
      }

      _logger.i(() => '[onIceRestart] restarting ICE for subscriber');
      final result = await subscriber.restartIce();
      _logger.d(() => '[onIceRestart] subscriber ICE restart result: $result');
    } else {
      _logger.w(() => '[onIceRestart] unknown peer type: $peerType');
    }
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
    final state = stateManager.callStateStream.value;
    final videoInputDevice = state.videoInputDevice;
    if (videoInputDevice != null) {
      await setVideoInputDevice(videoInputDevice);
    }
  }

  Future<void> _onLocalTrackPublished(RtcLocalTrack track) async {
    _logger.d(() => '[onPublisherTrackPublished] track: $track');

    if (track.isAudioTrack && stateManager.callState.isAudioSuspended) {
      _logger.d(
        () =>
            '[onPublisherTrackPublished] audio suspended, '
            'disabling and skipping start for audio track ${track.trackId}',
      );
      _suspendAudioTrack(track);
    } else {
      await track.start();

      if (track.isAudioTrack) {
        await applyCurrentAudioOutputDevice();
      }
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

  /// Negotiates [pc], escalating an unresolved track mid.
  @visibleForTesting
  Future<void> negotiateOrRecover(StreamPeerConnection pc) =>
      _negotiator.negotiateOrRecover(pc);

  Future<void> _onRemoteTrackReceived(
    StreamPeerConnection pc,
    RtcRemoteTrack remoteTrack,
  ) async {
    _logger.d(() => '[onRemoteTrackReceived] remoteTrack: $remoteTrack');

    if (remoteTrack.isAudioTrack && stateManager.callState.isAudioSuspended) {
      _logger.d(
        () =>
            '[onRemoteTrackReceived] audio suspended, '
            'disabling and skipping start for audio track ${remoteTrack.trackId}',
      );
      _suspendAudioTrack(remoteTrack);
    } else {
      await remoteTrack.start();

      if (remoteTrack.isAudioTrack) {
        await applyCurrentAudioOutputDevice();
      }
    }

    return stateManager.rtcUpdateSubscriberTrack(
      trackIdPrefix: remoteTrack.trackIdPrefix,
      trackType: remoteTrack.trackType,
    );
  }

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
  Future<void> applyCurrentAudioOutputDevice() async {
    // Only re-apply an output the user explicitly selected.
    if (!stateManager.audioOutputSelectedByUser) return;

    final state = stateManager.callStateStream.value;
    final audioOutputDevice = state.audioOutputDevice;
    if (audioOutputDevice == null) return;

    final result = await setAudioOutputDevice(audioOutputDevice);
    if (result is Failure) {
      _logger.w(
        () =>
            '[applyCurrentAudioOutputDevice] ${audioOutputDevice.id} not '
            'applied: ${result.videoError.message}',
      );
    }
  }

  /// Disables a freshly-received audio track and records it so
  /// [resumeSuspendedAudioTracks] can re-enable it on resume.
  void _suspendAudioTrack(RtcTrack track) {
    track.disable();
    onSuspendedAudioTrackRecorded(track.trackId);
  }

  /// Whether [track] is the local microphone track and the SDK currently
  /// considers it muted.
  bool _isMutedLocalMicrophoneTrack(RtcTrack track) {
    if (track is! RtcLocalTrack) return false;
    if (track.trackType != SfuTrackType.audio) return false;

    final localParticipant = stateManager.callState.localParticipant;
    if (localParticipant == null) {
      // Warned about because the resume that follows is indistinguishable
      // from a legitimate mute in a customer log.
      _logger.w(
        () =>
            '[isMutedLocalMicrophoneTrack] no local participant in state, '
            'treating ${track.trackId} as muted',
      );
      return true;
    }

    return !localParticipant.isAudioEnabled;
  }

  /// Resumes audio tracks that were suspended or arrived during suspension.
  Future<void> resumeSuspendedAudioTracks(
    Map<String, SuspendedTrackState> priorStates,
  ) async {
    final rtcManager = this.rtcManager;
    if (rtcManager == null) return;

    final tracks = <String, RtcTrack>{
      ...rtcManager.localTracks,
      ...rtcManager.remoteTracks,
    };
    for (final trackId in tracks.keys) {
      // Read again: an earlier track's resume awaits, and meanwhile this one
      // may have been removed or replaced under the same id.
      final track = rtcManager.getTrack(trackId);
      if (track == null || !track.isAudioTrack) continue;

      final prior = priorStates[trackId];
      if (prior == null) continue;

      await _resumeSuspendedAudioTrack(trackId, track, prior);
    }
  }

  Future<void> _resumeSuspendedAudioTrack(
    String trackId,
    RtcTrack track,
    SuspendedTrackState prior,
  ) async {
    switch (prior) {
      case SuspendedTrackState.wasEnabled:
        // [priorStates] is a snapshot, user may have muted since.
        // Re-enabling could make the mic live while UI/SDK show muted, especially on iOS/macOS.
        if (_isMutedLocalMicrophoneTrack(track)) {
          _logger.d(
            () =>
                '[resumeSuspendedAudioTracks] track $trackId was muted '
                'during the suspension, leaving disabled',
          );
          return;
        }

        track.enable();
        _logger.d(
          () => '[resumeSuspendedAudioTracks] re-enabled track $trackId',
        );
      case SuspendedTrackState.neverStarted:
        // For local mic tracks published during suspension, starting here
        // could make the mic live even if muted in the SDK/UI.
        if (_isMutedLocalMicrophoneTrack(track)) {
          _logger.d(
            () =>
                '[resumeSuspendedAudioTracks] track $trackId was muted '
                'during the suspension, leaving unstarted',
          );
          return;
        }

        await track.start();
        await applyCurrentAudioOutputDevice();
        _logger.d(
          () => '[resumeSuspendedAudioTracks] started track $trackId',
        );
      case SuspendedTrackState.wasDisabled:
        _logger.v(
          () =>
              '[resumeSuspendedAudioTracks] track $trackId was '
              'disabled before suspension, leaving disabled',
        );
    }
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
