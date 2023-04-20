import 'dart:async';

import '../../stream_video.dart';
import '../coordinator/models/coordinator_events.dart';
import '../models/call_created_data.dart';
import '../models/call_joined_data.dart';
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

  Future<Result<None>> connect();

  Future<Result<None>> disconnect();

  Future<Result<None>> end();

  Future<Result<None>> requestPermissions(List<CallPermission> permissions);

  Future<Result<None>> grantPermissions({
    required String userId,
    List<CallPermission> permissions = const [],
  });

  Future<Result<None>> revokePermissions({
    required String userId,
    List<CallPermission> permissions = const [],
  });

  Future<Result<None>> blockUser(String userId);

  Future<Result<None>> unblockUser(String userId);

  Future<Result<None>> startRecording();

  Future<Result<None>> stopRecording();

  Future<Result<None>> startBroadcasting();

  Future<Result<None>> stopBroadcasting();

  Future<Result<None>> muteUsers(List<String> userIds);

  Future<Result<None>> apply(ParticipantAction action);

  Future<Result<None>> inviteUsers(List<UserInfo> users);

  Future<Result<None>> setLocalTrack(RtcLocalTrack track);

  List<RtcTrack> getTracks(String trackIdPrefix);

  RtcTrack? getTrack(String trackIdPrefix, SfuTrackType trackType);
}
