import '../models/call_permission.dart';
import 'external_action.dart';

abstract class CallAction extends StreamExternalAction {
  const CallAction();
}

class RequestPermissions extends CallAction {
  const RequestPermissions(this.permissions);

  final List<CallPermission> permissions;

  @override
  List<Object?> get props => [permissions];
}

class GrantPermissions extends CallAction {
  const GrantPermissions({
    required this.userId,
    this.permissions = const [],
  });

  final String userId;
  final List<CallPermission> permissions;

  @override
  List<Object?> get props => [userId, permissions];
}

class RevokePermissions extends CallAction {
  const RevokePermissions({
    required this.userId,
    this.permissions = const [],
  });

  final String userId;
  final List<CallPermission> permissions;

  @override
  List<Object?> get props => [userId, permissions];
}

class BlockUser extends CallAction {
  const BlockUser({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class UnblockUser extends CallAction {
  const UnblockUser({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class MuteUsers extends CallAction {
  const MuteUsers({
    required this.userIds,
  });

  final List<String> userIds;

  @override
  List<Object?> get props => [userIds];
}

class StartRecording extends CallAction {
  const StartRecording();
}

class StopRecording extends CallAction {
  const StopRecording();
}

class StartBroadcasting extends CallAction {
  const StartBroadcasting();
}

class StopBroadcasting extends CallAction {
  const StopBroadcasting();
}
