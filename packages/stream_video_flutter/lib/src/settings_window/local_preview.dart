import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// A 16:9 preview of the local participant, as the settings tabs show it.
///
/// [width] fixes its width; without one it is as wide as it is allowed to be.
///
/// Shared by the settings tabs. Deliberately not exported.
@internal
class StreamSettingsLocalPreview extends StatelessWidget {
  /// Creates a local preview.
  const StreamSettingsLocalPreview({
    super.key,
    required this.call,
    this.width,
  });

  /// The call whose local participant is shown.
  final Call call;

  /// The width of the preview.
  final double? width;

  static CallParticipantState? _localParticipant(CallState state) =>
      state.localParticipant;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: PartialCallStateBuilder(
          call: call,
          selector: _localParticipant,
          builder: (context, participant) {
            if (participant == null) return const SizedBox.shrink();

            return StreamParticipantTile(
              call: call,
              participant: participant,
              // The call screen draws the same participant behind the window.
              rendererScopePrefix: 'settings-preview',
              // A preview, not a participant to act on.
              actions: const [],
            );
          },
        ),
      ),
    );
  }
}
