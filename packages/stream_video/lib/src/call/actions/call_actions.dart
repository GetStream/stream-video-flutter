import '../../action/call_action.dart';
import '../../models/call_permission.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../call.dart';

extension PermissionsExtensions on Call {
  Future<Result<None>> requestPermissions(List<CallPermission> permissions) {
    return apply(RequestPermissions(permissions));
  }

  Future<Result<None>> grantPermissions({
    required String userId,
    List<CallPermission> permissions = const [],
  }) {
    return apply(GrantPermissions(userId: userId, permissions: permissions));
  }

  Future<Result<None>> revokePermissions({
    required String userId,
    List<CallPermission> permissions = const [],
  }) {
    return apply(RevokePermissions(userId: userId, permissions: permissions));
  }

  Future<Result<None>> blockUser(String userId) {
    return apply(BlockUser(userId: userId));
  }

  Future<Result<None>> unblockUser(String userId) {
    return apply(UnblockUser(userId: userId));
  }

  Future<Result<None>> startRecording() {
    return apply(const StartRecording());
  }

  Future<Result<None>> stopRecording() {
    return apply(const StopRecording());
  }

  Future<Result<None>> startTranscription() {
    return apply(const StartTranscription());
  }

  Future<Result<None>> stopTranscription() {
    return apply(const StopTranscription());
  }

  Future<Result<None>> startBroadcasting() {
    return apply(const StartBroadcasting());
  }

  Future<Result<None>> stopBroadcasting() {
    return apply(const StopBroadcasting());
  }

  Future<Result<None>> muteUsers(List<String> userIds) {
    return apply(MuteUsers(userIds: userIds));
  }
}
