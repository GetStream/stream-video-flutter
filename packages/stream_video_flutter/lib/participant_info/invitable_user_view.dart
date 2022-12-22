import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// {@template onInvitableUserTap}
/// The action to perform when the user is tapped.
/// {@endtemplate}
typedef OnInvitableUserTap = void Function(UserInfo);

class StreamInvitableUserView extends StatelessWidget {
  const StreamInvitableUserView(
      {super.key,
      required this.user,
      required this.selected,
      this.onInvitableUserTap});

  final UserInfo user;
  final bool selected;

  /// {@macro onInvitableUserTap}
  final OnInvitableUserTap? onInvitableUserTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onInvitableUserTap?.call(user),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamUserAvatar(
              user: user,
              avatarTheme: const StreamAvatarTheme(
                  initialsTextStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  constraints: BoxConstraints(
                    minHeight: 56,
                    minWidth: 56,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(32))),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  user.name,
                  style: const TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Visibility(
              visible: selected,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.check,
                  color: Colors.blue,
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
