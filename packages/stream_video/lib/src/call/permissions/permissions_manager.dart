import 'package:meta/meta.dart';

import '../../../stream_video.dart';
import '../../models/call_permission.dart';
import '../../utils/none.dart';
import '../state/call_state_notifier.dart';

typedef GetStateOrNull = CallState? Function();

@internal
class PermissionsManager {
  const PermissionsManager({
    required this.callCid,
    required this.coordinatorClient,
    required this.stateManager,
  });

  TaggedLogger get _logger => const TaggedLogger('SV:PermissionsManager');

  final StreamCallCid callCid;
  final CoordinatorClient coordinatorClient;
  final CallStateNotifier stateManager;

  Future<Result<None>> endCall() async {
    if (!_hasPermission(CallPermission.endCall)) {
      return Result.error('has no "end-call" permission');
    }
    _logger.d(() => '[endCall] callCid: $callCid');
    final result = await coordinatorClient.endCall(callCid);
    _logger.v(() => '[endCall] result: $result');
    return result;
  }

  Future<Result<None>> request(
    List<CallPermission> permissions,
  ) async {
    final canRequest = permissions.every(canRequestPermission);
    if (!canRequest) {
      _logger.w(() => '[request] rejected (no permission)');
      return Result.error(
        'Some permissions cannot be requested (see canRequestPermission method)',
      );
    }
    _logger.d(() => '[request] permissions: $permissions');
    final result = coordinatorClient.requestPermissions(
      RequestPermissionsInput(
        callCid: callCid,
        permissions: permissions,
      ),
    );
    _logger.v(() => '[request] result: $result');
    return result;
  }

  /// Grants the [permissions] to the [userId] in the [callCid].
  Future<Result<None>> grant({
    required String userId,
    List<CallPermission> permissions = const [],
  }) async {
    final canUpdate = _hasPermission(CallPermission.updateCallPermissions);
    if (!canUpdate) {
      _logger.w(() => '[grant] rejected (no permission)');
      return Result.error(
        'Cannot grant permissions (see canUpdatePermission method)',
      );
    }
    _logger.d(() => '[grant] userId: $userId, permissions: $permissions');
    final result = await coordinatorClient.updateUserPermissions(
      UpdateUserPermissionsInput(
        callCid: callCid,
        userId: userId,
        grantPermissions: permissions,
        revokePermissions: const [],
      ),
    );
    _logger.v(() => '[grant] result: $result');
    return result;
  }

  /// Revokes the [permissions] from the [userId] in the [callCid].
  Future<Result<None>> revoke({
    required String userId,
    List<CallPermission> permissions = const [],
  }) async {
    final canUpdate = _hasPermission(CallPermission.updateCallPermissions);
    if (!canUpdate) {
      _logger.w(() => '[revoke] rejected (no permission)');
      return Result.error(
        'Cannot revoke permissions (see canUpdatePermission method)',
      );
    }
    _logger.d(() => '[revoke] userId: $userId, permissions: $permissions');
    final result = await coordinatorClient.updateUserPermissions(
      UpdateUserPermissionsInput(
        callCid: callCid,
        userId: userId,
        grantPermissions: const [],
        revokePermissions: permissions,
      ),
    );
    _logger.v(() => '[revoke] result: $result');
    return result;
  }

  Future<Result<None>> blockUser(String userId) async {
    if (!_hasPermission(CallPermission.blockUsers)) {
      _logger.w(() => '[blockUser] rejected (no permission)');
      return Result.error('Cannot block user (no permission)');
    }
    _logger.d(() => '[blockUser] userId: $userId');
    final result = await coordinatorClient.blockUser(
      BlockUserInput(
        callCid: callCid,
        userId: userId,
      ),
    );
    _logger.v(() => '[blockUser] result: $result');
    return result;
  }

  Future<Result<None>> unblockUser(String userId) async {
    if (!_hasPermission(CallPermission.blockUsers)) {
      _logger.w(() => '[unblockUser] rejected (no permission)');
      return Result.error('Cannot unblock user (no permission)');
    }
    _logger.d(() => '[unblockUser] userId: $userId');
    final result = coordinatorClient.unblockUser(
      UnblockUserInput(
        callCid: callCid,
        userId: userId,
      ),
    );
    _logger.v(() => '[unblockUser] result: $result');
    return result;
  }

  Future<Result<None>> startRecording() async {
    if (!_hasPermission(CallPermission.startRecordCall)) {
      _logger.w(() => '[startRecording] rejected (no permission)');
      return Result.error('Cannot start recording (no permission)');
    }
    _logger.d(() => '[startRecording] no args');
    final result = await coordinatorClient.startRecording(callCid);
    _logger.v(() => '[startRecording] result: $result');
    return result;
  }

