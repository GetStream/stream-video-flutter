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
import '../action/user_action.dart';
import '../call_state.dart';
import '../call_state_manager.dart';
import '../coordinator/coordinator_client.dart';
import '../coordinator/ws/coordinator_ws.dart';
import '../errors/video_error.dart';
import '../state_emitter.dart';
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
  CallV2Impl({
    required this.getCurrentUserId,
    required this.callCid,
    required CoordinatorClientV2 coordinatorClient,
    required CoordinatorWebSocketV2 coordinatorWS,
  })  : _coordinatorClient = coordinatorClient,
        _coordinatorWS = coordinatorWS,
        _sessionFactory = CallSessionFactory(
          callCid: callCid,
        );

  late final _logger = taggedLogger(tag: 'SV:Call:$callCid');
  late final CallStateManager _stateManager = CallStateManager(
    getCurrentUserId,
    callCid,
    _coordinatorClient,
  );

  final String? Function() getCurrentUserId;
  final String callCid;
  final CoordinatorClientV2 _coordinatorClient;
  final CoordinatorWebSocketV2 _coordinatorWS;
  final CallSessionFactory _sessionFactory;

  @override
  StateEmitter<CallStateV2> get state => _stateManager.state;

  CallSession? _session;

  @override
  Future<Result<None>> connect({
    CallSettings settings = const CallSettings(),
  }) async {
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

    final sessionStartedResult = await _session!.start();
    if (sessionStartedResult is! Success<bool>) {
      return sessionStartedResult as Failure;
    }

    if (settings.cameraEnabled) {
      await apply(const SetCameraEnabled(enabled: true));
    }
    if (settings.microphoneEnabled) {
      await apply(const SetMicrophoneEnabled(enabled: true));
    }
    if (settings.screenShareEnabled) {
      await apply(const SetScreenShareEnabled(enabled: true));
    }

    _logger.v(() => '[connect] completed');

    return None().toSuccess();
  }

  @override
  Future<Result<None>> disconnect() async {
    await _session?.dispose();
    _session = null;
    return None().toSuccess();
  }

  @override
  Future<Result<None>> apply(UserAction action) async {
    if (_session == null) {
      return Failure(const VideoError(message: 'Call session is not started'));
    }

    final result = await _session!.apply(action);
    return result;
  }

  @override
  RtcTrack? getTrack(String trackId) {
    return _session?.getTrack(trackId);
  }
}
