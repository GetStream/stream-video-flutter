import 'dart:async';

import 'package:async/async.dart' as async;

import '../../stream_video.dart';
import '../action/call_action.dart';
import '../action/external_action.dart';
import '../action/internal/coordinator_action.dart';
import '../action/internal/lifecycle_action.dart';
import '../call_state_manager.dart';
import '../coordinator/models/coordinator_events.dart';
import '../errors/video_error_composer.dart';
import '../middleware/query_members_middleware.dart';
import '../models/call_credentials.dart';
import '../retry/retry_policy.dart';
import '../sfu/data/events/sfu_events.dart';
import '../shared_emitter.dart';
import '../state_emitter.dart';
import '../utils/cancelables.dart';
import '../utils/none.dart';
import '../utils/standard.dart';
import '../webrtc/sdp/editor/sdp_editor_impl.dart';
import '../webrtc/sdp/policy/rule/sdp_munging_rule.dart';
import 'permissions/permissions_manager.dart';
import 'permissions/permissions_manager_impl.dart';
import 'session/call_session.dart';
import 'session/call_session_factory.dart';

const _idState = 1;
const _idCoordEvents = 2;
const _idSessionEvents = 3;
const _idSessionStats = 4;
const _idConnect = 5;
const _idAwait = 6;

const _tag = 'SV:Call';

int _callSeq = 1;

/// Represents a [CallImpl] in which you can connect to.
class CallImpl implements Call {
  factory CallImpl({
    required StreamCallCid callCid,
    StreamVideo? streamVideo,
    RetryPolicy? retryPolicy,
  }) {
    streamLog.i(_tag, () => '<factory> callCid: $callCid');
    return CallImpl._internal(
      callCid: callCid,
      streamVideo: streamVideo,
      retryPolicy: retryPolicy,
    );
  }

  factory CallImpl.created({
    required CallCreatedData data,
    StreamVideo? streamVideo,
    RetryPolicy? retryPolicy,
  }) {
    streamLog.i(_tag, () => '<factory> created: $data');
    return CallImpl._internal(
      callCid: data.callCid,
      streamVideo: streamVideo,
      retryPolicy: retryPolicy,
    ).also((it) => it._stateManager.dispatch(SetLifecycleStage.created(data)));
  }

  factory CallImpl.joined({
    required CallJoinedData data,
    StreamVideo? streamVideo,
    RetryPolicy? retryPolicy,
  }) {
    streamLog.i(_tag, () => '<factory> joined: $data');
    return CallImpl._internal(
      callCid: data.callCid,
      streamVideo: streamVideo,
      retryPolicy: retryPolicy,
      credentials: data.credentials,
    ).also((it) => it._stateManager.dispatch(SetLifecycleStage.joined(data)));
  }

  factory CallImpl._internal({
    required StreamCallCid callCid,
    StreamVideo? streamVideo,
    RetryPolicy? retryPolicy,
    CallCredentials? credentials,
  }) {
    final finalStreamVideo = streamVideo ?? StreamVideo.instance;
    final finalRetryPolicy = retryPolicy ?? finalStreamVideo.retryPolicy;
    final stateManager = _makeStateManager(callCid, finalStreamVideo);
    final permissionManager = _makePermissionAwareManager(
      callCid,
      finalStreamVideo,
      stateManager,
    );
    return CallImpl._(
      streamVideo: finalStreamVideo,
      retryPolicy: finalRetryPolicy,
      stateManager: stateManager,
      credentials: credentials,
      permissionManager: permissionManager,
    );
  }

  CallImpl._({
    required StreamVideo streamVideo,
    required RetryPolicy retryPolicy,
    required CallStateManager stateManager,
    required PermissionsManager permissionManager,
    CallCredentials? credentials,
  })  : _sessionFactory = CallSessionFactory(
          callCid: stateManager.state.value.callCid,
          sdpEditor: SdpEditorImpl(streamVideo.sdpPolicy),
        ),
        _stateManager = stateManager,
        _permissionsManager = permissionManager,
        _streamVideo = streamVideo,
        _retryPolicy = retryPolicy,
        _credentials = credentials {
    streamLog.i(_tag, () => '<init> state: ${stateManager.state.value}');
    _subscriptions.add(
      _idState,
      stateManager.state.listen((state) async => _onStateChanged(state)),
    );
    _subscriptions.add(
      _idCoordEvents,
      streamVideo.events.on<CoordinatorCallEvent>((event) async {
        await _onCoordinatorEvent(event);
      }),
    );
  }

