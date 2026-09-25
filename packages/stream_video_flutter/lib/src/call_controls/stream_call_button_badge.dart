import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// A badge drawn on the top-end corner of a call button.
///
/// See also:
///
///  * [CallControlErrorBadge], which marks a control that cannot work right
///    now.
///  * [CallControlNotificationBadge], which shows a count.
sealed class CallControlBadge {
  const CallControlBadge();
}

/// Marks a call control that cannot work right now, such as a microphone whose
/// permission was refused.
///
/// Drawn as a [StreamErrorBadge], styled by [StreamCallButtonBadgeTheme].
final class CallControlErrorBadge extends CallControlBadge {
  /// Creates an error badge.
  const CallControlErrorBadge();

  @override
  bool operator ==(Object other) => other is CallControlErrorBadge;

  @override
  int get hashCode => (CallControlErrorBadge).hashCode;
}

/// Shows a count on a call button, such as the people in a call or unread
/// messages.
///
/// Drawn as a [StreamBadgeNotification], styled by
/// [StreamBadgeNotificationTheme]. A count of zero or less draws nothing.
final class CallControlNotificationBadge extends CallControlBadge {
  /// Creates a badge showing [count].
  const CallControlNotificationBadge({required this.count, this.type});

  /// The number to show.
  final int count;

  /// The colour the count is drawn in.
  ///
  /// Null uses [StreamBadgeNotificationType.primary].
  final StreamBadgeNotificationType? type;

  @override
  bool operator ==(Object other) =>
      other is CallControlNotificationBadge &&
      other.count == count &&
      other.type == type;

  @override
  int get hashCode => Object.hash(count, type);
}

/// Overlays a [CallControlBadge] on the top-end corner of a call button.
///
/// Shared by [CallControlButton] and [CallFeatureButton] so the badge sits in
/// the same place on both.
///
/// The error badge's styling resolves from [StreamCallButtonBadgeTheme],
/// falling back to the design system's defaults for a call control — see
/// [StreamCallButtonBadgeStyle]. The count takes its styling from
/// [StreamBadgeNotificationTheme].
class StreamCallButtonBadge extends StatelessWidget {
  /// Creates a new instance of [StreamCallButtonBadge].
  const StreamCallButtonBadge({
    super.key,
    this.badge,
    required this.child,
    this.style,
  });

  /// The badge to draw.
  ///
  /// Null draws none.
  final CallControlBadge? badge;

  /// The button to badge.
  final Widget child;

  /// Overrides for the error badge's styling.
  ///
  /// Takes precedence over [StreamCallButtonBadgeTheme] for the properties it
  /// sets; the rest still resolve from the theme.
  final StreamCallButtonBadgeStyle? style;

  @override
  Widget build(BuildContext context) {
    return switch (badge) {
      null => child,
      CallControlErrorBadge() => _buildError(context),
      CallControlNotificationBadge(:final count) when count <= 0 => child,
      CallControlNotificationBadge(:final count, :final type) =>
        StreamBadgeNotification(type: type, label: '$count', child: child),
    };
  }

  Widget _buildError(BuildContext context) {
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
