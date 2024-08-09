// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../stream_video.dart';
import '../../version.g.dart';
import '../coordinator/models/coordinator_models.dart';
import '../errors/video_error_composer.dart';
import '../models/call_received_data.dart';
import '../retry/retry_policy.dart';
import '../sfu/data/events/sfu_events.dart';
import '../shared_emitter.dart';
import '../state_emitter.dart';
import '../utils/cancelable_operation.dart';
import '../utils/cancelables.dart';
import '../utils/extensions.dart';
import '../utils/future.dart';
import '../utils/standard.dart';
import '../webrtc/model/stats/rtc_ice_candidate_pair.dart';
import '../webrtc/model/stats/rtc_inbound_rtp_video_stream.dart';
import '../webrtc/model/stats/rtc_outbound_rtp_video_stream.dart';
import '../webrtc/rtc_manager.dart';
import '../webrtc/sdp/editor/sdp_editor_impl.dart';
import '../webrtc/sdp/policy/sdp_policy.dart';
import 'permissions/permissions_manager.dart';
import 'session/call_session.dart';
import 'session/call_session_factory.dart';
import 'state/call_state_notifier.dart';

typedef OnCallPermissionRequest = void Function(
  CoordinatorCallPermissionRequestEvent,
);

typedef GetCurrentUserId = String? Function();

typedef SetActiveCall = Future<void> Function(Call?);
typedef SetOutgoingCall = Future<void> Function(Call?);
typedef GetActiveCall = Call? Function();
typedef GetOutgoingCall = Call? Function();

const _idState = 1;
const _idUserId = 2;
const _idCoordEvents = 3;
const _idSessionEvents = 4;
const _idSessionStats = 5;
const _idConnect = 6;
const _idAwait = 7;

const _tag = 'SV:Call';

const _reconnectTimeout = Duration(seconds: 30);
const _fastReconnectTimeout = Duration(seconds: kDebugMode ? 10 : 3);

int _callSeq = 1;

/// Represents a [Call] in which you can connect to.
class Call {
  /// Do not use the factory directly,
  /// use the [StreamVideo.makeCall] method to construct a `Call` instance.
  @internal
  factory Call({
    required StreamCallCid callCid,
    required CoordinatorClient coordinatorClient,
    required StateEmitter<User?> currentUser,
    required SetActiveCall setActiveCall,
    required SetOutgoingCall setOutgoingCall,
    required GetActiveCall getActiveCall,
    required GetOutgoingCall getOutgoingCall,
    RetryPolicy? retryPolicy,
    SdpPolicy? sdpPolicy,
    CallPreferences? preferences,
  }) {
    streamLog.i(_tag, () => '<factory> callCid: $callCid');
    return Call._internal(
      callCid: callCid,
      coordinatorClient: coordinatorClient,
      currentUser: currentUser,
      setActiveCall: setActiveCall,
      setOutgoingCall: setOutgoingCall,
      getActiveCall: getActiveCall,
      getOutgoingCall: getOutgoingCall,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
      preferences: preferences,
    );
  }

  /// Do not use the factory directly,
  /// use the [StreamVideo.makeCall] method to construct a `Call` instance.
  @internal
  factory Call.fromCreated({
    required CallCreatedData data,
    required CoordinatorClient coordinatorClient,
    required StateEmitter<User?> currentUser,
    required SetActiveCall setActiveCall,
    required SetOutgoingCall setOutgoingCall,
    required GetActiveCall getActiveCall,
    required GetOutgoingCall getOutgoingCall,
    RetryPolicy? retryPolicy,
    SdpPolicy? sdpPolicy,
    CallPreferences? preferences,
  }) {
    streamLog.i(_tag, () => '<factory> created: $data');
    return Call._internal(
      callCid: data.callCid,
      coordinatorClient: coordinatorClient,
      currentUser: currentUser,
      setActiveCall: setActiveCall,
      setOutgoingCall: setOutgoingCall,
      getActiveCall: getActiveCall,
      getOutgoingCall: getOutgoingCall,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
      preferences: preferences,
    ).also(
      (it) => it._stateManager.lifecycleCallCreated(
        data,
        callConnectOptions: it.connectOptions,
      ),
    );
  }

  /// Do not use the factory directly,
  /// use the [StreamVideo.makeCall] method to construct a `Call` instance.
  @internal
  factory Call.fromRinging({
    required CallRingingData data,
    required CoordinatorClient coordinatorClient,
    required StateEmitter<User?> currentUser,
    required SetActiveCall setActiveCall,
    required SetOutgoingCall setOutgoingCall,
    required GetActiveCall getActiveCall,
    required GetOutgoingCall getOutgoingCall,
    RetryPolicy? retryPolicy,
    SdpPolicy? sdpPolicy,
    CallPreferences? preferences,
  }) {
    streamLog.i(_tag, () => '<factory> created: $data');
    return Call._internal(
      callCid: data.callCid,
      coordinatorClient: coordinatorClient,
      currentUser: currentUser,
      setActiveCall: setActiveCall,
      setOutgoingCall: setOutgoingCall,
      getActiveCall: getActiveCall,
      getOutgoingCall: getOutgoingCall,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
      preferences: preferences,
    ).also((it) => it._stateManager.lifecycleCallRinging(data));
  }

  factory Call._internal({
    required StreamCallCid callCid,
    required CoordinatorClient coordinatorClient,
    required StateEmitter<User?> currentUser,
    required SetActiveCall setActiveCall,
    required SetOutgoingCall setOutgoingCall,
    required GetActiveCall getActiveCall,
    required GetOutgoingCall getOutgoingCall,
    RetryPolicy? retryPolicy,
    SdpPolicy? sdpPolicy,
    CallPreferences? preferences,
    CallCredentials? credentials,
  }) {
    final finalCallPreferences = preferences ?? DefaultCallPreferences();
    final finalRetryPolicy = retryPolicy ?? const RetryPolicy();
    final finalSdpPolicy = sdpPolicy ?? const SdpPolicy();
    final stateManager = _makeStateManager(
      callCid,
      coordinatorClient,
      currentUser,
      finalCallPreferences,
    );
    final permissionManager = _makePermissionAwareManager(
      callCid,
      coordinatorClient,
      stateManager,
    );
    return Call._(
      coordinatorClient: coordinatorClient,
      currentUser: currentUser,
      setActiveCall: setActiveCall,
      setOutgoingCall: setOutgoingCall,
      getActiveCall: getActiveCall,
      getOutgoingCall: getOutgoingCall,
      preferences: finalCallPreferences,
      stateManager: stateManager,
      credentials: credentials,
      retryPolicy: finalRetryPolicy,
      sdpPolicy: finalSdpPolicy,
      permissionManager: permissionManager,
    );
  }

  Call._({
    required StateEmitter<User?> currentUser,
    required SetActiveCall setActiveCall,
    required SetOutgoingCall setOutgoingCall,
    required GetActiveCall getActiveCall,
    required GetOutgoingCall getOutgoingCall,
    required CoordinatorClient coordinatorClient,
    required CallPreferences preferences,
    required CallStateNotifier stateManager,
    required PermissionsManager permissionManager,
    required RetryPolicy retryPolicy,
    required SdpPolicy sdpPolicy,
    CallCredentials? credentials,
  })  : _sessionFactory = CallSessionFactory(
          callCid: stateManager.callState.callCid,
          sdpEditor: SdpEditorImpl(sdpPolicy),
        ),
        _stateManager = stateManager,
        _permissionsManager = permissionManager,
        _getCurrentUserId = (() => currentUser.valueOrNull?.id),
        _currentUserIdUpdates = currentUser
            .asStream()
            .map((it) => it?.id)
            .whereNotNull()
            .distinct(),
        _setActiveCall = setActiveCall,
        _setOutgoingCall = setOutgoingCall,
        _getActiveCall = getActiveCall,
        _getOutgoingCall = getOutgoingCall,
        _coordinatorClient = coordinatorClient,
        _preferences = preferences,
        _retryPolicy = retryPolicy,
        _credentials = credentials {
    streamLog.i(_tag, () => '<init> state: ${stateManager.callState}');
    if (stateManager.callState.isRingingFlow) {
      _observeState();
      _observeEvents();
      _observeUserId();
    }
  }

