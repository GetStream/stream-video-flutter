import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Represents state for [StreamInvitableUserListController].
class CallInviteState {
  /// Creates a new instance of [CallInviteState].
  const CallInviteState({
    required this.users,
    required this.selectedUsers,
  });

  /// Users which can be invited.
  final List<UserInfo> users;

  /// Selected users to be invited.
  final Map<String, UserInfo> selectedUsers;
}
