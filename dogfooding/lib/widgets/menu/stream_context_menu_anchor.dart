import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'stream_context_menu_heading.dart';

/// Anchors a [StreamContextMenu] to the widget built by [builder].
///
/// Wraps [MenuAnchor] with the plumbing every Stream-styled dropdown needs:
/// [MenuAnchor]'s own Material panel is neutralized (see [menuStyle]) so that
/// [StreamContextMenu] supplies the whole surface, the panel is bounded by
/// [constraints], and descendant [StreamContextMenuAction]s are sized and
/// styled like the `Web / Menu Item` component in the design.
///
/// [StreamContextMenu] sizes itself to its widest child, so labels that can be
/// arbitrarily long need [TextOverflow.ellipsis] to truncate rather than wrap.
///
/// This is a dogfooding-local component; it is meant to move into the SDK.
class StreamContextMenuAnchor extends StatelessWidget {
  /// Creates a menu anchor hosting a [StreamContextMenu].
  const StreamContextMenuAnchor({
    super.key,
    required this.menuChildren,
    required this.builder,
    this.controller,
    this.constraints = defaultConstraints,
    this.alignmentOffset = Offset.zero,
    this.onOpen,
    this.onClose,
  });

  /// The default bounds of the menu panel.
  ///
  /// The minimum width comes from the menu items themselves, which carry the
  /// design's 200px minimum.
  static const defaultConstraints = BoxConstraints(
    maxWidth: 320,
    maxHeight: 360,
  );

  /// A [MenuStyle] that hides [MenuAnchor]'s own Material panel.
  ///
  /// Use it on a plain [MenuAnchor] when the menu content already draws its
  /// own surface, as [StreamContextMenu] does: background, border, radius and
  /// elevation all come from the content instead.
  static const menuStyle = MenuStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
    shadowColor: WidgetStatePropertyAll(Colors.transparent),
    surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
    elevation: WidgetStatePropertyAll(0),
    padding: WidgetStatePropertyAll(EdgeInsets.zero),
  );

  /// The items of the menu, passed to [StreamContextMenu.children].
  ///
  /// Typically [StreamContextMenuAction]s, [StreamContextMenuSeparator]s and
  /// [StreamContextMenuHeading]s.
  final List<Widget> menuChildren;

  /// Builds the widget the menu is anchored to.
  final MenuAnchorChildBuilder builder;

  /// The controller opening and closing the menu.
  final MenuController? controller;

  /// The bounds of the menu panel.
  ///
  /// Defaults to [defaultConstraints].
  final BoxConstraints constraints;

  /// The offset of the menu relative to the anchor.
  final Offset alignmentOffset;

  /// Called when the menu opens.
  final VoidCallback? onOpen;

  /// Called when the menu closes.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;

    return MenuAnchor(
      controller: controller,
      alignmentOffset: alignmentOffset,
      onOpen: onOpen,
      onClose: onClose,
      style: menuStyle,
      builder: builder,
      menuChildren: [
        // Both MenuAnchor's panel and StreamContextMenu scroll vertically, and
        // on mobile they would both attach to the PrimaryScrollController,
        // which trips the panel's Scrollbar assertion. Keep the inner one out
        // of it; the panel is the one that should own the primary controller.
        PrimaryScrollController.none(
          child: ConstrainedBox(
            constraints: constraints,
            // The design's `Web / Menu Item` is a 32px tall row with a 200px
            // minimum width, a caption/emphasis label and 16px icons. The
            // stream_core_flutter defaults are a 40px tall row with a 242px
            // minimum width, a body/emphasis label and 20px icons.
            //
            // The row is inset by 8px on top of the 4px the menu panel already
            // pads with, which puts the content 12px from the panel edge and
            // leaves the row's rounded highlight 4px inside it, as designed.
            child: StreamContextMenuActionTheme(
              data: StreamContextMenuActionThemeData(
                style: StreamContextMenuActionStyle(
                  textStyle: WidgetStatePropertyAll(textTheme.captionEmphasis),
                  iconSize: const WidgetStatePropertyAll(16),
                  minimumSize: const WidgetStatePropertyAll(Size(200, 32)),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: spacing.xs),
                  ),
                ),
              ),
              child: StreamContextMenu(children: menuChildren),
            ),
          ),
        ),
      ],
    );
  }
}
