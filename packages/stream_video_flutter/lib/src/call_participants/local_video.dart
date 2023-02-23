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
    this.enableSnappingBehavior,
    this.floatingParticipantWidth,
    this.floatingParticipantHeight,
    this.floatingParticipantPadding,
    this.floatingViewAlignment,
    this.userAvatarTheme,
    this.shadowColor,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Represents a call.
  final Call call;

  /// The current local participant.
  final CallParticipantState localParticipant;

  /// The width of the floating view.
  final double? floatingParticipantWidth;

  /// The height of the floating view.
  final double? floatingParticipantHeight;

  /// The padding between floating view and the container.
  final double? floatingParticipantPadding;

  /// The initial position of the floating view.
  final FloatingViewAlignment? floatingViewAlignment;

  /// If the floating view should be automatically anchored to one of the
  /// corners.
  final bool? enableSnappingBehavior;

  /// The theme for the avatar.
  final StreamUserAvatarThemeData? userAvatarTheme;

  /// The color of shadow.
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final theme = StreamLocalVideoTheme.of(context);
    final floatingParticipantWidth =
        this.floatingParticipantWidth ?? theme.floatingParticipantWidth;
    final floatingParticipantHeight =
        this.floatingParticipantHeight ?? theme.floatingParticipantHeight;
    final floatingParticipantPadding =
        this.floatingParticipantPadding ?? theme.floatingParticipantPadding;
    final floatingViewAlignment =
        this.floatingViewAlignment ?? theme.floatingViewAlignment;
    final enableSnappingBehavior =
        this.enableSnappingBehavior ?? theme.enableSnappingBehavior;
    final userAvatarTheme = this.userAvatarTheme ?? theme.userAvatarTheme;
    final shadowColor = this.shadowColor ?? theme.shadowColor;

    return FloatingViewContainer(
      floatingViewWidth: floatingParticipantWidth,
      floatingViewHeight: floatingParticipantHeight,
      floatingViewPadding: floatingParticipantPadding,
      enableSnappingBehavior: enableSnappingBehavior,
      floatingViewAlignment: floatingViewAlignment,
      floatingView: Container(
        height: floatingParticipantHeight,
        width: floatingParticipantWidth,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
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
          borderRadius: BorderRadius.circular(16),
          userAvatarTheme: userAvatarTheme,
        ),
      ),
      child: child,
    );
  }
}
