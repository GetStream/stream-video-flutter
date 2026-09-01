import 'package:flutter/material.dart';
import 'package:stream_core_flutter/core.dart';

import 'stream_context_menu_anchor.dart';
import 'stream_context_menu_heading.dart';
import 'stream_radio_indicator.dart';

/// One choice inside a [StreamMenuSection].
@immutable
class StreamMenuOption {
  /// Creates a menu option.
  const StreamMenuOption({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  /// The text of the row.
  final String label;

  /// Whether this is the option currently in effect.
  final bool selected;

  /// Called when the user picks this option.
  ///
  /// The menu closes itself first, so this does not have to.
  final VoidCallback onSelected;
}

/// A group of mutually exclusive [StreamMenuOption]s under one [heading].
@immutable
class StreamMenuSection {
  /// Creates a menu section.
  const StreamMenuSection({required this.heading, required this.options});

  /// The label above the group, e.g. "Microphone".
  final String heading;

  /// The choices in the group. Exactly one is normally [
  /// StreamMenuOption.selected].
  final List<StreamMenuOption> options;
}

/// Opens and closes the menu a [StreamAdaptiveMenuAnchor] hosts.
///
/// Handed to the anchor's builder so the same builder drives both
/// presentations without knowing which one it got.
abstract class StreamMenuHandle {
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
///     icon: const Icon(Icons.expand_more),
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
    this.alignmentOffset = const Offset(0, 8),
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

  /// The offset of the anchored menu relative to its anchor.
  ///
  /// Ignored by the sheet presentation.
  final Offset alignmentOffset;

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
    option.onSelected();
  }

  Future<void> _openSheet() async {
    setState(() => _isOpen = true);
    await showStreamSheet<void>(
      context: context,
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

    return StreamContextMenuAnchor(
      controller: _menuController,
      alignmentOffset: widget.alignmentOffset,
      onOpen: () => setState(() => _isOpen = true),
      onClose: () {
        if (mounted) setState(() => _isOpen = false);
      },
      menuChildren: StreamContextMenuAction.sectioned(
        sections: [
          for (final section in widget.sections)
            [
              StreamContextMenuHeading(label: Text(section.heading)),
              for (final option in section.options)
                StreamContextMenuAction<void>(
                  onTap: () => _select(option),
                  leading: StreamRadioIndicator(selected: option.selected),
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
            padding: EdgeInsets.only(bottom: spacing.sm),
            children: [
              for (final section in sections) ...[
                Padding(
                  // A heading insets itself by spacing.xs, a list tile by
                  // spacing.sm; the difference lines their text up.
                  padding: EdgeInsets.symmetric(horizontal: spacing.xxs),
                  child: StreamContextMenuHeading(
                    label: Text(section.heading),
                  ),
                ),
                for (final option in section.options)
                  StreamListTile(
                    leading: StreamRadioIndicator(selected: option.selected),
                    title: Text(
                      option.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    selected: option.selected,
                    onTap: () => onSelected(option),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
