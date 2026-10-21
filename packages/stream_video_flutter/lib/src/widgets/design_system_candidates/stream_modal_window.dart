import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import 'stream_modal_parts.dart';

/// A modal window with a sidebar of tabs, showing one tab at a time.
///
/// Mirrors the `Modal Window` and `Web / Modal Dialog Sidebar` components from
/// the design: the sidebar at the start edge lists the tabs, and the rest of
/// the window shows the selected tab under a header with its label and a
/// close button.
///
/// Pass it to [showStreamModalDialog], which supplies the scrim:
///
/// {@tool snippet}
///
/// ```dart
/// showStreamModalDialog<void>(
///   context: context,
///   builder: (context) => StreamModalWindow(
///     tabs: [
///       StreamModalWindowTab(
///         icon: Icon(context.streamIcons.settingsFill),
///         label: const Text('Device'),
///         builder: (context) => const DeviceSettings(),
///       ),
///       StreamModalWindowTab(
///         icon: Icon(context.streamIcons.blurFill),
///         label: const Text('Effects'),
///         builder: (context) => const EffectsSettings(),
///       ),
///     ],
///   ),
/// );
/// ```
/// {@end-tool}
///
/// The window takes the whole of [constraints], so switching tabs never
/// changes its size. The selected tab is drawn in a scroll view.
///
/// A [StreamAdaptiveMenuAnchor] in a tab opens its anchored menu on every
/// platform rather than a bottom sheet. Wrap the tab's content in a
/// [StreamAdaptiveMenuAnchorTheme] that sets
/// [StreamAdaptiveMenuAnchorThemeData.useSheet] to change that.
///
/// When the window is narrower than 560, the sidebar shows only the tabs'
/// icons, each with its tab's [StreamModalWindowTab.tooltip].
///
/// This is a design-system candidate: it lives in this SDK until the
/// component is finalized and can graduate to stream_core_flutter.
class StreamModalWindow extends StatefulWidget {
  /// Creates a modal window.
  const StreamModalWindow({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.showCloseButton = true,
    this.onClose,
    this.constraints = StreamModalDialog.defaultConstraints,
  }) : assert(tabs.length > 0, 'A modal window needs at least one tab.'),
       assert(
         initialIndex >= 0 && initialIndex < tabs.length,
         'initialIndex must be the index of one of the tabs.',
       );

  /// The tabs, in the order the sidebar lists them.
  final List<StreamModalWindowTab> tabs;

  /// The index of the tab selected when the window opens.
  ///
  /// Must be the index of one of the [tabs].
  final int initialIndex;

  /// Called with the tab's index when the user selects a different tab.
  final ValueChanged<int>? onTabChanged;

  /// Whether the header draws a close button.
  final bool showCloseButton;

  /// Called when the close button is pressed.
  ///
  /// Defaults to popping the window with no value.
  final VoidCallback? onClose;

  /// The bounds of the window.
  ///
  /// Defaults to [StreamModalDialog.defaultConstraints].
  final BoxConstraints constraints;

  @override
  State<StreamModalWindow> createState() => _StreamModalWindowState();
}

/// One tab of a [StreamModalWindow].
@immutable
class StreamModalWindowTab {
  /// Creates a tab.
  const StreamModalWindowTab({
    required this.icon,
    required this.label,
    required this.builder,
    this.tooltip,
  });

  /// The icon drawn before [label] in the sidebar.
  ///
  /// A collapsed sidebar shows only the icon.
  final Widget icon;

  /// The tab's name: drawn in the sidebar and as the title of the header.
  ///
  /// Typically a [Text].
  final Widget label;

  /// The tooltip a collapsed sidebar shows on the tab's icon.
  ///
  /// Defaults to the text of [label] when it is a [Text]. Without either, the
  /// icon has no tooltip.
  final String? tooltip;

  /// Builds the tab's content.
  ///
  /// Runs inside the window, and only while the tab is selected: selecting
  /// the tab again builds it again. The content is placed in a scroll view,
  /// so it should size itself to what it shows.
  final WidgetBuilder builder;
}

// Below this window width, the sidebar shows only the tabs' icons.
const double _collapseBelowWidth = 560;

class _StreamModalWindowState extends State<StreamModalWindow> {
  late int _selectedIndex = _clamp(widget.initialIndex);

  int _clamp(int index) => index.clamp(0, widget.tabs.length - 1);

  @override
  void didUpdateWidget(StreamModalWindow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedIndex = _clamp(_selectedIndex);
  }

