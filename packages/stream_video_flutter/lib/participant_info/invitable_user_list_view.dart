import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/participant_info/invitable_user_view.dart';
import 'package:stream_video_flutter/participant_info/invitable_user_list_controller.dart';
import 'package:stream_video_flutter/theme/stream_invitable_user_list_theme.dart';
import 'package:stream_video_flutter/participant_info/users_provider.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'call_participant_info_view.dart';

/// {@template invitableUserViewBuilder}
/// Builder function used to build an invitable user view.
/// {@endtemplate}
typedef InvitableUserViewBuilder = Widget Function(BuildContext context,
    StreamInvitableUserListController controller, int index);

/// {@template separatorWidgetBuilder}
/// Builder function used to build a separator widget.
/// {@endtemplate}
typedef SeparatorWidgetBuilder = Widget Function(
    BuildContext context, int index);

/// {@template streamInvitableUserListView}
/// Displays invitable users.
/// {@endtemplate}
class StreamInvitableUserListView extends StatelessWidget {
  /// {@macro streamInvitableUserListView}
  const StreamInvitableUserListView(
      {super.key,
      required this.controller,
      this.selectedIcon = Icons.check,
      this.invitableUserListTheme,
      this.invitableUserViewBuilder,
      this.separatorWidgetBuilder});

  /// Controller used to control the list of users.
  final StreamInvitableUserListController controller;

  /// Icon for selected user.
  final IconData selectedIcon;

  /// Theme for the invitable user list.
  final StreamInvitableUserListTheme? invitableUserListTheme;

  /// {@macro invitableUserViewBuilder}
  final InvitableUserViewBuilder? invitableUserViewBuilder;

  /// {@macro separatorWidgetBuilder}
  final SeparatorWidgetBuilder? separatorWidgetBuilder;

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamVideoTheme.of(context);
    final invitableUserListTheme =
        this.invitableUserListTheme ?? streamChatTheme.invitableUserListTheme;
    return Column(
      children: [
        Expanded(
            child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                itemBuilder: (context, index) {
                  return invitableUserViewBuilder?.call(
                          context, controller, index) ??
                      StreamInvitableUserView(
                        user: controller.getUser(index),
                        selected: controller.isSelected(index),
                        onInvitableUserTap: (user) {
                          controller.toggleSelection(user);
                        },
                        selectedIcon: selectedIcon,
                      );
                },
                separatorBuilder: (context, index) =>
                    separatorWidgetBuilder?.call(context, index) ??
                    Divider(
                      indent: invitableUserListTheme.dividerIndent,
                      height: invitableUserListTheme.dividerHeight,
                      color: invitableUserListTheme.dividerColor,
                    ),
                itemCount: controller.userCount)),
      ],
    );
  }
}

/// {@template streamInviteButton}
/// Displays invite button.
/// {@endtemplate}
class StreamInviteButton extends StatelessWidget {
  /// {@macro streamInviteButton}
  const StreamInviteButton(
      {super.key, required this.controller, this.icon = Icons.group_add});

  /// Controller used to control the list of users.
  final StreamInvitableUserListController controller;

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
            icon: Icon(icon)));
  }
}
