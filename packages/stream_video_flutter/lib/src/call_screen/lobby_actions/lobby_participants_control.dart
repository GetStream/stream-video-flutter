import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../../l10n/localization_extension.dart';

/// Shows how many people are already in the call, and opens the list of them.
///
/// The count sits on a green badge rather than the notification badge's red,
/// because people waiting is good news rather than something to fix.
class StreamLobbyParticipantsControl extends StatelessWidget {
  /// Creates a new instance of [StreamLobbyParticipantsControl].
  const StreamLobbyParticipantsControl({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);
    final colorScheme = context.streamColorScheme;
    final translations = context.translations;
    final participants = controller.participants;

    final spacing = context.streamSpacing;

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
                label:
                    controller.users[participant.userId]?.name ??
                    participant.userId,
                leading: StreamUserAvatar(
                  user: _userInfoFor(controller, participant),
                ),
              ),
          ],
        ),
      ],
      builder: (context, handle) {
        final button = CallControlButton(
          icon: Icon(context.streamIcons.usersFill),
          tooltip: translations.lobbyParticipants,
          onPressed: participants.isEmpty ? null : handle.toggle,
        );

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
      },
    );
  }

  UserInfo _userInfoFor(
    StreamLobbyController controller,
    CallParticipant participant,
  ) {
    final user = controller.users[participant.userId];
    return UserInfo(
      id: participant.userId,
      name: user?.name ?? participant.userId,
      image: user?.image,
    );
  }
}
