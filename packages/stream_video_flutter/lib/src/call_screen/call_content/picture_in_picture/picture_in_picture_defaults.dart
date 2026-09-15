import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../stream_video_flutter.dart';

/// The participant tile style the picture-in-picture window draws with, before
/// [StreamPictureInPictureStyle.tileStyle] is merged over it.
///
/// Only what the window is rather than what its size implies: at the size
/// Android gives it the tile resolves [StreamParticipantTileChrome.compact],
/// which already anchors the chrome in the corners and leaves out the sound
/// indicator, the camera-off icon and the overflow button. This is what holds
/// whatever size the window comes in at.
///
/// Shared with the tests that assert what the window draws, so the shape they
/// check is the one it uses. Deliberately not exported.
@internal
StreamParticipantTileStyle pictureInPictureTileStyle(BuildContext context) {
  return const StreamParticipantTileStyle(
    // The window is rounded by the system, so a tile rounding itself as well
    // leaves the Material behind it showing in the corners. Which also rules
    // out an outline: it would be drawn square and then have its corners
    // clipped away by the window.
    borderRadius: BorderRadius.zero,
    border: Border(),
    showSpeakerBorder: false,
    // Nothing drawn in the window can be tapped: Android delivers taps to the
    // window rather than to what is in it.
    showMoreButton: false,
    // A window dragged large enough to resolve full would otherwise get these
    // back, and neither belongs in a glance at the call.
    labelStyle: StreamParticipantLabelStyle(
      showAudioIndicator: false,
      showVideoOffIcon: false,
    ),
  );
}
