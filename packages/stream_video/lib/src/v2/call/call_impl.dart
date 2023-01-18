import 'dart:async';

import '../../../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart'
    as rpc;
import '../../logger/logger.dart';
import '../../logger/stream_logger.dart';
import '../action/user_action.dart';
import '../call_state.dart';
import '../call_state_reducer.dart';
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
    required this.callCid,
    required this.coordinatorClient,
    required this.coordinatorWS,
  }) : sessionFactory = CallSessionFactory(
          callCid: callCid,
        );

  final _logger = taggedLogger(tag: 'SV:Call');

  final _state = MutableStateEmitterImpl(CallStateV2());
  final _stateReducer = CallStateReducer();

  final String callCid;
  final CoordinatorClientV2 coordinatorClient;
  final CoordinatorWebSocketV2 coordinatorWS;
  final CallSessionFactory sessionFactory;

  CallSession? session;
  StateEmitter<CallStateV2> get state => _state;

  @override
  Future<Result<None>> connect({
    CallSettings settings = const CallSettings(),
  }) async {
    final typeAndId = callCid.split(':');

    final joinResult = await coordinatorClient.joinCall(
      rpc.JoinCallRequest(id: typeAndId[1], type: typeAndId[0]),
    );
    if (joinResult is! Success<rpc.JoinCallResponse>) {
      return joinResult as Failure;
    }
    final edgeResult = await coordinatorClient.findBestCallEdgeServer(
      callCid: callCid,
      edges: joinResult.data.edges,
    );
    if (edgeResult is! Success<rpc.GetCallEdgeServerResponse>) {
      return edgeResult as Failure;
    }

    session = await sessionFactory.makeCallSession(
      credentials: edgeResult.data.credentials,
    );

    final sessionStartedResult = await session!.start();
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

    logger.fine('Call Connect completed');

    return None().toSuccess();
  }

  @override
  Future<Result<None>> disconnect() async {
    await session?.dispose();
    session = null;
    return None().toSuccess();
  }

  @override
  Future<Result<None>> apply(UserAction action) async {
    if (session == null) {
      return Failure(const VideoError(message: 'Call session is not started'));
    }

    final result = await session!.apply(action);
    return result;
  }

  @override
  RtcTrack? getTrack(String trackId) {
    return session?.getTrack(trackId);
  }
}
