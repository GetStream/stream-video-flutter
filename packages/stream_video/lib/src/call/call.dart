import 'dart:async';

import '../../stream_video.dart';
import '../action/call_action.dart';
import '../action/internal/lifecycle_action.dart';
import '../coordinator/models/coordinator_events.dart';
import '../errors/video_error_composer.dart';
import '../models/call_credentials.dart';
import '../models/call_permission.dart';
import '../retry/retry_policy.dart';
import '../sfu/data/events/sfu_events.dart';
import '../shared_emitter.dart';
import '../state_emitter.dart';
import '../utils/cancelable_operation.dart';
import '../utils/cancelables.dart';
import '../utils/future.dart';
import '../utils/none.dart';
import '../utils/standard.dart';
import '../webrtc/sdp/editor/sdp_editor_impl.dart';
import 'permissions/permissions_manager.dart';
import 'session/call_session.dart';
import 'session/call_session_factory.dart';
import 'state/call_state_notifier.dart';

typedef OnCallPermissionRequest = void Function(
  CoordinatorCallPermissionRequestEvent,
);

const _idState = 1;
const _idCoordEvents = 2;
const _idSessionEvents = 3;
const _idSessionStats = 4;
const _idConnect = 5;
const _idAwait = 6;

const _tag = 'SV:Call';

int _callSeq = 1;

/// Represents a [Call] in which you can connect to.
class Call {
  factory Call.from({
    required String type,
    required String id,
    StreamVideo? streamVideo,
    CallPreferences? preferences,
  }) {
    final callCid = StreamCallCid.from(type: type, id: id);
    streamLog.i(_tag, () => '<factory> callCid: $callCid');
    return Call._internal(
      callCid: callCid,
      streamVideo: streamVideo,
      preferences: preferences,
    );
  }

  factory Call.fromCid({
    required String cid,
    StreamVideo? streamVideo,
    CallPreferences? preferences,
  }) {
    final callCid = StreamCallCid(cid: cid);
    streamLog.i(_tag, () => '<factory> callCid: $callCid');
    return Call._internal(
      callCid: callCid,
      streamVideo: streamVideo,
      preferences: preferences,
    );
  }

  factory Call.fromCreated({
    required CallCreatedData data,
    StreamVideo? streamVideo,
    CallPreferences? preferences,
  }) {
    streamLog.i(_tag, () => '<factory> created: $data');
    return Call._internal(
      callCid: data.callCid,
      streamVideo: streamVideo,
      preferences: preferences,
    ).also((it) => it._stateManager.lifecycleCallCreated(CallCreated(data)));
  }

  factory Call.fromJoined({
    required CallJoinedData data,
    StreamVideo? streamVideo,
    CallPreferences? preferences,
  }) {
    streamLog.i(_tag, () => '<factory> joined: $data');
    return Call._internal(
      callCid: data.callCid,
      streamVideo: streamVideo,
      preferences: preferences,
      credentials: data.credentials,
    ).also((it) => it._stateManager.lifecycleCallJoined(CallJoined(data)));
  }

  factory Call._internal({
    required StreamCallCid callCid,
    StreamVideo? streamVideo,
    CallPreferences? preferences,
    CallCredentials? credentials,
  }) {
    final finalStreamVideo = streamVideo ?? StreamVideo.instance;
    final finalCallPreferences = preferences ?? DefaultCallPreferences();
    final stateManager = _makeStateManager(
      callCid,
      finalStreamVideo,
      finalCallPreferences,
    );
    final permissionManager = _makePermissionAwareManager(
      callCid,
      finalStreamVideo,
      stateManager,
    );
    return Call._(
      streamVideo: finalStreamVideo,
      preferences: finalCallPreferences,
      stateManager: stateManager,
      credentials: credentials,
      permissionManager: permissionManager,
    );
  }

  Call._({
    required StreamVideo streamVideo,
    required CallPreferences preferences,
    required CallStateNotifier stateManager,
    required PermissionsManager permissionManager,
    CallCredentials? credentials,
  })  : _sessionFactory = CallSessionFactory(
          callCid: stateManager.callState.callCid,
          sdpEditor: SdpEditorImpl(streamVideo.sdpPolicy),
        ),
        _stateManager = stateManager,
        _permissionsManager = permissionManager,
        _streamVideo = streamVideo,
        _preferences = preferences,
        _retryPolicy = streamVideo.retryPolicy,
        _credentials = credentials {
    streamLog.i(_tag, () => '<init> state: ${stateManager.callState}');
    _subscriptions.add(
      _idState,
      stateManager.callStateStream
          .listen((state) async => _onStateChanged(state)),
    );
    _subscriptions.add(
      _idCoordEvents,
      streamVideo.events.on<CoordinatorCallEvent>((event) async {
        await _onCoordinatorEvent(event);
      }),
    );
  }