  late final _logger = taggedLogger(tag: '$_tag-${_callSeq++}');
  late final _subscriptions = Subscriptions();
  late final _cancelables = Cancelables();

  final GetCurrentUserId _getCurrentUserId;
  final Stream<String> _currentUserIdUpdates;
  final SetActiveCall _setActiveCall;
  final SetOutgoingCall _setOutgoingCall;
  final GetActiveCall _getActiveCall;
  final GetOutgoingCall _getOutgoingCall;
  final CoordinatorClient _coordinatorClient;
  final RetryPolicy _retryPolicy;
  final CallPreferences _preferences;
  final CallSessionFactory _sessionFactory;
  final CallStateNotifier _stateManager;
  final PermissionsManager _permissionsManager;

  CallCredentials? _credentials;
  int _reconnectAttempt = 0;

  StreamCallCid get callCid => state.value.callCid;

  StreamCallType get type => state.value.callType;

  bool get isActiveCall => _getActiveCall()?.callCid == callCid;

  String get id => state.value.callId;

  StateEmitter<CallState> get state => _stateManager.callStateStream;

  SharedEmitter<CallStats> get stats => _stats;
  late final _stats = MutableSharedEmitterImpl<CallStats>();

  SharedEmitter<StreamCallEvent> get callEvents => _callEvents;
  final _callEvents = MutableSharedEmitterImpl<StreamCallEvent>();

  OnCallPermissionRequest? onPermissionRequest;

  final _status = MutableStateEmitterImpl<_ConnectionStatus>(
    _ConnectionStatus.disconnected,
  );

  CallSession? _session;

  CallConnectOptions _connectOptions = const CallConnectOptions();
  CallConnectOptions? _connectOptionsOverride;

  final List<Timer> _reactionTimers = [];

  @override
  String toString() {
    return 'Call{cid: $callCid}';
  }

  CallConnectOptions get connectOptions {
    return _connectOptionsOverride ?? _connectOptions;
  }

  set connectOptions(CallConnectOptions connectOptions) {
    final status = _status.value;
    if (status == _ConnectionStatus.connected) {
      _logger.w(
        () => '[setConnectOptions] rejected (connectOptions must be'
            ' set before invoking `connect`)',
      );
      return;
    }
    _logger.d(() => '[setConnectOptions] connectOptions: $connectOptions)');
    _connectOptionsOverride = connectOptions;
  }

  void _observeState() {
    _subscriptions.add(
      _idState,
      _stateManager.callStateStream
          .listen((state) async => _onStateChanged(state)),
    );
  }

  void _observeEvents() {
    _subscriptions.add(
      _idCoordEvents,
      _coordinatorClient.events.on<CoordinatorCallEvent>((event) async {
        event.mapToCallEvent(state.value).emitIfNotNull(_callEvents);
        await _onCoordinatorEvent(event);
      }),
    );
  }

  void _observeUserId() {
    _subscriptions.add(
      _idUserId,
      _currentUserIdUpdates.listen((userId) {
        if (userId.isEmpty) return;
        final stateUserId = _stateManager.callState.currentUserId;
        if (userId == stateUserId) {
          _logger.v(() => '[observeUserId] rejected (same userId): $userId');
          return;
        }
        _logger.d(() => '[observeUserId] userId: $userId');
        _stateManager.lifecycleUpdateUserId(userId);
      }),
    );
  }

  Future<void> _onStateChanged(CallState state) async {
    final status = state.status;
    _logger.v(() => '[onStateChanged] status: $status');
    if (status is CallStatusDisconnected) {
      await _clear('status-disconnected');
    }
    _sessionFactory.sdpEditor.opusDtxEnabled =
        state.settings.audio.opusDtxEnabled;
    _sessionFactory.sdpEditor.opusRedEnabled =
        state.settings.audio.redundantCodingEnabled;
  }

  Future<void> _onCoordinatorEvent(CoordinatorCallEvent event) async {
    // Return if the event is not for this call.
    if (event.callCid != state.value.callCid) return;
    _logger.v(() => '[onCoordinatorEvent] event.type: ${event.runtimeType}');
    _logger.v(() => '[onCoordinatorEvent] calStatus: ${state.value.status}');

    if (event is CoordinatorCallPermissionRequestEvent) {
      // Notify the client about the permission request.
      return onPermissionRequest?.call(event);
    }

    if (event is CoordinatorCallRejectedEvent) {
      return _stateManager.coordinatorCallRejected(event);
    } else if (event is CoordinatorCallAcceptedEvent) {
      return _stateManager.coordinatorCallAccepted(event);
    } else if (event is CoordinatorCallEndedEvent) {
      return _stateManager.coordinatorCallEnded(event);
    } else if (event is CoordinatorCallPermissionsUpdatedEvent) {
      return _stateManager.coordinatorCallPermissionsUpdated(event);
    } else if (event is CoordinatorCallRecordingStartedEvent) {
      return _stateManager.coordinatorCallRecordingStarted(event);
    } else if (event is CoordinatorCallRecordingStoppedEvent) {
      return _stateManager.coordinatorCallRecordingStopped(event);
    } else if (event is CoordinatorCallTranscriptionStartedEvent) {
      return _stateManager.coordinatorCallTranscriptionStarted(event);
    } else if (event is CoordinatorCallTranscriptionStoppedEvent) {
      return _stateManager.coordinatorCallTranscriptionStopped(event);
    } else if (event is CoordinatorCallBroadcastingStartedEvent) {
      return _stateManager.coordinatorCallBroadcastingStarted(event);
    } else if (event is CoordinatorCallBroadcastingStoppedEvent) {
      return _stateManager.coordinatorCallBroadcastingStopped(event);
    } else if (event is CoordinatorCallReactionEvent) {
      _reactionTimers.add(
        Timer(_preferences.reactionAutoDismissTime, () {
          _stateManager.resetCallReaction(event.user.id);
        }),
      );

      return _stateManager.coordinatorCallReaction(event);
    }
  }

  Future<Result<None>> accept() async {
    final state = this.state.value;
    _logger.i(() => '[reject] ${_status.value}; state: $state');
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(() => '[acceptCall] rejected (invalid status): $status');
      return Result.error('invalid status: $status');
    }

    final outgoingCall = _getOutgoingCall();
    if (outgoingCall?.callCid != callCid) {
      await outgoingCall?.reject(reason: CallRejectReason.cancel());
      await outgoingCall?.leave();
      await _setOutgoingCall(null);
    }

    final activeCall = _getActiveCall();
    if (activeCall?.callCid != callCid) {
      await activeCall?.reject(reason: CallRejectReason.cancel());
      await activeCall?.leave();
      await _setActiveCall(null);
    }

