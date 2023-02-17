import 'dart:async';

import '../../../stream_video.dart';
import '../action/call_control_action.dart';
import '../call_state.dart';
import '../call_state_manager.dart';
import '../coordinator/models/coordinator_models.dart';
import '../errors/video_error_composer.dart';
import '../model/call_cid.dart';
import '../model/call_created.dart';
import '../model/call_joined.dart';
import '../model/call_received_created.dart';
import '../model/call_status.dart';
import '../sfu/data/events/sfu_events.dart';
import '../shared_emitter.dart';
import '../state_emitter.dart';
import '../stream_video.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import '../utils/subscriptions.dart';
import '../webrtc/rtc_track.dart';
import 'call.dart';
import 'call_settings.dart';
import 'session/call_session.dart';
import 'session/call_session_factory.dart';

const _idSessionEvents = 1;
const _idCoordEvents = 2;

const _tag = 'SV:Call';

int _callSeq = 1;

/// Represents a [CallImpl] in which you can connect to.
class CallImpl extends Call {
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
    _subscriptions.add(_idCoordEvents, streamVideo.events.listen((event) {
      _logger.v(() => '[onCallCoordEvent] event.type: ${event.runtimeType}');
      _logger.v(() => '[onCallCoordEvent] calStatus: ${state.value.status}');
      _stateManager.onCoordinatorEvent(event);
    }));
  }

  late final _logger = taggedLogger(tag: '$_tag-${_callSeq++}');
  late final _subscriptions = Subscriptions();

  final StreamVideo _streamVideo;
  final CallSessionFactory _sessionFactory;
  final CallStateManager _stateManager;

  @override
  StreamCallCid get callCid => _stateManager.state.value.callCid;

  @override
  StateEmitter<CallState> get state => _stateManager.state;

  @override
  SharedEmitter<SfuEvent> get events => _events;
  final _events = MutableSharedEmitterImpl<SfuEvent>();

  final _status = MutableStateEmitterImpl<_ConnectionStatus>(
    _ConnectionStatus.disconnected,
  );

  CallSession? _session;

  @override
  String toString() {
    return 'Call{cid: $callCid}';
  }

  @override
  Future<Result<CallCreated>> dial({
    required List<String> participantIds,
  }) async {
    return create(
      participantIds: participantIds,
      ringing: true,
    );
  }

  Future<Result<None>> _acceptCall(AcceptCall action) async {
    final state = _stateManager.state.value;
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
    final state = _stateManager.state.value;
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
    final state = _stateManager.state.value;
    final status = state.status;
    _logger.d(() => '[cancelCall] status: $status');
    if (status is! CallStatusOutgoing || status.acceptedByCallee) {
      _logger.w(() => '[cancelCall] rejected (invalid status): $status');
      return Result.error('invalid status: $status');
    }
    final result = await _streamVideo.cancelCall(cid: state.callCid);
    _logger.v(() => '[cancelCall] completed: $result');
    if (result is Success<None>) {
      await _stateManager.onCallControlAction(action);
    }
    return result;
  }

  @override
  Future<Result<CallReceivedOrCreated>> getOrCreate({
    List<String> participantIds = const [],
    bool ringing = false,
  }) async {
    final state = _stateManager.state.value;
    final result = await _streamVideo.getOrCreateCall(
      cid: state.callCid,
      participantIds: participantIds,
      ringing: ringing,
    );
    if (result is Success<CallReceivedOrCreated>) {
      await _stateManager.onCallReceivedOrCreated(result.data);
    }
    return result;
  }

  @override
  Future<Result<CallCreated>> create({
    List<String> participantIds = const [],
    bool ringing = false,
  }) async {
    final state = _stateManager.state.value;
    final result = await _streamVideo.createCall(
      cid: state.callCid,
      participantIds: participantIds,
      ringing: ringing,
    );
    if (result is Success<CallCreated>) {
      await _stateManager.onCallCreated(result.data);
    }
    return result;
  }

  @override
  Future<Result<None>> connect({
    CallSettings settings = const CallSettings(),
  }) async {
    if (_status.value == _ConnectionStatus.connected) {
      _logger.w(() => '[connect] rejected (connected)');
      return Result.success(None());
    }
    if (_status.value == _ConnectionStatus.connecting) {
      _logger.v(() => '[connect] await "connecting" change');
      final status = await _status.firstWhere(
        (it) => it != _ConnectionStatus.connecting,
        timeLimit: settings.dropTimeout,
      );
      if (status == _ConnectionStatus.connected) {
        return Result.success(None());
      } else {
        return Result.error('original "connect" failed');
      }
    }
    await Call.activeCall?.disconnect();
    Call.activeCall = this;
    Call.onActiveCall?.call(this);
    _status.value = _ConnectionStatus.connecting;
    final result = await _connect(settings);
    if (result.isSuccess) {
      _status.value = _ConnectionStatus.connected;
    } else {
      await disconnect();
    }
    return result;
  }

  Future<Result<None>> _connect(CallSettings settings) async {
    _logger.d(() => '[connect] settings: $settings');
    final validation = await _stateManager.validateUserId(_streamVideo);
    if (validation.isFailure) {
      _logger.w(() => '[connect] rejected (validation): $validation');
      return validation;
    }
    _logger.v(() => '[connect] validated');

    final state = _stateManager.state.value;
    final status = state.status;
    if (!status.isJoinable && !status.isJoined) {
      _logger.w(() => '[connect] rejected (not Joinable/Joined): $status');
      return Result.error('invalid status: $status');
    }

    final result = await _awaitIfNeeded(settings.dropTimeout);
    if (result.isFailure) {
      _logger.e(() => '[connect] waiting failed: $result');
      await _stateManager.onWaitingTimeout(settings.dropTimeout);
      return result;
    }

    _logger.v(() => '[connect] joining to coordinator');
    final joinedResult = await _joinIfNeeded();
    if (joinedResult is! Success<CallCredentials>) {
      _logger.e(() => '[connect] joining failed: $result');
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
    await _applySettings(settings);

    _logger.v(() => '[connect] completed');
    return Result.success(None());
  }

  Future<Result<CallCredentials>> _joinIfNeeded() async {
    final state = _stateManager.state.value;
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
      final state = _stateManager.state.value;
      final status = state.status;
      if (status is CallStatusOutgoing && !status.acceptedByCallee) {
        await _awaitOutgoingToBeAccepted(timeLimit);
      }
      if (status is CallStatusIncoming && !status.acceptedByMe) {
        await _awaitIncomingToBeAccepted(timeLimit);
      }
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
    return Result.success(None());
  }

  @override
  Future<Result<None>> disconnect() async {
    final state = _stateManager.state.value;
    _logger.d(() => '[disconnect] state: $state');
    await _stateManager.onDisconnect();
    await _subscriptions.cancelAll();
    await _session?.dispose();
    _session = null;
    _status.value = _ConnectionStatus.disconnected;
    Call.activeCall = null;
    Call.onActiveCall?.call(null);
    return Result.success(None());
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
      return _applyPublisherAction(action);
    } else if (action is CancelCall) {
      return _cancelCall(action);
    } else if (action is AcceptCall) {
      return _acceptCall(action);
    } else if (action is RejectCall) {
      return _rejectCall(action);
    }
    return Result.error('Action not supported: $action');
  }

  Future<Result<None>> _applyPublisherAction(
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

  Future<void> _applySettings(CallSettings settings) async {
    if (settings.cameraEnabled) {
      await apply(const SetCameraEnabled(enabled: true));
    }
    if (settings.microphoneEnabled) {
      await apply(const SetMicrophoneEnabled(enabled: true));
    }
    if (settings.screenShareEnabled) {
      await apply(const SetScreenShareEnabled(enabled: true));
    }
  }

  Future<void> _awaitIncomingToBeAccepted(Duration timeLimit) async {
    await _stateManager.state.firstWhere(
      (state) {
        final status = state.status;
        return status is CallStatusIncoming && status.acceptedByMe;
      },
      timeLimit: timeLimit,
    );
  }

  Future<void> _awaitOutgoingToBeAccepted(Duration timeLimit) async {
    await _stateManager.state.firstWhere(
      (state) {
        final status = state.status;
        return status is CallStatusOutgoing && status.acceptedByCallee;
      },
      timeLimit: timeLimit,
    );
  }

  @override
  Future<void> inviteUsers(List<UserInfo> users) {
    return _streamVideo.inviteUsers(callCid: callCid.value, users: users);
  }
}

typedef GetUserId = String? Function();

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

enum _ConnectionStatus {
  disconnected,
  connecting,
  connected;
}
