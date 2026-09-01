import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

/// Shows how many people are in the call, and opens the list of them.
///
/// The count sits on a green badge rather than the notification badge's red,
/// because people being there is good news rather than something to fix.
///
/// Tapping opens the list itself — an anchored menu on desktop, a bottom sheet
/// on Android and iOS. Pass [onTap] to do something else with the press: in a
/// call an app usually has a side panel of its own to open, with more in it
/// than names.
///
/// {@tool snippet}
///
/// ```dart
/// StreamParticipantsControl(
///   participants: participants,
///   onTap: () => openParticipantsPanel(),
/// )
/// ```
/// {@end-tool}
class StreamParticipantsControl extends StatelessWidget {
  /// Creates a new instance of [StreamParticipantsControl].
  const StreamParticipantsControl({
    super.key,
    required this.participants,
    this.onTap,
  });

  /// The people to count on the badge, and to list when [onTap] is null.
  final List<UserInfo> participants;

  /// Called instead of opening the built-in list.
  ///
  /// The control is disabled when this is null and there is nobody to list.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final translations = context.translations;
    final spacing = context.streamSpacing;

    Widget badged(Widget button) {
      if (participants.isEmpty) return button;

      return StreamBadgeNotificationTheme(
        data: StreamBadgeNotificationThemeData(
          primaryBackgroundColor: colorScheme.accentSuccess,
        ),
        child: StreamBadgeNotification(
          label: '${participants.length}',
          child: button,
        ),
      );
    }

    Widget button(VoidCallback? onPressed) => badged(
      CallControlButton(
        icon: Icon(context.streamIcons.usersFill),
        tooltip: translations.lobbyParticipants,
        onPressed: onPressed,
      ),
    );

    // Nothing to anchor a menu to when the press is the caller's to handle.
    if (onTap case final onTap?) return button(onTap);

    return StreamAdaptiveMenuAnchor(
      title: translations.lobbyParticipants,
      // The design's menu row is sized for a 16px icon; an avatar is 40, and
      // in a 40px row it touches both edges. These are the sheet's own
      // insets, so a name sits the same distance from the edge either way.
      menuItemStyle: StreamContextMenuActionStyle(
        minimumSize: const WidgetStatePropertyAll(Size(200, 56)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: spacing.sm),
        ),
      ),
      sections: [
        StreamMenuSection(
          // One unlabelled group: the sheet's header already names it, and an
          // anchored menu of names needs no heading over them.
          options: [
            for (final participant in participants)
              StreamMenuOption(
                label: participant.name,
                leading: StreamUserAvatar(user: participant),
              ),
          ],
        ),
      ],
      builder: (context, handle) =>
          button(participants.isEmpty ? null : handle.toggle),
    );
  }
}
