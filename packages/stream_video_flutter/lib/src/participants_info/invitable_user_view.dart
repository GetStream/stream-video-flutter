import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// {@template streamInvitableUserView}
/// Displays invitable user.
/// {@endtemplate}
class StreamInvitableUserView extends StatelessWidget {
  /// {@macro streamInvitableUserView}
  const StreamInvitableUserView({
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
