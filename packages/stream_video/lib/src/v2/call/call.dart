import 'dart:async';

import '../../../stream_video.dart';
import '../action/call_control_action.dart';
import '../call_state.dart';
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../shared_emitter.dart';
import '../state_emitter.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import '../webrtc/rtc_track.dart';
import 'call_impl.dart';
import 'call_settings.dart';

/// Represents a [CallV2] in which you can connect to.
abstract class CallV2 {
  const CallV2();

  factory CallV2.fromCid({
    required StreamCallCid callCid,
    StreamVideoV2? streamVideo,
  }) {
    return CallV2Impl(
      callCid: callCid,
      streamVideo: streamVideo,
    );
  }

  factory CallV2.fromCreated({
    required CallCreated data,
    StreamVideoV2? streamVideo,
  }) {
    return CallV2Impl.created(
      data: data,
      streamVideo: streamVideo,
    );
  }

  factory CallV2.fromJoined({
    required CallJoined data,
    StreamVideoV2? streamVideo,
  }) {
    return CallV2Impl.joined(
      data: data,
      streamVideo: streamVideo,
    );
  }

  static CallV2? activeCall;
  static void Function(CallV2?)? onActiveCall;

  StreamCallCid get callCid;

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

  Future<Result<None>> connect({
    CallSettings settings = const CallSettings(),
  });

  Future<Result<None>> disconnect();

  Future<Result<None>> apply(CallControlAction action);

  List<RtcTrack> getTracks(String trackIdPrefix);

  RtcTrack? getTrack(String trackIdPrefix, SfuTrackType trackType);

  Future<void> inviteUsers(List<UserInfo> users);
}
