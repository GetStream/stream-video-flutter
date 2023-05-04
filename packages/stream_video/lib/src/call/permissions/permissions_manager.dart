import 'package:meta/meta.dart';

import '../../../stream_video.dart';
import '../../action/call_action.dart';
import '../../models/call_permission.dart';
import '../../utils/none.dart';
import '../state/call_state_notifier.dart';

typedef GetStateOrNull = CallState? Function();

@internal
class PermissionsManager {
  const PermissionsManager({
    required this.callCid,
    required this.streamVideo,
    required this.stateManager,
  });

  TaggedLogger get _logger => const TaggedLogger('SV:PermissionsManager');

  final StreamCallCid callCid;
  final StreamVideo streamVideo;
  final CallStateNotifier stateManager;

  Future<Result<None>> endCall() async {
    if (!_hasPermission(CallPermission.endCall)) {
      return Result.error('has no "end-call" permission');
    }
    _logger.d(() => '[endCall] callCid: $callCid');
    final result = await streamVideo.endCall(callCid: callCid);
    _logger.v(() => '[endCall] result: $result');
    return result;
  }

  Future<Result<None>> apply(CallAction action) async {
    if (action is RequestPermissions) {
      return _request(action.permissions);
    } else if (action is GrantPermissions) {
      return _grant(userId: action.userId, permissions: action.permissions);
    } else if (action is RevokePermissions) {
      return _revoke(userId: action.userId, permissions: action.permissions);
    } else if (action is BlockUser) {
      return _blockUser(action.userId);
    } else if (action is UnblockUser) {
      return _unblockUser(action.userId);
    } else if (action is MuteUsers) {
      return _muteUsers(action.userIds);
    } else if (action is StartRecording) {
      return _startRecording();
    } else if (action is StopRecording) {
      return _stopRecording();
    } else if (action is StartBroadcasting) {
      return _startBroadcasting();
    } else if (action is StopBroadcasting) {
      return _stopBroadcasting();
    }
    return Result.error('Action not supported: $action');
  }

  Future<Result<None>> _request(
    List<CallPermission> permissions,
  ) async {
    final canRequest = permissions.every(_canRequestPermission);
    if (!canRequest) {
      _logger.w(() => '[request] rejected (no permission)');
      return Result.error(
        'Some permissions cannot be requested (see canRequestPermission method)',
      );
    }
    _logger.d(() => '[request] permissions: $permissions');
    final result = await streamVideo.requestPermissions(
      callCid: callCid,
      permissions: permissions,
    );
    _logger.v(() => '[request] result: $result');
    return result;
  }

  Future<Result<None>> _grant({
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
    final result = await streamVideo.updateUserPermissions(
      callCid: callCid,
      userId: userId,
      grantPermissions: permissions,
    );
    _logger.v(() => '[grant] result: $result');
    return result;
  }

  Future<Result<None>> _revoke({
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
    final result = await streamVideo.updateUserPermissions(
      callCid: callCid,
      userId: userId,
      revokePermissions: permissions,
    );
    _logger.v(() => '[revoke] result: $result');
    return result;
  }

  Future<Result<None>> _blockUser(String userId) async {
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
    return result;
  }

  Future<Result<None>> _unblockUser(String userId) async {
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
    return result;
  }

  Future<Result<None>> _startRecording() async {
    if (!_hasPermission(CallPermission.startRecordCall)) {
      _logger.w(() => '[startRecording] rejected (no permission)');
      return Result.error('Cannot start recording (no permission)');
    }
    _logger.d(() => '[startRecording] no args');
    final result = await streamVideo.startRecording(callCid: callCid);
    _logger.v(() => '[startRecording] result: $result');
    return result;
  }

  Future<Result<None>> _stopRecording() async {
    if (!_hasPermission(CallPermission.stopRecordCall)) {
      _logger.w(() => '[stopRecording] rejected (no permission)');
      return Result.error('Cannot stop recording (no permission)');
    }
    _logger.d(() => '[stopRecording] no args');
    final result = await streamVideo.stopRecording(callCid: callCid);
    _logger.v(() => '[stopRecording] result: $result');
    return result;
  }

  Future<Result<None>> _startBroadcasting() async {
    if (!_hasPermission(CallPermission.startBroadcastCall)) {
      _logger.w(() => '[startBroadcasting] rejected (no permission)');
      return Result.error('Cannot start broadcasting (no permission)');
    }
    _logger.d(() => '[startBroadcasting] no args');
    final result = await streamVideo.startBroadcasting(callCid: callCid);
    _logger.v(() => '[startBroadcasting] result: $result');
    return result;
  }

  Future<Result<None>> _stopBroadcasting() async {
    if (!_hasPermission(CallPermission.stopBroadcastCall)) {
      _logger.w(() => '[stopBroadcasting] rejected (no permission)');
      return Result.error('Cannot stop broadcasting (no permission)');
    }
    _logger.d(() => '[stopBroadcasting] no args');
    final result = await streamVideo.stopBroadcasting(callCid: callCid);
    _logger.v(() => '[stopBroadcasting] result: $result');
    return result;
  }

  Future<Result<None>> _muteUsers(List<String> userIds) async {
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
    return result;
  }

  bool _canRequestPermission(CallPermission permission) {
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
    final capabilities = stateManager.callStateStream.valueOrNull?.ownCapabilities;
    if (capabilities == null || capabilities.isEmpty) {
      _logger.w(() => '[hasPermission] rejected (no capabilities)');
      return false;
    }
    return capabilities.contains(permission);
  }
}
