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

    final button = CallControlButton(
      icon: Icon(context.streamIcons.usersFill),
      tooltip: translations.lobbyParticipants,
      onPressed: participants.isEmpty
          ? null
          : () => _showParticipants(context, controller),
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
  }

  void _showParticipants(
    BuildContext context,
    StreamLobbyController controller,
  ) {
    showStreamSheet<void>(
      context: context,
      builder: (context, scrollController) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamSheetHeader(
            title: Text(context.translations.lobbyParticipants),
          ),
          Flexible(
            child: ListView(
              controller: scrollController,
              shrinkWrap: true,
              children: [
                for (final participant in controller.participants)
                  Builder(
                    builder: (context) {
                      final user = controller.users[participant.userId];
                      // Matches the inset the device sheets use, so rows in
                      // the two line up and a highlight never runs into the
                      // sheet's edges.
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.streamSpacing.xxs,
                        ),
                        child: StreamListTile(
                          leading: StreamUserAvatar(
                            user: UserInfo(
                              id: participant.userId,
                              name: user?.name ?? participant.userId,
                              image: user?.image,
                            ),
                          ),
                          title: Text(user?.name ?? participant.userId),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
