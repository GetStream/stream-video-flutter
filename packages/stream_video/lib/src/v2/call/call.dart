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
import '../utils/none.dart';
import '../webrtc/rtc_track.dart';
import 'call_settings.dart';
import 'session/call_session.dart';
import 'session/call_session_factory.dart';

/// Represents a [CallV2] in which you can connect to.
abstract class CallV2 {
  StateEmitter<CallStateV2> get state;

  Future<Result<None>> apply(UserAction action);

  Future<Result<None>> connect({
    CallSettings settings = const CallSettings(),
  });

  Future<Result<None>> disconnect();

  RtcTrack? getTrack(String trackId);
}
