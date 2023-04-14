import 'dart:math' as math;

import 'package:flutter/material.dart';

const _kDefaultSpacing = 16.0;

/// A widget that places children in a two dimensional arrangement
/// and stretches them evenly to occupy full width and full height.
class TileView extends StatelessWidget {
  /// Creates a new instance of [TileView].
  const TileView({
    super.key,
    required this.children,
    required this.mainAxisCount,
    required this.crossAxisCount,
    this.mainAxisSpacing = _kDefaultSpacing,
    this.crossAxisSpacing = _kDefaultSpacing,
    this.padding = const EdgeInsets.all(_kDefaultSpacing),
    this.mainAxisAlignment = WrapAlignment.center,
    this.crossAxisAlignment = WrapAlignment.center,
    this.maxTileWidth = double.infinity,
    this.maxTileHeight = double.infinity,
  });

  /// The number of children per column.
  final int mainAxisCount;

  /// The number of children per row.
  final int crossAxisCount;

  /// Space between the items in the main axis.
  final double mainAxisSpacing;

  /// Space between the items in the cross axis.
  final double crossAxisSpacing;

  /// Padding around the grid.
  final EdgeInsetsGeometry padding;

  /// Alignment of the children in the cross axis.
  final WrapAlignment crossAxisAlignment;

  /// Alignment of the children in the main axis.
  final WrapAlignment mainAxisAlignment;

  /// The maximum width of a tile.
  ///
  /// If the width of a tile is greater than this value, it will be
  /// scaled down to fit.
  final double maxTileWidth;

  /// The maximum height of a tile.
  ///
  /// If the height of a tile is greater than this value, it will be
  /// scaled down to fit.
  final double maxTileHeight;

  /// The widgets to display.
  final Iterable<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;
          final spacing = mainAxisSpacing * (mainAxisCount - 1);
          final availableHeight = maxHeight - spacing;

          final maxWidth = constraints.maxWidth;
          final spacingWidth = crossAxisSpacing * (crossAxisCount - 1);
          final availableWidth = maxWidth - spacingWidth;

          final itemHeight = (availableHeight / mainAxisCount).floorToDouble();
          final itemWidth = (availableWidth / crossAxisCount).floorToDouble();

          return Wrap(
            spacing: crossAxisSpacing,
            runSpacing: mainAxisSpacing,
            alignment: crossAxisAlignment,
            runAlignment: mainAxisAlignment,
            children: [
              ...children.map((child) {
                return SizedBox(
                  width: math.min(itemWidth, maxTileWidth),
                  height: math.min(itemHeight, maxTileHeight),
                  child: child,
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
