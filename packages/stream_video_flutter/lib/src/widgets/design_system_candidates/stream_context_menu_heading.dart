import 'package:flutter/material.dart';
import 'package:stream_core_flutter/core.dart';

/// The heading of a section inside a [StreamContextMenu], e.g. "Microphone".
///
/// Mirrors the `Web / Menu Heading` component from the design: it shares the
/// row height and the horizontal inset of a menu item, but the label is
/// tertiary instead of primary. It is not interactive unless given an [onTap],
/// as the heading of a section that collapses is.
///
/// This is a design-system candidate: it lives in this SDK until the
/// component is finalized and can graduate to stream_core_flutter.
class StreamContextMenuHeading extends StatelessWidget {
  /// Creates a context menu heading.
  const StreamContextMenuHeading({
    super.key,
    required this.label,
    this.trailing,
    this.onTap,
  });

  /// The heading widget, typically a [Text].
  final Widget label;

  /// Drawn at the far end of the row, typically the chevron of a section that
  /// collapses.
  final Widget? trailing;

  /// Called when the heading is pressed.
  ///
  /// Null leaves the row inert, which is what an ordinary heading wants.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    final heading = Container(
      constraints: const BoxConstraints(minWidth: 200, minHeight: 32),
      // Matches the inset of a menu item: 8px on top of the 4px the menu
      // panel pads with.
      padding: EdgeInsets.symmetric(horizontal: spacing.xs),
      alignment: AlignmentDirectional.centerStart,
      child: DefaultTextStyle.merge(
        style: textTheme.captionEmphasis.copyWith(
          color: colorScheme.textTertiary,
        ),
        child: switch (trailing) {
          // Row rather than the bare label so the trailing sits at the far
          // end of the heading, where a row's own trailing sits.
          final trailing? => Row(
            children: [
              Flexible(child: label),
              SizedBox(width: spacing.xxs),
              trailing,
            ],
          ),
          null => label,
        },
      ),
    );

    if (onTap == null) return heading;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: heading,
    );
  }
}
