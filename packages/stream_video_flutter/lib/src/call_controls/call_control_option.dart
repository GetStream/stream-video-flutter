import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Widget that represents a call control option.
class CallControlOption extends StatelessWidget {
  /// Creates a new instance of [CallControlOption].
  const CallControlOption({
    super.key,
    required this.icon,
    this.state = .on,
    this.onPressed,
  });

  /// The icon of the call control option.
  final Widget icon;

  final CallControlState state;

  /// The callback to invoke when the user taps on the call control option.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return StreamButtonTheme(
      data: .new(
        primary: .new(
          solid: .new(
            backgroundColor: .all(
              context.streamColorScheme.accentSuccess,
            ),
          ),
        ),
      ),
      child: _MaybeBadged(
        showErrorBadge: state == .disabled,
        child: StreamButton.icon(
          icon: icon,
          onPressed: onPressed,
          style: switch (state) {
            .on => .secondary,
            .off => .destructive,
            .positive => .primary,
            .negative => .destructive,
            .disabled => .destructive,
          },
        ),
      ),
    );
  }
}

class _MaybeBadged extends StatelessWidget {
  const _MaybeBadged({required this.showErrorBadge, required this.child});

  final bool showErrorBadge;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!showErrorBadge) return child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        PositionedDirectional(
          top: -4,
          end: -4,
          child: StreamErrorBadge(size: StreamErrorBadgeSize.sm),
        ),
      ],
    );
  }
}

enum CallControlState {
  on,
  off,
  positive,
  negative,
  disabled,
}