    final result = await _coordinatorClient.acceptCall(cid: state.callCid);
    if (result is Success<None>) {
      _stateManager.lifecycleCallAccepted();
    }
    return result;
  }

  Future<Result<None>> reject({CallRejectReason? reason}) async {
    final state = this.state.value;
    _logger.i(() => '[reject] ${_status.value}; state: $state');
    final status = state.status;
    if ((status is! CallStatusIncoming || status.acceptedByMe) &&
        status is! CallStatusOutgoing) {
      _logger.w(() => '[rejectCall] rejected (invalid status): $status');
      return Result.error('invalid status: $status');
    }
    final result = await _coordinatorClient.rejectCall(
      cid: state.callCid,
      reason: reason?.value,
    );
    if (result is Success<None>) {
      _stateManager.lifecycleCallRejected();
    }
    return result;
  }

  Future<Result<None>> end() async {
    _logger.d(() => '[end] no args');
    final state = this.state.value;
    _logger.d(() => '[end] status: ${state.status}');
    if (state.status is! CallStatusActive) {
      _logger.w(() => '[end] rejected (invalid status): ${state.status}');
      return Result.error('invalid status: ${state.status}');
    }
    _status.value = _ConnectionStatus.disconnected;
    await _clear('end');
    final result = await _permissionsManager.endCall();
    _stateManager.lifecycleCallEnded();
    _logger.v(() => '[end] completed: $result');
    return result;
  }

  @Deprecated('Lobby view no longer needs joining to coordinator')
  Future<Result<None>> joinLobby({
    CallConnectOptions? connectOptions,
  }) async {
    _logger.d(() => '[joinLobby] no args');
    _stateManager.lifecycleCallJoining();
    final joinedResult = await _joinIfNeeded(connectOptions: connectOptions);
    if (joinedResult is Success<CallCredentials>) {
      _logger.v(() => '[joinLobby] completed');
      return const Result.success(none);
    } else {
      final failedResult = joinedResult as Failure;
      _logger.e(() => '[joinLobby] failed: $failedResult');
      final error = failedResult.error;
      _stateManager.lifecycleCallConnectFailed(error: error);
      return failedResult;
    }
  }

  Future<Result<None>> join({
    CallConnectOptions? connectOptions,
  }) async {
    _logger.i(() => '[join] status: ${_status.value}');
    if (_status.value == _ConnectionStatus.connected) {
      _logger.w(() => '[join] rejected (connected)');
      return const Result.success(none);
    }

    if (_getActiveCall()?.callCid == callCid) {
      _logger.w(
        () => '[join] rejected (a call with the same cid is in progress)',
      );
      return Result.error('a call with the same cid is in progress');
    }

    if (_status.value == _ConnectionStatus.connecting) {
      _logger.v(() => '[join] await "connecting" change');
      final status = await _status.firstWhere(
        (it) => it != _ConnectionStatus.connecting,
        timeLimit: _preferences.connectTimeout,
      );

      if (status == _ConnectionStatus.connected) {
        return const Result.success(none);
      } else {
        return Result.error('original "connect" failed');
      }
    }

    await _setActiveCall(this);
    _status.value = _ConnectionStatus.connecting;

    final result = await _connect(connectOptions: connectOptions)
        .asCancelable()
        .storeIn(_idConnect, _cancelables)
        .valueOrDefault(Result.error('connect cancelled'));

    if (result.isSuccess) {
      _logger.v(() => '[join] finished: $result');
      _status.value = _ConnectionStatus.connected;
    } else {
      _logger.e(() => '[join] failed: $result');
      await leave();
    }
    return result;
  }

  Future<Result<CallMetadata>> update({
    Map<String, Object>? custom,
    StreamRingSettings? ring,
    StreamAudioSettings? audio,
    StreamVideoSettings? video,
    StreamScreenShareSettings? screenShare,
    StreamRecordingSettings? recording,
    StreamTranscriptionSettings? transcription,
    StreamBackstageSettings? backstage,
    StreamGeofencingSettings? geofencing,
  }) {
    return _coordinatorClient.updateCall(
      callCid: callCid,
      custom: custom ?? {},
      ring: ring,
      audio: audio,
      video: video,
      screenShare: screenShare,
      recording: recording,
      transcription: transcription,
      backstage: backstage,
      geofencing: geofencing,
    );
  }

  Future<Result<None>> _connect({
    CallConnectOptions? connectOptions,
  }) async {
    _logger.d(() => '[join] options: $_connectOptions');
    final validation = await _stateManager.validateUserId(_getCurrentUserId);
    if (validation.isFailure) {
      _logger.w(() => '[join] rejected (validation): $validation');
      return validation;
    }
    _logger.v(() => '[join] validated');

    final state = this.state.value;
    final status = state.status;
    if (!status.isConnectable) {
      _logger.w(() => '[join] rejected (not Connectable): $status');
      return Result.error('invalid status: $status');
    }
    _observeState();
    _observeEvents();
    _observeUserId();
    final result = await _awaitIfNeeded();
    if (result.isFailure) {
      _logger.e(() => '[join] waiting failed: $result');

      await reject(reason: CallRejectReason.timeout());
      _stateManager.lifecycleCallTimeout();

      return result;
    }

    _stateManager.lifecycleCallConnecting(attempt: _reconnectAttempt);
    _logger.v(() => '[join] joining to coordinator');
    final joinedResult = await _joinIfNeeded(connectOptions: connectOptions);
    if (joinedResult is! Success<CallCredentials>) {
      _logger.e(() => '[join] coordinator joining failed: $joinedResult');
      final error = (joinedResult as Failure).error;
      _stateManager.lifecycleCallConnectFailed(error: error);
      return result;
    }

    _logger.v(() => '[join] starting sfu session');
    final sessionResult = await _startSession(joinedResult.data);

    if (sessionResult is! Success<None>) {
      _logger.w(() => '[join] sfu session start failed: $sessionResult');
      final error = (sessionResult as Failure).error;
      _stateManager.lifecycleCallConnectFailed(error: error);
      return sessionResult;
    }

    _logger.v(() => '[join] started session');
    _stateManager.lifecycleCallConnected();

    await _applyConnectOptions();

    _logger.v(() => '[join] completed');
    return const Result.success(none);
  }

  Future<Result<CallCredentials>> _joinIfNeeded({
    CallConnectOptions? connectOptions,
  }) async {
    final creds = _credentials;
    if (creds != null) {
      _logger.w(() => '[joinIfNeeded] rejected (already joined): $creds');
      return Result.success(creds);
    }
    _logger.d(() => '[joinIfNeeded] no args');
    final joinedResult =
        await _joinCall(create: true, connectOptions: connectOptions);
    if (joinedResult is Success<CallJoinedData>) {
      _logger.v(() => '[joinIfNeeded] completed');
      _credentials = joinedResult.data.credentials;
      _session?.rtcManager
          ?.updateReportingInterval(joinedResult.data.reportingIntervalMs);
      return Result.success(joinedResult.data.credentials);
    }
    _logger.e(() => '[joinIfNeeded] failed: $joinedResult');
    return joinedResult as Failure;
  }

  Future<Result<None>> _startSession(
    CallCredentials credentials, [
    String? sessionId,
  ]) async {
    _logger.d(
      () => '[startSession] credentials: $credentials, sessionId: $sessionId',
    );
    _credentials = null;
    final session = await _sessionFactory.makeCallSession(
      sessionId: sessionId,
      credentials: credentials,
      stateManager: _stateManager,
      onFullReconnectNeeded: () => _fullReconnect(null),
    );
    _logger.v(() => '[startSession] session created: $session');
    _session = session;
    _subscriptions.add(
      _idSessionEvents,
      session.events.listen((event) {
        _logger.log(
          event.logPriority,
          () => '[listenSfuEvent] event.type: ${event.runtimeType}',
        );
        event.mapToCallEvent(state.value).emitIfNotNull(_callEvents);
        _onSfuEvent(event);
      }),
    );

    _subscriptions.add(
      _idSessionStats,
      session.stats.listen((stats) {
        _logger.v(() => '[listenRtcStats] stats: $stats');
        _stats.emit(stats);
        processStats(stats);
      }),
    );

    var localStats = state.value.localStats ?? LocalStats.empty();
    localStats = localStats.copyWith(
      sfu: session.config.sfuUrl,
      sdkVersion: streamVideoVersion,
      webRtcVersion: switch (CurrentPlatform.type) {
        PlatformType.android => androidWebRTCVersion,
        PlatformType.ios => iosWebRTCVersion,
        _ => null,
      },
    );

    _stateManager.lifecycleCallSessionStart(
      sessionId: session.sessionId,
      localStats: localStats,
    );

    final result = await session.start();
    _logger.v(() => '[startSession] completed: $result');
    return result;
  }

  void processStats(CallStats stats) {
    var publisherStats =
        state.value.publisherStats ?? PeerConnectionStats.empty();
    var subscriberStats =
        state.value.subscriberStats ?? PeerConnectionStats.empty();

    if (stats.peerType == StreamPeerType.publisher) {
      final mediaStatsF = stats.stats
          .whereType<RtcOutboundRtpVideoStream>()
          .where((s) => s.rid == 'f')
          .map(MediaStatsInfo.fromRtcOutboundRtpVideoStream)
          .firstOrNull;
      final mediaStatsH = stats.stats
          .whereType<RtcOutboundRtpVideoStream>()
          .where((s) => s.rid == 'h')
          .map(MediaStatsInfo.fromRtcOutboundRtpVideoStream)
          .firstOrNull;
      final mediaStatsQ = stats.stats
          .whereType<RtcOutboundRtpVideoStream>()
          .where((s) => s.rid == 'q')
          .map(MediaStatsInfo.fromRtcOutboundRtpVideoStream)
          .firstOrNull;

      final allStats = [mediaStatsF, mediaStatsH, mediaStatsQ];
      final mediaStats = allStats.firstWhereOrNull(
        (s) => s?.width != null && s?.height != null && s?.fps != null,
      );

      final jitterInMs = ((mediaStats?.jitter ?? 0) * 1000).toInt();
      final resolution = mediaStats != null
          ? '${mediaStats.width} x ${mediaStats.height} @ ${mediaStats.fps}fps'
          : null;

      publisherStats = publisherStats.copyWith(
        resolution: resolution,
        qualityDropReason: mediaStats?.qualityLimit,
        jitterInMs: jitterInMs,
      );
    }

    final inboudRtpVideo =
        stats.stats.whereType<RtcInboundRtpVideoStream>().firstOrNull;

    if (stats.peerType == StreamPeerType.subscriber && inboudRtpVideo != null) {
      final jitterInMs = ((inboudRtpVideo.jitter ?? 0) * 1000).toInt();
      final resolution = inboudRtpVideo.frameWidth != null &&
              inboudRtpVideo.frameHeight != null &&
              inboudRtpVideo.framesPerSecond != null
          ? '${inboudRtpVideo.frameWidth} x ${inboudRtpVideo.frameHeight} @ ${inboudRtpVideo.framesPerSecond}fps'
          : null;

      subscriberStats = subscriberStats.copyWith(
        resolution: resolution,
        jitterInMs: jitterInMs,
      );
    }

    final candidatePair =
        stats.stats.whereType<RtcIceCandidatePair>().firstOrNull;
    if (candidatePair != null) {
      final latency = candidatePair.currentRoundTripTime;
      final outgoingBitrate = candidatePair.availableOutgoingBitrate;
      final incomingBitrate = candidatePair.availableIncomingBitrate;

      if (stats.peerType == StreamPeerType.publisher) {
        publisherStats = publisherStats.copyWith(
          latency: latency != null ? (latency * 1000).toInt() : null,
          bitrateKbps: outgoingBitrate != null ? outgoingBitrate / 1000 : null,
        );
      } else {
        subscriberStats = subscriberStats.copyWith(
          bitrateKbps: incomingBitrate != null ? incomingBitrate / 1000 : null,
        );
      }
    }

    var latencyHistory = state.value.latencyHistory;
    if (stats.peerType == StreamPeerType.publisher &&
        publisherStats.latency != null) {
      latencyHistory = [
        ...state.value.latencyHistory.reversed.take(19).toList().reversed,
        publisherStats.latency!,
      ];
    }

    _stateManager.lifecycleCallStats(
      publisherStats: publisherStats,
      subscriberStats: subscriberStats,
      latencyHistory: latencyHistory,
    );
  }

  Future<Result<None>> _stopSession() async {
    _subscriptions.cancel(_idSessionEvents);
    _subscriptions.cancel(_idSessionStats);

    await _session?.dispose();
    _session = null;
    _credentials = null;

    return const Result.success(none);
  }

  Future<void> _onSfuEvent(SfuEvent sfuEvent) async {
    if (sfuEvent is SfuSocketDisconnected) {
      await _reconnect(sfuEvent.reason);
    } else if (sfuEvent is SfuSocketFailed) {
      await _reconnect(sfuEvent.error);
    } else if (sfuEvent is SfuGoAwayEvent) {
      await _switchSfu(sfuEvent.goAwayReason);
    }
  }

  Future<void> _reconnect(dynamic reason) async {
    //one reconnect attempt at a time
    if (_status.value == _ConnectionStatus.reconnecting) return;
    _status.value = _ConnectionStatus.reconnecting;

    _stateManager.lifecycleCallConnecting(
      attempt: 1,
      isFastReconnectAttempt: true,
    );

    var tryFastReconnect = true;
    _logger.w(() => '[reconnect] starting timer');
    final timer = Timer(_fastReconnectTimeout, () {
      _logger.w(() => '[reconnect] too late for fast reconnect');
      tryFastReconnect = false;
    });

    final connectionStatus = await InternetConnectionChecker.createInstance(
      checkInterval: const Duration(seconds: 1),
    )
        .onStatusChange
        .firstWhere((status) => status == InternetConnectionStatus.connected)
        .timeout(
      _reconnectTimeout,
      onTimeout: () {
        _logger.w(() => '[reconnect] timeout');

        return InternetConnectionStatus.disconnected;
      },
    );

    //no internet connection after _reconnectTimeout, leave the call
    if (connectionStatus != InternetConnectionStatus.connected) {
      timer.cancel();
      await leave();
      return;
    }

    if (_session != null && tryFastReconnect) {
      _logger.w(() => '[reconnect] trying fast reconnect');
      timer.cancel();

      final result = await _session!.fastReconnect();
      if (!result.isSuccess) {
        _logger.w(
          () =>
              '[reconnect] fast reconnect failed, doing full reconnect: ${result.fold(success: (success) => '', failure: (failure) => failure.error.message)}',
        );
        await _fullReconnect(reason);
      } else {
        _logger.w(
          () => '[reconnect] fast reconnect successful',
        );

        _stateManager.lifecycleCallConnected();
        _status.value = _ConnectionStatus.connected;
      }
    } else {
      _logger.w(() => '[reconnect] doing full reconnect');
      await _fullReconnect(reason);
    }
  }

  Future<void> _fullReconnect(dynamic reason) async {
    if (_status.value == _ConnectionStatus.disconnected) {
      _logger.w(() => '[fullReconnect] rejected (disconnected)');
      return;
    }
    if (_status.value == _ConnectionStatus.connecting) {
      _logger.w(() => '[fullReconnect] rejected (connecting)');
      return;
    }
    _status.value = _ConnectionStatus.connecting;
    _logger.w(() => '[fullReconnect] >>>>>>>>>>>>>>>> reason: $reason');
    _subscriptions.cancel(_idSessionEvents);
    final sessionId = _session?.sessionId;
    await _session?.dispose();
    _session = null;

    Result<None> result;
    final startTime = DateTime.now().toUtc().millisecondsSinceEpoch;
    while (true) {
      _reconnectAttempt++;
      _stateManager.lifecycleCallConnecting(attempt: _reconnectAttempt);
      if (_status.value == _ConnectionStatus.disconnected) {
        _logger.w(
          () =>
              '[fullReconnect] attempt($_reconnectAttempt) rejected (disconnected)',
        );
        _logger.v(() => '[fullReconnect] <<<<<<<<<<<<<<< rejected');
        return;
      }
      final elapsed = DateTime.now().toUtc().millisecondsSinceEpoch - startTime;
      final retryPolicy = _retryPolicy;
      if (elapsed > retryPolicy.config.callRejoinTimeout.inMilliseconds) {
        _logger.w(() => '[fullReconnect] timeout exceed');
        result = Result.error('was unable to reconnect in 15 seconds');
        break;
      }
      final delay = retryPolicy.backoff(_reconnectAttempt);
      _logger.v(
        () => '[fullReconnect] attempt: $_reconnectAttempt, '
            'elapsed: $elapsed, delay: $delay',
      );
      await Future<void>.delayed(delay);
      _logger.v(() => '[fullReconnect] joining to coordinator');
      final joinedResult = await _joinIfNeeded(connectOptions: _connectOptions);
      if (joinedResult is! Success<CallCredentials>) {
        _logger.e(() => '[fullReconnect] joining failed: $joinedResult');
        continue;
      }
      _logger.v(() => '[fullReconnect] starting session');
      result = await _startSession(joinedResult.data, sessionId);
      if (result is! Success<None>) {
        _logger.w(() => '[fullReconnect] session start failed: $result');
        continue;
      }
      _logger.v(() => '[fullReconnect] session started');
      break;
    }
    _reconnectAttempt = 0;
    if (result.isFailure) {
      _logger.e(() => '[fullReconnect] <<<<<<<<<<<<<<< failed: $result');
      _status.value = _ConnectionStatus.disconnected;
      final error = (result as Failure).error;
      _stateManager.lifecycleCallConnectFailed(error: error);
      return;
    }
    _logger.v(() => '[fullReconnect] <<<<<<<<<<<<<<< completed');
    _stateManager.lifecycleCallConnected();
    _status.value = _ConnectionStatus.connected;
    await _applyConnectOptions();
    _logger.v(() => '[fullReconnect] <<<<<<<<<<<<<<< side effects applied');
  }

  Future<Result<None>> _awaitIfNeeded() async {
    final state = this.state.value;
    final status = state.status;
    final settings = state.settings;
    Future<Result<None>>? futureResult;
    if (status is CallStatusOutgoing && !status.acceptedByCallee) {
      final timeout = settings.ring.autoCancelTimeout;
      _logger.d(() => '[awaitIfNeeded] outgoing timeout: $timeout');
      futureResult = _awaitOutgoingToBeAccepted(timeout);
    } else if (status is CallStatusIncoming && !status.acceptedByMe) {
      final timeout = settings.ring.autoRejectTimeout;
      _logger.d(() => '[awaitIfNeeded] incoming timeout: $timeout');
      futureResult = _awaitIncomingToBeAccepted(timeout);
    } else if (status is CallStatusJoining) {
      // TODO we don't need this case, since we no longer join from LobbyView
      _logger.d(() => '[awaitIfNeeded] joining to become joined');
      futureResult = _awaitCallToBeJoined();
    }
    if (futureResult != null) {
      _logger.v(() => '[awaitIfNeeded] return cancelable');
      return futureResult.asCancelable().storeIn(_idAwait, _cancelables).value;
    }
    return const Result.success(none);
  }

  Future<Result<None>> leave() async {
    final state = this.state.value;
    _logger.i(() => '[leave] ${_status.value}; state: $state');
    if (state.status.isDisconnected) {
      _logger.w(() => '[leave] rejected (state.status is disconnected)');
      return const Result.success(none);
    }
    if (_status.value == _ConnectionStatus.disconnected) {
      _logger.w(() => '[leave] rejected (status is disconnected)');
      return const Result.success(none);
    }
    _status.value = _ConnectionStatus.disconnected;
    await _clear('leave');
    _stateManager.lifecycleCallDisconnected();
    _logger.v(() => '[leave] finished');
    return const Result.success(none);
  }

  Future<void> _switchSfu(SfuGoAwayReason reason) async {
    _logger.d(() => '[switchSfu] reason: $reason');
    final migratingFrom = _session?.config.sfuName;
    final sessionId = _session?.sessionId;

    if (_stateManager.callState.status is CallStatusMigrating) {
      _logger.d(() => '[switchSfu] rejected (call already migrating)');
      return;
    }
    await _stopSession();
    _stateManager.lifecycleCallMigrating();
    _logger.d(() => '[switchSfu] migratingFrom: $migratingFrom($sessionId)');
    final joinedResult = await _joinCall(
      migratingFrom: migratingFrom,
      connectOptions: _connectOptions,
    );

    if (joinedResult is! Success<CallJoinedData>) {
      final failedResult = joinedResult as Failure;
      _logger.e(() => '[switchSfu] failed: $failedResult');
      final error = failedResult.error;
      _stateManager.lifecycleCallConnectFailed(error: error);
      return;
    }

    _session?.rtcManager
        ?.updateReportingInterval(joinedResult.data.reportingIntervalMs);

    _logger.v(() => '[switchSfu] starting sfu session');
    final sessionResult = await _startSession(
      joinedResult.data.credentials,
      sessionId,
    );
    if (sessionResult is! Success<None>) {
      _logger.w(() => '[switchSfu] sfu session start failed: $sessionResult');
      final error = (sessionResult as Failure).error;
      _stateManager.lifecycleCallConnectFailed(error: error);
      return;
    }
    _logger.v(() => '[switchSfu] started session');
    _stateManager.lifecycleCallConnected();
    await _applyConnectOptions();

    _logger.v(() => '[switchSfu] completed');
  }

  Future<void> _clear(String src) async {
    _logger.d(() => '[clear] src: $src');
    for (final timer in _reactionTimers) {
      timer.cancel();
    }
    _status.value = _ConnectionStatus.disconnected;
    _subscriptions.cancelAll();
    _cancelables.cancelAll();
    await _session?.dispose();
    _session = null;
    await _setActiveCall(null);
    await _setOutgoingCall(null);
    _logger.v(() => '[clear] completed');
  }

  Future<Result<None>> setLocalTrack(RtcLocalTrack track) async {
    return _setLocalTrack(track);
  }

  RtcTrack? getTrack(String trackIdPrefix, SfuTrackType trackType) {
    return _session?.getTrack(trackIdPrefix, trackType);
  }

  List<RtcTrack> getTracks(String trackIdPrefix) {
    return [...?_session?.getTracks(trackIdPrefix)];
  }

  Future<ByteBuffer?> takeScreenshot(
    CallParticipantState participant, {
    SfuTrackType? trackType,
  }) async {
    final track =
        getTrack(participant.trackIdPrefix, trackType ?? SfuTrackType.video);

    return track?.captureScreenshot();
  }

  Future<void> _applyCallSettingsToConnectOptions(CallSettings settings) async {
    // Apply defaul audio output and input devices
    final mediaDevicesResult =
        await RtcMediaDeviceNotifier.instance.enumerateDevices();
    final mediaDevices = mediaDevicesResult.fold(
      success: (success) => success.data,
      failure: (failure) => <RtcMediaDevice>[],
    );

    final audioOutputs = mediaDevices
        .where((d) => d.kind == RtcMediaDeviceKind.audioOutput)
        .toList();
    final audioInputs = mediaDevices
        .where((d) => d.kind == RtcMediaDeviceKind.audioInput)
        .toList();

    var defaultAudioOutput = audioOutputs.firstWhereOrNull((device) {
      if (settings.audio.defaultDevice ==
          AudioSettingsRequestDefaultDeviceEnum.speaker) {
        return device.id.equalsIgnoreCase(
          AudioSettingsRequestDefaultDeviceEnum.speaker.value,
        );
      }

      return !device.id.equalsIgnoreCase(
        AudioSettingsRequestDefaultDeviceEnum.speaker.value,
      );
    });

    if (defaultAudioOutput == null && audioOutputs.isNotEmpty) {
      defaultAudioOutput = audioOutputs.first;
    }

    final defaultAudioInput = audioInputs
            .firstWhereOrNull((d) => d.label == defaultAudioOutput?.label) ??
        audioInputs.firstOrNull;

    _connectOptions = connectOptions.copyWith(
      camera: TrackOption.fromSetting(
        enabled: settings.video.cameraDefaultOn,
      ),
      microphone: TrackOption.fromSetting(
        enabled: settings.audio.micDefaultOn,
      ),
      audioInputDevice: defaultAudioInput,
      audioOutputDevice: defaultAudioOutput,
      cameraFacingMode: settings.video.cameraFacing ==
              VideoSettingsRequestCameraFacingEnum.front
          ? FacingMode.user
          : FacingMode.environment,
      speakerDefaultOn: settings.audio.speakerDefaultOn,
    );
  }

  Future<void> _applyConnectOptions() async {
    _logger.d(() => '[applyConnectOptions] connectOptions: $_connectOptions');
    await _applyCameraOption(
      _connectOptions.camera,
      _connectOptions.cameraFacingMode,
    );
    await _applyMicrophoneOption(_connectOptions.microphone);
    await _applyScreenShareOption(_connectOptions.screenShare);

    if (_connectOptions.audioInputDevice != null) {
      await setAudioInputDevice(_connectOptions.audioInputDevice!);
    }

    if (_connectOptions.audioOutputDevice != null) {
      await setAudioOutputDevice(_connectOptions.audioOutputDevice!);
    } else {
      if (CurrentPlatform.isIos) {
        await _session?.rtcManager?.setAppleAudioConfiguration(
          speakerOn: _connectOptions.speakerDefaultOn,
        );
      }
    }

    _logger.v(() => '[applyConnectOptions] finished');
  }

  Future<void> _applyCameraOption(
    TrackOption cameraOption,
    FacingMode facingMode,
  ) async {
    if (cameraOption is TrackProvided) {
      await _setLocalTrack(cameraOption.track);
    } else if (cameraOption is TrackEnabled) {
      await setCameraEnabled(
        enabled: true,
        constraints: CameraConstraints(
          facingMode: facingMode,
        ),
      );
    }
  }

  Future<void> _applyMicrophoneOption(TrackOption microphoneOption) async {
    if (microphoneOption is TrackProvided) {
      await _setLocalTrack(microphoneOption.track);
    } else if (microphoneOption is TrackEnabled) {
      await setMicrophoneEnabled(enabled: true);
    }
  }

  Future<void> _applyScreenShareOption(TrackOption screenShareOption) async {
    if (screenShareOption is TrackProvided) {
      await _setLocalTrack(screenShareOption.track);
    } else if (screenShareOption is TrackEnabled) {
      await setScreenShareEnabled(enabled: true);
    }
  }

  Future<Result<None>> _setLocalTrack(RtcLocalTrack track) async {
    _logger.d(() => '[setLocalTrack] localTrack: $track');
    final session = _session;
    if (session == null) {
      _logger.w(() => '[setLocalTrack] rejected (session is null);');
      return Result.error('no call session');
    }
    final result = await session.setLocalTrack(track);
    _logger.v(() => '[setLocalTrack] completed: $result');
    if (result.isSuccess) {
      final mediaConstraints = track.mediaConstraints;
      if (mediaConstraints is AudioConstraints) {
        _logger.v(() => '[setLocalTrack]: setMicrophoneEnabled true');
        await setMicrophoneEnabled(enabled: true);
      } else if (mediaConstraints is CameraConstraints) {
        _logger.v(() => '[setLocalTrack]: setCameraEnabled true');
        await setCameraEnabled(enabled: true);
      } else if (mediaConstraints is ScreenShareConstraints) {
        _logger.v(() => '[setLocalTrack] setScreenShareEnabled true');
        await setScreenShareEnabled(enabled: true);
      } else {
        streamLog.e(
          _tag,
          () => '[_setLocalTrack] failed: $mediaConstraints',
        );
      }
    }
    return result;
  }

  Future<Result<None>> _awaitIncomingToBeAccepted(Duration timeLimit) async {
    return state.firstWhere(
      (state) {
        final status = state.status;
        return status is CallStatusIncoming && status.acceptedByMe;
      },
      timeLimit: timeLimit,
    ).then((value) {
      _logger.i(() => '[awaitIncomingToBeAccepted] completed');
      return const Result.success(none);
    }).onError((e, stk) {
      _logger.e(() => '[awaitIncomingToBeAccepted] failed: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    });
  }

  Future<Result<None>> _awaitOutgoingToBeAccepted(Duration timeLimit) async {
    return state.firstWhere(
      (state) {
        final status = state.status;
        return status is CallStatusOutgoing && status.acceptedByCallee;
      },
      timeLimit: timeLimit,
    ).then((value) {
      _logger.i(() => '[awaitOutgoingToBeAccepted] completed');
      return const Result.success(none);
    }).onError((e, stk) {
      _logger.e(() => '[awaitOutgoingToBeAccepted] failed: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    });
  }

  Future<Result<None>> _awaitCallToBeJoined() async {
    return state.firstWhere(
      (state) {
        return state.status is CallStatusJoined;
      },
      timeLimit: const Duration(seconds: 60),
    ).then((value) {
      _logger.e(() => '[awaitCallToBeJoined] completed');
      return const Result.success(none);
    }).onError((e, stk) {
      _logger.e(() => '[awaitCallToBeJoined] failed: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    });
  }

  Future<Result<None>> addMembers(List<UserInfo> users) {
    return _coordinatorClient.addMembers(
      callCid: callCid,
      members: users.map((user) {
        return MemberRequest(userId: user.id, role: user.role);
      }).toList(),
    );
  }

  Future<Result<None>> removeMembers(List<String> userIds) {
    return _coordinatorClient.removeMembers(
      callCid: callCid,
      removeIds: userIds,
    );
  }

  Future<Result<None>> updateCallMembers({
    List<UserInfo> updateMembers = const [],
    List<String> removeIds = const [],
  }) {
    return _coordinatorClient.updateCallMembers(
      callCid: callCid,
      updateMembers: updateMembers.map((user) {
        return MemberRequest(userId: user.id, role: user.role);
      }).toList(),
      removeIds: removeIds,
    );
  }

  /// Receives a call information. You can then use
  /// the [CallReceivedData] in order to create a [Call] object.
  Future<Result<CallReceivedData>> get({
    int? membersLimit,
    bool ringing = false,
    bool notify = false,
    bool video = false,
  }) async {
    _logger.d(
      () => '[get] cid: $callCid, membersLimit: $membersLimit'
          ', ringing: $ringing, notify: $notify',
    );
    final currentUserId = _getCurrentUserId();
    if (currentUserId == null) {
      _logger.e(() => '[get] failed (no userId)');
      return Result.error('[get] failed; no user_id found');
    }

    final response = await _coordinatorClient.getCall(
      callCid: callCid,
      membersLimit: membersLimit,
      ringing: ringing,
      notify: notify,
      video: video,
    );

    return response.fold(
      success: (it) {
        _stateManager.lifecycleCallReceived(
          it.data,
          ringing: ringing,
          notify: notify,
        );
        _logger.v(() => '[get] completed: ${it.data}');
        return it;
      },
      failure: (it) {
        _logger.e(() => '[get] failed: ${it.error}');
        return it;
      },
    );
  }

  /// Receives a call or creates it with given information. You can then use
  /// the [CallReceivedOrCreatedData] in order to create a [Call] object.
  Future<Result<CallReceivedOrCreatedData>> getOrCreate({
    List<String> memberIds = const [],
    bool ringing = false,
    bool video = false,
    String? team,
    bool? notify,
    DateTime? startsAt,
    StreamBackstageSettings? backstage,
    int? maxDuration,
    int? maxParticipants,
    Map<String, Object> custom = const {},
  }) async {
    _logger.d(
      () => '[getOrCreate] cid: $callCid, ringing: $ringing, '
          'memberIds: $memberIds',
    );

    final currentUserId = _getCurrentUserId();
    if (currentUserId == null) {
      _logger.e(() => '[getOrCreate] failed (no userId)');
      return Result.error('[getOrCreate] failed; no user_id found');
    }

    if (ringing) {
      await _setOutgoingCall(this);
    }

    LimitsSettingsRequest? limits;
    if (maxDuration != null || maxParticipants != null) {
      limits = LimitsSettingsRequest(
        maxDurationSeconds: maxDuration,
        maxParticipants: maxParticipants,
      );
    }

    final settingsOverride = CallSettingsRequest(
      backstage: backstage?.toOpenDto(),
      limits: limits,
    );

    final response = await _coordinatorClient.getOrCreateCall(
      callCid: callCid,
      ringing: ringing,
      members: {...memberIds, currentUserId}.map((id) {
        return MemberRequest(
          userId: id,
          role: 'admin',
        );
      }).toList(),
      team: team,
      notify: notify,
      video: video,
      startsAt: startsAt,
      settingsOverride: settingsOverride,
      custom: custom,
    );

    return response.fold(
      success: (it) async {
        await _applyCallSettingsToConnectOptions(
          it.data.data.metadata.settings,
        );

        _stateManager.lifecycleCallCreated(
          it.data.data,
          ringing: ringing,
          callConnectOptions: connectOptions,
        );
        _logger.v(() => '[getOrCreate] completed: ${it.data}');
        return it;
      },
      failure: (it) {
        _logger.e(() => '[getOrCreate] failed: ${it.error}');
        return it;
      },
    );
  }

  /// Allows you to create a new call with the given parameters
  /// and joins the call immediately.
  Future<Result<CallJoinedData>> _joinCall({
    bool create = false,
    bool video = false,
    String? migratingFrom,
    CallConnectOptions? connectOptions,
  }) async {
    _logger.d(() => '[joinCall] cid: $callCid, migratingFrom: $migratingFrom');
    final joinResult = await _coordinatorClient.joinCall(
      callCid: callCid,
      create: create,
      migratingFrom: migratingFrom,
      video: video,
    );
    if (joinResult is! Success<CoordinatorJoined>) {
      _logger.e(() => '[joinCall] join failed: $joinResult');
      return joinResult as Failure;
    }
    final receivedOrCreated = CallReceivedOrCreatedData(
      wasCreated: joinResult.data.wasCreated,
      data: CallCreatedData(
        callCid: callCid,
        metadata: joinResult.data.metadata,
      ),
    );

    await _applyCallSettingsToConnectOptions(
      receivedOrCreated.data.metadata.settings,
    );

    if (connectOptions != null) {
      _connectOptions = _connectOptions.merge(connectOptions);
    }

    if (_connectOptionsOverride != null) {
      _connectOptions = _connectOptions.merge(_connectOptionsOverride!);
      _connectOptionsOverride = null;
    }

    _stateManager.lifecycleCallCreated(
      receivedOrCreated.data,
      callConnectOptions: this.connectOptions,
    );
    _logger.v(() => '[joinCall] joinedMetadata: ${joinResult.data.metadata}');
    final joined = CallJoinedData(
      callCid: callCid,
      wasCreated: joinResult.data.wasCreated,
      metadata: joinResult.data.metadata,
      credentials: joinResult.data.credentials,
      reportingIntervalMs: joinResult.data.reportingIntervalMs,
    );
    _stateManager.lifecycleCallJoined(joined);
    _logger.v(() => '[joinCall] completed: $joined');
    return Result.success(joined);
  }

  /// Returns true if the current user has the [CallPermission] supplied.
  bool hasPermission(CallPermission permission) {
    return _permissionsManager.hasPermission(permission);
  }

  Future<Result<None>> requestPermissions(List<CallPermission> permissions) {
    return _permissionsManager.request(permissions);
  }

  Future<Result<None>> grantPermissions({
    required String userId,
    List<CallPermission> permissions = const [],
  }) {
    return _permissionsManager.grant(userId: userId, permissions: permissions);
  }

  Future<Result<None>> revokePermissions({
    required String userId,
    List<CallPermission> permissions = const [],
  }) {
    return _permissionsManager.revoke(userId: userId, permissions: permissions);
  }

  Future<Result<None>> blockUser(String userId) {
    return _permissionsManager.blockUser(userId);
  }

  Future<Result<None>> unblockUser(String userId) {
    return _permissionsManager.unblockUser(userId);
  }

  Future<Result<None>> startRecording({
    String? recordingExternalStorage,
  }) async {
    final result = await _permissionsManager.startRecording(
      recordingExternalStorage: recordingExternalStorage,
    );

    if (result.isSuccess) {
      _stateManager.setCallRecording(isRecording: true);
    }

    return result;
  }

  Future<Result<List<CallRecording>>> listRecordings() async {
    return _permissionsManager.listRecordings();
  }

  Future<Result<None>> stopRecording() async {
    final result = await _permissionsManager.stopRecording();

    if (result.isSuccess) {
      _stateManager.setCallRecording(isRecording: false);
    }

    return result;
  }

  Future<Result<None>> startTranscription() async {
    final result = await _permissionsManager.startTranscription();

    if (result.isSuccess) {
      _stateManager.setCallTranscribing(isTranscribing: true);
    }

    return result;
  }

  Future<Result<List<CallTranscription>>> listTranscriptions() async {
    return _permissionsManager.listTranscriptions();
  }

  Future<Result<None>> stopTranscription() async {
    final result = await _permissionsManager.stopTranscription();

    if (result.isSuccess) {
      _stateManager.setCallTranscribing(isTranscribing: false);
    }

    return result;
  }

  /// Starts the broadcasting of the call.
  Future<Result<String?>> startHLS() async {
    final result = await _permissionsManager.startBroadcasting();

    if (result.isSuccess) {
      _stateManager.setCallBroadcasting(
        isBroadcasting: true,
        hlsPlaylistUrl: result.getDataOrNull(),
      );
    }
    return result;
  }

  /// Stops the broadcasting of the call.
  Future<Result<None>> stopHLS() async {
    final result = await _permissionsManager.stopBroadcasting();

    if (result.isSuccess) {
      _stateManager.setCallBroadcasting(isBroadcasting: false);
    }

    return result;
  }

  /// Allows for the muting of a or group of users as indicated by [userIds].
  /// By default the function will mute the audio tracks of the user but this
  /// can be override by passing a [track] to the function.
  ///
  /// Note: The user calling this function must have permission to perform the
  /// action else it will result in an error.
  Future<Result<None>> muteUsers({
    required List<String> userIds,
    TrackType track = TrackType.audio,
  }) {
    return _permissionsManager.muteUsers(userIds: userIds, track: track);
  }

  /// Allows for the muting of the current user.
  ///
  /// By default the function will mute the audio tracks of the user but this
  /// can be override by passing a [track] to the function.
  Future<Result<None>> muteSelf({TrackType track = TrackType.audio}) {
    return _permissionsManager.muteSelf(track: track);
  }

  /// Allows for the muting of all users except current user calling the function.
  ///
  /// By default the function will mute the audio tracks of the user but this
  /// can be override by passing a [track] to the function.
  ///
  /// Note: The user calling this function must have permission to perform the
  ///  action else it will result in an error.
  Future<Result<None>> muteOthers({TrackType track = TrackType.audio}) {
    return _permissionsManager.muteOthers(track: track);
  }

  /// Allows for the muting of all users on a call including the current user
  /// calling the function.
  ///
  /// Note: The user calling this function must have permission to perform the
  //  action else it will result in an error.
  Future<Result<None>> muteAllUsers() {
    return _permissionsManager.muteAllUsers();
  }

  Future<Result<None>> setCameraPosition(CameraPosition cameraPosition) async {
    final result = await _session?.setCameraPosition(cameraPosition) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      _stateManager.participantUpdateCameraPosition(
        cameraPosition: cameraPosition,
      );
    }

    return result;
  }

  Future<Result<None>> flipCamera() async {
    final result =
        await _session?.flipCamera() ?? Result.error('Session is null');

    if (result.isSuccess) {
      _connectOptions = connectOptions.copyWith(
        cameraFacingMode: connectOptions.cameraFacingMode.flip(),
      );

      _stateManager.participantFlipCamera();
    }

    return result;
  }

  Future<Result<None>> setVideoInputDevice(RtcMediaDevice device) async {
    final result = await _session?.setVideoInputDevice(device) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      _stateManager.participantSetVideoInputDevice(device: device);
    }

    return result;
  }

  Future<Result<None>> setCameraEnabled({
    required bool enabled,
    CameraConstraints? constraints,
  }) async {
    final result =
        await _session?.setCameraEnabled(enabled, constraints: constraints) ??
            Result.error('Session is null');

    if (result.isSuccess) {
      _stateManager.participantSetCameraEnabled(
        enabled: enabled,
      );

      _connectOptions = _connectOptions.copyWith(
        camera: enabled ? TrackOption.enabled() : TrackOption.disabled(),
        cameraFacingMode: constraints?.facingMode ?? FacingMode.user,
      );
    }

    return result;
  }

  Future<Result<None>> setMicrophoneEnabled({
    required bool enabled,
    AudioConstraints? constraints,
  }) async {
    final result = await _session?.setMicrophoneEnabled(
          enabled,
          constraints: constraints,
        ) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      _stateManager.participantSetMicrophoneEnabled(
        enabled: enabled,
      );

      _connectOptions = _connectOptions.copyWith(
        microphone: enabled ? TrackOption.enabled() : TrackOption.disabled(),
      );

      if (_connectOptions.audioOutputDevice != null) {
        await setAudioOutputDevice(_connectOptions.audioOutputDevice!);
      }
    }

    return result;
  }

  Future<bool> requestScreenSharePermission() {
    return Helper.requestCapturePermission();
  }

  Future<Result<None>> setScreenShareEnabled({
    required bool enabled,
    ScreenShareConstraints? constraints,
  }) async {
    // Checks to ensure the user can share their screen.
    final canShare = hasPermission(CallPermission.screenshare);
    if (enabled && !canShare) {
      return Result.error('Missing permission to share screen for the user');
    }

    final result = await _session?.setScreenShareEnabled(
          enabled,
          constraints: constraints,
        ) ??
        Result.error('Call session is null, cannot start screen share');

    if (result.isSuccess) {
      _stateManager.participantSetScreenShareEnabled(
        enabled: enabled,
      );

      _connectOptions = _connectOptions.copyWith(
        screenShare: enabled ? TrackOption.enabled() : TrackOption.disabled(),
      );
    }

    return result;
  }

  Future<Result<None>> setAudioInputDevice(RtcMediaDevice device) async {
    final result = await _session?.setAudioInputDevice(device) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      _connectOptions = connectOptions.copyWith(audioInputDevice: device);

      _stateManager.participantSetAudioInputDevice(device: device);
    }

    return result;
  }

  Future<Result<None>> setAudioOutputDevice(RtcMediaDevice device) async {
    final result = await _session?.setAudioOutputDevice(device) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      _connectOptions = connectOptions.copyWith(audioOutputDevice: device);

      _stateManager.participantSetAudioOutputDevice(
        device: device,
      );
    }

    return result;
  }

  Future<Result<None>> setParticipantPinned({
    required String sessionId,
    required String userId,
    required bool pinned,
  }) async {
    final result = await _session?.setParticipantPinned(
          sessionId: sessionId,
          userId: userId,
          pinned: pinned,
        ) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      _stateManager.setParticipantPinned(
        sessionId: sessionId,
        userId: userId,
        pinned: pinned,
      );
    }

    return result;
  }

  /// Starts the livestreaming of the call.
  Future<Result<CallMetadata>> goLive({
    bool? startHls,
    bool? startRecording,
    bool? startTranscription,
  }) async {
    final result = await _coordinatorClient.goLive(
      callCid: callCid,
      startHls: startHls,
      startRecording: startRecording,
      startTranscription: startTranscription,
    );

    if (result.isSuccess) {
      _stateManager.setCallLive(isLive: true);
    }

    return result;
  }

  /// Stops the livestreaming of the call.
  Future<Result<CallMetadata>> stopLive() async {
    final result = await _coordinatorClient.stopLive(callCid);

    if (result.isSuccess) {
      _stateManager.setCallLive(isLive: false);
    }

    return result;
  }

  Future<Result<None>> updateViewportVisibility({
    required String sessionId,
    required String userId,
    required ViewportVisibility visibility,
  }) async {
    final change = VisibilityChange(
      sessionId: sessionId,
      userId: userId,
      visibility: visibility,
    );

    final result = await _session?.updateViewportVisibility(change) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      _stateManager.participantUpdateViewportVisibility(
        sessionId: sessionId,
        userId: userId,
        visibility: visibility,
      );
    }

    return result;
  }

  Future<Result<None>> setSubscriptions(
    List<SubscriptionChange> changes,
  ) async {
    final result = await _session?.setSubscriptions(changes) ??
        Result.error('Session is null');

    // TODO: Verify this is not needed
    // if (result.isSuccess) {
    //   _stateManager
    //       .participantUpdateSubscriptions();
    // }

    return result;
  }

  Future<Result<None>> setSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required Map<SfuTrackTypeVideo, RtcVideoDimension> trackTypes,
  }) async {
    final change = SubscriptionChange.set(
      userId: userId,
      sessionId: sessionId,
      trackIdPrefix: trackIdPrefix,
      trackTypes: trackTypes,
    );

    final result = await _session?.setSubscriptions([
          change,
        ]) ??
        Result.error('Session is null');

    // TODO: Verify this is not needed
    // if (result.isSuccess) {
    //   _stateManager.participantUpdateSubscriptions(
    //     UpdateSubscriptions([
    //       UpdateSubscription(
    //         userId: userId,
    //         sessionId: sessionId,
    //         trackIdPrefix: trackIdPrefix,
    //         trackType: trackTypes.keys.first,
    //       ),
    //     ]),
    //   );
    // }

    return result;
  }

  Future<Result<None>> updateSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required SfuTrackTypeVideo trackType,
    RtcVideoDimension? videoDimension,
  }) async {
    final result = await _session?.updateSubscription(
          SubscriptionChange.update(
            userId: userId,
            sessionId: sessionId,
            trackIdPrefix: trackIdPrefix,
            trackType: trackType,
            videoDimension: videoDimension,
          ),
        ) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      _stateManager.participantUpdateSubscription(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
        videoDimension: videoDimension,
      );
    }

    return result;
  }

  Future<Result<None>> removeSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required SfuTrackTypeVideo trackType,
    RtcVideoDimension? videoDimension,
  }) async {
    final result = await _session?.updateSubscription(
          SubscriptionChange.update(
            userId: userId,
            sessionId: sessionId,
            trackIdPrefix: trackIdPrefix,
            trackType: trackType,
          ),
        ) ??
        Result.error('Session is null');

    if (result.isSuccess) {
      _stateManager.participantRemoveSubscription(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
      );
    }

    return result;
  }

  Future<Result<QueriedMembers>> queryMembers({
    required Map<String, Object> filterConditions,
    String? next,
    String? prev,
    List<SortParam> sorts = const [],
    int? limit,
  }) {
    return _permissionsManager.queryMembers(
      filterConditions: filterConditions,
      next: next,
      prev: prev,
      sorts: sorts,
      limit: limit,
    );
  }

  Future<Result<CallReaction>> sendReaction({
    required String reactionType,
    String? emojiCode,
    Map<String, Object> custom = const {},
  }) {
    return _permissionsManager.sendReaction(
      reactionType: reactionType,
      emojiCode: emojiCode,
      custom: custom,
    );
  }

  void resetReaction({
    required String userId,
  }) {
    return _stateManager.resetCallReaction(userId);
  }

  List<CallReaction> getCurrentReactions() {
    return _stateManager.callState.callParticipants.fold([],
        (previousValue, e) {
      if (e.reaction != null) {
        return [...previousValue, e.reaction!];
      } else {
        return previousValue;
      }
    });
  }

  Future<Result<None>> sendCustomEvent({
    required String eventType,
    Map<String, Object> custom = const {},
  }) {
    return _coordinatorClient.sendCustomEvent(
      callCid: callCid,
      eventType: eventType,
      custom: custom,
    );
  }
}

