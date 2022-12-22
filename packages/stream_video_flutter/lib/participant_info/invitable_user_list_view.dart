import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/participant_info/invitable_user_view.dart';
import 'package:stream_video_flutter/participant_info/invitable_user_list_controller.dart';
import 'package:stream_video_flutter/participant_info/users_provider.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'call_participant_info_view.dart';

/// {@template invitableUserViewBuilder}
/// Builder function used to build a participant info view.
/// {@endtemplate}
typedef InvitableUserViewBuilder = Widget Function(BuildContext context,
    StreamInvitableUserListController controller, int index);

/// {@template separatorWidgetBuilder}
/// Builder function used to build a participant info view.
/// {@endtemplate}
typedef SeparatorWidgetBuilder = Widget Function(
    BuildContext context, int index);

class StreamInvitableUserListView extends StatelessWidget {
  const StreamInvitableUserListView(
      {super.key,
      required this.controller,
      this.invitableUserViewBuilder,
      this.separatorWidgetBuilder});

  final StreamInvitableUserListController controller;
  final InvitableUserViewBuilder? invitableUserViewBuilder;
  final SeparatorWidgetBuilder? separatorWidgetBuilder;

  @override
  Widget build(BuildContext context) {
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
                      );
                },
                separatorBuilder: (context, index) =>
                    separatorWidgetBuilder?.call(context, index) ??
                    const Divider(
                      indent: 16,
                      height: 0,
                      color: Colors.grey,
                    ),
                itemCount: controller.userCount)),
      ],
    );
  }
}

class StreamInviteButton extends StatelessWidget {
  const StreamInviteButton(
      {super.key, required this.controller, this.icon = Icons.group_add});

  final StreamInvitableUserListController controller;
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
