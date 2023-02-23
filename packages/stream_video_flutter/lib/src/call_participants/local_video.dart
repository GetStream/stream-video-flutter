import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../widgets/floating_view/floating_view_alignment.dart';

/// Represents a floating item used to feature a participant video.
class StreamLocalVideo extends StatelessWidget {
  /// Creates a new instance of [StreamLocalVideo].
  const StreamLocalVideo({
    super.key,
    required this.child,
    required this.call,
    required this.localParticipant,
    this.localVideoWidth,
    this.localVideoHeight,
    this.localVideoPadding,
    this.initialAlignment,
    this.enableSnappingBehavior,
    this.userAvatarTheme,
    this.borderRadius,
    this.shadowColor,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Represents a call.
  final Call call;

  /// The current local participant.
  final CallParticipantState localParticipant;

  /// The width of the floating view.
  final double? localVideoWidth;

  /// The height of the floating view.
  final double? localVideoHeight;

  /// The padding between floating view and the container.
  final double? localVideoPadding;

  /// The initial position of the floating view.
  final FloatingViewAlignment? initialAlignment;

  /// If the floating view should be automatically anchored to one of the
  /// corners.
  final bool? enableSnappingBehavior;

  /// The theme for the avatar.
  final StreamUserAvatarThemeData? userAvatarTheme;

  /// The border radius of the local video.
  final BorderRadius? borderRadius;

  /// The color of shadow.
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final theme = StreamLocalVideoTheme.of(context);
    final localVideoWidth = this.localVideoWidth ?? theme.localVideoWidth;
    final localVideoHeight = this.localVideoHeight ?? theme.localVideoHeight;
    final localVideoPadding = this.localVideoPadding ?? theme.localVideoPadding;
    final initialAlignment = this.initialAlignment ?? theme.initialAlignment;
    final enableSnappingBehavior =
        this.enableSnappingBehavior ?? theme.enableSnappingBehavior;
    final userAvatarTheme = this.userAvatarTheme ?? theme.userAvatarTheme;
    final borderRadius = this.borderRadius ?? theme.borderRadius;
    final shadowColor = this.shadowColor ?? theme.shadowColor;

    return FloatingViewContainer(
      floatingViewWidth: localVideoWidth,
      floatingViewHeight: localVideoHeight,
      floatingViewPadding: localVideoPadding,
      enableSnappingBehavior: enableSnappingBehavior,
      floatingViewAlignment: initialAlignment,
      floatingView: Container(
        width: localVideoWidth,
        height: localVideoHeight,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 4,
              spreadRadius: 2,
            )
          ],
        ),
        child: StreamCallParticipant(
          call: call,
          participant: localParticipant,
          borderRadius: borderRadius,
          userAvatarTheme: userAvatarTheme,
          showParticipantLabel: false,
          showDominantSpeakerBorder: false,
        ),
      ),
      child: child,
    );
  }
}
