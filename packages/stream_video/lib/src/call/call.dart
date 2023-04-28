import 'dart:async';

import '../../stream_video.dart';
import '../action/external_action.dart';
import '../coordinator/models/coordinator_events.dart';
import '../models/call_permission.dart';
import '../sfu/data/events/sfu_events.dart';
import '../shared_emitter.dart';
import '../state_emitter.dart';
import '../utils/none.dart';
import 'call_impl.dart';

typedef OnCallPermissionRequest = void Function(
  CoordinatorCallPermissionRequestEvent,
);

/// Represents a [Call] in which you can connect to.
abstract class Call {
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
    required CallCreatedData data,
    StreamVideo? streamVideo,
  }) {
    return CallImpl.created(
      data: data,
      streamVideo: streamVideo,
    );
  }

  factory Call.fromJoined({
    required CallJoinedData data,
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

  SharedEmitter<CallStats> get stats;

  SharedEmitter<SfuEvent> get events;

  OnCallPermissionRequest? onPermissionRequest;

  CallConnectOptions get connectOptions;

  set connectOptions(CallConnectOptions connectOptions);

  Future<Result<None>> join();

  Future<Result<None>> accept();

  Future<Result<None>> reject();

  Future<Result<None>> end();

  Future<Result<None>> connect();

  Future<Result<None>> disconnect();

  Future<Result<None>> apply(StreamExternalAction action);

  Future<Result<None>> inviteUsers(List<UserInfo> users);

  List<RtcTrack> getTracks(String trackIdPrefix);

  RtcTrack? getTrack(String trackIdPrefix, SfuTrackType trackType);
}
