import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

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
    required this.style,
    this.cameraTrack,
    required this.child,
  });

  /// The resolved style of the screen.
  final StreamRingingCallStyle style;

  /// The camera to draw, or null to draw the fill alone.
  final RtcLocalCameraTrack? cameraTrack;

  /// The screen drawn on top.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final track = cameraTrack;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: style.backgroundColor!),
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
              sigmaX: style.blurSigma!,
              sigmaY: style.blurSigma!,
            ),
            child: ColoredBox(color: style.scrimColor!),
          ),
        ),
        child,
      ],
    );
  }
}