  late final _logger = taggedLogger(tag: '$_tag-${_callSeq++}');
  late final _subscriptions = Subscriptions();
  late final _cancelables = Cancelables();

  final StreamVideo _streamVideo;
  final RetryPolicy _retryPolicy;
  final CallSessionFactory _sessionFactory;
  final CallStateManager _stateManager;
  final PermissionsManager _permissionsManager;

  CallCredentials? _credentials;
  int _reconnectAttempt = 0;

  @override
  StreamCallCid get callCid => state.value.callCid;

  @override
  StateEmitter<CallState> get state => _stateManager.state;

  @override
  SharedEmitter<CallStats> get stats => _stats;
  late final _stats = MutableSharedEmitterImpl<CallStats>();

  @override
  SharedEmitter<SfuEvent> get events => _events;
  final _events = MutableSharedEmitterImpl<SfuEvent>();

  @override
  OnCallPermissionRequest? onPermissionRequest;

  final _status = MutableStateEmitterImpl<_ConnectionStatus>(
    _ConnectionStatus.disconnected,
  );

  CallSession? _session;

  CallConnectOptions _connectOptions = const CallConnectOptions();

  @override
  String toString() {
    return 'Call{cid: $callCid}';
  }

  @override
  CallConnectOptions get connectOptions {
    return _connectOptions;
  }

  @override
  set connectOptions(CallConnectOptions connectOptions) {
    final status = _status.value;
    if (status == _ConnectionStatus.connecting ||
        status == _ConnectionStatus.connected) {
      _logger.w(
        () => '[setConnectOptions] rejected (connectOptions must be'
            ' set before invoking `connect`)',
      );
      return;
    }
    _logger.d(() => '[setConnectOptions] connectOptions: $connectOptions)');
    _connectOptions = connectOptions;
  }

  // This is only used in [_onStateChanged] to determine the difference between
  // the previous and current state. It should not be used for any other
  // purpose. It is not guaranteed to be the latest, Use [state] instead.
  CallState? _prevState;

  Future<void> _onStateChanged(CallState state) async {
    final status = state.status;
    _logger.v(() => '[onStateChanged] status: $status');
    if (status is CallStatusDisconnected) {
      await _clear('status-disconnected');
    }

    if (_prevState?.settings.audio.opusDtxEnabled !=
        state.settings.audio.opusDtxEnabled) {
      _sessionFactory.sdpEditor.upsert(
        SdpMungingRule.setOpusDtxEnabled(
          enabled: state.settings.audio.opusDtxEnabled,
        ),
      );
    }
    if (_prevState?.settings.audio.redundantCodingEnabled !=
        state.settings.audio.redundantCodingEnabled) {
      _sessionFactory.sdpEditor.upsert(
        SdpMungingRule.setOpusRedEnabled(
          enabled: state.settings.audio.redundantCodingEnabled,
        ),
      );
    }

    _prevState = state;
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
    _stateManager.dispatch(CoordinatorEventAction(event));
  }

