// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'floating_participant_tile_defaults.dart';

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
    @Deprecated(
      'The self-view sizes its avatar from StreamAvatarTheme, and the '
      'placeholder from StreamParticipantTileStyle.placeholderStyle. This '
      'parameter has no effect. Will be removed in the next major version.',
    )
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
  @Deprecated(
    'The self-view sizes its avatar from StreamAvatarTheme, and the placeholder '
    'from StreamParticipantTileStyle.placeholderStyle. This parameter has no '
    'effect. Will be removed in the next major version.',
  )
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
    final defaults = StreamFloatingParticipantTileStyleDefaults(context);

    // The deprecated parameters win where they are given, so existing call
    // sites keep positioning the self-view the way they always did.
    final style = StreamFloatingParticipantTileStyle(
      size: (localVideoWidth != null || localVideoHeight != null)
          ? Size(
              localVideoWidth ?? defaults.size.width,
              localVideoHeight ?? defaults.size.height,
            )
          : null,
      padding: localVideoPadding,
      borderRadius: borderRadius,
      initialAlignment: initialAlignment,
      enableSnapping: enableSnappingBehavior,
      shadowColor: shadowColor,
    );

    final resolved = floatingStyle?.merge(style) ?? style;
    final size = resolved.size ?? defaults.size;

    return FloatingViewContainer(
      floatingViewWidth: size.width,
      floatingViewHeight: size.height,
      floatingViewPadding: resolved.padding ?? defaults.padding,
      enableSnappingBehavior:
          resolved.enableSnapping ?? defaults.enableSnapping,
      floatingViewAlignment:
          resolved.initialAlignment ?? defaults.initialAlignment,
      floatingView: StreamFloatingParticipantTile(
        call: call,
        participant: participant,
        style: style,
        participantBuilder: participantBuilder,
      ),
      child: child,
    );
  }
}
