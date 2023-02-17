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

/// Represents a [Call] in which you can connect to.
abstract class Call {
  const Call();

  factory Call.fromCid({
    required StreamCallCid callCid,
    StreamVideo? streamVideo,
  }) {
    return CallImpl(
      callCid: callCid,
      streamVideo: streamVideo,
    );
  }

  factory Call.fromCreated({
    required CallCreated data,
    StreamVideo? streamVideo,
  }) {
    return CallImpl.created(
      data: data,
      streamVideo: streamVideo,
    );
  }

  factory Call.fromJoined({
    required CallJoined data,
    StreamVideo? streamVideo,
  }) {
    return CallImpl.joined(
      data: data,
      streamVideo: streamVideo,
    );
  }

  static Call? activeCall;
  static void Function(Call?)? onActiveCall;

  StreamCallCid get callCid;

  StateEmitter<CallState> get state;

  SharedEmitter<SfuEvent> get events;

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
