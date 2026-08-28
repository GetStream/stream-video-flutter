import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// The participant tile this app registers on the component factory.
///
/// Adds an overflow menu to every tile in the app at once — the grid, the
/// spotlight strip and the screen-share filmstrip — which is what registering a
/// component rather than passing actions at a call site buys.
class DogfoodingParticipantTile extends StatelessWidget {
  /// Creates the app's participant tile.
  const DogfoodingParticipantTile({super.key, required this.props});

  /// The properties the SDK built this tile with.
  final StreamParticipantTileProps props;

  @override
  Widget build(BuildContext context) {
    // Decorate rather than clobber: a call site that supplied its own actions
    // asked for something more specific than an app-wide default.
    if (props.actions != null || props.actionsBuilder != null) {
      return DefaultStreamParticipantTile(props: props);
    }

    return DefaultStreamParticipantTile(
      props: props.copyWith(actionsBuilder: _actionsFor),
    );
  }

  /// The overflow menu offered on a participant's tile.
  ///
  /// Rebuilt for each participant on every build, so it reflects whether they
  /// are pinned or muted right now.
  List<StreamParticipantTileAction> _actionsFor(
    BuildContext context,
    CallParticipantState participant,
  ) {
    final call = props.call;
    final icons = context.streamIcons;

    return [
      StreamParticipantTileAction(
        icon: participant.isPinned ? icons.unpin : icons.pin,
        label: participant.isPinned ? 'Unpin' : 'Pin',
        onPressed: () => call.setParticipantPinnedLocally(
          sessionId: participant.sessionId,
          userId: participant.userId,
          pinned: !participant.isPinned,
        ),
      ),
      // Muting someone else is a moderation action, so it is only offered to a
      // user the call has granted it to. Muting yourself is what the call
      // controls are for.
      if (!participant.isLocal && call.hasPermission(CallPermission.muteUsers))
        StreamParticipantTileAction(
          icon: icons.voiceOffFill,
          label: 'Mute',
          // Listed but unselectable once they are muted, so the menu keeps its
          // shape as people talk.
          enabled: participant.isAudioEnabled,
          onPressed: () =>
              unawaited(call.muteUsers(userIds: [participant.userId])),
        ),
    ];
  }
}
