import 'package:flutter/material.dart';
import 'package:stream_core_flutter/core.dart';

/// A row of tabs, each taking an equal share of the width, marking the
/// selected one with an accent label over an accent underline.
///
/// Mirrors the `Web / Tab Bar` component from the design.
///
/// Unlike Material's [TabBar] this carries no controller and no page view:
/// [selectedIndex] comes from the caller and [onSelected] reports a tap. That
/// keeps a tab switch a plain state change, which is what a tab bar over
/// already-loaded content wants — there is nothing to animate between and
/// nothing to reload.
///
/// This is a design-system candidate: it lives in this SDK until the
/// component is finalized and can graduate to stream_core_flutter.
class StreamTabBar extends StatelessWidget {
  /// Creates a tab bar.
  const StreamTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  }) : assert(tabs.length > 0, 'A tab bar needs at least one tab.');

  /// The tabs to draw, in order.
  final List<StreamTabBarItem> tabs;

  /// The index into [tabs] of the selected tab.
  final int selectedIndex;

  /// Called with the index of the tapped tab.
  final ValueChanged<int> onSelected;

  /// The height of the bar, underline included.
  static const height = 48.0;

  static const _indicatorWeight = 2.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          for (final (index, tab) in tabs.indexed)
            Expanded(
              child: _StreamTab(
                item: tab,
                selected: index == selectedIndex,
                onPressed: () => onSelected(index),
              ),
            ),
        ],
      ),
    );
  }
}

/// One tab of a [StreamTabBar].
@immutable
class StreamTabBarItem {
  /// Creates a tab.
  const StreamTabBarItem({required this.label, this.icon});

  /// The tab's label.
  final String label;

  /// An icon drawn before [label].
  final Widget? icon;
}

class _StreamTab extends StatelessWidget {
  const _StreamTab({
    required this.item,
    required this.selected,
    required this.onPressed,
  });

  final StreamTabBarItem item;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final spacing = context.streamSpacing;

    final color = selected
        ? colorScheme.accentPrimary
        : colorScheme.textSecondary;

    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: StreamTabBar._indicatorWeight,
                color: selected
                    ? colorScheme.accentPrimary
                    : colorScheme.borderDefault,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(spacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: spacing.xs,
              children: [
                if (item.icon case final icon?)
                  IconTheme.merge(
                    data: IconThemeData(color: color),
                    child: icon,
                  ),
                Flexible(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.streamTextTheme.captionEmphasis.copyWith(
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
