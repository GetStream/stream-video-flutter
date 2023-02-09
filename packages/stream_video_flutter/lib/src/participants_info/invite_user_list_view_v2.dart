import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'invite_user_list_controller_v2.dart';

/// {@template invitableUserViewBuilder}
/// Builder function used to build an invitable user view.
/// {@endtemplate}
typedef InvitableUserViewBuilder = Widget Function(
  BuildContext context,
  StreamInviteUserListControllerV2 controller,
  int index,
);

/// {@template separatorWidgetBuilder}
/// Builder function used to build a separator widget.
/// {@endtemplate}
typedef SeparatorWidgetBuilder = Widget Function(
  BuildContext context,
  int index,
);

/// {@template streamInvitableUserListView}
/// Displays invitable users.
/// {@endtemplate}
class StreamInviteUserListViewV2 extends StatefulWidget {
  /// {@macro streamInvitableUserListView}
  const StreamInviteUserListViewV2({
    super.key,
    required this.controller,
    this.selectedIcon = Icons.check,
    this.invitableUserListTheme,
    this.invitableUserViewBuilder,
    this.separatorWidgetBuilder,
  });

  /// Controller used to control the list of users.
  final StreamInviteUserListControllerV2 controller;

  /// Icon for selected user.
  final IconData selectedIcon;

  /// Theme for the invitable user list.
  final StreamInvitableUserListTheme? invitableUserListTheme;

  /// {@macro invitableUserViewBuilder}
  final InvitableUserViewBuilder? invitableUserViewBuilder;

  /// {@macro separatorWidgetBuilder}
  final SeparatorWidgetBuilder? separatorWidgetBuilder;

  @override
  State<StreamInviteUserListViewV2> createState() =>
      _StreamInviteUserListViewStateV2();
}

class _StreamInviteUserListViewStateV2
    extends State<StreamInviteUserListViewV2> {
  StreamInviteUserListControllerV2 get _controller => widget.controller;

  @override
  void initState() {
    super.initState();

    _controller.doInitialLoad();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamVideoTheme.of(context);
    final invitableUserListTheme = this.widget.invitableUserListTheme ??
        streamChatTheme.invitableUserListTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Participants'),
        actions: [
          InviteButtonV2(
            controller: widget.controller,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16),
              itemBuilder: (context, index) {
                final builder = widget.invitableUserViewBuilder;
                if (builder != null) {
                  builder.call(context, widget.controller, index);
                }
                return InviteUserItem(
                  user: widget.controller.getUser(index),
                  selected: widget.controller.isSelected(index),
                  onInvitableUserTap: (user) {
                    widget.controller.toggleSelection(user);
                  },
                  selectedIcon: widget.selectedIcon,
                );
              },
              separatorBuilder: (context, index) =>
                  widget.separatorWidgetBuilder?.call(context, index) ??
                  Divider(
                    indent: invitableUserListTheme.dividerIndent,
                    height: invitableUserListTheme.dividerHeight,
                    color: invitableUserListTheme.dividerColor,
                  ),
              itemCount: widget.controller.userCount,
            ),
          ),
        ],
      ),
    );
  }
}

/// {@template streamInviteButton}
/// Displays invite button.
/// {@endtemplate}
class InviteButtonV2 extends StatelessWidget {
  /// {@macro streamInviteButton}
  const InviteButtonV2({
    super.key,
    required this.controller,
    this.icon = Icons.group_add,
  });

  /// Controller used to control the list of users.
  final StreamInviteUserListControllerV2 controller;

  /// Icon for this button.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.hasSelected,
      child: IconButton(
        onPressed: () async {
          await controller.inviteSelected();
        },
        icon: Icon(icon),
      ),
    );
  }
}

/// {@template streamInvitableUserView}
/// Displays invitable user.
/// {@endtemplate}
class InviteUserItem extends StatelessWidget {
  /// {@macro streamInvitableUserView}
  const InviteUserItem({
    super.key,
    required this.user,
    required this.selected,
    required this.selectedIcon,
    this.invitableUserTheme,
    this.onInvitableUserTap,
  });

  /// Represents invitable user.
  final UserInfo user;

  /// Whether the [user] is selected.
  final bool selected;

  /// Icon for the selected user.
  final IconData selectedIcon;

  /// Theme for the invitable user list.
  final StreamInvitableUserTheme? invitableUserTheme;

  /// The action to perform when a user is tapped.
  final ValueChanged<UserInfo>? onInvitableUserTap;

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamVideoTheme.of(context);
    final invitableUserTheme =
        this.invitableUserTheme ?? streamChatTheme.invitableUserTheme;
    final avatarTheme =
        invitableUserTheme.avatarTheme ?? streamChatTheme.avatarTheme;

    return InkWell(
      onTap: () => onInvitableUserTap?.call(user),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            StreamUserAvatar(
              user: user,
              avatarTheme: avatarTheme,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  user.name,
                  style: invitableUserTheme.usernameTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Visibility(
              visible: selected,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  selectedIcon,
                  color: invitableUserTheme.selectedIconColor,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
