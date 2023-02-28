import 'dart:async';

import '../../stream_video.dart';
import '../coordinator/models/coordinator_events.dart';
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

  OnCallPermissionRequest? onPermissionRequest;

  Future<Result<None>> joinCall();

  Future<Result<None>> connect({
    CallConnectOptions options = const CallConnectOptions(),
  });

  Future<Result<None>> disconnect();

  Future<Result<None>> apply(CallControlAction action);

  bool canRequestPermission(String permission);

  bool canUpdateUserPermissions();

  Future<Result<None>> requestPermissions(List<String> permissions);

  Future<Result<None>> updateUserPermissions({
    required String userId,
    List<String> grantPermissions = const [],
    List<String> revokePermissions = const [],
  });

  List<RtcTrack> getTracks(String trackIdPrefix);

  RtcTrack? getTrack(String trackIdPrefix, SfuTrackType trackType);

  Future<Result<None>> inviteUsers(List<UserInfo> users);
}

extension CallX on Call {
  Future<Result<None>> grantPermissions({
    required String userId,
    required List<String> permissions,
  }) {
    return updateUserPermissions(
      userId: userId,
      grantPermissions: permissions,
    );
  }

  Future<Result<None>> revokePermissions({
    required String userId,
    required List<String> permissions,
  }) {
    return updateUserPermissions(
      userId: userId,
      revokePermissions: permissions,
    );
  }
}
