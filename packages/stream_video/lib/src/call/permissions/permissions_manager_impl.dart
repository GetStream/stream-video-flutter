import 'package:meta/meta.dart';

import '../../../stream_video.dart';
import '../../action/internal/permitted_action.dart';
import '../../call_state_manager.dart';
import '../../models/call_permission.dart';
import '../../utils/none.dart';
import 'permissions_manager.dart';

typedef GetStateOrNull = CallState? Function();

@internal
class PermissionsManagerImpl implements PermissionsManager {
  const PermissionsManagerImpl({
    required this.callCid,
    required this.streamVideo,
    required this.stateManager,
  });

  TaggedLogger get _logger => const TaggedLogger('SV');

  final StreamCallCid callCid;
  final StreamVideo streamVideo;
  final CallStateManager stateManager;

  @override
  Future<Result<None>> request(
    List<CallPermission> permissions,
  ) async {
    final canRequest = permissions.every(_canRequestPermission);
    if (!canRequest) {
      return Result.error(
        'Some permissions cannot be requested (see canRequestPermission method)',
      );
    }

    final result = await streamVideo.requestPermissions(
      callCid: callCid,
      permissions: permissions,
    );
    if (result.isSuccess) {
      stateManager.onAction(
        PermissionsRequested(permissions: permissions),
      );
    }
    return result;
  }

  @override
  Future<Result<None>> grant({
    required String userId,
    List<CallPermission> permissions = const [],
  }) async {
    final canUpdate = _hasPermission(CallPermission.updateCallPermissions);
    if (!canUpdate) {
      return Result.error(
        'Cannot grant permissions (see canUpdatePermission method)',
      );
    }
    final result = await streamVideo.updateUserPermissions(
      callCid: callCid,
      userId: userId,
      grantPermissions: permissions,
    );
    if (result.isSuccess) {
      stateManager.onAction(
        PermissionsGranted(userId: userId, permissions: permissions),
      );
    }
    return result;
  }

  @override
  Future<Result<None>> revoke({
    required String userId,
    List<CallPermission> permissions = const [],
  }) async {
    final canUpdate = _hasPermission(CallPermission.updateCallPermissions);
    if (!canUpdate) {
      return Result.error(
        'Cannot revoke permissions (see canUpdatePermission method)',
      );
    }
    final result = await streamVideo.updateUserPermissions(
      callCid: callCid,
      userId: userId,
      revokePermissions: permissions,
    );
    if (result.isSuccess) {
      stateManager.onAction(
        PermissionsRevoked(userId: userId, permissions: permissions),
      );
    }
    return result;
  }

  @override
  Future<Result<None>> endCall() async {
    if (!_hasPermission(CallPermission.endCall)) {
      return Result.error('has no "end-call" permission');
    }
    _logger.d(() => '[endCall] callCid: $callCid');
    final result = await streamVideo.endCall(callCid: callCid);
    if (result.isSuccess) {
      stateManager.onAction(const CallEnded());
    }
    _logger.v(() => '[endCall] result: $result');
    return result;
  }


  @override
  Future<Result<None>> blockUser(String userId) async {
    if (!_hasPermission(CallPermission.blockUsers)) {
      _logger.w(() => '[blockUser] rejected (no permission)');
      return Result.error('Cannot block user (no permission)');
    }
    _logger.d(() => '[blockUser] userId: $userId');
    final result = await streamVideo.blockUser(
      callCid: callCid,
      userId: userId,
    );
    _logger.v(() => '[blockUser] result: $result');
    if (result.isSuccess) {
      stateManager.onAction(UserBlocked(userId: userId));
    }
    return result;
  }

  @override
  Future<Result<None>> unblockUser(String userId) async {
    if (!_hasPermission(CallPermission.blockUsers)) {
      _logger.w(() => '[unblockUser] rejected (no permission)');
      return Result.error('Cannot unblock user (no permission)');
    }
    _logger.d(() => '[unblockUser] userId: $userId');
    final result = await streamVideo.unblockUser(
      callCid: callCid,
      userId: userId,
    );
    _logger.v(() => '[unblockUser] result: $result');
    if (result.isSuccess) {
      stateManager.onAction(UserUnblocked(userId: userId));
    }
    return result;
  }

  @override
  Future<Result<None>> startRecording() async {
    if (!_hasPermission(CallPermission.startRecordCall)) {
      _logger.w(() => '[startRecording] rejected (no permission)');
      return Result.error('Cannot start recording (no permission)');
    }
    _logger.d(() => '[startRecording] no args');
    final result = await streamVideo.startRecording(callCid: callCid);
    _logger.v(() => '[startRecording] result: $result');
    if (result.isSuccess) {
      stateManager.onAction(const RecordingStarted());
    }
    return result;
  }

  @override
  Future<Result<None>> stopRecording() async {
    if (!_hasPermission(CallPermission.stopRecordCall)) {
      _logger.w(() => '[stopRecording] rejected (no permission)');
      return Result.error('Cannot stop recording (no permission)');
    }
    _logger.d(() => '[stopRecording] no args');
    final result = await streamVideo.stopRecording(callCid: callCid);
    _logger.v(() => '[stopRecording] result: $result');
    if (result.isSuccess) {
      stateManager.onAction(const RecordingStopped());
    }
    return result;
  }

  @override
  Future<Result<None>> startBroadcasting() async {
    if (!_hasPermission(CallPermission.startBroadcastCall)) {
      _logger.w(() => '[startBroadcasting] rejected (no permission)');
      return Result.error('Cannot start broadcasting (no permission)');
    }
    _logger.d(() => '[startBroadcasting] no args');
    final result = await streamVideo.startBroadcasting(callCid: callCid);
    _logger.v(() => '[startBroadcasting] result: $result');
    if (result.isSuccess) {
      stateManager.onAction(const BroadcastingStarted());
    }
    return result;
  }

  @override
  Future<Result<None>> stopBroadcasting() async {
    if (!_hasPermission(CallPermission.stopBroadcastCall)) {
      _logger.w(() => '[stopBroadcasting] rejected (no permission)');
      return Result.error('Cannot stop broadcasting (no permission)');
    }
    _logger.d(() => '[stopBroadcasting] no args');
    final result = await streamVideo.stopBroadcasting(callCid: callCid);
    _logger.v(() => '[stopBroadcasting] result: $result');
    if (result.isSuccess) {
      stateManager.onAction(const BroadcastingStopped());
    }
    return result;
  }

  @override
  Future<Result<None>> muteUsers(List<String> userIds) async {
    if (!_hasPermission(CallPermission.muteUsers)) {
      _logger.w(() => '[muteUsers] rejected (no permission)');
      return Result.error('Cannot mute users (no permission)');
    }
    _logger.d(() => '[muteUsers] userIds: $userIds');
    final result = await streamVideo.muteUsers(
      callCid: callCid,
      userIds: userIds,
    );
    _logger.v(() => '[muteUsers] result: $result');
    if (result.isSuccess) {
      stateManager.onAction(UsersMuted(userIds: userIds));
    }
    return result;
  }

  bool _canRequestPermission(CallPermission permission) {
    final settings = stateManager.state.valueOrNull?.settings;
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
    final capabilities = stateManager.state.valueOrNull?.ownCapabilities;
    if (capabilities == null || capabilities.isEmpty) {
      _logger.w(() => '[hasPermission] rejected (no capabilities)');
      return false;
    }
    return capabilities.contains(permission);
  }
}
