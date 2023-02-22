import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'invite_user_list_controller.dart';

/// Builder function used to build an invitable user view.
typedef InvitableUserViewBuilder = Widget Function(
  BuildContext context,
  StreamInviteUserListController controller,
  int index,
);

/// Builder function used to build a separator widget.
typedef SeparatorWidgetBuilder = Widget Function(
  BuildContext context,
  int index,
);

/// Displays invitable users.
class StreamInviteUserListView extends StatefulWidget {
  /// Creates a new instance of [StreamInviteUserListView].
  const StreamInviteUserListView({
    super.key,
    required this.controller,
    this.selectedIcon = Icons.check,
    this.invitableUserViewBuilder,
    this.separatorWidgetBuilder,
    this.inviteDividerColor,
    this.inviteDividerIndent,
    this.inviteDividerHeight,
    this.inviteUsernameTextStyle,
    this.inviteSelectedIconColor,
    this.inviteUserAvatarTheme,
  });

  /// Controller used to control the list of users.
  final StreamInviteUserListController controller;

  /// Icon for selected user.
  final IconData selectedIcon;

  /// {@macro invitableUserViewBuilder}
  final InvitableUserViewBuilder? invitableUserViewBuilder;

  /// {@macro separatorWidgetBuilder}
  final SeparatorWidgetBuilder? separatorWidgetBuilder;

  final Color? inviteDividerColor;

  /// List divider indent.
  final double? inviteDividerIndent;

  /// List divider height.
  final double? inviteDividerHeight;

  /// [TextStyle] for the user name.
  final TextStyle? inviteUsernameTextStyle;

  /// Color of the selected icon.
  final Color? inviteSelectedIconColor;

  /// Theme for the user avatar widget.
  final StreamUserAvatarThemeData? inviteUserAvatarTheme;

  @override
  State<StreamInviteUserListView> createState() =>
      _StreamInviteUserListViewState();
}

class _StreamInviteUserListViewState extends State<StreamInviteUserListView> {
  StreamInviteUserListController get _controller => widget.controller;

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
    final theme = StreamCallParticipantsInfoMenuTheme.of(context);
    final inviteDividerColor =
        widget.inviteDividerColor ?? theme.inviteDividerColor;
    final inviteDividerIndent =
        widget.inviteDividerIndent ?? theme.inviteDividerIndent;
    final inviteDividerHeight =
        widget.inviteDividerHeight ?? theme.inviteDividerHeight;
    final inviteUsernameTextStyle =
        widget.inviteUsernameTextStyle ?? theme.inviteUsernameTextStyle;
    final inviteSelectedIconColor =
        widget.inviteSelectedIconColor ?? theme.inviteSelectedIconColor;
    final inviteUserAvatarTheme =
        widget.inviteUserAvatarTheme ?? theme.inviteUserAvatarTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Participants'),
        actions: [
          InviteButton(
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
                  inviteUsernameTextStyle: inviteUsernameTextStyle,
                  inviteSelectedIconColor: inviteSelectedIconColor,
                  inviteUserAvatarTheme: inviteUserAvatarTheme,
                );
              },
              separatorBuilder: (context, index) =>
                  widget.separatorWidgetBuilder?.call(context, index) ??
                  Divider(
                    indent: inviteDividerIndent,
                    height: inviteDividerHeight,
                    color: inviteDividerColor,
                  ),
              itemCount: widget.controller.userCount,
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays invite button.
class InviteButton extends StatelessWidget {
  /// Creates a new instance of [InviteButton].
  const InviteButton({
    super.key,
    required this.controller,
    this.icon = Icons.group_add,
  });

  /// Controller used to control the list of users.
  final StreamInviteUserListController controller;

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

/// Displays invitable user.
class InviteUserItem extends StatelessWidget {
  /// Creates a new instance of [InviteUserItem].
  const InviteUserItem({
    super.key,
    required this.user,
    required this.selected,
    required this.selectedIcon,
    this.onInvitableUserTap,
    this.inviteUsernameTextStyle,
    this.inviteSelectedIconColor,
    this.inviteUserAvatarTheme,
  });

  /// Represents invitable user.
  final UserInfo user;

  /// Whether the [user] is selected.
  final bool selected;

  /// Icon for the selected user.
  final IconData selectedIcon;

  /// The action to perform when a user is tapped.
  final ValueChanged<UserInfo>? onInvitableUserTap;

  /// [TextStyle] for the user name.
  final TextStyle? inviteUsernameTextStyle;

  /// Color of the selected icon.
  final Color? inviteSelectedIconColor;

  /// Theme for the user avatar widget.
  final StreamUserAvatarThemeData? inviteUserAvatarTheme;

  @override
  Widget build(BuildContext context) {
    final theme = StreamCallParticipantsInfoMenuTheme.of(context);
    final inviteUsernameTextStyle =
        this.inviteUsernameTextStyle ?? theme.inviteUsernameTextStyle;
    final inviteSelectedIconColor =
        this.inviteSelectedIconColor ?? theme.inviteSelectedIconColor;
    final inviteUserAvatarTheme =
        this.inviteUserAvatarTheme ?? theme.inviteUserAvatarTheme;

    return InkWell(
      onTap: () => onInvitableUserTap?.call(user),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            StreamUserAvatarTheme(
              data: inviteUserAvatarTheme,
              child: StreamUserAvatar(
                user: user,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  user.name,
                  style: inviteUsernameTextStyle,
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
                  color: inviteSelectedIconColor,
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
