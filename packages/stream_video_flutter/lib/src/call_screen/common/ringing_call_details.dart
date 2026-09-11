import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';

/// Who is ringing and what the call is doing: an avatar over a name and a
/// status line.
///
/// Shared by the incoming and outgoing screens, which differ in what sits
/// behind it and in the colors [style] resolves to, not in the block itself.
class RingingCallDetails extends StatelessWidget {
  /// Creates a new instance of [RingingCallDetails].
  const RingingCallDetails({
    super.key,
    required this.participants,
    required this.status,
    required this.style,
    this.avatar,
    this.nameLine,
  });

  /// The people the call is ringing.
  final List<UserInfo> participants;

  /// The line under the name — what the call is doing right now.
  final String status;

  /// The resolved style of the screen this block sits on.
  final StreamRingingCallStyle style;

  /// Drawn in place of the avatar, when the host supplied one.
  final Widget? avatar;

  /// Drawn in place of the name, when the host supplied one.
  final Widget? nameLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: style.contentSpacing!,
      children: [
        avatar ?? _buildAvatar(),
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: style.titleSpacing!,
          children: [
            nameLine ??
                Text(
                  nameLineFor(context, participants),
                  style: style.titleTextStyle,
                  textAlign: TextAlign.center,
                ),
            Text(status, style: style.statusTextStyle, textAlign: .center),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    if (participants.length == 1) {
      return StreamAvatarTheme(
        data: style.avatarTheme!,
        child: StreamUserAvatar(user: participants.first),
      );
    }

    // The group sizes and borders its own children, so they are handed over
    // bare rather than under the single avatar's theme.
    return StreamAvatarGroup(
      size: style.avatarGroupSize,
      children: [
        for (final participant in participants)
          StreamUserAvatar(user: participant),
      ],
    );
  }

  /// The one line naming everyone [participants] is ringing.
  ///
  /// Past two people it names two and counts the rest: the block is centred on
  /// one line, and a third name pushes it past the screen on all but the
  /// shortest of names.
  static String nameLineFor(
    BuildContext context,
    List<UserInfo> participants,
  ) {
    final translations = context.translations;
    final names = participants.map((it) => it.name).toList();

    return switch (names.length) {
      0 => translations.ringingNobody,
      1 => names.first,
      2 => translations.ringingTwoCallers(names[0], names[1]),
      _ => translations.ringingManyCallers(
        names[0],
        names[1],
        names.length - 2,
      ),
    };
  }
}
