import 'dart:async';

import 'package:stream_video/protobuf/video/coordinator/edge_v1/edge.pb.dart'
    as edge;
import 'package:stream_video/src/logger/logger.dart';
import 'package:stream_video/src/logger/stream_logger.dart';
import 'package:stream_video/src/options.dart';
import 'package:stream_video/src/v2/call_state.dart';
import 'package:stream_video/src/v2/state_emitter.dart';
import 'package:stream_video/src/v2/utils/result.dart';

import '../../../../protobuf/video/coordinator/client_v1_rpc/client_rpc.pb.dart'
    as rpc;
import '../action/user_action.dart';
import '../call_state_reducer.dart';
import '../coordinator/coordinator_client.dart';
import '../coordinator/ws/coordinator_ws.dart';
import '../utils/none.dart';
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
      callSettings: settings,
    );

    await session?.start();

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
    // TODO: implement apply
    return None().toSuccess();
  }

  @override
  RtcTrack? getTrack(String trackId) {
    return session?.getTrack(trackId);
  }
}
