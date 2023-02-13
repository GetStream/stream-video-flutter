import '../../stream_video_flutter.dart';
import '../participants_info/invite_user_list_controller.dart';

/// Represents state for [StreamInviteUserListController].
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
