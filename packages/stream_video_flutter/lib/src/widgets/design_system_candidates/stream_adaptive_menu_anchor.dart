import 'package:flutter/material.dart';
import 'package:stream_core_flutter/core.dart';

import 'stream_context_menu_anchor.dart';
import 'stream_context_menu_heading.dart';
import 'stream_radio_indicator.dart';

/// Which way a menu is expected to open from its anchor.
///
/// The anchored menu flips itself when there is no room, so this is about what
/// the anchor should *say* — which way its caret points — rather than where the
/// menu ends up. A control bar along the bottom of a call opens upwards; a
/// field in a form opens down.
enum StreamMenuDirection {
  /// Below the anchor. The default, and what a field in a form does.
  down,

  /// Above the anchor, as a control bar along the bottom of the screen does.
  up,
}

/// One row inside a [StreamMenuSection].
///
/// A row is a choice when [selected] is set and pickable when [onSelected] is:
/// a device menu sets both, a list that only shows something — the people
/// already in a call, say — sets neither.
@immutable
class StreamMenuOption {
  /// Creates a menu option.
  const StreamMenuOption({
    required this.label,
    this.leading,
    this.selected,
    this.onSelected,
  });

  /// The text of the row.
  final String label;

  /// Drawn before the label.
  ///
  /// Defaults to a radio indicator when [selected] is set, and to nothing
  /// otherwise.
  final Widget? leading;

  /// Whether this is the option currently in effect.
  ///
  /// Null where the section is not a choice, which also drops the radio
  /// indicator the rows would otherwise carry.
  final bool? selected;

  /// Called when the user picks this option.
  ///
  /// The menu closes itself first, so this does not have to. Null renders the
  /// row as something to read rather than something to press.
  final VoidCallback? onSelected;
}

/// A group of [StreamMenuOption]s, optionally under a [heading].
@immutable
class StreamMenuSection {
  /// Creates a menu section.
  const StreamMenuSection({required this.options, this.heading});

  /// The label above the group, e.g. "Microphone".
  ///
  /// Null draws no heading, which is what a menu of one unlabelled group
  /// wants.
  final String? heading;

  /// The rows in the group.
  final List<StreamMenuOption> options;
}

/// Whether a menu built from these sections has anything to offer.
///
/// A caret or a field with nothing to open is disabled rather than opening an
/// empty popup, so every caller needs this.
extension StreamMenuSectionsX on Iterable<StreamMenuSection> {
  /// True when no section has a row in it.
  bool get hasNoOptions => every((section) => section.options.isEmpty);
}

/// Opens and closes the menu a [StreamAdaptiveMenuAnchor] hosts.
///
/// Handed to the anchor's builder so the same builder drives both
/// presentations without knowing which one it got.
abstract interface class StreamMenuHandle {
  /// Whether the menu is currently showing.
  bool get isOpen;

  /// Shows the menu.
  void open();

  /// Hides the menu.
  void close();

  /// Shows the menu if it is hidden, hides it if it is showing.
  void toggle();
}

/// Builds the widget a [StreamAdaptiveMenuAnchor] hangs its menu off.
typedef StreamAdaptiveMenuAnchorBuilder =
    Widget Function(BuildContext context, StreamMenuHandle handle);

/// Presents [sections] as an anchored context menu on desktop and web, and as
/// a bottom sheet on Android and iOS.
///
/// A popup pinned to a 32px caret is awkward to hit with a thumb and out of
/// place next to the rest of a phone's chrome, so the presentation follows the
/// platform rather than the call site: nothing that uses this has to branch.
///
/// {@tool snippet}
///
/// ```dart
/// StreamAdaptiveMenuAnchor(
///   title: 'Microphone',
///   sections: [
///     StreamMenuSection(
///       heading: 'Microphone',
///       options: [
///         for (final device in devices)
///           StreamMenuOption(
///             label: device.label,
///             selected: device == selected,
///             onSelected: () => select(device),
///           ),
///       ],
///     ),
///   ],
///   builder: (context, handle) => IconButton(
///     onPressed: handle.toggle,
///     icon: Icon(context.streamIcons.caretDown),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// This is a design-system candidate: it lives in this SDK until the
/// component is finalized and can graduate to stream_core_flutter.
class StreamAdaptiveMenuAnchor extends StatefulWidget {
  /// Creates an adaptive menu anchor.
  const StreamAdaptiveMenuAnchor({
    super.key,
    required this.sections,
    required this.builder,
    this.title,
    this.useSheet,
    this.matchAnchorWidth = false,
    this.menuItemStyle,
    this.menuElevation,
    this.direction = StreamMenuDirection.down,
    this.alignmentOffset,
  });