  void _select(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final style = StreamModalWindowTheme.of(context).style;
    final defaults = _StreamModalWindowStyleDefaults(context);
    final tab = widget.tabs[_selectedIndex];

    return StreamModalSurface(
      constraints: widget.constraints,
      backgroundColor: style?.backgroundColor ?? defaults.backgroundColor,
      child: SizedBox.expand(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final collapsed = constraints.maxWidth < _collapseBelowWidth;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Sidebar(
                  tabs: widget.tabs,
                  selectedIndex: _selectedIndex,
                  collapsed: collapsed,
                  style: style,
                  defaults: defaults,
                  onSelected: _select,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StreamModalHeader(
                        title: tab.label,
                        actions: [
                          if (widget.showCloseButton)
                            StreamModalCloseButton(onPressed: widget.onClose),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          // A new tab starts at its top.
                          key: ValueKey(_selectedIndex),
                          padding:
                              style?.contentPadding ?? defaults.contentPadding,
                          child: StreamAdaptiveMenuAnchorTheme(
                            data: StreamAdaptiveMenuAnchorTheme.of(context)
                                .merge(
                                  const StreamAdaptiveMenuAnchorThemeData(
                                    useSheet: false,
                                  ),
                                ),
                            child: Builder(builder: tab.builder),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.tabs,
    required this.selectedIndex,
    required this.collapsed,
    required this.style,
    required this.defaults,
    required this.onSelected,
  });

  final List<StreamModalWindowTab> tabs;
  final int selectedIndex;
  final bool collapsed;
  final StreamModalWindowStyle? style;
  final _StreamModalWindowStyleDefaults defaults;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return DecoratedBox(
      // In front, so the Material below doesn't paint over it.
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: BorderDirectional(
          end: BorderSide(
            color: style?.sidebarBorderColor ?? defaults.sidebarBorderColor,
          ),
        ),
      ),
      // A Material rather than a colored box: the rows draw their selected
      // fill as ink, which paints on the nearest Material and would be
      // covered by a box painted above it.
      child: Material(
        color: style?.sidebarBackgroundColor ?? defaults.sidebarBackgroundColor,
        child: SizedBox(
          width: collapsed
              ? null
              : style?.sidebarWidth ?? defaults.sidebarWidth,
          child: StreamListTileTheme(
            data: defaults.navItemStyle.merge(style?.navItemStyle),
            child: FocusTraversalGroup(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.xxs,
                  vertical: spacing.xxs + spacing.xxxs,
                ),
                child: Column(
                  crossAxisAlignment: collapsed
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.stretch,
                  children: [
                    for (final (index, tab) in tabs.indexed)
                      _NavItem(
                        tab: tab,
                        selected: index == selectedIndex,
                        collapsed: collapsed,
                        onTap: () => onSelected(index),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.selected,
    required this.collapsed,
    required this.onTap,
  });

  final StreamModalWindowTab tab;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final spacing = context.streamSpacing;
    final listTileTheme = context.streamListTileTheme;

    final states = {if (selected) WidgetState.selected};
    final iconColor =
        listTileTheme.iconColor?.resolve(states) ?? colorScheme.textSecondary;
    final labelColor =
        listTileTheme.titleColor?.resolve(states) ?? colorScheme.textPrimary;
    final labelStyle =
        listTileTheme.titleTextStyle ?? context.streamTextTheme.bodyDefault;

    final icon = IconTheme.merge(
      data: IconThemeData(size: 16, color: iconColor),
      child: tab.icon,
    );

    Widget item = StreamListTileContainer(
      selected: selected,
      onTap: onTap,
      child: collapsed
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                // Not drawn, but still read out, so the row keeps its name.
                SizedBox.shrink(
                  child: Visibility.maintain(visible: false, child: tab.label),
                ),
              ],
            )
          : Row(
              spacing: spacing.sm,
              children: [
                icon,
                Expanded(
                  child: DefaultTextStyle.merge(
                    style: labelStyle.copyWith(color: labelColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: tab.label,
                  ),
                ),
              ],
            ),
    );

    final tooltip = switch (tab) {
      StreamModalWindowTab(:final tooltip?) => tooltip,
      StreamModalWindowTab(label: Text(:final data?)) => data,
      _ => null,
    };
    if (collapsed && tooltip != null) {
      item = Tooltip(
        message: tooltip,
        // The hidden label above already names the row.
        excludeFromSemantics: true,
        child: item,
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 40),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.xxs),
        child: Align(
          widthFactor: collapsed ? 1 : null,
          child: item,
        ),
      ),
    );
  }
}

class _StreamModalWindowStyleDefaults extends StreamModalWindowStyle {
  _StreamModalWindowStyleDefaults(this._context);

  final BuildContext _context;

  late final StreamColorScheme _colorScheme = _context.streamColorScheme;
  late final StreamSpacing _spacing = _context.streamSpacing;

  @override
  Color get backgroundColor => _colorScheme.backgroundElevation1;

  @override
  double get sidebarWidth => 200;

  @override
  Color get sidebarBackgroundColor => _colorScheme.backgroundElevation1;

  @override
  Color get sidebarBorderColor => _colorScheme.borderSubtle;

  @override
  StreamListTileThemeData get navItemStyle => StreamListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(_context.streamRadius.md),
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: _spacing.sm,
      vertical: _spacing.xs,
    ),
  );

  @override
  EdgeInsetsGeometry get contentPadding => EdgeInsetsDirectional.only(
    start: _spacing.xl,
    end: _spacing.xl,
    bottom: _spacing.xxl,
  );
}
