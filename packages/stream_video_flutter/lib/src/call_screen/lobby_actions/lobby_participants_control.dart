import 'package:flutter/widgets.dart';

import '../../../stream_video_flutter.dart';

/// The lobby's participants control: [StreamParticipantsControl] over the
/// people already in the call.
///
/// Exists so a preset can list it without wiring anything up. Use
/// [StreamParticipantsControl] directly anywhere there is no
/// [StreamLobbyScope] — in a call, where an app usually wants `onTap` to open
/// a panel of its own rather than the built-in list.
class StreamLobbyParticipantsControl extends StatelessWidget {
  /// Creates a new instance of [StreamLobbyParticipantsControl].
  const StreamLobbyParticipantsControl({super.key, this.onTap});

  /// Called instead of opening the built-in list.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);

    return StreamParticipantsControl(
      onTap: onTap,
      participants: [
        for (final participant in controller.participants)
          UserInfo(
            id: participant.userId,
            name:
                controller.users[participant.userId]?.name ??
                participant.userId,
            image: controller.users[participant.userId]?.image,
          ),
      ],
    );
  }
}