  /// The groups of choices the menu offers.
  final List<StreamMenuSection> sections;

  /// Builds the widget the menu is anchored to.
  final StreamAdaptiveMenuAnchorBuilder builder;

  /// The sheet header's title.
  ///
  /// Only the sheet presentation shows it; the anchored menu relies on its
  /// section headings instead.
  final String? title;

  /// Forces one presentation instead of following the platform.
  ///
  /// Null — the default — picks the sheet on Android and iOS and the anchored
  /// menu everywhere else.
  final bool? useSheet;

  /// Whether the anchored menu should be exactly as wide as its anchor.
  ///
  /// Off by default, because a menu is normally as wide as its content: a
  /// popup hanging off a 32px caret should not be 32px wide. Turn it on where
  /// the anchor is a full-width field and a narrower menu would look detached
  /// from it.
  ///
  /// Only has an effect when the anchor is given a bounded width, and nothing
  /// to do with the sheet presentation, which is always full width.
  final bool matchAnchorWidth;

  /// Overrides for the anchored menu's rows.
  ///
  /// The design's menu row is sized for a 16px icon beside a caption; a menu
  /// whose rows carry something bigger needs a taller one. The sheet's rows
  /// are `StreamListTile`s and are already sized for it, so this does not
  /// apply to them.
  final StreamContextMenuActionStyle? menuItemStyle;

  /// How high the anchored menu floats above the page.
  ///
  /// Null takes the value from `StreamContextMenuTheme`. Pass 0 for a menu
  /// separated from the page by its border alone. The sheet presentation has
  /// its own surface and ignores this.
  final double? menuElevation;

  /// Which way the menu is expected to open.
  ///
  /// Sets which side of the anchor [alignmentOffset] clears by default, and is
  /// what an anchor asks to point its caret the right way. The sheet
  /// presentation always comes up from the bottom and ignores it.
  final StreamMenuDirection direction;

  /// The offset of the anchored menu relative to its anchor.
  ///
  /// Null clears the anchor by 8 on whichever side [direction] names. Ignored
  /// by the sheet presentation.
  final Offset? alignmentOffset;

  @override
  State<StreamAdaptiveMenuAnchor> createState() =>
      _StreamAdaptiveMenuAnchorState();
}

