import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'call_button_badge.dart';

/// A round icon button for a call feature that is off by default and prominent
/// while it is on: screen sharing, closed captions, recording, and the members
/// and chat panels.
///
/// Selected paints the accent colour, which is what separates a feature from a
/// [CallControlButton]: a muted microphone is destructive red because the user
/// has taken something away, while a live screen share is accent blue because
/// they have added something.
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
    this.showErrorBadge = false,
    this.onPressed,
    this.tooltip,
  });

  /// The icon of the button.
  final Widget icon;

  /// Whether the feature this button controls is currently on.
  final bool selected;

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
        style: selected ? .primary : .secondary,
      ),
    );
  }
}
