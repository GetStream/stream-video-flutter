import 'package:flutter/material.dart';
import 'package:stream_core_flutter/core.dart';

/// The heading of a section inside a [StreamContextMenu], e.g. "Microphone".
///
/// Mirrors the `Web / Menu Heading` component from the design: it shares the
/// row height and the horizontal inset of a menu item, but the label is
/// tertiary instead of primary and the row is not interactive.
///
/// This is a design-system candidate: it lives in this SDK until the
/// component is finalized and can graduate to stream_core_flutter.
class StreamContextMenuHeading extends StatelessWidget {
  /// Creates a context menu heading.
  const StreamContextMenuHeading({super.key, required this.label});

  /// The heading widget, typically a [Text].
  final Widget label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 200, minHeight: 32),
      // Matches the inset of a menu item: 8px on top of the 4px the menu
      // panel pads with.
      padding: EdgeInsets.symmetric(horizontal: spacing.xs),
      alignment: AlignmentDirectional.centerStart,
      child: DefaultTextStyle.merge(
        style: textTheme.captionEmphasis.copyWith(
          color: colorScheme.textTertiary,
        ),
        child: label,
      ),
    );
  }
}