class _StreamAdaptiveMenuAnchorState extends State<StreamAdaptiveMenuAnchor>
    implements StreamMenuHandle {
  final _menuController = MenuController();
  bool _isOpen = false;

  @override
  bool get isOpen => _isOpen;

  @override
  void toggle() => _isOpen ? close() : open();

  @override
  void open() {
    if (_useSheet) {
      _openSheet();
    } else {
      _menuController.open();
    }
  }

  @override
  void close() {
    // Guarded because the sheet branch closes by popping a route: called while
    // nothing is open it would pop whatever screen the anchor sits on.
    if (!_isOpen) return;

    if (_useSheet) {
      Navigator.of(context).pop();
    } else {
      _menuController.close();
    }
  }

  /// Whether this build should present a sheet.
  ///
  /// Read off the ambient theme rather than off a platform detector, so that a
  /// test — and an app deliberately emulating another platform — gets the
  /// presentation it asked for. It also does the right thing for a mobile
  /// browser, which reports a mobile target platform.
  bool get _useSheet =>
      widget.useSheet ??
      switch (Theme.of(context).platform) {
        TargetPlatform.android || TargetPlatform.iOS => true,
        _ => false,
      };

  void _select(StreamMenuOption option) {
    close();
    option.onSelected?.call();
  }

  /// What a row draws before its label: whatever it was given, or the radio
  /// indicator a choice implies.
  static Widget? _leadingOf(StreamMenuOption option) {
    if (option.leading case final leading?) return leading;
    if (option.selected case final selected?) {
      return StreamRadioIndicator(selected: selected);
    }
    return null;
  }

  Future<void> _openSheet() async {
    setState(() => _isOpen = true);
    await showStreamSheet<void>(
      context: context,
      isDismissible: true,
      builder: (context, scrollController) => _MenuSheet(
        title: widget.title,
        sections: widget.sections,
        scrollController: scrollController,
        onSelected: _select,
      ),
    );
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_useSheet) return widget.builder(context, this);
    if (!widget.matchAnchorWidth) return _anchored(context);

    // The anchor's own incoming constraints are the field's width. Measuring
    // here rather than inside the MenuAnchor's builder because the panel's
    // constraints are a property of the anchor widget, fixed before that
    // builder runs.
    return LayoutBuilder(
      builder: (context, constraints) => _anchored(
        context,
        width: constraints.hasBoundedWidth ? constraints.maxWidth : null,
      ),
    );
  }

  Widget _anchored(BuildContext context, {double? width}) {
    return StreamContextMenuAnchor(
      controller: _menuController,
      alignmentOffset:
          widget.alignmentOffset ??
          switch (widget.direction) {
            StreamMenuDirection.down => const Offset(0, 8),
            StreamMenuDirection.up => const Offset(0, -8),
          },
      actionStyle: widget.menuItemStyle,
      elevation: widget.menuElevation,
      // StreamContextMenu is an IntrinsicWidth, so a tight width overrides
      // what its content would otherwise ask for — including the 200px
      // minimum a menu row carries, which would otherwise overflow a field
      // narrower than that.
      constraints: switch (width) {
        final width? => StreamContextMenuAnchor.defaultConstraints.copyWith(
          minWidth: width,
          maxWidth: width,
        ),
        null => StreamContextMenuAnchor.defaultConstraints,
      },
      onOpen: () => setState(() => _isOpen = true),
      onClose: () {
        if (mounted) setState(() => _isOpen = false);
      },
      menuChildren: StreamContextMenuAction.sectioned(
        sections: [
          for (final section in widget.sections)
            [
              // A heading with no rows under it would label nothing.
              if (section.options.isNotEmpty)
                if (section.heading case final heading?)
                  StreamContextMenuHeading(label: Text(heading)),
              for (final option in section.options)
                StreamContextMenuAction<void>(
                  onTap: option.onSelected == null
                      ? null
                      : () => _select(option),
                  // Deliberately left enabled for a row with nothing to
                  // press. `enabled: false` is the design system's
                  // *unavailable* look — it paints the label in
                  // `textDisabled` — and a list that only shows something,
                  // like the people already in a call, would render every
                  // name as though that person were unavailable.
                  leading: _leadingOf(option),
                  label: Text(
                    option.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
        ],
      ),
      builder: (context, _, _) => widget.builder(context, this),
    );
  }
}

/// The sheet presentation of a [StreamAdaptiveMenuAnchor].
class _MenuSheet extends StatelessWidget {
  const _MenuSheet({
    required this.title,
    required this.sections,
    required this.scrollController,
    required this.onSelected,
  });

  final String? title;
  final List<StreamMenuSection> sections;
  final ScrollController scrollController;
  final ValueChanged<StreamMenuOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final title = this.title;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) StreamSheetHeader(title: Text(title)),
        Flexible(
          child: ListView(
            // The sheet hands this down so that dragging the list past its
            // top drags the sheet instead of overscrolling.
            controller: scrollController,
            shrinkWrap: true,
            children: [
              for (final section in sections) ...[
                // See the anchored rows: a heading needs rows under it.
                if (section.options.isNotEmpty)
                  if (section.heading case final heading?)
                    Padding(
                      // Everything in the sheet is inset by spacing.xxs so a
                      // selected row's rounded fill has room to breathe rather
                      // than running into the sheet's edges. A heading insets
                      // itself by spacing.xs and a list tile by spacing.sm, so the
                      // heading takes the larger outer pad and the two line up.
                      padding: EdgeInsets.symmetric(horizontal: spacing.xs),
                      child: StreamContextMenuHeading(label: Text(heading)),
                    ),
                for (final option in section.options)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacing.xxs),
                    child: StreamListTile(
                      leading: _StreamAdaptiveMenuAnchorState._leadingOf(
                        option,
                      ),
                      title: Text(
                        option.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      selected: option.selected ?? false,
                      // See the anchored rows: enabled is the look, not the
                      // interactivity. A null onTap already makes the row
                      // inert and gives it a non-interactive cursor.
                      onTap: option.onSelected == null
                          ? null
                          : () => onSelected(option),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