  static Call? activeCall;
  static void Function(Call?)? onActiveCall;

  late final _logger = taggedLogger(tag: '$_tag-${_callSeq++}');
  late final _subscriptions = Subscriptions();
  late final _cancelables = Cancelables();

  final StreamVideo _streamVideo;
  //FIXME(Deven+Nash): What do we want to do about this?
  final RetryPolicy _retryPolicy;
  final CallPreferences _preferences;
  final CallSessionFactory _sessionFactory;
  final CallStateNotifier _stateManager;
  final PermissionsManager _permissionsManager;

  CallCredentials? _credentials;
  int _reconnectAttempt = 0;

  StreamCallCid get callCid => state.value.callCid;

  String get type => state.value.callType;

  String get id => state.value.callId;

  StateEmitter<CallState> get state => _stateManager.callStateStream;

  SharedEmitter<CallStats> get stats => _stats;
  late final _stats = MutableSharedEmitterImpl<CallStats>();

  SharedEmitter<SfuEvent> get events => _events;
  final _events = MutableSharedEmitterImpl<SfuEvent>();

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

  CallConnectOptions get connectOptions {
    return _connectOptions;
  }

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
    _sessionFactory.sdpEditor.opusDtxEnabled =
        state.settings.audio.opusDtxEnabled;
    _sessionFactory.sdpEditor.opusRedEnabled =
        state.settings.audio.redundantCodingEnabled;

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

