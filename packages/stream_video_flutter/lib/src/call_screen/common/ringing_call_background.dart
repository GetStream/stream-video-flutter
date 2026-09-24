import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import 'ringing_call_style_defaults.dart';

/// What an outgoing ringing screen is drawn on: the caller's own camera,
/// blurred and washed out so the call details stay legible on top of it.
///
/// Falls back to a plain fill whenever there is no camera to draw — it is off,
/// it has not opened yet, or it refused to open. That is the design's
/// camera-off state, not an error state.
class RingingCallBackground extends StatelessWidget {
  /// Creates a new instance of [RingingCallBackground].
  const RingingCallBackground({
    super.key,
    this.style,
    this.cameraTrack,
    required this.child,
  });

  /// Overrides for the fill, the scrim and the blur.
  ///
  /// Anything left null falls back to what the outgoing screen resolves, so a
  /// background built by hand does not have to name all three.
  final StreamRingingCallStyle? style;

  /// The camera to draw, or null to draw the fill alone.
  final RtcLocalCameraTrack? cameraTrack;

  /// The screen drawn on top.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = RingingCallStyleDefaults(context, this.style);
    final track = cameraTrack;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: style.backgroundColor),
        if (track != null)
          VideoTrackRenderer(
            videoTrack: track,
            mirror: track.mediaConstraints.facingMode == FacingMode.user,
          ),
        // Over the fill as well as over the camera: the scrim is what the
        // details' contrast is designed against, and dropping it when the
        // camera is off would leave them on a different background.
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: style.blurSigma,
              sigmaY: style.blurSigma,
            ),
            child: ColoredBox(color: style.scrimColor),
          ),
        ),
        child,
      ],
    );
  }
}