  Future<Result<None>> stopRecording() async {
    if (!_hasPermission(CallPermission.stopRecordCall)) {
      _logger.w(() => '[stopRecording] rejected (no permission)');
      return Result.error('Cannot stop recording (no permission)');
    }
    _logger.d(() => '[stopRecording] no args');
    final result = await coordinatorClient.stopRecording(callCid);
    _logger.v(() => '[stopRecording] result: $result');
    return result;
  }

  Future<Result<None>> startBroadcasting() async {
    if (!_hasPermission(CallPermission.startBroadcastCall)) {
      _logger.w(() => '[startBroadcasting] rejected (no permission)');
      return Result.error('Cannot start broadcasting (no permission)');
    }
    _logger.d(() => '[startBroadcasting] no args');
    final result = await coordinatorClient.startBroadcasting(callCid);
    _logger.v(() => '[startBroadcasting] result: $result');
    return result;
  }

  Future<Result<None>> stopBroadcasting() async {
    if (!_hasPermission(CallPermission.stopBroadcastCall)) {
      _logger.w(() => '[stopBroadcasting] rejected (no permission)');
      return Result.error('Cannot stop broadcasting (no permission)');
    }
    _logger.d(() => '[stopBroadcasting] no args');
    final result = await coordinatorClient.stopBroadcasting(callCid);
    _logger.v(() => '[stopBroadcasting] result: $result');
    return result;
  }

  Future<Result<None>> muteUsers(List<String> userIds, TrackType track) async {
    if (!_hasPermission(CallPermission.muteUsers)) {
      _logger.w(() => '[muteUsers] rejected (no permission)');
      return Result.error('Cannot mute users (no permission)');
    }
    _logger.d(() => '[muteUsers] userIds: $userIds');

    late final Result<None> result;
    if (track == TrackType.all) {
      result = await coordinatorClient.muteUsers(
        MuteUsersInput(
          callCid: callCid,
          userIds: userIds,
          audio: true,
          video: true,
          screenshare: true,
        ),
      );
    } else {
      result = await coordinatorClient.muteUsers(
        MuteUsersInput(
          callCid: callCid,
          userIds: userIds,
          audio: track == TrackType.audio,
          video: track == TrackType.video,
          screenshare: track == TrackType.screenshare,
        ),
      );
    }

    _logger.v(() => '[muteUsers] result: $result');
    return result;
  }

  Future<Result<None>> muteSelf(TrackType track) async {
    if (!_hasPermission(CallPermission.muteUsers)) {
      _logger.w(() => '[muteSelf] rejected (no permission)');
      return Result.error('Cannot mute self (no permission)');
    }
    _logger.d(() => '[muteSelf] muting current user');

    final selfUID = stateManager.callState.currentUserId;
    return muteUsers([selfUID], track);
  }

  Future<Result<None>> muteOthers(TrackType track) async {
    if (!_hasPermission(CallPermission.muteUsers)) {
      _logger.w(() => '[muteOthers] rejected (no permission)');
      return Result.error('Cannot mute other users (no permission)');
    }
    _logger.d(() => '[muteOthers] muting other users');

    final selfUID = stateManager.callState.currentUserId;
    final usersToMute = <String>[];

    for (final participant in stateManager.callState.otherParticipants) {
      if (participant.publishedTracks.containsKey(track.toSFUTrackType())) {
        usersToMute.add(participant.userId);
      }
    }
    return muteUsers([selfUID], track);
  }

  Future<Result<None>> muteAllUsers(TrackType track) async {
    if (!_hasPermission(CallPermission.muteUsers)) {
      _logger.w(() => '[muteAllUsers] rejected (no permission)');
      return Result.error('Cannot mute users (no permission)');
    }
    _logger.d(() => '[muteAllUsers] muting all users');

    return coordinatorClient.muteUsers(
      MuteUsersInput(
        callCid: callCid,
        muteAllUsers: true,
        userIds: const [],
        audio: true,
        video: true,
        screenshare: true,
      ),
    );
  }

  bool canRequestPermission(CallPermission permission) {
    final settings = stateManager.callStateStream.valueOrNull?.settings;
    if (settings == null) {
      _logger.w(() => 'canRequestPermission: no settings');
      return false;
    }

    if (permission == CallPermission.sendAudio) {
      return settings.audio.accessRequestEnabled;
    } else if (permission == CallPermission.sendVideo) {
      return settings.video.accessRequestEnabled;
    } else if (permission == CallPermission.screenshare) {
      return settings.screenShare.accessRequestEnabled;
    }

    _logger.w(() => 'canRequestPermission: unknown permission: $permission');
    return false;
  }

  bool _hasPermission(CallPermission permission) {
    final capabilities =
        stateManager.callStateStream.valueOrNull?.ownCapabilities;
    if (capabilities == null || capabilities.isEmpty) {
      _logger.w(() => '[hasPermission] rejected (no capabilities)');
      return false;
    }
    return capabilities.contains(permission);
  }
}
