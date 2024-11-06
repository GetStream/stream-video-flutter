// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart';

import '../../protobuf/video/sfu/event/events.pb.dart' show ReconnectDetails;
import '../../stream_video.dart';
import '../../version.g.dart';
import '../coordinator/models/coordinator_models.dart';
import '../coordinator/open_api/error/open_api_error.dart';
import '../errors/video_error_composer.dart';
import '../models/call_received_data.dart';
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_error.dart';
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
import '../ws/ws.dart';
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
const _idReconnect = 7;
const _idFastReconnectTimeout = 8;

const _tag = 'SV:Call';
int _callSeq = 1;

/// Represents a [Call] in which you can connect to.
class Call {
  /// Do not use the factory directly,
  /// use the [StreamVideo.makeCall] method to construct a `Call` instance.
  @internal
  factory Call({
    required StreamCallCid callCid,
    required CoordinatorClient coordinatorClient,
    required StreamVideo streamVideo,
    RetryPolicy? retryPolicy,
    SdpPolicy? sdpPolicy,
    CallPreferences? preferences,
  }) {
    streamLog.i(_tag, () => '<factory> callCid: $callCid');
    return Call._internal(
      callCid: callCid,
      coordinatorClient: coordinatorClient,
      streamVideo: streamVideo,
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
    required StreamVideo streamVideo,
    RetryPolicy? retryPolicy,
    SdpPolicy? sdpPolicy,
    CallPreferences? preferences,
  }) {
    streamLog.i(_tag, () => '<factory> created: $data');
    return Call._internal(
      callCid: data.callCid,
      coordinatorClient: coordinatorClient,
      streamVideo: streamVideo,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
      preferences: preferences,
    ).also(
      (it) => it._stateManager.updateFromCallCreatedData(
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
    required StreamVideo streamVideo,
    RetryPolicy? retryPolicy,
    SdpPolicy? sdpPolicy,
    CallPreferences? preferences,
  }) {
    streamLog.i(_tag, () => '<factory> created: $data');
    return Call._internal(
      callCid: data.callCid,
      coordinatorClient: coordinatorClient,
      streamVideo: streamVideo,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
      preferences: preferences,
    ).also((it) => it._stateManager.lifecycleCallRinging(data));
  }

  factory Call._internal({
    required StreamCallCid callCid,
    required CoordinatorClient coordinatorClient,
    required StreamVideo streamVideo,
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
      streamVideo.state.user,
      finalCallPreferences,
    );

    final permissionManager = _makePermissionAwareManager(
      callCid,
      coordinatorClient,
      stateManager,
    );

    return Call._(
      coordinatorClient: coordinatorClient,
      streamVideo: streamVideo,
      preferences: finalCallPreferences,
      stateManager: stateManager,
      credentials: credentials,
      retryPolicy: finalRetryPolicy,
      sdpPolicy: finalSdpPolicy,
      permissionManager: permissionManager,
    );
  }

  Call._({
    required CoordinatorClient coordinatorClient,
    required StreamVideo streamVideo,
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
        _coordinatorClient = coordinatorClient,
        _streamVideo = streamVideo,
        _preferences = preferences,
        _retryPolicy = retryPolicy,
        _credentials = credentials,
        dynascaleManager = DynascaleManager(stateManager: stateManager) {
    streamLog.i(_tag, () => '<init> state: ${stateManager.callState}');

    if (stateManager.callState.isRingingFlow) {
      _init();
    }
  }

  late final _logger = taggedLogger(tag: '$_tag-${_callSeq++}');
  late final _subscriptions = Subscriptions();
  late final _cancelables = Cancelables();
  late final _callInitLock = Lock();
  late final _callJoinLock = Lock();
  late final _callReconnectLock = Lock();

  final CoordinatorClient _coordinatorClient;
  final StreamVideo _streamVideo;
  final RetryPolicy _retryPolicy;
  final CallPreferences _preferences;
  final CallSessionFactory _sessionFactory;
  final CallStateNotifier _stateManager;
  final PermissionsManager _permissionsManager;
  final DynascaleManager dynascaleManager;

  CallCredentials? _credentials;
  CallSession? _session;
  CallSession? _previousSession;

  int _reconnectAttempts = 0;
  Duration _fastReconnectDeadline = Duration.zero;
  SfuReconnectionStrategy _reconnectStrategy =
      SfuReconnectionStrategy.unspecified;
  Future<InternetStatus>? _awaitNetworkAvailableFuture;
  bool _initialized = false;

  final List<Timer> _reactionTimers = [];

  String get id => state.value.callId;
  StreamCallCid get callCid => state.value.callCid;
  StreamCallType get type => state.value.callType;
  bool get isActiveCall =>
      _streamVideo.state.activeCall.valueOrNull?.callCid == callCid;

  StateEmitter<CallState> get state => _stateManager.callStateStream;

  SharedEmitter<CallStats> get stats => _stats;
  late final _stats = MutableSharedEmitterImpl<CallStats>();

  SharedEmitter<StreamCallEvent> get callEvents => _callEvents;
  final _callEvents = MutableSharedEmitterImpl<StreamCallEvent>();

  OnCallPermissionRequest? onPermissionRequest;

  CallConnectOptions _connectOptions = const CallConnectOptions();
  CallConnectOptions? _connectOptionsOverride;

  @override
  String toString() {
    return 'Call{cid: $callCid}';
  }

  CallConnectOptions get connectOptions {
    return _connectOptionsOverride ?? _connectOptions;
  }

  /// It is better to pass the [connectOptions] to [join] method,
  /// setting it directly has to be done carefully. Depending on the moment in the call lifecycle,
  /// it might be overwritten by default configuration or it might be too late to apply the changes.
  set connectOptions(CallConnectOptions connectOptions) {
    if (state.value.status is CallStatusConnected) {
      _logger.w(
        () => '[setConnectOptions] rejected (connectOptions must be'
            ' set before invoking `connect`)',
      );

      return;
    }

    _logger.d(() => '[setConnectOptions] connectOptions: $connectOptions)');
    _connectOptionsOverride = connectOptions;
  }

  Future<void> _init() {
    return _callInitLock.synchronized(() async {
      _logger.v(() => '[_init] no args');

      if (_initialized) return;
      _logger.d(() => '[_init] initializing');

      _observeEvents();
      _observeState();
      _observeReconnectEvents();
      _observeUserId();

      _logger.v(() => '[_init] initialized');
      _initialized = true;
    });
  }

  void _observeState() {
    _subscriptions.add(
      _idState,
      _stateManager.callStateStream.listen(
        (state) async => _onStateChanged(state),
      ),
    );
  }

  void _observeEvents() {
    _subscriptions.cancel(_idCoordEvents);
    _subscriptions.add(
      _idCoordEvents,
      _coordinatorClient.events.on<CoordinatorCallEvent>((event) async {
        event.mapToCallEvent(state.value).emitIfNotNull(_callEvents);
        await _onCoordinatorEvent(event);
      }),
    );
  }

  void _observeReconnectEvents() {
    _subscriptions.add(
      _idReconnect,
      InternetConnection.createInstance().onStatusChange.listen(
        (status) {
          if (status == InternetStatus.disconnected) {
            _logger.d(() => '[observeReconnectEvents] network disconnected');
            _awaitNetworkAvailableFuture = _awaitNetworkAvailable();
            _reconnect(SfuReconnectionStrategy.fast);
          }
        },
      ),
    );
  }

  void _observeUserId() {
    _subscriptions.add(
      _idUserId,
      _streamVideo.state.user
          .asStream()
          .map((u) => u.id)
          .distinct()
          .listen((userId) {
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

    if (status is CallStatusReconnectionFailed) {
      await leave(reason: DisconnectReason.reconnectionFailed());
    }

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
    _logger.v(
      () =>
          '[onCoordinatorEvent] event.type: ${event.runtimeType}, calStatus: ${state.value.status}',
    );

    switch (event) {
      case CoordinatorCallPermissionRequestEvent _:
        // Notify the client about the permission request.
        return onPermissionRequest?.call(event);
      case CoordinatorCallRejectedEvent _:
        return _stateManager.coordinatorCallRejected(event);
      case CoordinatorCallAcceptedEvent _:
        return _stateManager.coordinatorCallAccepted(event);
      case CoordinatorCallEndedEvent _:
        return _stateManager.coordinatorCallEnded(event);
      case CoordinatorCallPermissionsUpdatedEvent _:
        return _stateManager.coordinatorCallPermissionsUpdated(event);
      case CoordinatorCallRecordingStartedEvent _:
        return _stateManager.coordinatorCallRecordingStarted(event);
      case CoordinatorCallRecordingStoppedEvent _:
        return _stateManager.coordinatorCallRecordingStopped(event);
      case CoordinatorCallRecordingFailedEvent _:
        return _stateManager.coordinatorCallRecordingFailed(event);
      case CoordinatorCallTranscriptionStartedEvent _:
        return _stateManager.coordinatorCallTranscriptionStarted(event);
      case CoordinatorCallTranscriptionStoppedEvent _:
        return _stateManager.coordinatorCallTranscriptionStopped(event);
      case CoordinatorCallTranscriptionFailedEvent _:
        return _stateManager.coordinatorCallTranscriptionFailed(event);
      case CoordinatorCallBroadcastingStartedEvent _:
        return _stateManager.coordinatorCallBroadcastingStarted(event);
      case CoordinatorCallBroadcastingStoppedEvent _:
        return _stateManager.coordinatorCallBroadcastingStopped(event);
      case CoordinatorCallBroadcastingFailedEvent _:
        return _stateManager.coordinatorCallBroadcastingFailed(event);
      case CoordinatorCallRingingEvent _:
        return _stateManager.callMetadataChanged(event.metadata);
      case CoordinatorCallMissedEvent _:
        return _stateManager.callMetadataChanged(event.metadata);
      case CoordinatorCallSessionEndedEvent _:
        return _stateManager.callMetadataChanged(event.metadata);
      case CoordinatorCallSessionStartedEvent _:
        return _stateManager.callMetadataChanged(event.metadata);
      case CoordinatorCallUpdatedEvent _:
        return _stateManager.callMetadataChanged(event.metadata);
      case CoordinatorCallReactionEvent _:
        _reactionTimers.add(
          Timer(_preferences.reactionAutoDismissTime, () {
            _stateManager.resetCallReaction(event.user.id);
          }),
        );
        return _stateManager.coordinatorCallReaction(event);
      case CoordinatorCallSessionParticipantCountUpdatedEvent _:
        if (state.value.status.isConnected || state.value.status.isJoined) {
          return;
        }

        return _stateManager.setParticipantsCount(
          totalCount:
              event.participantsCountByRole.values.fold(0, (a, b) => a + b),
          anonymousCount: event.anonymousParticipantCount,
        );
      default:
        break;
    }
  }

  /// Accepts the incoming call.
  Future<Result<None>> accept() async {
    final state = this.state.value;
    _logger.i(() => '[accept] state: $state');

    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(() => '[accept] rejected (invalid status): $status');
      return Result.error('invalid status: $status');
    }

    final outgoingCall = _streamVideo.state.outgoingCall.valueOrNull;
    if (outgoingCall != null && outgoingCall.callCid != callCid) {
      _logger.i(() => '[accept] canceling outgoing call: $outgoingCall');
      await outgoingCall.reject(reason: CallRejectReason.cancel());

      await _streamVideo.state.setOutgoingCall(null);
    }

    final activeCall = _streamVideo.state.activeCall.valueOrNull;
    if (activeCall != null && activeCall.callCid != callCid) {
      _logger.i(() => '[accept] canceling another active call: $activeCall');
      await activeCall.reject(reason: CallRejectReason.cancel());

      await _streamVideo.state.setActiveCall(null);
    }

    final result = await _coordinatorClient.acceptCall(cid: state.callCid);
    if (result is Success<None>) {
      _stateManager.lifecycleCallAccepted();
    }

    return result;
  }

  /// Rejects the incoming call.
  Future<Result<None>> reject({CallRejectReason? reason}) async {
    final state = this.state.value;
    _logger.i(() => '[reject] state: $state');

    final result = await _coordinatorClient.rejectCall(
      cid: state.callCid,
      reason: reason?.value,
    );

    // Always leave the call after rejecting it.
    await leave(
      reason: result is Success<None>
          ? DisconnectReason.rejected(
              byUserId: state.currentUserId,
              reason: reason,
            )
          : null,
    );

    return result;
  }

  /// Ends the call for all participants.
  Future<Result<None>> end() async {
    final state = this.state.value;
    _logger.d(() => '[end] status: ${state.status}');

    if (state.status is! CallStatusActive) {
      _logger.w(() => '[end] rejected (invalid status): ${state.status}');
      return Result.error('invalid status: ${state.status}');
    }

    _session?.leave(reason: 'user is ending the call');
    await _clear('end');

    final result = await _permissionsManager.endCall();
    _stateManager.lifecycleCallEnded();

    _logger.v(() => '[end] completed: $result');
    return result;
  }

  /// Joins the call.
  ///
  /// - [connectOptions]: optional initial call configuration
  Future<Result<None>> join({
    CallConnectOptions? connectOptions,
  }) async {
    await _init();

    if (state.value.status is CallStatusConnected) {
      _logger.w(() => '[join] rejected (connected)');
      return const Result.success(none);
    }

    if (_streamVideo.state.activeCall.valueOrNull?.callCid == callCid) {
      _logger.w(
        () => '[join] rejected (a call with the same cid is in progress)',
      );

      return Result.error('a call with the same cid is in progress');
    }

    if (state.value.status is CallStatusConnecting) {
      _logger.v(() => '[join] await "connecting" change');

      final status = await state.firstWhere(
        (it) => it.status is CallStatusConnected,
        timeLimit: _preferences.connectTimeout,
      );

      if (status is! CallStatusConnected) {
        return const Result.success(none);
      } else {
        _logger.e(() => '[join] original "connect" failed');
        return Result.error('original "connect" failed');
      }
    }

    await _streamVideo.state.setActiveCall(this);
    final result = await _join(connectOptions: connectOptions)
        .asCancelable()
        .storeIn(_idConnect, _cancelables)
        .valueOrDefault(Result.error('connect cancelled'));

    if (result.isSuccess) {
      _logger.v(() => '[join] finished: $result');
    } else {
      _logger.e(() => '[join] failed: $result');
      await leave();
    }

    return result;
  }

  Future<Result<None>> _join({
    CallConnectOptions? connectOptions,
  }) async {
    if (_callJoinLock.locked) {
      _logger.w(() => '[join] rejected (already joining)');
      return Result.error('already joining');
    }

    return _callJoinLock.synchronized(() async {
      _logger.d(() => '[join] options: $_connectOptions');

      final validation =
          await _stateManager.validateUserId(_streamVideo.currentUser.id);

      if (validation.isFailure) {
        _logger.w(() => '[join] rejected (validation): $validation');
        return validation;
      }

      _logger.v(() => '[join] validated');

      final performingMigration =
          _reconnectStrategy == SfuReconnectionStrategy.migrate;
      final performingRejoin =
          _reconnectStrategy == SfuReconnectionStrategy.rejoin;
      final performingFastReconnect =
          _reconnectStrategy == SfuReconnectionStrategy.fast;

      final result = await _awaitIfNeeded();
      if (result.isFailure) {
        _logger.e(() => '[join] waiting failed: $result');

        await reject(reason: CallRejectReason.timeout());
        _stateManager.lifecycleCallTimeout();

        return result;
      }

      _stateManager.lifecycleCallConnecting(
        attempt: _reconnectAttempts,
        strategy: _reconnectStrategy,
      );

      final joinedResult = await _joinIfNeeded(
        connectOptions: connectOptions,
      );

      if (joinedResult is! Success<CallCredentials>) {
        _logger.e(() => '[join] coordinator joining failed: $joinedResult');

        final error = (joinedResult as Failure).error;
        _stateManager.lifecycleCallConnectFailed(error: error);
        return result;
      }

      _credentials = joinedResult.data;

      _previousSession = _session;

      final isWsHealthy = _previousSession?.sfuWS.isConnected ?? false;

      final reconnectDetails =
          _reconnectStrategy == SfuReconnectionStrategy.unspecified
              ? null
              : _previousSession?.getReconnectDetails(_reconnectStrategy);

      if (performingRejoin || performingMigration || !isWsHealthy) {
        _logger.v(
          () =>
              '[join] creating new sfu session (rejoin: $performingRejoin, migration: $performingMigration, wsHealthy: $isWsHealthy)',
        );

        _session = await _sessionFactory.makeCallSession(
          // a new session_id is necessary for the REJOIN strategy.
          // we use the previous session_id if available
          sessionId: performingRejoin ? null : _previousSession?.sessionId,
          credentials: _credentials!,
          stateManager: _stateManager,
          dynascaleManager: dynascaleManager,
          onPeerConnectionFailure: (pc) async {
            if (state.value.status is! CallStatusReconnecting) {
              await pc.pc.restartIce().onError((_, __) {
                _reconnect(SfuReconnectionStrategy.rejoin);
              });
            }
          },
        );

        dynascaleManager.init(
          sfuClient: _session!.sfuClient,
          sessionId: _session!.sessionId,
        );
      } else {
        _logger.v(
          () =>
              '[join] reusing previous sfu session (rejoin: $performingRejoin, migration: $performingMigration, wsHealthy: $isWsHealthy)',
        );

        _session = _previousSession;
      }

      if (_session?.sessionSeq != _previousSession?.sessionSeq) {
        _logger.d(() => '[join] starting sfu session');

        final sessionResult = await _startSession(
          _session!,
          reconnectDetails: reconnectDetails,
        );

        if (sessionResult is! Success<None>) {
          _logger.e(() => '[join] sfu session start failed: $sessionResult');

          final error = (sessionResult as Failure).error;
          _stateManager.lifecycleCallConnectFailed(error: error);
          return sessionResult;
        }
      }

      if (performingFastReconnect && isWsHealthy) {
        _logger.d(() => '[join] fast reconnecting');

        final result = await _session?.fastReconnect();

        result?.fold(
          success: (success) {
            _logger.v(() => '[join] fast reconnecting success');
            _fastReconnectDeadline = success.data.fastReconnectDeadline;
          },
          failure: (failure) {
            _logger.e(() => '[join] fast reconnecting failed: $failure');
            return failure;
          },
        );
      }

      if (performingRejoin) {
        _logger.v(() => '[join] leaving previous session');
        _previousSession?.leave(
          reason:
              'Closing previous WS after reconnect with strategy: ${_reconnectStrategy.name}',
        );
        await _previousSession?.dispose();
      } else if (!isWsHealthy) {
        _logger.v(() => '[join] closing unhealthy WS');
        await _previousSession?.close(
          StreamWebSocketCloseCode.disposeOldSocket,
          closeReason: 'Closing unhealthy WS after reconnect',
        );
      }

      // For migration we have to wait for confirmation before we can complete the flow
      if (_reconnectStrategy != SfuReconnectionStrategy.migrate) {
        _previousSession = null;
        _stateManager.lifecycleCallConnected();
      }

      _logger.v(() => '[join] apllying connect options');
      await _applyConnectOptions();

      _logger.v(() => '[join] completed');
      return const Result.success(none);
    });
  }

  Future<Result<CallCredentials>> _joinIfNeeded({
    CallConnectOptions? connectOptions,
  }) async {
    _logger.d(
      () => '[joinIfNeeded] options: $connectOptions, '
          'reconnectionStrategy: $_reconnectStrategy',
    );

    final credentials = _credentials;
    final prevState = _stateManager.callState;

    if (credentials == null ||
        _reconnectStrategy == SfuReconnectionStrategy.rejoin ||
        _reconnectStrategy == SfuReconnectionStrategy.migrate) {
      _logger.w(() => '[joinIfNeeded] joining');

      final joinedResult = await _performJoinCallRequest(
        create: true,
        connectOptions: connectOptions,
        migratingFrom: _reconnectStrategy == SfuReconnectionStrategy.migrate
            ? _session?.config.sfuName
            : null,
      );

      return joinedResult.fold(
        success: (success) {
          _credentials = success.data.credentials;
          _session?.rtcManager
              ?.updateReportingInterval(success.data.reportingIntervalMs);

          return Result.success(success.data.credentials);
        },
        failure: (failure) {
          _logger.e(() => '[joinIfNeeded] failed: $failure');
          _stateManager.state = prevState;
          return failure;
        },
      );
    }

    _logger.w(() => '[joinIfNeeded] rejected (already joined): $_credentials');
    return Result.success(credentials);
  }

  Future<Result<CallJoinedData>> _performJoinCallRequest({
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

    // Apply call settings to connect options only when not reconnecting.
    if (_reconnectStrategy == SfuReconnectionStrategy.unspecified) {
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
    }

    _logger.v(() => '[joinCall] joinedMetadata: ${joinResult.data.metadata}');

    final joined = CallJoinedData(
      callCid: callCid,
      wasCreated: joinResult.data.wasCreated,
      metadata: joinResult.data.metadata,
      credentials: joinResult.data.credentials,
      reportingIntervalMs: joinResult.data.reportingIntervalMs,
    );

    _stateManager.lifecycleCallJoined(
      joined,
      callConnectOptions: connectOptions,
    );

    _logger.v(() => '[joinCall] completed: $joined');
    return Result.success(joined);
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
    StreamLimitsSettings? limits,
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
      limits: limits,
    );
  }

  Future<Result<None>> _startSession(
    CallSession session, {
    ReconnectDetails? reconnectDetails,
  }) async {
    _logger.d(
      () => '[startSession] sessionId: $session',
    );

    _session = session;

    _subscriptions.cancel(_idSessionEvents);
    _subscriptions.cancel(_idSessionStats);

    _subscriptions.add(
      _idSessionEvents,
      session.events.listen((event) {
        // _logger.log(
        //   event.logPriority,
        //   () => '[listenSfuEvent] event.type: ${event.runtimeType}',
        // );
        event.mapToCallEvent(state.value).emitIfNotNull(_callEvents);
        _onSfuEvent(event);
      }),
    );

    _subscriptions.add(
      _idSessionStats,
      session.stats.listen((stats) {
        _stats.emit(stats);
        _processStats(stats);
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

    final result = await session.start(reconnectDetails: reconnectDetails);

    return result.fold(
      success: (success) {
        _logger.v(() => '[startSession] success: $success');
        _fastReconnectDeadline = success.data.fastReconnectDeadline;
        return const Result.success(none);
      },
      failure: (failure) {
        _logger.e(() => '[startSession] failed: $failure');
        return failure;
      },
    );
  }

  void _processStats(CallStats stats) {
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

  Future<void> _onSfuEvent(SfuEvent sfuEvent) async {
    if (sfuEvent is SfuParticipantLeftEvent) {
      final callParticipants = [...state.value.callParticipants]..removeWhere(
          (participant) =>
              participant.userId == sfuEvent.participant.userId &&
              participant.sessionId == sfuEvent.participant.sessionId,
        );

      if (callParticipants.length == 1 &&
          callParticipants.first.userId == _streamVideo.currentUser.id &&
          state.value.isRingingFlow &&
          _stateManager.callPreferences.dropIfAloneInRingingFlow) {
        await leave();
      }
    } else if (sfuEvent is SfuHealthCheckResponseEvent) {
      _stateManager.setParticipantsCount(
        totalCount: sfuEvent.participantCount.total,
        anonymousCount: sfuEvent.participantCount.anonymous,
      );
    }

    if (sfuEvent is SfuSocketDisconnected) {
      _logger.w(() => '[onSfuEvent] socket disconnected');
    } else if (sfuEvent is SfuSocketFailed) {
      _logger.w(() => '[onSfuEvent] socket failed');
    } else if (sfuEvent is SfuGoAwayEvent) {
      _logger.w(() => '[onSfuEvent] go away, migrating sfu');
      await _reconnect(SfuReconnectionStrategy.migrate);
    }
    // error event
    else if (sfuEvent is SfuErrorEvent) {
      switch (sfuEvent.error.reconnectStrategy) {
        case SfuReconnectionStrategy.rejoin:
        case SfuReconnectionStrategy.fast:
        case SfuReconnectionStrategy.migrate:
          _logger.w(
            () =>
                '[onSfuEvent] SFU error: ${sfuEvent.error}, reconnect strategy: ${sfuEvent.error.reconnectStrategy}',
          );
          await _reconnect(sfuEvent.error.reconnectStrategy);
          break;
        case SfuReconnectionStrategy.disconnect:
          _logger.w(
            () => '[onSfuEvent] SFU error: ${sfuEvent.error}, leaving call',
          );
          await leave();
          break;
        case SfuReconnectionStrategy.unspecified:
          _logger.w(() => '[onSfuEvent] SFU error: ${sfuEvent.error}');
          break;
      }
    }
  }

  Future<void> _reconnect(SfuReconnectionStrategy strategy) async {
    if (_callReconnectLock.locked) {
      _logger.w(
        () =>
            '[reconnect] rejected $strategy (reconnect in progress: $_reconnectStrategy)',
      );
      return;
    }

    await _callReconnectLock.synchronized(() async {
      _reconnectStrategy = strategy;

      do {
        if (strategy != SfuReconnectionStrategy.migrate) {
          _reconnectAttempts++;
        }

        _stateManager.lifecycleCallConnecting(
          attempt: _reconnectAttempts,
          strategy: strategy,
        );

        _logger.d(
          () => '[reconnect] strategy: $strategy, attempt: $_reconnectAttempts',
        );

        try {
          final networkStatus = await _awaitNetworkAvailableFuture;
          _logger.v(() => '[reconnect] network: $networkStatus');

          if (networkStatus == InternetStatus.disconnected) {
            _logger.w(() => '[reconnect] reconnection timeout');
            _stateManager.lifecycleCallReconnectingFailed();
            return;
          }

          switch (_reconnectStrategy) {
            case SfuReconnectionStrategy.unspecified:
            case SfuReconnectionStrategy.disconnect:
              _logger
                  .v(() => '[reconnect]  No-op strategy $_reconnectStrategy');
            case SfuReconnectionStrategy.fast:
              _logger.v(() => '[reconnect] fast reconnect');
              await _reconnectFast();
            case SfuReconnectionStrategy.rejoin:
              _logger.v(() => '[reconnect] rejoin');
              await _reconnectRejoin();
            case SfuReconnectionStrategy.migrate:
              _logger.v(() => '[reconnect] migrate');
              await _reconnectMigrate();
          }
        } catch (error) {
          switch (error) {
            case OpenApiError() when error.apiError.unrecoverable ?? false:
            case APIError() when error.unrecoverable ?? false:
              _logger.w(() => '[reconnect] unrecoverable error');
              _stateManager.lifecycleCallReconnectingFailed();
              return;
            default:
              _logger.w(
                () =>
                    '[reconnect] reconnect failed, error: $error, strategy: $_reconnectStrategy, attempt: $_reconnectAttempts. Attempting with Rejoin strategy',
              );

              await Future<void>.delayed(
                _retryPolicy.backoff(_reconnectAttempts),
              );
              _reconnectStrategy = SfuReconnectionStrategy.rejoin;
          }
        }
      } while (state.value.status is! CallStatusConnected &&
          state.value.status is! CallStatusDisconnected &&
          state.value.status is! CallStatusReconnectionFailed);
    });
  }

  Future<void> _reconnectFast() async {
    _reconnectStrategy = SfuReconnectionStrategy.fast;
    await _join();
  }

  Future<void> _reconnectRejoin() async {
    _reconnectStrategy = SfuReconnectionStrategy.rejoin;
    await _join();
  }

  Future<void> _reconnectMigrate() async {
    _reconnectStrategy = SfuReconnectionStrategy.migrate;
    await _join();
    final result = await _session?.waitForMigrationComplete();

    await _previousSession?.close(StreamWebSocketCloseCode.disposeOldSocket);

    result?.fold(
      success: (_) {
        _stateManager.lifecycleCallConnected();
      },
      failure: (_) {
        _reconnectStrategy = SfuReconnectionStrategy.rejoin;
      },
    );
  }

  Future<InternetStatus> _awaitNetworkAvailable() async {
    _logger.v(() => '[awaitNetworkAwailable] starting timer');
    final fastReconnectTimer = Timer(_fastReconnectDeadline, () {
      _logger.w(() => '[awaitNetworkAwailable] too late for fast reconnect');
      if (_reconnectStrategy == SfuReconnectionStrategy.fast) {
        _reconnectStrategy = SfuReconnectionStrategy.rejoin;
      }
    });

    final connectionStatus = await InternetConnection.createInstance(
      checkInterval: const Duration(seconds: 1),
    )
        .onStatusChange
        .firstWhere((status) => status == InternetStatus.connected)
        .timeout(
          _retryPolicy.config.callRejoinTimeout,
          onTimeout: () {
            _logger.w(() => '[awaitNetworkAwailable] timeout');
            return InternetStatus.disconnected;
          },
        )
        .asCancelable()
        .storeIn(_idFastReconnectTimeout, _cancelables)
        .valueOrDefault(InternetStatus.disconnected);

    fastReconnectTimer.cancel();
    return connectionStatus;
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

  /// Leaves the call.
  ///
  /// - [reason]: optional reason for leaving the call
  Future<Result<None>> leave({DisconnectReason? reason}) async {
    final state = this.state.value;
    _logger.i(() => '[leave] state: $state');

    if (state.status.isDisconnected) {
      _logger.w(() => '[leave] rejected (state.status is disconnected)');
      return const Result.success(none);
    }

    try {
      _session?.leave(reason: 'user is leaving the call');
    } finally {
      await _clear('leave');
    }

    _stateManager.lifecycleCallDisconnected(reason: reason);
    _logger.v(() => '[leave] finished');

    return const Result.success(none);
  }

  Future<void> _clear(String src) async {
    _logger.d(() => '[clear] src: $src');

    for (final timer in _reactionTimers) {
      timer.cancel();
    }

    _subscriptions.cancelAll();
    _cancelables.cancelAll();
    await _session?.dispose();
    _session = null;
    await dynascaleManager.dispose();
    await _streamVideo.state.setActiveCall(null);
    await _streamVideo.state.setOutgoingCall(null);
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

  /// Takes a picture of a VideoTrack at highest possible resolution
  ///
  /// - [participant]: the participant whose track to take a screenshot of
  /// - [trackType]: optional type of track to take a screenshot of, defaults to [SfuTrackType.video]
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
      targetResolution: settings.video.targetResolution,
      screenShareTargetResolution: settings.screenShare.targetResolution,
    );
  }

  Future<void> _applyConnectOptions() async {
    _logger.d(() => '[applyConnectOptions] connectOptions: $_connectOptions');
    await _applyCameraOption(
      _connectOptions.camera,
      _connectOptions.cameraFacingMode,
      _connectOptions.targetResolution,
    );
    await _applyMicrophoneOption(_connectOptions.microphone);
    await _applyScreenShareOption(
      _connectOptions.screenShare,
      _connectOptions.screenShareTargetResolution,
    );

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
    StreamTargetResolution? targetResolution,
  ) async {
    if (cameraOption is TrackProvided) {
      await _setLocalTrack(cameraOption.track);
    } else if (cameraOption is TrackEnabled) {
      await setCameraEnabled(
        enabled: true,
        constraints: CameraConstraints(
          facingMode: facingMode,
          params: targetResolution?.toVideoParams() ??
              RtcVideoParametersPresets.h720_16x9,
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

  Future<void> _applyScreenShareOption(
    TrackOption screenShareOption,
    StreamTargetResolution? targetResolution,
  ) async {
    if (screenShareOption is TrackProvided) {
      await _setLocalTrack(screenShareOption.track);
    } else if (screenShareOption is TrackEnabled) {
      await setScreenShareEnabled(
        enabled: true,
        constraints: ScreenShareConstraints(
          params: targetResolution?.toVideoParams(
                defaultBitrate: RtcVideoParametersPresets.k1080pBitrate,
              ) ??
              RtcVideoParametersPresets.h1080_16x9,
        ),
      );
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

  /// Adds members to the current call.
  Future<Result<None>> addMembers(List<UserInfo> users) {
    return _coordinatorClient.addMembers(
      callCid: callCid,
      members: users.map((user) {
        return MemberRequest(userId: user.id, role: user.role);
      }).toList(),
    );
  }

  /// Removes members from the current call.
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

  /// Loads the information about the call.
  ///
  /// - [ringing]: If `true`, sends a VoIP notification, triggering the native call screen on iOS and Android.
  /// - [notify]: If `true`, sends a standard push notification.
  /// - [video]: Marks the call as a video call if `true`; otherwise, audio-only.
  /// - [watch]:  If `true`, listens to coordinator events and updates call state accordingly.
  /// - [membersLimit]: Sets the total number of members to return as part of the response.
  Future<Result<CallReceivedData>> get({
    int? membersLimit,
    bool ringing = false,
    bool notify = false,
    bool video = false,
    bool watch = true,
  }) async {
    _logger.d(
      () => '[get] cid: $callCid, membersLimit: $membersLimit'
          ', ringing: $ringing, notify: $notify, video: $video',
    );

    if (watch) {
      _observeEvents();
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
        _stateManager.updateFromCallReceivedData(
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

  /// Loads the information about the call and creates it if it doesn't exist.
  ///
  /// - [ringing]: If `true`, sends a VoIP notification, triggering the native call screen on iOS and Android.
  /// - [notify]: If `true`, sends a standard push notification.
  /// - [video]: Marks the call as a video call if `true`; otherwise, audio-only.
  /// - [watch]:  If `true`, listens to coordinator events and updates call state accordingly.
  Future<Result<CallReceivedOrCreatedData>> getOrCreate({
    List<String> memberIds = const [],
    bool ringing = false,
    bool video = false,
    bool watch = true,
    bool? notify,
    String? team,
    DateTime? startsAt,
    StreamBackstageSettings? backstage,
    StreamLimitsSettings? limits,
    Map<String, Object> custom = const {},
  }) async {
    _logger.d(
      () => '[getOrCreate] cid: $callCid, ringing: $ringing, '
          'memberIds: $memberIds',
    );

    if (watch) {
      _observeEvents();
    }

    if (ringing) {
      await _streamVideo.state.setOutgoingCall(this);
    }

    final settingsOverride = CallSettingsRequest(
      backstage: backstage?.toOpenDto(),
      limits: limits?.toOpenDto(),
    );

    final response = await _coordinatorClient.getOrCreateCall(
      callCid: callCid,
      ringing: ringing,
      members: {...memberIds, _streamVideo.state.currentUser.id}.map((id) {
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

        _stateManager.updateFromCallCreatedData(
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
  /// action else it will result in an error.
  Future<Result<None>> muteOthers({TrackType track = TrackType.audio}) {
    return _permissionsManager.muteOthers(track: track);
  }

  /// Allows for the muting of all users on a call including the current user
  /// calling the function.
  ///
  /// Note: The user calling this function must have permission to perform the
  /// action else it will result in an error.
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
    if (enabled && !hasPermission(CallPermission.sendVideo)) {
      return Result.error('Missing permission to send video');
    }

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
    if (enabled && !hasPermission(CallPermission.sendAudio)) {
      return Result.error('Missing permission to send video');
    }

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

    final updatedConstraints =
        (constraints ?? const ScreenShareConstraints()).copyWith(
      params: constraints?.params ??
          _connectOptions.screenShareTargetResolution?.toVideoParams(
            defaultBitrate: RtcVideoParametersPresets.k1080pBitrate,
          ),
    );

    final result = await _session?.setScreenShareEnabled(
          enabled,
          constraints: updatedConstraints,
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
    final result = await dynascaleManager.setSubscriptions(changes);
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

    final result = await dynascaleManager.setSubscriptions([
      change,
    ]);

    return result;
  }

  Future<Result<None>> updateSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required SfuTrackTypeVideo trackType,
    RtcVideoDimension? videoDimension,
  }) async {
    final result = await dynascaleManager.updateSubscription(
      SubscriptionChange.update(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
        videoDimension: videoDimension,
      ),
    );

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
    final result = await dynascaleManager.updateSubscription(
      SubscriptionChange.update(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
      ),
    );

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

  /// Specifies the preference for incoming video resolution. The preference will
  /// be matched as closely as possible, but the actual resolution will depend
  /// on the video source quality and client network conditions. This will enable
  /// incoming video if it was previously disabled.
  ///
  /// [resolution] is the preferred resolution, or `null` to clear the preference.
  /// [sessionIds] optionally specifies the session IDs of the participants this
  /// preference affects. By default, it affects all participants.
  Future<Result<None>> setPreferredIncomingVideoResolution(
    VideoResolution? resolution, {
    List<String>? sessionIds,
  }) async {
    dynascaleManager.setVideoTrackSubscriptionOverrides(
      override: resolution != null
          ? VideoTrackSubscriptionOverride(
              dimension: RtcVideoDimension(
                width: resolution.width,
                height: resolution.height,
              ),
            )
          : null,
      sessionIds: sessionIds,
    );

    return dynascaleManager.applyTrackSubscriptions();
  }

  /// Enables or disables incoming video from all remote call participants,
  /// and removes any preference for preferred resolution.
  Future<Result<None>> setIncomingVideoEnabled(bool enabled) async {
    dynascaleManager.setVideoTrackSubscriptionOverrides(
      override: VideoTrackSubscriptionOverride(enabled: enabled),
    );

    return dynascaleManager.applyTrackSubscriptions();
  }

  Future<Result<QueriedMembers>> queryMembers({
    required Map<String, Object> filterConditions,
    String? next,
    String? prev,
    List<SortParamRequest> sorts = const [],
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