CallStateNotifier _makeStateManager(
  StreamCallCid callCid,
  CoordinatorClient coordinatorClient,
  StateEmitter<User?> currentUser,
  CallPreferences callPreferences,
) {
  final currentUserId = currentUser.valueOrNull?.id ?? '';

  return CallStateNotifier(
    CallState(
      currentUserId: currentUserId,
      callCid: callCid,
    ),
    callPreferences,
  );
}

PermissionsManager _makePermissionAwareManager(
  StreamCallCid callCid,
  CoordinatorClient coordinatorClient,
  CallStateNotifier stateManager,
) {
  return PermissionsManager(
    callCid: callCid,
    coordinatorClient: coordinatorClient,
    stateManager: stateManager,
  );
}

extension on CallStateNotifier {
  Future<Result<None>> validateUserId(GetCurrentUserId getCurrentUserId) async {
    final stateUserId = callState.currentUserId;
    final currentUserId = getCurrentUserId() ?? '';
    if (currentUserId.isEmpty) {
      return Result.error('no userId');
    }
    if (stateUserId.isEmpty || stateUserId != currentUserId) {
      lifecycleUpdateUserId(currentUserId);
    }
    return const Result.success(none);
  }
}

@Deprecated('Rely on CallStatus')
enum _ConnectionStatus {
  disconnected,
  connecting,
  reconnecting,
  connected;

  @override
  String toString() {
    return name;
  }
}

enum TrackType {
  audio,
  video,
  screenshare,
  all;

  @override
  String toString() {
    return name;
  }

  SfuTrackType toSFUTrackType() {
    switch (this) {
      case TrackType.audio:
        return SfuTrackType.audio;
      case TrackType.video:
        return SfuTrackType.video;
      case TrackType.screenshare:
        return SfuTrackType.screenShare;
      //ignore:no_default_cases
      default:
        throw Exception('Unknown mute type: $this');
    }
  }
}
