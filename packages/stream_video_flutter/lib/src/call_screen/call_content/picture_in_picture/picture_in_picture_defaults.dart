import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../stream_video_flutter.dart';
import '../../../call_participants/indicators/connection_quality_indicator_defaults.dart';

/// The participant tile style the picture-in-picture window draws with, before
/// [StreamPictureInPictureStyle.tileStyle] is merged over it.
///
/// Shared with the tests that assert what the window draws, so the shape they
/// check is the one it uses. Deliberately not exported.
@internal
StreamParticipantTileStyle pictureInPictureTileStyle(BuildContext context) {
  final radius = context.streamRadius;

  // The chrome sits in the corners of the window, so the corner each piece
  // occupies is square and only the inner one is rounded. Directional: the
  // toolbar puts the pill at the start and the indicator at the end, and which
  // corner each of those is comes out in the layout.
  final cornerRadius = radius.lg;

  return StreamParticipantTileStyle(
    // The window is rounded by the system, so a tile rounding itself as well
    // leaves the Material behind it showing in the corners. Which also rules
    // out an outline: it would be drawn square and then have its corners
    // clipped away by the window.
    borderRadius: BorderRadius.zero,
    border: const Border(),
    showSpeakerBorder: false,
    showMoreButton: false,
    // Flush into the window's own corners: at this size an inset costs more
    // video than it buys in breathing room.
    toolbarPadding: EdgeInsets.zero,
    labelStyle: StreamParticipantLabelStyle(
      showAudioIndicator: false,
      showVideoOffIcon: false,
      borderRadius: BorderRadiusDirectional.only(topEnd: cornerRadius),
    ),
    connectionQualityIndicatorStyle: StreamConnectionQualityIndicatorStyle(
      // Only the shape changes, so it is taken off the decoration the indicator
      // would have drawn — resolved the way the indicator resolves it — rather
      // than described again here, which would drop an app's own fill. A
      // rounded rectangle where the default is a circle, and BoxDecoration
      // allows a radius on neither shape but the rectangle.
      decoration: _indicatorDecoration(context).copyWith(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadiusDirectional.only(topStart: cornerRadius),
      ),
    ),
  );
}

/// The decoration the connection quality indicator would draw here.
BoxDecoration _indicatorDecoration(BuildContext context) {
  final style = StreamConnectionQualityIndicatorTheme.of(context).style;
  return style?.decoration ??
      StreamConnectionQualityIndicatorStyleDefaults(context).decoration;
}
