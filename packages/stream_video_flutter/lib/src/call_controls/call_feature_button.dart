import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'call_button_badge.dart';

/// The colour a [CallFeatureButton] takes while it is on.
///
/// Only while it is on: an unselected feature is the same secondary grey
/// whatever its tone, so a row of features reads as one row until something is
/// switched on.
enum CallFeatureTone {
  /// The resting tone. Screen sharing, closed captions, picture in picture,
  /// and the members and chat panels.
  accent,

  /// A feature whose being on is consequential in itself, rather than merely
  /// active. Recording, which is capturing the call.
  destructive,
}

/// A round icon button for a call feature that is off by default and prominent
/// while it is on: screen sharing, closed captions, recording, and the members
/// and chat panels.
///
/// Selected paints the accent colour, which is what separates a feature from a
/// [CallControlButton]: a muted microphone is destructive red because the user
/// has taken something away, while a live screen share is accent blue because
/// they have added something. A feature whose being on is itself consequential
/// takes [CallFeatureTone.destructive] and paints red while it is on.
///
/// {@tool snippet}
///
/// ```dart
/// CallFeatureButton(
///   icon: Icon(context.streamIcons.presentDesktopFill),
///   selected: isScreenSharing,
///   onPressed: toggleScreenShare,
/// )
/// ```
/// {@end-tool}
class CallFeatureButton extends StatelessWidget {
  /// Creates a new instance of [CallFeatureButton].
  const CallFeatureButton({
    super.key,
    required this.icon,
    this.selected = false,
    this.tone = .accent,
    this.showErrorBadge = false,
    this.onPressed,
    this.tooltip,
  });

  /// The icon of the button.
  final Widget icon;

  /// Whether the feature this button controls is currently on.
  final bool selected;

  /// The colour to paint while [selected]. Ignored while it is false.
  final CallFeatureTone tone;

  /// Whether to draw an error badge on the button's top-end corner.
  ///
  /// Marks a feature that needs attention — a screen share the platform
  /// refused, say. A feature that merely cannot be used right now takes a null
  /// [onPressed] instead.
  final bool showErrorBadge;

  /// The callback to invoke when the user taps on the button.
  ///
  /// Null renders the button disabled.
  final VoidCallback? onPressed;

  /// The message shown when the button is long-pressed or hovered.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return CallButtonBadge(
      showErrorBadge: showErrorBadge,
      child: StreamButton.icon(
        icon: icon,
        onPressed: onPressed,
        tooltip: tooltip,
        style: switch ((selected, tone)) {
          (false, _) => .secondary,
          (true, .accent) => .primary,
          (true, .destructive) => .destructive,
        },
      ),
    );
  }
}
