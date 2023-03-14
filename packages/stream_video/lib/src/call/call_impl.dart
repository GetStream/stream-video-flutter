import 'dart:async';

import '../../stream_video.dart';
import '../call_permission.dart';
import '../call_state_manager.dart';
import '../coordinator/models/coordinator_events.dart';
import '../errors/video_error_composer.dart';
import '../models/call_credentials.dart';
import '../sfu/data/events/sfu_events.dart';
import '../shared_emitter.dart';
import '../state_emitter.dart';
import '../utils/none.dart';
import 'session/call_session.dart';
import 'session/call_session_factory.dart';

const _idSessionEvents = 1;
const _idCoordEvents = 2;

const _tag = 'SV:Call';

int _callSeq = 1;

/// Represents a [CallImpl] in which you can connect to.
class CallImpl implements Call {
  factory CallImpl({
    required StreamCallCid callCid,
    StreamVideo? streamVideo,
  }) {
    streamLog.i(_tag, () => '<factory> callCid: $callCid');
    final finalStreamVideo = streamVideo ?? StreamVideo.instance;
    final stateManager = _makeCallStateManager(callCid, finalStreamVideo);
    return CallImpl._(
      streamVideo: finalStreamVideo,
      stateManager: stateManager,
    );
  }

  factory CallImpl.created({
    required CallCreated data,
    StreamVideo? streamVideo,
  }) {
    streamLog.i(_tag, () => '<factory> created: $data');
    final finalStreamVideo = streamVideo ?? StreamVideo.instance;
    final stateManager = _makeCallStateManager(data.callCid, finalStreamVideo);
    stateManager.onCallCreated(data);
    return CallImpl._(
      streamVideo: finalStreamVideo,
      stateManager: stateManager,
    );
  }

  factory CallImpl.joined({
    required CallJoined data,
    StreamVideo? streamVideo,
  }) {
    streamLog.i(_tag, () => '<factory> joined: $data');
    final finalStreamVideo = streamVideo ?? StreamVideo.instance;
    final stateManager = _makeCallStateManager(data.callCid, finalStreamVideo);
    stateManager.onCallJoined(data);
    return CallImpl._(
      streamVideo: finalStreamVideo,
      stateManager: stateManager,
    );
  }

  CallImpl._({
    required StreamVideo streamVideo,
    required CallStateManager stateManager,
  })  : _sessionFactory = CallSessionFactory(
          callCid: stateManager.state.value.callCid,
        ),
        _stateManager = stateManager,
        _streamVideo = streamVideo {
    streamLog.i(_tag, () => '<init> state: ${stateManager.state.value}');
    _subscriptions.add(
      _idCoordEvents,
      streamVideo.events.on<CoordinatorCallEvent>((event) {
        // Return if the event is not for this call.
        if (event.callCid != state.value.callCid.value) return;
        _logger.v(() => '[onCallCoordEvent] event.type: ${event.runtimeType}');
        _logger.v(() => '[onCallCoordEvent] calStatus: ${state.value.status}');

        if (event is CoordinatorCallPermissionRequestEvent) {
          // Notify the client about the permission request.
          return onPermissionRequest?.call(event);
        }

        _stateManager.onCoordinatorEvent(event);
      }),
    );
  }

  late final _logger = taggedLogger(tag: '$_tag-${_callSeq++}');
  late final _subscriptions = Subscriptions();

  final StreamVideo _streamVideo;
  final CallSessionFactory _sessionFactory;
  final CallStateManager _stateManager;

  @override
  StreamCallCid get callCid => state.value.callCid;