  @override
  Future<Result<None>> accept() async {
    final state = this.state.value;
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(() => '[acceptCall] rejected (invalid status): $status');
      return Result.error('invalid status: $status');
    }
    final result = await _streamVideo.acceptCall(
      cid: state.callCid,
    );
    if (result is Success<None>) {
      _stateManager.dispatch(SetLifecycleStage.accepted());
    }
    return result;
  }

  @override
  Future<Result<None>> reject() async {
    final state = this.state.value;
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(() => '[rejectCall] rejected (invalid status): $status');
      return Result.error('invalid status: $status');
    }
    final result = await _streamVideo.rejectCall(
      cid: state.callCid,
    );
    if (result is Success<None>) {
      _stateManager.dispatch(SetLifecycleStage.rejected());
    }
    return result;
  }

  @override
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
    _stateManager.dispatch(SetLifecycleStage.ended());
    _logger.v(() => '[end] completed: $result');
    return result;
  }

  @override
  Future<Result<None>> join() async {
    _logger.d(() => '[join] no args');
    _stateManager.dispatch(SetLifecycleStage.joining());
    final joinedResult = await _joinIfNeeded();
    if (joinedResult is Success<CallCredentials>) {
      _logger.v(() => '[join] completed');
      return Result.success(None());
    } else {
      final failedResult = joinedResult as Failure;
      _logger.e(() => '[join] failed: $failedResult');
      final error = failedResult.error;
      _stateManager.dispatch(SetLifecycleStage.connectFailed(error));
      return failedResult;
    }
  }

  @override
  Future<Result<None>> connect() async {
    _logger.i(() => '[connect] status: ${_status.value}');
    if (_status.value == _ConnectionStatus.connected) {
      _logger.w(() => '[connect] rejected (connected)');
      return Result.success(None());
    }
    if (_status.value == _ConnectionStatus.connecting) {
      _logger.v(() => '[connect] await "connecting" change');
      final status = await _status.firstWhere(
        (it) => it != _ConnectionStatus.connecting,
        timeLimit: _connectOptions.dropTimeout,
      );
      if (status == _ConnectionStatus.connected) {
        return Result.success(None());
      } else {
        return Result.error('original "connect" failed');
      }
    }
    await Call.activeCall?.disconnect();
    if (Call.activeCall == null) {
      Call.activeCall = this;
      Call.onActiveCall?.call(this);
    }
    _status.value = _ConnectionStatus.connecting;
    final result = await _connect()
        .asCancelable()
        .storeIn(_idConnect, _cancelables)
        .valueOrDefault(Result.error('connect cancelled'));
    if (result.isSuccess) {
      _logger.v(() => '[connect] finished: $result');
      _status.value = _ConnectionStatus.connected;
    } else {
      _logger.e(() => '[connect] failed: $result');
      await disconnect();
    }
    return result;
  }

  Future<Result<None>> _connect() async {
    _logger.d(() => '[connect] options: $_connectOptions');
    final validation = await _stateManager.validateUserId(_streamVideo);
    if (validation.isFailure) {
      _logger.w(() => '[connect] rejected (validation): $validation');
      return validation;
    }
    _logger.v(() => '[connect] validated');

    final state = this.state.value;
    final status = state.status;
    if (!status.isConnectable) {
      _logger.w(() => '[connect] rejected (not Connectable): $status');
      return Result.error('invalid status: $status');
    }
    final timeout = _connectOptions.dropTimeout;
    final result = await _awaitIfNeeded(timeout);
    if (result.isFailure) {
      _logger.e(() => '[connect] waiting failed: $result');
      _stateManager.dispatch(SetLifecycleStage.timeout(timeout));
      return result;
    }

    _stateManager.dispatch(SetLifecycleStage.connecting(_reconnectAttempt));
    _logger.v(() => '[connect] joining to coordinator');
    final joinedResult = await _joinIfNeeded();
    if (joinedResult is! Success<CallCredentials>) {
      _logger.e(() => '[connect] joining failed: $joinedResult');
      final error = (joinedResult as Failure).error;
      _stateManager.dispatch(SetLifecycleStage.connectFailed(error));
      return result;
    }

    _logger.v(() => '[connect] starting sfu session');
    final sessionResult = await _startSession(joinedResult.data);
    if (sessionResult is! Success<None>) {
      _logger.w(() => '[connect] sfu session start failed: $sessionResult');
      final error = (sessionResult as Failure).error;
      _stateManager.dispatch(SetLifecycleStage.connectFailed(error));
      return sessionResult;
    }
    _logger.v(() => '[connect] started session');
    _stateManager.dispatch(SetLifecycleStage.connected());
    await _applyConnectOptions();

    _logger.v(() => '[connect] completed');
    return Result.success(None());
  }

  Future<Result<CallCredentials>> _joinIfNeeded() async {
    final state = this.state.value;
    final creds = _credentials;
    if (creds != null) {
      _logger.w(() => '[joinIfNeeded] rejected (already joined): $creds');
      return Result.success(creds);
    }
    _logger.d(() => '[joinIfNeeded] no args');
    final joinedResult = await _streamVideo.joinCall(
      cid: state.callCid,
      create: true,
      onReceivedOrCreated: (data) async {
        _stateManager.dispatch(SetLifecycleStage.created(data.data));
      },
    );
    if (joinedResult is Success<CallJoinedData>) {
      _logger.v(() => '[joinIfNeeded] completed');
      _stateManager.dispatch(SetLifecycleStage.joined(joinedResult.data));
      _credentials = joinedResult.data.credentials;
      return Result.success(joinedResult.data.credentials);
    }
    _logger.e(() => '[joinIfNeeded] failed: $joinedResult');
    return joinedResult as Failure;
  }

  Future<Result<None>> _startSession(CallCredentials credentials) async {
    _logger.d(() => '[startSession] credentials: $credentials');
    _credentials = null;
    final session = await _sessionFactory.makeCallSession(
      credentials: credentials,
      stateManager: _stateManager,
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
        _events.emit(event);
        _onSfuEvent(event);
      }),
    );
    _subscriptions.add(_idSessionStats, session.stats.listen(_stats.emit));
    _stateManager.dispatch(SetLifecycleStage.sessionStart(session.sessionId));
    final result = await session.start();
    _logger.v(() => '[startSession] completed: $result');
    return result;
  }

  Future<void> _onSfuEvent(SfuEvent sfuEvent) async {
    if (sfuEvent is SfuSocketDisconnected) {
      await _reconnect(sfuEvent.reason);
    } else if (sfuEvent is SfuSocketFailed) {
      await _reconnect(sfuEvent.error);
    }
  }

  Future<void> _reconnect(dynamic reason) async {
    if (_status.value == _ConnectionStatus.disconnected) {
      _logger.w(() => '[reconnect] rejected (disconnected)');
      return;
    }
    if (_status.value == _ConnectionStatus.connecting) {
      _logger.w(() => '[reconnect] rejected (connecting)');
      return;
    }
    _status.value = _ConnectionStatus.connecting;
    _logger.w(() => '[reconnect] >>>>>>>>>>>>>>>> reason: $reason');
    _subscriptions.cancel(_idSessionEvents);
    await _session?.dispose();
    _session = null;

    Result<None> result;
    final startTime = DateTime.now().toUtc().millisecondsSinceEpoch;
    while (true) {
      _reconnectAttempt++;
      _stateManager.dispatch(SetLifecycleStage.connecting(_reconnectAttempt));
      if (_status.value == _ConnectionStatus.disconnected) {
        _logger.w(() =>
            '[reconnect] attempt($_reconnectAttempt) rejected (disconnected)');
        _logger.v(() => '[reconnect] <<<<<<<<<<<<<<< rejected');
        return;
      }
      final elapsed = DateTime.now().toUtc().millisecondsSinceEpoch - startTime;
      if (elapsed > _retryPolicy.config.callRejoinTimeout.inMilliseconds) {
        _logger.w(() => '[reconnect] timeout exceed');
        result = Result.error('was unable to reconnect in 15 seconds');
        break;
      }
      final delay = _retryPolicy.backoff(_reconnectAttempt);
      _logger.v(
        () => '[reconnect] attempt: $_reconnectAttempt, '
            'elapsed: $elapsed, delay: $delay',
      );
      await Future<void>.delayed(delay);
      _logger.v(() => '[reconnect] joining to coordinator');
      final joinedResult = await _joinIfNeeded();
      if (joinedResult is! Success<CallCredentials>) {
        _logger.e(() => '[reconnect] joining failed: $joinedResult');
        continue;
      }
      _logger.v(() => '[reconnect] starting session');
      result = await _startSession(joinedResult.data);
      if (result is! Success<None>) {
        _logger.w(() => '[reconnect] session start failed: $result');
        continue;
      }
      _logger.v(() => '[reconnect] session started');
      break;
    }
    _reconnectAttempt = 0;
    if (result.isFailure) {
      _logger.e(() => '[reconnect] <<<<<<<<<<<<<<< failed: $result');
      _status.value = _ConnectionStatus.disconnected;
      final error = (result as Failure).error;
      _stateManager.dispatch(SetLifecycleStage.connectFailed(error));
      return;
    }
    _logger.v(() => '[reconnect] <<<<<<<<<<<<<<< completed');
    _stateManager.dispatch(SetLifecycleStage.connected());
    _status.value = _ConnectionStatus.connected;
    await _applyConnectOptions();
    _logger.v(() => '[reconnect] <<<<<<<<<<<<<<< side effects applied');
  }

  Future<Result<None>> _awaitIfNeeded(Duration timeLimit) async {
    final state = this.state.value;
    final status = state.status;
    Future<Result<None>>? futureResult;
    if (status is CallStatusOutgoing && !status.acceptedByCallee) {
      _logger.d(() => '[awaitIfNeeded] outgoing to be accepted by callee');
      futureResult = _awaitOutgoingToBeAccepted(timeLimit);
    } else if (status is CallStatusIncoming && !status.acceptedByMe) {
      _logger.d(() => '[awaitIfNeeded] incoming to be accepted by me');
      futureResult = _awaitIncomingToBeAccepted(timeLimit);
    } else if (status is CallStatusJoining) {
      _logger.d(() => '[awaitIfNeeded] joining to become joined');
      futureResult = _awaitCallToBeJoined();
    }
    if (futureResult != null) {
      _logger.v(() => '[awaitIfNeeded] return cancelable');
      return futureResult.asCancelable().storeIn(_idAwait, _cancelables).value;
    }
    return Result.success(None());
  }

  @override
  Future<Result<None>> disconnect() async {
    final state = this.state.value;
    _logger.i(() => '[disconnect] ${_status.value}; state: $state');
    if (state.status.isDisconnected) {
      _logger.w(() => '[disconnect] rejected (state.status is disconnected)');
      return Result.success(None());
    }
    if (_status.value == _ConnectionStatus.disconnected) {
      _logger.w(() => '[disconnect] rejected (status is disconnected)');
      return Result.success(None());
    }
    _status.value = _ConnectionStatus.disconnected;
    await _clear('disconnect');
    _stateManager.dispatch(SetLifecycleStage.disconnected());
    _logger.v(() => '[disconnect] finished');
    return Result.success(None());
  }

  Future<void> _clear(String src) async {
    _logger.d(() => '[clear] src: $src');
    _status.value = _ConnectionStatus.disconnected;
    _subscriptions.cancel(_idSessionEvents);
    _subscriptions.cancel(_idSessionStats);
    _cancelables.cancelAll();
    await _session?.dispose();
    _session = null;
    if (Call.activeCall != null) {
      Call.activeCall = null;
      Call.onActiveCall?.call(null);
    }
    _logger.v(() => '[clear] completed');
  }

  @override
  Future<Result<None>> setLocalTrack(RtcLocalTrack track) async {
    return _setLocalTrack(track);
  }

  @override
  RtcTrack? getTrack(String trackIdPrefix, SfuTrackType trackType) {
    return _session?.getTrack(trackIdPrefix, trackType);
  }

  @override
  List<RtcTrack> getTracks(String trackIdPrefix) {
    return [...?_session?.getTracks(trackIdPrefix)];
  }

  @override
  Future<Result<None>> apply(StreamExternalAction action) async {
    _logger.d(() => '[apply] action: $action');
    final result = await _apply(action);
    _logger.v(() => '[apply] result: $result');
    if (result.isSuccess) {
      _stateManager.dispatch(action);
    }
    return result;
  }

  Future<Result<None>> _apply(StreamExternalAction action) async {
    if (action is CallAction) {
      return _permissionsManager.apply(action);
    } else if (action is ParticipantAction) {
      return _session.apply(action);
    }
    return Result.error('unsupported action: $action');
  }

  Future<void> _applyConnectOptions() async {
    _logger.d(() => '[applyConnectOptions] connectOptions: $_connectOptions');
    await _applyCameraOption(_connectOptions.camera);
    await _applyMicrophoneOption(_connectOptions.microphone);
    await _applyScreenShareOption(_connectOptions.screenShare);
    _logger.v(() => '[applyConnectOptions] finished');
  }

  Future<void> _applyCameraOption(TrackOption cameraOption) async {
    if (cameraOption is TrackProvided) {
      await _setLocalTrack(cameraOption.track);
    } else if (cameraOption is TrackEnabled) {
      await setCameraEnabled(enabled: true);
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
      final action = track.composeControlAction();
      _logger.v(() => '[setLocalTrack] composed action: $action');
      if (action != null) {
        _stateManager.dispatch(action);
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
      _logger.e(() => '[awaitIncomingToBeAccepted] completed');
      return Result.success(None());
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
      _logger.e(() => '[awaitOutgoingToBeAccepted] completed');
      return Result.success(None());
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
      return Result.success(None());
    }).onError((e, stk) {
      _logger.e(() => '[awaitCallToBeJoined] failed: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    });
  }

  @override
  Future<Result<None>> inviteUsers(List<UserInfo> users) {
    return _streamVideo.inviteUsers(callCid: callCid.value, users: users);
  }
}

CallStateManager _makeStateManager(
  StreamCallCid callCid,
  StreamVideo streamVideo,
) {
  final currentUserId = streamVideo.currentUser?.id ?? '';
  final middlewares = [
    QueryMembersMiddleware(streamVideo: streamVideo),
  ];

  return CallStateManagerImpl(
    initialState: CallState(
      currentUserId: currentUserId,
      callCid: callCid,
    ),
    middlewares: middlewares,
  );
}

PermissionsManager _makePermissionAwareManager(
  StreamCallCid callCid,
  StreamVideo streamVideo,
  CallStateManager stateManager,
) {
  return PermissionsManagerImpl(
    callCid: callCid,
    streamVideo: streamVideo,
    stateManager: stateManager,
  );
}

extension on CallStateManager {
  Future<Result<None>> validateUserId(StreamVideo streamVideo) async {
    final stateUserId = state.value.currentUserId;
    final currentUserId = streamVideo.currentUser?.id ?? '';
    if (currentUserId.isEmpty) {
      return Result.error('no userId');
    }
    if (stateUserId.isEmpty) {
      dispatch(SetUserId(currentUserId));
    }
    return Result.success(None());
  }
}

extension on RtcLocalTrack {
  ParticipantAction? composeControlAction() {
    if (mediaConstraints is AudioConstraints) {
      return const SetMicrophoneEnabled(enabled: true);
    } else if (mediaConstraints is CameraConstraints) {
      return const SetCameraEnabled(enabled: true);
    } else if (mediaConstraints is ScreenShareConstraints) {
      return const SetScreenShareEnabled(enabled: true);
    }
    streamLog.e(_tag, () => '[composeControlAction] failed: $mediaConstraints');
    return null;
  }
}

@Deprecated('Rely on CallStatus')
enum _ConnectionStatus {
  disconnected,
  connecting,
  connected;

  @override
  String toString() {
    return name;
  }
}

extension<T> on async.CancelableOperation<T> {
  Future<T> valueOrDefault(T cancellationValue) {
    return valueOrCancellation(cancellationValue).then((value) => value!);
  }

  async.CancelableOperation<T> storeIn(int id, Cancelables cancelables) {
    cancelables.add(id, this);
    return this;
  }
}

extension<T> on Future<T> {
  async.CancelableOperation<T> asCancelable() {
    return async.CancelableOperation.fromFuture(this);
  }
}

extension on CallSession? {
  Future<Result<None>> apply(ParticipantAction action) async {
    final tag = '$_tag-$_callSeq';
    final session = this;
    if (session == null) {
      streamLog.w(tag, () => '[apply] rejected (session is null);');
      return Result.error('no call session');
    }
    final result = await session.apply(action);
    streamLog.v(tag, () => '[apply] completed: $result');
    return result;
  }
}
