import 'dart:async';

import 'package:stream_video/src/logger/logger.dart';
import 'package:stream_video/src/logger/stream_logger.dart';
import 'package:stream_video/src/v2/call_state.dart';
import 'package:stream_video/src/v2/state_emitter.dart';
import 'package:stream_video/src/v2/utils/result.dart';

import '../../../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart'
    as rpc;
import '../../logger/logger.dart';
import '../../logger/stream_logger.dart';
import '../../internal/events.dart';
import '../action/user_action.dart';
import '../call_state.dart';
import '../call_state_manager.dart';
import '../coordinator/coordinator_client.dart';
import '../coordinator/models/coordinator_models.dart';
import '../coordinator/ws/coordinator_ws.dart';
import '../errors/video_error.dart';
import '../state_emitter.dart';
import '../errors/video_error.dart';
import '../model/call_status.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import '../utils/result_converters.dart';
import '../webrtc/rtc_track.dart';
import 'call.dart';
import 'call_settings.dart';
import 'session/call_session.dart';
import 'session/call_session_factory.dart';

/// Represents a [CallV2Impl] in which you can connect to.
class CallV2Impl extends CallV2 {
  factory CallV2Impl({
    required String currentUserId,
    required String callCid,
    required CoordinatorClientV2 coordinatorClient,
    required CoordinatorWebSocketV2 coordinatorWS,
    required CallMetadata metadata,
  }) {
    return CallV2Impl._(
      currentUserId: currentUserId,
      callCid: callCid,
      coordinatorClient: coordinatorClient,
      coordinatorWS: coordinatorWS,
      initialState: CallStateV2(
        currentUserId: currentUserId,
        callCid: callCid,
        metadata: metadata,
      ),
    );
  }

  CallV2Impl._({
    required this.currentUserId,
    required this.callCid,
    required CoordinatorClientV2 coordinatorClient,
    required CoordinatorWebSocketV2 coordinatorWS,
    required CallStateV2 initialState,
  })  : _coordinatorClient = coordinatorClient,
        _coordinatorWS = coordinatorWS,
        _sessionFactory = CallSessionFactory(
          currentUserId: currentUserId,
          callCid: callCid,
        ),
        _stateManager = CallStateManagerImpl(
          currentUserId: currentUserId,
          initialState: initialState,
          coordinatorClient: coordinatorClient,
        );

  late final _logger = taggedLogger(tag: 'SV:Call:$callCid');

  final String currentUserId;
  final String callCid;
  final CoordinatorClientV2 _coordinatorClient;
  final CoordinatorWebSocketV2 _coordinatorWS;
  final CallSessionFactory _sessionFactory;
  late final CallStateManager _stateManager;

  @override
  StateEmitter<CallStateV2> get state => _stateManager.state;

  CallSession? _session;

  @override
  Future<Result<None>> connect({
    CallSettings settings = const CallSettings(),
  }) async {
    final result = await _awaitAcceptedIfNeeded(settings.dropTimeout);
    if (result is Failure) {
      return result;
    }
    await _stateManager.onConnect();
    final typeAndId = callCid.split(':');

    final joinResult = await _coordinatorClient.joinCall(
      rpc.JoinCallRequest(id: typeAndId[1], type: typeAndId[0]),
    );
    if (joinResult is! Success<rpc.JoinCallResponse>) {
      return joinResult as Failure;
    }
    final edgeResult = await _coordinatorClient.findBestCallEdgeServer(
      callCid: callCid,
      edges: joinResult.data.edges,
    );
    if (edgeResult is! Success<rpc.GetCallEdgeServerResponse>) {
      _logger.w(() => '[connect] completed');
      return edgeResult as Failure;
    }

    _session = await _sessionFactory.makeCallSession(
      credentials: edgeResult.data.credentials,
      stateManager: _stateManager,
    );

    await _session?.start();
    
    await _applySettings(settings);

    _logger.v(() => '[connect] completed');

    return None().toSuccess();
  }

  Future<Result<None>> _awaitAcceptedIfNeeded(Duration timeLimit) async {
    final curState = _stateManager.state.value;
    if (curState.status != CallStatus.outgoing) {
      return None().toSuccess();
    }
    try {
      await _stateManager.state.firstWhere(
        (state) => state.status == CallStatus.joining,
        timeLimit: timeLimit,
      );
      return None().toSuccess();
    } catch (e, stk) {
      return e.toFailure(stk);
    }
  }

  @override
  Future<Result<None>> disconnect() async {
    await _stateManager.onDisconnect();
    await _session?.dispose();
    _session = null;
    return None().toSuccess();
  }

  @override
  RtcTrack? getTrack(String trackId) {
    return _session?.getTrack(trackId);
  }

  @override
  Future<Result<None>> apply(UserAction action) async {
    _logger.d(() => '[apply] action: $action');
    final Result<None> result;
    if (action is EstablishCall) {
      result = await _establishCall(action);
    } else if (action is UpdateCall) {
      result = await _updateCall(action);
    } else {
      result = Failure(VideoError(message: 'unexpected action: $action'));
    }
    _logger.v(() => '[apply] result: $result');
    if (result is Success<None>) {
      await _stateManager.onUserAction(action);
    }
    return result;
  }

  Future<Result<None>> _updateCall(UpdateCall action) async {
    final session = _session;
    if (session == null) {
      _logger.w(() => '[updateCall] rejected (session is null);');
      return Failure(const VideoError(message: 'no call session'));
    }
    return session.apply(action);
  }

  Future<Result<None>> _establishCall(EstablishCall action) async {
    if (action is AcceptCall) {
      return _acceptCall();
    } else if (action is RejectCall) {
      return _rejectCall();
    } else if (action is CancelCall) {
      return _cancelCall();
    }
    return None().toSuccess();
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

  Future<Result<None>> _acceptCall() async {
    return _sendUserEvent(rpc.UserEventType.USER_EVENT_TYPE_ACCEPTED_CALL);
  }

  Future<Result<None>> _rejectCall() async {
    return _sendUserEvent(rpc.UserEventType.USER_EVENT_TYPE_REJECTED_CALL);
  }

  Future<Result<None>> _cancelCall() async {
    return _sendUserEvent(rpc.UserEventType.USER_EVENT_TYPE_CANCELLED_CALL);
  }

  Future<Result<None>> _sendUserEvent(rpc.UserEventType userEvent) async {
    final result = await _coordinatorClient.sendUserEvent(
      rpc.SendEventRequest(
        callCid: callCid,
        eventType: userEvent,
      ),
    );
    if (result is Failure) {
      return result;
    }
    return None().toSuccess();
  }
}
