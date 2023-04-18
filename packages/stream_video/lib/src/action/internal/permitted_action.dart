import 'package:meta/meta.dart';

import '../../models/call_permission.dart';
import '../internal_action.dart';

@internal
abstract class PermittedAction extends StreamInternalAction {
  const PermittedAction();
}

class PermissionsRequested extends PermittedAction {
  const PermissionsRequested({
    required this.permissions,
  });

  final List<CallPermission> permissions;

  @override
  List<Object?> get props => [permissions];
}

class PermissionsGranted extends PermittedAction {
  const PermissionsGranted({
    required this.userId,
    this.permissions = const [],
  });

  final String userId;
  final List<CallPermission> permissions;

  @override
  List<Object?> get props => [userId, permissions];
}

class PermissionsRevoked extends PermittedAction {
  const PermissionsRevoked({
    required this.userId,
    this.permissions = const [],
  });

  final String userId;
  final List<CallPermission> permissions;

  @override
  List<Object?> get props => [userId, permissions];
}

class CallEnded extends PermittedAction {
  const CallEnded();
}

class UserBlocked extends PermittedAction {
  const UserBlocked({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class UserUnblocked extends PermittedAction {
  const UserUnblocked({
    required this.userId,
  });

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class UsersMuted extends PermittedAction {
  const UsersMuted({
    required this.userIds,
  });

  final List<String> userIds;

  @override
  List<Object?> get props => [userIds];
}

class RecordingStarted extends PermittedAction {
  const RecordingStarted();
}

class RecordingStopped extends PermittedAction {
  const RecordingStopped();
}

class BroadcastingStarted extends PermittedAction {
  const BroadcastingStarted();
}

class BroadcastingStopped extends PermittedAction {
  const BroadcastingStopped();
}
