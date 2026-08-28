import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Represents a floating item used to feature a participant video.
class StreamLocalVideo extends StatelessWidget {
  /// Creates a new instance of [StreamLocalVideo].
  const StreamLocalVideo({
    super.key,
    required this.child,
    required this.call,
    required this.participant,
    this.localVideoWidth,
    this.localVideoHeight,
    this.localVideoPadding,
    this.initialAlignment,
    this.enableSnappingBehavior,
    this.userAvatarTheme,
    this.borderRadius,
    this.shadowColor,
    this.participantBuilder,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Represents a call.
  final Call call;

  /// The current local participant.
  final CallParticipantState participant;

  /// The width of the local video view.
  final double? localVideoWidth;

  /// The height of the local video view.
  final double? localVideoHeight;

  /// The padding between local video view and the container.
  final double? localVideoPadding;

  /// The initial position of the local video view.
  final FloatingViewAlignment? initialAlignment;

  /// If the local video view should be automatically anchored to one of the
  /// corners.
  final bool? enableSnappingBehavior;

  /// The theme for the avatar.
  final StreamUserAvatarThemeData? userAvatarTheme;

  /// The border radius of the local video.
  final BorderRadius? borderRadius;

  /// The color of shadow.
  final Color? shadowColor;

  /// Builder function used to build the local participant.
  final CallParticipantBuilder? participantBuilder;

  @override
  Widget build(BuildContext context) {
    final floatingStyle = StreamFloatingParticipantTileTheme.of(context).style;
    final defaults = _floatingDefaults(context);

    // The deprecated parameters win where they are given, so existing call
    // sites keep positioning the self-view the way they always did.
    final style = StreamFloatingParticipantTileStyle(
      size: (localVideoWidth != null || localVideoHeight != null)
          ? Size(
              localVideoWidth ?? defaults.width,
              localVideoHeight ?? defaults.height,
            )
          : null,
      padding: localVideoPadding,
      borderRadius: borderRadius,
      initialAlignment: initialAlignment,
      enableSnapping: enableSnappingBehavior,
      shadowColor: shadowColor,
    );

    final resolved = floatingStyle?.merge(style) ?? style;
    final size = resolved.size ?? Size(defaults.width, defaults.height);

    return FloatingViewContainer(
      floatingViewWidth: size.width,
      floatingViewHeight: size.height,
      floatingViewPadding: resolved.padding ?? defaults.padding,
      enableSnappingBehavior: resolved.enableSnapping ?? true,
      floatingViewAlignment:
          resolved.initialAlignment ?? FloatingViewAlignment.topRight,
      floatingView: StreamFloatingParticipantTile(
        call: call,
        participant: participant,
        style: style,
        participantBuilder: participantBuilder,
      ),
      child: child,
    );
  }

  // Only the dimensions and inset are needed before the floating tile builds;
  // everything else it resolves for itself.
  ({double width, double height, double padding}) _floatingDefaults(
    BuildContext context,
  ) => (width: 140, height: 228, padding: context.streamSpacing.md);
}