    if (event is CoordinatorCallRejectedEvent) {
      return _stateManager.coordinatorUpdateCallRejected(event);
    } else if (event is CoordinatorCallAcceptedEvent) {
      return _stateManager.coordinatorUpdateCallAccepted(event);
    } else if (event is CoordinatorCallEndedEvent) {
      return _stateManager.coordinatorCallEnded(event);
    } else if (event is CoordinatorCallPermissionsUpdatedEvent) {
      return _stateManager.coordinatorCallPermissionsUpdated(event);
    } else if (event is CoordinatorCallRecordingStartedEvent) {
      return _stateManager.coordinatorCallRecordingStarted(event);
    } else if (event is CoordinatorCallRecordingStoppedEvent) {
      return _stateManager.coordinatorCallRecordingStopped(event);
    } else if (event is CoordinatorCallBroadcastingStartedEvent) {
      return _stateManager.coordinatorCallBroadcastingStarted(event);
    } else if (event is CoordinatorCallBroadcastingStoppedEvent) {
      return _stateManager.coordinatorCallBroadcastingStopped(event);
    }
  }

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
      _stateManager.lifecycleCallAccepted(const CallAccepted());
    }
    return result;
  }

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
      _stateManager.lifecycleCallRejected(const CallRejected());
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
    _stateManager.lifecycleCallEnded(const CallEnded());
    _logger.v(() => '[end] completed: $result');
    return result;
  }

  Future<Result<None>> join() async {
    _logger.d(() => '[join] no args');
    _stateManager.lifecycleCallJoining(const CallJoining());
    final joinedResult = await _joinIfNeeded();
    if (joinedResult is Success<CallCredentials>) {
      _logger.v(() => '[join] completed');
      return Result.success(None());
    } else {
      final failedResult = joinedResult as Failure;
      _logger.e(() => '[join] failed: $failedResult');
      final error = failedResult.error;
      _stateManager.lifecycleCallConnectFailed(ConnectFailed(error));
      return failedResult;
    }
  }

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
        timeLimit: _preferences.connectTimeout,
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
    final result = await _awaitIfNeeded();
    if (result.isFailure) {
      _logger.e(() => '[connect] waiting failed: $result');

      _stateManager.lifecycleCallTimeout(const CallTimeout());

      return result;
    }

    _stateManager
        .lifecycleCallConnectingAction(CallConnecting(_reconnectAttempt));
    _logger.v(() => '[connect] joining to coordinator');
    final joinedResult = await _joinIfNeeded();
    if (joinedResult is! Success<CallCredentials>) {
      _logger.e(() => '[connect] joining failed: $joinedResult');
      final error = (joinedResult as Failure).error;
      _stateManager.lifecycleCallConnectFailed(ConnectFailed(error));
      return result;
    }

    _logger.v(() => '[connect] starting sfu session');
    final sessionResult = await _startSession(joinedResult.data);
    if (sessionResult is! Success<None>) {
      _logger.w(() => '[connect] sfu session start failed: $sessionResult');
      final error = (sessionResult as Failure).error;
      _stateManager.lifecycleCallConnectFailed(ConnectFailed(error));
      return sessionResult;
    }
    _logger.v(() => '[connect] started session');
    _stateManager.lifecycleCallConnected(const CallConnected());
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
      onReceivedOrCreated: (call) async {
        _stateManager.lifecycleCallCreated(CallCreated(call.data));
      },
    );
    if (joinedResult is Success<CallJoinedData>) {
      _logger.v(() => '[joinIfNeeded] completed');
      _stateManager.lifecycleCallJoined(CallJoined(joinedResult.data));
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
    _stateManager
        .lifecycleCallSessionStart(CallSessionStart(session.sessionId));
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
      _stateManager
          .lifecycleCallConnectingAction(CallConnecting(_reconnectAttempt));
      if (_status.value == _ConnectionStatus.disconnected) {
        _logger.w(() =>
            '[reconnect] attempt($_reconnectAttempt) rejected (disconnected)');
        _logger.v(() => '[reconnect] <<<<<<<<<<<<<<< rejected');
        return;
      }
      final elapsed = DateTime.now().toUtc().millisecondsSinceEpoch - startTime;
      final retryPolicy = _streamVideo.retryPolicy;
      if (elapsed > retryPolicy.config.callRejoinTimeout.inMilliseconds) {
        _logger.w(() => '[reconnect] timeout exceed');
        result = Result.error('was unable to reconnect in 15 seconds');
        break;
      }
      final delay = retryPolicy.backoff(_reconnectAttempt);
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
      _stateManager.lifecycleCallConnectFailed(ConnectFailed(error));
      return;
    }
    _logger.v(() => '[reconnect] <<<<<<<<<<<<<<< completed');
    _stateManager.lifecycleCallConnected(const CallConnected());
    _status.value = _ConnectionStatus.connected;
    await _applyConnectOptions();
    _logger.v(() => '[reconnect] <<<<<<<<<<<<<<< side effects applied');
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
      _logger.d(() => '[awaitIfNeeded] joining to become joined');
      futureResult = _awaitCallToBeJoined();
    }
    if (futureResult != null) {
      _logger.v(() => '[awaitIfNeeded] return cancelable');
      return futureResult.asCancelable().storeIn(_idAwait, _cancelables).value;
    }
    return Result.success(None());
  }

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
    _stateManager.lifecycleCallDisconnected(const CallDisconnected());
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

  Future<Result<None>> setLocalTrack(RtcLocalTrack track) async {
    return _setLocalTrack(track);
  }

  RtcTrack? getTrack(String trackIdPrefix, SfuTrackType trackType) {
    return _session?.getTrack(trackIdPrefix, trackType);
  }

  List<RtcTrack> getTracks(String trackIdPrefix) {
    return [...?_session?.getTracks(trackIdPrefix)];
  }

  // Future<Result<None>> apply(StreamExternalAction action) async {
  //   _logger.d(() => '[apply] action: $action');
  //   final result = await _apply(action);
  //   _logger.v(() => '[apply] result: $result');
  //   if (result.isSuccess) {
  //     _stateManager.dispatch(action);
  //   }
  //   return result;
  // }
  //
  // Future<Result<None>> _apply(StreamExternalAction action) async {
  //   if (action is CallAction) {
  //     return _permissionsManager.apply(action);
  //   } else if (action is ParticipantAction) {
  //     return _session.apply(action);
  //   }
  //   return Result.error('unsupported action: $action');
  // }

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
      final mediaConstraints = track.mediaConstraints;
      if (mediaConstraints is AudioConstraints) {
        const action = SetMicrophoneEnabled(enabled: true);
        _logger.v(() => '[setLocalTrack] composed action: $action');
        await setMicrophoneEnabled(enabled: true);
      } else if (mediaConstraints is CameraConstraints) {
        const action = SetCameraEnabled(enabled: true);
        _logger.v(() => '[setLocalTrack] composed action: $action');
        await setCameraEnabled(enabled: true);
      } else if (mediaConstraints is ScreenShareConstraints) {
        const action = SetScreenShareEnabled(enabled: true);
        _logger.v(() => '[setLocalTrack] composed action: $action');
        await setScreenShareEnabled(enabled: true);
      } else {
        streamLog.e(
            _tag, () => '[composeControlAction] failed: $mediaConstraints');
      }

      // if (action != null) {
      //   _stateManager.dispatch(action);
      // }
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
      _logger.i(() => '[awaitOutgoingToBeAccepted] completed');
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

  Future<Result<None>> inviteUsers(List<UserInfo> users) {
    return _streamVideo.inviteUsers(callCid: callCid.value, users: users);
  }

  Future<Result<None>> requestPermissions(List<CallPermission> permissions) {
    return _permissionsManager.apply(RequestPermissions(permissions));
  }

  Future<Result<None>> grantPermissions({
    required String userId,
    List<CallPermission> permissions = const [],
  }) {
    return _permissionsManager
        .apply(GrantPermissions(userId: userId, permissions: permissions));
  }

  Future<Result<None>> revokePermissions({
    required String userId,
    List<CallPermission> permissions = const [],
  }) {
    return _permissionsManager
        .apply(RevokePermissions(userId: userId, permissions: permissions));
  }

  Future<Result<None>> blockUser(String userId) {
    return _permissionsManager.apply(BlockUser(userId: userId));
  }

  Future<Result<None>> unblockUser(String userId) {
    return _permissionsManager.apply(UnblockUser(userId: userId));
  }

  Future<Result<None>> startRecording() {
    return _permissionsManager.apply(const StartRecording());
  }

  Future<Result<None>> stopRecording() {
    return _permissionsManager.apply(const StopRecording());
  }

  Future<Result<None>> startBroadcasting() {
    return _permissionsManager.apply(const StartBroadcasting());
  }

  Future<Result<None>> stopBroadcasting() {
    return _permissionsManager.apply(const StopBroadcasting());
  }

  Future<Result<None>> muteUsers(List<String> userIds) {
    return _permissionsManager.apply(MuteUsers(userIds: userIds));
  }

  Future<Result<None>> setCameraPosition(CameraPosition cameraPosition) {
    return _session.apply(
      LocalParticipantAction.setCameraPosition(cameraPosition: cameraPosition),
    );
  }

  Future<Result<None>> flipCamera() {
    return _session.apply(const LocalParticipantAction.flipCamera());
  }

  Future<Result<None>> setVideoInputDevice(RtcMediaDevice device) {
    return _session
        .apply(LocalParticipantAction.setVideoInputDevice(device: device));
  }

  Future<Result<None>> setCameraEnabled({required bool enabled}) {
    return _session
        .apply(LocalParticipantAction.setCameraEnabled(enabled: enabled));
  }

  Future<Result<None>> setMicrophoneEnabled({required bool enabled}) {
    return _session
        .apply(LocalParticipantAction.setMicrophoneEnabled(enabled: enabled));
  }

  Future<Result<None>> setScreenShareEnabled({required bool enabled}) {
    return _session.apply(
      LocalParticipantAction.setScreenShareEnabled(enabled: enabled),
    );
  }

  Future<Result<None>> setAudioInputDevice(RtcMediaDevice device) {
    return _session
        .apply(LocalParticipantAction.setAudioInputDevice(device: device));
  }

  Future<Result<None>> setAudioOutputDevice(RtcMediaDevice device) {
    return _session
        .apply(LocalParticipantAction.setAudioOutputDevice(device: device));
  }

  Future<Result<None>> setSubscriptions(List<SetSubscription> actions) {
    return _session.apply(RemoteParticipantAction.setSubscriptions(actions));
  }

  Future<Result<None>> updateSubscriptions(List<SubscriptionAction> actions) {
    return _session.apply(RemoteParticipantAction.updateSubscriptions(actions));
  }

  Future<Result<None>> setSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required Map<SfuTrackTypeVideo, RtcVideoDimension> trackTypes,
  }) {
    return _session.apply(
      RemoteParticipantAction.setSubscription(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackTypes: trackTypes,
      ),
    );
  }

  Future<Result<None>> updateSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required SfuTrackTypeVideo trackType,
    RtcVideoDimension? videoDimension,
  }) {
    return _session.apply(
      RemoteParticipantAction.updateSubscription(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
        videoDimension: videoDimension,
      ),
    );
  }

  Future<Result<None>> removeSubscription({
    required String userId,
    required String sessionId,
    required String trackIdPrefix,
    required SfuTrackTypeVideo trackType,
    RtcVideoDimension? videoDimension,
  }) {
    return _session.apply(
      RemoteParticipantAction.removeSubscription(
        userId: userId,
        sessionId: sessionId,
        trackIdPrefix: trackIdPrefix,
        trackType: trackType,
      ),
    );
  }
}

CallStateNotifier _makeStateManager(
  StreamCallCid callCid,
  StreamVideo streamVideo,
  CallPreferences callPreferences,
) {
  final currentUserId = streamVideo.currentUser?.id ?? '';

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
  StreamVideo streamVideo,
  CallStateNotifier stateManager,
) {
  return PermissionsManager(
    callCid: callCid,
    streamVideo: streamVideo,
    stateManager: stateManager,
  );
}

extension on CallStateNotifier {
  Future<Result<None>> validateUserId(StreamVideo streamVideo) async {
    final stateUserId = callState.currentUserId;
    final currentUserId = streamVideo.currentUser?.id ?? '';
    if (currentUserId.isEmpty) {
      return Result.error('no userId');
    }
    if (stateUserId.isEmpty) {
      lifecycleUpdateUserId(SetUserId(currentUserId));
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
