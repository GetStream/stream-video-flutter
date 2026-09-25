import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Overlays an error badge or a count on the top-end corner of a call button.
///
/// Shared by [CallControlButton] and [CallFeatureButton] so the badge sits in
/// the same place on both.
///
/// The error badge's styling resolves from [StreamCallButtonBadgeTheme],
/// falling back to the design system's defaults for a call control — see
/// [StreamCallButtonBadgeStyle]. The count is a [StreamBadgeNotification], and
/// takes its styling from [StreamBadgeNotificationTheme].
class StreamCallButtonBadge extends StatelessWidget {
  /// Creates a new instance of [StreamCallButtonBadge].
  const StreamCallButtonBadge({
    super.key,
    this.showErrorBadge = false,
    this.count,
    this.countType,
    required this.child,
    this.style,
  });

  /// Whether to draw the error badge.
  ///
  /// Takes the corner over [count] while it is true.
  final bool showErrorBadge;

  /// The number to show on the button, such as participants or unread
  /// messages.
  ///
  /// Null or zero draws no count.
  final int? count;

  /// The colour the count is drawn in.
  ///
  /// Null uses [StreamBadgeNotificationType.primary].
  final StreamBadgeNotificationType? countType;

  /// The button to badge.
  final Widget child;

  /// Overrides for the badge's styling.
  ///
  /// Takes precedence over [StreamCallButtonBadgeTheme] for the properties it
  /// sets; the rest still resolve from the theme.
  final StreamCallButtonBadgeStyle? style;

  @override
  Widget build(BuildContext context) {
    if (!showErrorBadge) {
      final count = this.count;
      if (count == null || count <= 0) return child;

      return StreamBadgeNotification(
        type: countType,
        label: '$count',
        child: child,
      );
    }

    const defaults = _StreamCallButtonBadgeStyleDefaults();
    final themeStyle = StreamCallButtonBadgeTheme.of(context).style;
    final effective = themeStyle?.merge(style) ?? style;

    final overhang = effective?.overhang ?? defaults.overhang;

    return Stack(
      // The badge deliberately overhangs the button's box, so the stack must
      // not clip it away.
      clipBehavior: Clip.none,
      children: [
        child,
        PositionedDirectional(
          top: -overhang,
          end: -overhang,
          child: StreamErrorBadge(
            size: effective?.size ?? defaults.size,
            style: effective?.badgeStyle ?? defaults.badgeStyle,
            showBorder: effective?.showBorder ?? defaults.showBorder,
          ),
        ),
      ],
    );
  }
}

// Default style values for [StreamCallButtonBadge].
//
// The badge sits on a call control, which is itself often over video, so the
// design system gives it the warning severity rather than the shared error one.
class _StreamCallButtonBadgeStyleDefaults extends StreamCallButtonBadgeStyle {
  const _StreamCallButtonBadgeStyleDefaults();

  @override
  StreamErrorBadgeStyle get badgeStyle => StreamErrorBadgeStyle.warning;

  @override
  StreamErrorBadgeSize get size => StreamErrorBadgeSize.sm;

  @override
  bool get showBorder => false;

  @override
  double get overhang => 4;
}
