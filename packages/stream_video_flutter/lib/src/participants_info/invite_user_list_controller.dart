import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../utils/extensions.dart';

/// A controller for an invitable user list.
///
/// This class lets you perform tasks such as:
/// * Load initial data using [doInitialLoad].
/// * Toggle users selection using [toggleSelection].
/// * Send users invite request using [inviteSelected].
/// * Provide user info using [getUser].
/// * Provide selection info using [isSelected] and [hasSelected].
/// * Provide user count info using [userCount].
class StreamInviteUserListController extends ValueNotifier<CallInviteState> {
  /// Creates a new instance of [StreamInviteUserListController].
  StreamInviteUserListController({
    required this.call,
    required this.usersProvider,
  }) : super(const CallInviteState(users: [], selectedUsers: {}));

  /// Represents a call.
  final Call call;

  /// Reference to [StreamUsersProvider].
  final StreamUsersProvider usersProvider;

  /// Performs initial data loading.
  Future<void> doInitialLoad() async {
    final users = await usersProvider.providerUsers();
    value = CallInviteState(users: users, selectedUsers: {});
  }

  /// Returns total number of users.
  int get userCount => value.users.length;

  /// Whether there is at least one selected user.
  bool get hasSelected => value.selectedUsers.isNotEmpty;

  /// Select/deselect specified [user] and notifies listeners.
  void toggleSelection(UserInfo user) {
    final selectedUsers = value.selectedUsers;
    if (selectedUsers.containsKey(user.id)) {
      selectedUsers.remove(user.id);
    } else {
      selectedUsers[user.id] = user;
    }
    notifyListeners();
  }

  /// Invites selected users to the [call] and notifies listeners.
  Future<void> inviteSelected() async {
    final users = value.users;
    final selectedUsers = value.selectedUsers;

    await call.addMembers(selectedUsers.values.toList());
    users.removeWhere((user) => selectedUsers.containsKey(user.id));
    selectedUsers.clear();
    notifyListeners();
  }

  /// Returns a user instance by given [index].
  ///
  /// Throws a [StateError] if no user found.
  UserInfo getUser(int index) {
    final user = value.users.at(index);
    if (user == null) throw StateError('No user found at index: $index');
    return user;
  }

  /// Checks whether a user behind a given [index] is selected.
  bool isSelected(int index) {
    final userId = value.users.at(index)?.id;
    if (userId == null) return false;
    return value.selectedUsers.containsKey(userId);
  }
}
