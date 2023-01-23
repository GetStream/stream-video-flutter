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
import '../action/call_control_action.dart';
import '../model/call_cid.dart';
import '../model/call_created.dart';
import '../model/call_received_created.dart';
import '../reducer/call_state_reducer.dart';
import '../coordinator/coordinator_client.dart';
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../shared_emitter.dart';
import '../utils/none.dart';
import '../webrtc/rtc_track.dart';
import 'call_settings.dart';
import 'session/call_session_impl.dart';
import 'session/call_session_factory.dart';

/// Represents a [CallV2] in which you can connect to.
abstract class CallV2 {
  StreamCallCid get cid;

  StateEmitter<CallStateV2> get state;

  SharedEmitter<SfuEventV2> get events;

  Future<Result<CallCreated>> dial({
    required List<String> participantIds,
  });

  Future<Result<CallReceivedOrCreated>> getOrCreate({
    List<String> participantIds = const [],
    bool ringing = false,
  });

  Future<Result<CallCreated>> create({
    List<String> participantIds = const [],
    bool ringing = false,
  });

  Future<Result<None>> acceptCall();

  Future<Result<None>> rejectCall();

  Future<Result<None>> cancelCall();

  Future<Result<None>> connect({
    CallSettings settings = const CallSettings(),
  });

  Future<Result<None>> disconnect();

  List<RtcTrack> getTracks(String trackId);

  RtcTrack? getTrack(String trackId, SfuTrackType trackType);

  Future<Result<None>> apply(CallControlAction action);
}
