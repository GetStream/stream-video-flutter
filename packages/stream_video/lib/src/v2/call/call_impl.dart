import 'dart:async';

import '../../logger/stream_logger.dart';
import '../action/call_control_action.dart';
import '../call_state.dart';
import '../call_state_manager.dart';
import '../errors/video_error.dart';
import '../model/call_cid.dart';
import '../model/call_created.dart';
import '../model/call_joined.dart';
import '../model/call_received_created.dart';
import '../model/call_status.dart';
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../shared_emitter.dart';
import '../state_emitter.dart';
import '../stream_video_v2.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import '../utils/result_converters.dart';
import '../utils/subscriptions.dart';
import '../webrtc/rtc_track.dart';
import 'call.dart';
import 'call_settings.dart';
import 'session/call_session.dart';
import 'session/call_session_factory.dart';

const int _idSfuEvents = 1;

/// Represents a [CallV2Impl] in which you can connect to.
class CallV2Impl extends CallV2 {
  factory CallV2Impl({
    required String currentUserId,
    required StreamCallCid callCid,
    StreamVideoV2? streamVideo,
  }) {
    final finalStreamVideo = streamVideo ?? StreamVideoV2.instance;
    final stateManager = CallStateManagerImpl(
      currentUserId: currentUserId,
      initialState: CallStateV2(
        currentUserId: currentUserId,
        callCid: callCid,
      ),
      streamVideo: finalStreamVideo,
    );

    return CallV2Impl._(
      currentUserId: currentUserId,
      cid: callCid,
      streamVideo: finalStreamVideo,
      stateManager: stateManager,
    );
  }
  factory CallV2Impl.from({
    required String currentUserId,
    required CallCreated data,
    StreamVideoV2? streamVideo,
  }) {
    final finalStreamVideo = streamVideo ?? StreamVideoV2.instance;
    final stateManager = CallStateManagerImpl(
      currentUserId: currentUserId,
      initialState: CallStateV2(
        currentUserId: currentUserId,
        callCid: data.callCid,
      ),
      streamVideo: finalStreamVideo,
    );
    stateManager.onCallCreated(data);

    return CallV2Impl._(
      currentUserId: currentUserId,
      cid: data.callCid,
      streamVideo: finalStreamVideo,
      stateManager: stateManager,
    );
  }

  CallV2Impl._({
    required this.currentUserId,
    required this.cid,
    required StreamVideoV2 streamVideo,
    required CallStateManager stateManager,
  })  : _sessionFactory = CallSessionFactory(
          currentUserId: currentUserId,
          callCid: cid,
        ),
        _stateManager = stateManager,
        _streamVideo = streamVideo {
    streamVideo.events.listen(_stateManager.onCoordinatorEvent);
  }

  late final _logger = taggedLogger(tag: 'SV:Call:$cid');
  late final _subscriptions = Subscriptions();

  final String currentUserId;
  @override
  final StreamCallCid cid;
  final StreamVideoV2 _streamVideo;
  final CallSessionFactory _sessionFactory;
  late final CallStateManager _stateManager;

  @override
  StateEmitter<CallStateV2> get state => _stateManager.state;

  @override
  SharedEmitter<SfuEventV2> get events => _events;
  final MutableSharedEmitter<SfuEventV2> _events = MutableSharedEmitterImpl();

  CallSession? _session;

  @override
  Future<Result<CallCreated>> dial({
    required List<String> participantIds,
  }) async {
    return create(
      participantIds: participantIds,
      ringing: true,
    );
  }

  @override
  Future<Result<None>> acceptCall() async {
    final state = _stateManager.state.value;
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(() => '[acceptCall] rejected (invalid status): $status');
      return Failure(VideoError(message: 'invalid status: $status'));
    }
    final result = await _streamVideo.acceptCall(
      cid: cid,
    );
    if (result is Success<None>) {
      await _stateManager.onCallAccepted();
    }
    return result;
  }

  @override
  Future<Result<None>> rejectCall() async {
    final state = _stateManager.state.value;
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(() => '[rejectCall] rejected (invalid status): $status');
      return Failure(VideoError(message: 'invalid status: $status'));
    }
    final result = await _streamVideo.rejectCall(
      cid: cid,
    );
    if (result is Success<None>) {
      await _stateManager.onCallRejected();
    }
    return result;
  }

  @override
  Future<Result<None>> cancelCall() async {
    final state = _stateManager.state.value;
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(() => '[cancelCall] rejected (invalid status): $status');
      return Failure(VideoError(message: 'invalid status: $status'));
    }
    final result = await _streamVideo.cancelCall(
      cid: cid,
    );
    if (result is Success<None>) {
      await _stateManager.onCallCancelled();
    }
    return result;
  }

  @override
  Future<Result<CallReceivedOrCreated>> getOrCreate({
    List<String> participantIds = const [],
    bool ringing = false,
  }) async {
    final result = await _streamVideo.getOrCreateCall(
      cid: cid,
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
    final result = await _streamVideo.createCall(
      cid: cid,
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
    final state = _stateManager.state.value;
    final status = state.status;
    if (!status.isJoinable) {
      _logger.w(() => '[connect] rejected (status not Joinable): $status');
      return Failure(VideoError(message: 'invalid status: $status'));
    }
    final result = await _awaitIfNeeded(settings.dropTimeout);
    if (result is Failure) {
      _logger.e(() => '[connect] waiting failed: $result');
      await _stateManager.onWaitingTimeout(settings.dropTimeout);
      return result;
    }
    await _stateManager.onConnect();
    final joinedResult = await _streamVideo.joinCall(cid: cid);
    if (joinedResult is! Success<CallJoined>) {
      _logger.w(() => '[connect] join failed: $joinedResult');
      await _stateManager.onJoinFailed((joinedResult as Failure).error);
      return joinedResult;
    }
    await _stateManager.onJoined(joinedResult.data);
    final session = await _sessionFactory.makeCallSession(
      credentials: joinedResult.data.credentials,
      stateManager: _stateManager,
    );
    _session = session;
    _subscriptions.add(_idSfuEvents, session.events.listen(_events.emit));
    await _stateManager.onSessionStart(session.sessionId);
    await session.start();
    await _stateManager.onConnected();
    await _applySettings(settings);
    _logger.v(() => '[connect] completed');
    return None().toSuccess();
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
      return e.toFailure(stk);
    }
    return None().toSuccess();
  }

  @override
  Future<Result<None>> disconnect() async {
    await _stateManager.onDisconnect();
    await _subscriptions.cancelAll();
    await _session?.dispose();
    _session = null;
    return None().toSuccess();
  }

  @override
  RtcTrack? getTrack(String trackId, SfuTrackType trackType) {
    return _session?.getTrack(trackId, trackType);
  }

  @override
  List<RtcTrack> getTracks(String trackId) {
    return _session?.getTracks(trackId) ?? List.empty();
  }

  @override
  Future<Result<None>> apply(CallControlAction action) async {
    _logger.d(() => '[apply] action: $action');
    final session = _session;
    if (session == null) {
      _logger.w(() => '[apply] rejected (session is null);');
      return Failure(const VideoError(message: 'no call session'));
    }
    final result = await session.apply(action);
    _logger.v(() => '[apply] completed: $result');
    if (result is Success<None>) {
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
}
