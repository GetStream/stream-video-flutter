import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/participant_info/invitable_user_view.dart';
import 'package:stream_video_flutter/participant_info/model/call_invite_state.dart';
import 'package:stream_video_flutter/participant_info/users_provider.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_flutter/utils/extensions.dart';

import 'call_participant_info_view.dart';

class StreamInvitableUserListController extends ValueNotifier<CallInviteState> {
  StreamInvitableUserListController(
      {required this.call, required this.usersProvider})
      : super(CallInviteState(users: [], selectedUsers: {}));

  final Call call;
  final StreamUsersProvider usersProvider;

  Future<void> doInitialLoad() async {
    final users = await usersProvider.providerUsers();
    value = CallInviteState(users: users, selectedUsers: {});
  }

  int get userCount => value.users.length;

  bool get hasSelected => value.selectedUsers.isNotEmpty;

  void toggleSelection(UserInfo user) {
    final selectedUsers = value.selectedUsers;
    if (selectedUsers.containsKey(user.id)) {
      selectedUsers.remove(user.id);
    } else {
      selectedUsers[user.id] = user;
    }
    notifyListeners();
  }

  Future<void> inviteSelected() async {
    final users = value.users;
    final selectedUsers = value.selectedUsers;
    await call.inviteUsers(selectedUsers.values.toList());
    users.removeWhere((user) => selectedUsers.containsKey(user.id));
    selectedUsers.clear();
    notifyListeners();
  }

  UserInfo getUser(int index) {
    final user = value.users.at(index);
    if (user == null) throw StateError("No user found at index: $index");
    return user;
  }

  bool isSelected(int index) {
    final userId = value.users.at(index)?.id;
    if (userId == null) return false;
    return value.selectedUsers.containsKey(userId);
  }
}
