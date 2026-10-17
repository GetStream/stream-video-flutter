import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_core_flutter/core.dart';

/// The surface of a modal: an elevation-1 card with `radius.xl` corners,
/// centered in the window and kept `spacing.xxl` away from its edges.
///
/// Shared by `StreamModalDialog` and `StreamModalWindow`. Deliberately not
/// exported.
@internal
class StreamModalSurface extends StatelessWidget {
  /// Creates a modal surface.
  const StreamModalSurface({
    super.key,
    required this.constraints,
    this.backgroundColor,
    required this.child,
  });

  /// The bounds of the surface.
  final BoxConstraints constraints;

  /// The color of the surface.
  ///
  /// Defaults to `colorScheme.backgroundElevation1`.
  final Color? backgroundColor;

  /// The surface's content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:
          backgroundColor ?? context.streamColorScheme.backgroundElevation1,
      surfaceTintColor: Colors.transparent,
      elevation: context.streamElevation.level4,
      clipBehavior: Clip.antiAlias,
      insetPadding: EdgeInsets.all(context.streamSpacing.xxl),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(context.streamRadius.xl),
      ),
      child: ConstrainedBox(constraints: constraints, child: child),
    );
  }
}

/// The header of a modal: a one-line title at the leading edge and a row of
/// actions at the trailing edge.
///
/// Mirrors the `Web / Modal Dialog Header` component from the design. Shared
/// by `StreamModalDialog` and `StreamModalWindow`. Deliberately not exported.
@internal
class StreamModalHeader extends StatelessWidget {
  /// Creates a modal header.
  const StreamModalHeader({
    super.key,
    required this.title,
    required this.actions,
  });

  /// The title, drawn in `headingSm` and read out as a heading.
  final Widget? title;

  /// The buttons at the trailing edge.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return Padding(
      padding: EdgeInsets.all(spacing.xl),
      child: Row(
        spacing: spacing.md,
        children: [
          Expanded(
            child: DefaultTextStyle.merge(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.streamTextTheme.headingSm.copyWith(
                color: context.streamColorScheme.textPrimary,
              ),
              child: title == null
                  ? const SizedBox.shrink()
                  : Semantics(header: true, child: title),
            ),
          ),
          if (actions.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: spacing.xs,
              children: actions,
            ),
        ],
      ),
    );
  }
}

/// The close button of a modal's header.
///
/// Shared by `StreamModalDialog` and `StreamModalWindow`. Deliberately not
/// exported.
@internal
class StreamModalCloseButton extends StatelessWidget {
  /// Creates a close button.
  const StreamModalCloseButton({super.key, this.onPressed});

  /// Called when the button is pressed.
  ///
  /// Defaults to popping the modal with no value.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return StreamButton.icon(
      icon: Icon(context.streamIcons.xmark),
      style: StreamButtonStyle.secondary,
      type: StreamButtonType.ghost,
      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
    );
  }
}