  @override
  StateEmitter<CallState> get state => _stateManager.state;

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
    _connectOptions = connectOptions;
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
      await _stateManager.onCallControlAction(action);
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
      await _stateManager.onCallControlAction(action);
    }
    return result;
  }

  Future<Result<None>> _cancelCall(CancelCall action) async {
    final state = this.state.value;
    final status = state.status;
    _logger.d(() => '[cancelCall] status: $status');
    if (status is! CallStatusActive) {
      _logger.w(() => '[cancelCall] rejected (invalid status): $status');
      return Result.error('invalid status: $status');
    }
    final result = await _streamVideo.cancelCall(cid: state.callCid);
    _logger.v(() => '[cancelCall] result: $result');
    if (result is Success<None>) {
      _status.value = _ConnectionStatus.cancelled;
      _subscriptions.cancelAll();
      await _stateManager.onCallControlAction(action);
      await _session?.dispose();
      _session = null;
    }
    _logger.v(() => '[cancelCall] completed');
    return result;
  }

  Future<Result<None>> _endCall(EndCall action) async {
    final state = this.state.value;
    final status = state.status;
    _logger.d(() => '[endCall] status: $status');
    if (status is! CallStatusActive) {
      _logger.w(() => '[endCall] rejected (invalid status): $status');
      return Result.error('invalid status: $status');
    }
    final result = await _streamVideo.endCall(callCid: state.callCid);
    _logger.v(() => '[endCall] completed: $result');
    if (result is Success<None>) {
      await _stateManager.onCallControlAction(action);
    }
    return result;
  }

  @override
  Future<Result<None>> joinCall() async {
    _logger.d(() => '[joinCall] no args');
    final joinedResult = await _joinIfNeeded();
    if (joinedResult is Failure) {
      _logger.e(() => '[joinCall] failed: $joinedResult');
      await _stateManager.onConnectFailed(joinedResult.error);
      return joinedResult;
    }
    return Result.success(None());
  }

  @override
  Future<Result<None>> connect() async {
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
    final result = await _connect();
    if (result.isSuccess) {
      _status.value = _ConnectionStatus.connected;
    } else {
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
    if (!status.isJoinable && !status.isJoined && !status.isJoining) {
      _logger
          .w(() => '[connect] rejected (not Joinable/Joining/Joined): $status');
      return Result.error('invalid status: $status');
    }

    final result = await _awaitIfNeeded(_connectOptions.dropTimeout);
    if (result.isFailure) {
      _logger.e(() => '[connect] waiting failed: $result');
      await _stateManager.onWaitingTimeout(_connectOptions.dropTimeout);
      return result;
    }

    _logger.v(() => '[connect] joining to coordinator');
    final joinedResult = await _joinIfNeeded();
    if (joinedResult is! Success<CallCredentials>) {
      _logger.e(() => '[connect] joining failed: $joinedResult');
      await _stateManager.onConnectFailed((joinedResult as Failure).error);
      return result;
    }

    _logger.v(() => '[connect] starting session');
    final sessionResult = await _startSession(joinedResult.data);
    if (sessionResult is! Success<None>) {
      _logger.w(() => '[connect] session start failed: $sessionResult');
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
    final status = state.status;
    if (status is CallStatusJoined) {
      _logger.w(() => '[joinIfNeeded] rejected (already joined): $status');
      return Result.success(status.credentials);
    }
    _logger.d(() => '[joinIfNeeded] no args');
    await _stateManager.onCallJoining();
    final joinedResult = await _streamVideo.joinCall(
      cid: state.callCid,
      onReceivedOrCreated: (data) async {
        await _stateManager.onCallReceivedOrCreated(data);
      },
    );
    if (joinedResult is Success<CallJoined>) {
      _logger.v(() => '[joinIfNeeded] completed');
      await _stateManager.onCallJoined(joinedResult.data);
      return Result.success(joinedResult.data.credentials);
    }
    _logger.e(() => '[joinIfNeeded] failed: $joinedResult');
    return joinedResult as Failure;
  }

  Future<Result<void>> _startSession(CallCredentials credentials) async {
    final session = await _sessionFactory.makeCallSession(
      credentials: credentials,
      stateManager: _stateManager,
    );
    _session = session;
    _subscriptions.add(_idSessionEvents, session.events.listen(_events.emit));
    await _stateManager.onSessionStart(session.sessionId);
    return session.start();
  }

  Future<Result<None>> _awaitIfNeeded(Duration timeLimit) async {
    try {
      final state = this.state.value;
      final status = state.status;
      if (status is CallStatusOutgoing && !status.acceptedByCallee) {
        await _awaitOutgoingToBeAccepted(timeLimit);
      }
      if (status is CallStatusIncoming && !status.acceptedByMe) {
        await _awaitIncomingToBeAccepted(timeLimit);
      }
      // If we are coming from the pre-joining screen and already
      // started joining the call.
      if (status is CallStatusJoining) {
        await _awaitCallToBeJoined();
      }
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
    return Result.success(None());
  }

  @override
  Future<Result<None>> disconnect() async {
    final state = this.state.value;
    _logger.d(() => '[disconnect] ${_status.value}; state: $state');
    if (_status.value == _ConnectionStatus.disconnected) {
      _logger.w(() => '[disconnect] rejected (already disconnected)');
      return Result.success(None());
    }
    _status.value = _ConnectionStatus.disconnected;
    _subscriptions.cancelAll();
    await _stateManager.onDisconnect();
    await _session?.dispose();
    _session = null;
    if (Call.activeCall != null) {
      Call.activeCall = null;
      Call.onActiveCall?.call(null);
    }
    _logger.v(() => '[disconnect] finished');
    return Result.success(None());
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
    } else if (action is CancelCall) {
      return _cancelCall(action);
    } else if (action is AcceptCall) {
      return _acceptCall(action);
    } else if (action is RejectCall) {
      return _rejectCall(action);
    } else if (action is EndCall) {
      return _endCall(action);
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
      await _stateManager.onCallControlAction(action);
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
        await _stateManager.onCallControlAction(action);
      }
    }
    return result;
  }

  Future<void> _awaitIncomingToBeAccepted(Duration timeLimit) async {
    await state.firstWhere(
      (state) {
        final status = state.status;
        return status is CallStatusIncoming && status.acceptedByMe;
      },
      timeLimit: timeLimit,
    );
  }

  Future<void> _awaitOutgoingToBeAccepted(Duration timeLimit) async {
    await state.firstWhere(
      (state) {
        final status = state.status;
        return status is CallStatusOutgoing && status.acceptedByCallee;
      },
      timeLimit: timeLimit,
    );
  }

  Future<void> _awaitCallToBeJoined() async {
    await state.firstWhere(
      (state) {
        return state.status is CallStatusJoined;
      },
      timeLimit: const Duration(seconds: 60),
    );
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
      await _stateManager.onCallControlAction(action);
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
      await _stateManager.onCallControlAction(action);
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
      await _stateManager.onCallControlAction(action);
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
      await _stateManager.onCallControlAction(action);
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
      await _stateManager.onCallControlAction(action);
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
      await _stateManager.onCallControlAction(action);
    }
    return result;
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
      await _stateManager.onCallControlAction(action);
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

enum _ConnectionStatus {
  cancelled,
  disconnected,
  connecting,
  connected;

  @override
  String toString() {
    return name;
  }
}
