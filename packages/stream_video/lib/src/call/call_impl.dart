import 'dart:async';

import 'package:async/async.dart' as async;

import '../../stream_video.dart';
import '../call_state_manager.dart';
import '../coordinator/models/coordinator_events.dart';
import '../errors/video_error_composer.dart';
import '../models/call_credentials.dart';
import '../models/call_permission.dart';
import '../retry/retry_policy.dart';
import '../sfu/data/events/sfu_events.dart';
import '../shared_emitter.dart';
import '../state_emitter.dart';
import '../utils/cancelables.dart';
import '../utils/none.dart';
import '../webrtc/sdp/editor/sdp_editor_impl.dart';
import '../webrtc/sdp/policy/sdp_policy.dart';
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
    final finalStreamVideo = streamVideo ?? StreamVideo.instance;
    final finalRetryPolicy = retryPolicy ?? finalStreamVideo.retryPolicy;
    final stateManager = _makeCallStateManager(callCid, finalStreamVideo);
    return CallImpl._(
      streamVideo: finalStreamVideo,
      retryPolicy: finalRetryPolicy,
      stateManager: stateManager,
    );
  }

  factory CallImpl.created({
    required CallCreated data,
    StreamVideo? streamVideo,
    RetryPolicy? retryPolicy,
  }) {
    streamLog.i(_tag, () => '<factory> created: $data');
    final finalStreamVideo = streamVideo ?? StreamVideo.instance;
    final finalRetryPolicy = retryPolicy ?? finalStreamVideo.retryPolicy;
    final stateManager = _makeCallStateManager(data.callCid, finalStreamVideo);
    stateManager.onCreated(data);
    return CallImpl._(
      streamVideo: finalStreamVideo,
      retryPolicy: finalRetryPolicy,
      stateManager: stateManager,
    );
  }

  factory CallImpl.joined({
    required CallJoined data,
    StreamVideo? streamVideo,
    RetryPolicy? retryPolicy,
  }) {
    streamLog.i(_tag, () => '<factory> joined: $data');
    final finalStreamVideo = streamVideo ?? StreamVideo.instance;
    final finalRetryPolicy = retryPolicy ?? finalStreamVideo.retryPolicy;
    final stateManager = _makeCallStateManager(data.callCid, finalStreamVideo);
    stateManager.onJoined(data);
    return CallImpl._(
      streamVideo: finalStreamVideo,
      retryPolicy: finalRetryPolicy,
      stateManager: stateManager,
      credentials: data.credentials,
    );
  }

  CallImpl._({
    required StreamVideo streamVideo,
    required RetryPolicy retryPolicy,
    required CallStateManager stateManager,
    CallCredentials? credentials,
  })  : _sessionFactory = CallSessionFactory(
          callCid: stateManager.state.value.callCid,
          sdpEditor: SdpEditorImpl(streamVideo.sdpPolicy),
        ),
        _stateManager = stateManager,
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

  Future<void> _onStateChanged(CallState state) async {
    final status = state.status;
    _logger.v(() => '[onStateChanged] status: $status');
    if (status is CallStatusDisconnected) {
      await _clear('status-disconnected');
    }
    if (state.settings.audio.opusDtxEnabled) {
      _sessionFactory.sdpEditor.addRule(const EnableOpusDtxRule());
    }
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
    await _stateManager.onCoordinatorEvent(event);
  }

  Future<Result<None>> _acceptCall(AcceptCall action) async {
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
      await _stateManager.onControlAction(action);
    }
    return result;
  }

  Future<Result<None>> _rejectCall(RejectCall action) async {
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
      await _stateManager.onControlAction(action);
    }
    return result;
  }

  @override
  Future<Result<None>> join() async {
    _logger.d(() => '[join] no args');
    await _stateManager.onJoining();
    final joinedResult = await _joinIfNeeded();
    if (joinedResult is Success<CallCredentials>) {
      _logger.v(() => '[join] completed');
      return Result.success(None());
    } else {
      final failedResult = joinedResult as Failure;
      _logger.e(() => '[join] failed: $failedResult');
      await _stateManager.onConnectFailed(failedResult.error);
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

    final result = await _awaitIfNeeded(_connectOptions.dropTimeout);
    if (result.isFailure) {
      _logger.e(() => '[connect] waiting failed: $result');
      await _stateManager.onWaitingTimeout(_connectOptions.dropTimeout);
      return result;
    }

    await _stateManager.onConnecting(_reconnectAttempt);
    _logger.v(() => '[connect] joining to coordinator');
    final joinedResult = await _joinIfNeeded();
    if (joinedResult is! Success<CallCredentials>) {
      _logger.e(() => '[connect] joining failed: $joinedResult');
      await _stateManager.onConnectFailed((joinedResult as Failure).error);
      return result;
    }

    _logger.v(() => '[connect] starting sfu session');
    final sessionResult = await _startSession(joinedResult.data);
    if (sessionResult is! Success<None>) {
      _logger.w(() => '[connect] sfu session start failed: $sessionResult');
      await _stateManager.onConnectFailed((sessionResult as Failure).error);
      return sessionResult;
    }
    _logger.v(() => '[connect] started session');
    await _stateManager.onConnected();
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
        await _stateManager.onReceivedOrCreated(data);
      },
    );
    if (joinedResult is Success<CallJoined>) {
      _logger.v(() => '[joinIfNeeded] completed');
      await _stateManager.onJoined(joinedResult.data);
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
    await _stateManager.onSessionStart(session.sessionId);
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
      await _stateManager.onConnecting(_reconnectAttempt);
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
      await Future.delayed(delay);
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
      await _stateManager.onConnectFailed((result as Failure).error);
      return;
    }
    _logger.v(() => '[reconnect] <<<<<<<<<<<<<<< completed');
    await _stateManager.onConnected();
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
  Future<Result<None>> end() async {
    if (!_hasPermission(CallPermission.endCall)) {
      return Result.error('has no "end-call" permission');
    }
    final state = this.state.value;
    final status = state.status;
    _logger.d(() => '[end] status: $status');
    if (status is! CallStatusActive) {
      _logger.w(() => '[end] rejected (invalid status): $status');
      return Result.error('invalid status: $status');
    }
    _status.value = _ConnectionStatus.disconnected;
    await _clear('end');
    await _stateManager.onEnded();
    final result = await _streamVideo.endCall(callCid: state.callCid);
    _logger.v(() => '[end] completed: $result');
    return result;
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
    await _stateManager.onDisconnect();
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
    return _applyLocalTrack(track);
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
  Future<Result<None>> apply(CallControlAction action) async {
    if (action is SessionControlAction) {
      return _applySessionAction(action);
    } else if (action is AcceptCall) {
      return _acceptCall(action);
    } else if (action is RejectCall) {
      return _rejectCall(action);
    } else if (action is BlockUser) {
      return _blockUser(action);
    } else if (action is UnblockUser) {
      return _unblockUser(action);
    } else if (action is StartRecording) {
      return _startRecording(action);
    } else if (action is StopRecording) {
      return _stopRecording(action);
    } else if (action is StartBroadcasting) {
      return _startBroadcasting(action);
    } else if (action is StopBroadcasting) {
      return _stopBroadcasting(action);
    } else if (action is SendReaction) {
      return _sendReaction(action);
    } else if (action is MuteUsers) {
      return _muteUsers(action);
    } else if (action is RequestPermissions) {
      return _requestPermissions(action);
    } else if (action is UpdateUserPermissions) {
      return _updateUserPermissions(action);
    }
    return Result.error('Action not supported: $action');
  }

  Future<Result<None>> _applySessionAction(
    SessionControlAction action,
  ) async {
    _logger.d(() => '[apply] action: $action');
    final session = _session;
    if (session == null) {
      _logger.w(() => '[apply] rejected (session is null);');
      return Result.error('no call session');
    }
    final result = await session.apply(action);
    _logger.v(() => '[apply] completed: $result');
    if (result.isSuccess) {
      await _stateManager.onControlAction(action);
    }
    return result;
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
      await _applyLocalTrack(cameraOption.track);
    } else if (cameraOption is TrackEnabled) {
      await _applySessionAction(const SetCameraEnabled(enabled: true));
    }
  }

  Future<void> _applyMicrophoneOption(TrackOption microphoneOption) async {
    if (microphoneOption is TrackProvided) {
      await _applyLocalTrack(microphoneOption.track);
    } else if (microphoneOption is TrackEnabled) {
      await _applySessionAction(const SetMicrophoneEnabled(enabled: true));
    }
  }

  Future<void> _applyScreenShareOption(TrackOption screenShareOption) async {
    if (screenShareOption is TrackProvided) {
      await _applyLocalTrack(screenShareOption.track);
    } else if (screenShareOption is TrackEnabled) {
      await _applySessionAction(const SetScreenShareEnabled(enabled: true));
    }
  }

  Future<Result<None>> _applyLocalTrack(RtcLocalTrack track) async {
    _logger.d(() => '[applyLocalTrack] localTrack: $track');
    final session = _session;
    if (session == null) {
      _logger.w(() => '[applyLocalTrack] rejected (session is null);');
      return Result.error('no call session');
    }
    final result = await session.setLocalTrack(track);
    _logger.v(() => '[applyLocalTrack] completed: $result');
    if (result.isSuccess) {
      final action = track.composeControlAction();
      _logger.v(() => '[applyLocalTrack] composed action: $action');
      if (action != null) {
        await _stateManager.onControlAction(action);
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

  bool _canRequestPermission(CallPermission permission) {
    final settings = state.valueOrNull?.settings;
    if (settings == null) {
      _logger.w(() => 'canRequestPermission: no settings');
      return false;
    }

    if (permission == CallPermission.sendAudio) {
      return settings.audio.accessRequestEnabled;
    } else if (permission == CallPermission.sendVideo) {
      return settings.video.accessRequestEnabled;
    } else if (permission == CallPermission.screenshare) {
      return settings.screenShare.accessRequestEnabled;
    }

    _logger.w(() => 'canRequestPermission: unknown permission: $permission');
    return false;
  }

  Future<Result<None>> _requestPermissions(
    RequestPermissions action,
  ) async {
    final canRequest = action.permissions.every(_canRequestPermission);
    if (!canRequest) {
      return Result.error(
        'Some permissions cannot be requested (see canRequestPermission method)',
      );
    }

    return _streamVideo.requestPermissions(
      callCid: callCid,
      permissions: action.permissions,
    );
  }

  bool _hasPermission(CallPermission permission) {
    final capabilities = state.valueOrNull?.ownCapabilities;
    if (capabilities == null || capabilities.isEmpty) {
      _logger.w(() => '[hasPermission] rejected (no capabilities)');
      return false;
    }
    return capabilities.contains(permission);
  }

  Future<Result<None>> _updateUserPermissions(
    UpdateUserPermissions action,
  ) async {
    final canUpdate = _hasPermission(CallPermission.updateCallPermissions);
    if (!canUpdate) {
      return Result.error(
        'Cannot update permissions (see canUpdatePermission method)',
      );
    }

    return _streamVideo.updateUserPermissions(
      callCid: callCid,
      userId: action.userId,
      grantPermissions: action.grantPermissions,
      revokePermissions: action.revokePermissions,
    );
  }

  Future<Result<None>> _blockUser(BlockUser action) async {
    if (!_hasPermission(CallPermission.blockUsers)) {
      _logger.w(() => '[blockUser] rejected (no permission)');
      return Result.error('Cannot block user (no permission)');
    }
    _logger.d(() => '[blockUser] action: $action');
    final result = await _streamVideo.blockUser(
      callCid: callCid,
      userId: action.userId,
    );
    _logger.v(() => '[blockUser] result: $result');
    if (result.isSuccess) {
      await _stateManager.onControlAction(action);
    }
    return result;
  }

  Future<Result<None>> _unblockUser(UnblockUser action) async {
    if (!_hasPermission(CallPermission.blockUsers)) {
      _logger.w(() => '[unblockUser] rejected (no permission)');
      return Result.error('Cannot unblock user (no permission)');
    }
    _logger.d(() => '[unblockUser] action: $action');
    final result = await _streamVideo.unblockUser(
      callCid: callCid,
      userId: action.userId,
    );
    _logger.v(() => '[unblockUser] result: $result');
    if (result.isSuccess) {
      await _stateManager.onControlAction(action);
    }
    return result;
  }

  Future<Result<None>> _startRecording(StartRecording action) async {
    if (!_hasPermission(CallPermission.startRecordCall)) {
      _logger.w(() => '[startRecording] rejected (no permission)');
      return Result.error('Cannot start recording (no permission)');
    }
    _logger.d(() => '[startRecording] action: $action');
    final result = await _streamVideo.startRecording(callCid: callCid);
    _logger.v(() => '[startRecording] result: $result');
    if (result.isSuccess) {
      await _stateManager.onControlAction(action);
    }
    return result;
  }

  Future<Result<None>> _stopRecording(StopRecording action) async {
    if (!_hasPermission(CallPermission.stopRecordCall)) {
      _logger.w(() => '[stopRecording] rejected (no permission)');
      return Result.error('Cannot stop recording (no permission)');
    }
    _logger.d(() => '[stopRecording] action: $action');
    final result = await _streamVideo.stopRecording(callCid: callCid);
    _logger.v(() => '[stopRecording] result: $result');
    if (result.isSuccess) {
      await _stateManager.onControlAction(action);
    }
    return result;
  }

  Future<Result<None>> _startBroadcasting(StartBroadcasting action) async {
    if (!_hasPermission(CallPermission.startBroadcastCall)) {
      _logger.w(() => '[startBroadcasting] rejected (no permission)');
      return Result.error('Cannot start broadcasting (no permission)');
    }
    _logger.d(() => '[startBroadcasting] action: $action');
    final result = await _streamVideo.startBroadcasting(callCid: callCid);
    _logger.v(() => '[startBroadcasting] result: $result');
    if (result.isSuccess) {
      await _stateManager.onControlAction(action);
    }
    return result;
  }

  Future<Result<None>> _stopBroadcasting(StopBroadcasting action) async {
    if (!_hasPermission(CallPermission.stopBroadcastCall)) {
      _logger.w(() => '[stopBroadcasting] rejected (no permission)');
      return Result.error('Cannot stop broadcasting (no permission)');
    }
    _logger.d(() => '[stopBroadcasting] action: $action');
    final result = await _streamVideo.stopBroadcasting(callCid: callCid);
    _logger.v(() => '[stopBroadcasting] result: $result');
    if (result.isSuccess) {
      await _stateManager.onControlAction(action);
    }
    return result;
  }

  Future<Result<None>> _sendReaction(SendReaction action) async {
    if (!_hasPermission(CallPermission.createReaction)) {
      _logger.w(() => '[sendReaction] rejected (no permission)');
      return Result.error('Cannot send reaction (no permission)');
    }
    _logger.d(() => '[sendReaction] action: $action');
    final result = await _streamVideo.sendReaction(
      callCid: callCid,
      reactionType: action.reactionType,
      emojiCode: action.emojiCode,
      custom: action.custom,
    );
    _logger.v(() => '[sendReaction] result: $result');
    if (result.isSuccess) {
      await _stateManager.onControlAction(action);
    }
    return result.map((_) => None());
  }

  Future<Result<None>> _muteUsers(MuteUsers action) async {
    if (!_hasPermission(CallPermission.muteUsers)) {
      _logger.w(() => '[muteUsers] rejected (no permission)');
      return Result.error('Cannot start mute users (no permission)');
    }
    _logger.d(() => '[muteUsers] action: $action');
    final result = await _streamVideo.muteUsers(
      callCid: callCid,
      userIds: action.userIds,
    );
    _logger.v(() => '[muteUsers] result: $result');
    if (result.isSuccess) {
      await _stateManager.onControlAction(action);
    }
    return result;
  }
}

CallStateManager _makeCallStateManager(
  StreamCallCid callCid,
  StreamVideo streamVideo,
) {
  final currentUserId = streamVideo.currentUser?.id ?? '';
  return CallStateManagerImpl(
    initialState: CallState(
      currentUserId: currentUserId,
      callCid: callCid,
    ),
    streamVideo: streamVideo,
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
      await onUserIdSet(currentUserId);
    }
    return Result.success(None());
  }
}

extension on RtcLocalTrack {
  SessionControlAction? composeControlAction() {
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
