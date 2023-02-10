import 'package:flutter/material.dart';

/// A widget that places children in a two dimensional arrangement
/// and stretches them evenly to occupy full width and full height.
class TileView extends StatelessWidget {
  /// Creates a new instance of [TileView].
  const TileView({
    super.key,
    required this.columnCount,
    this.itemSpacing = 0,
    this.edgeInsets = EdgeInsets.zero,
    this.children = const <Widget>[],
  });

  /// The number of children per row.
  final int columnCount;

  /// The spacing between tiles.
  final double itemSpacing;

  /// Offsets from container.
  final EdgeInsets? edgeInsets;

  /// The widgets to display.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: edgeInsets,
      child: Column(
        children: _createRows(),
      ),
    );
  }

  List<Widget> _createRows() {
    final rows = <Widget>[];

    final rowCount = (children.length / columnCount).ceil();
    for (var rowIndex = 0; rowIndex < rowCount; rowIndex++) {
      rows.add(
        Expanded(
          child: Row(
            children: _createColumns(rowIndex),
          ),
        ),
      );

      if (rowIndex != rowCount - 1) {
        rows.add(SizedBox(height: itemSpacing));
      }
    }

    return rows;
  }

  List<Widget> _createColumns(int rowIndex) {
    final columns = <Widget>[];

    for (var columnIndex = 0; columnIndex < columnCount; columnIndex++) {
      final tileIndex = rowIndex * columnCount + columnIndex;
      if (tileIndex <= children.length - 1) {
        columns.add(Expanded(child: children[tileIndex]));
      } else {
        columns.add(Expanded(child: Container()));
      }

      if (columnIndex != columnCount - 1) {
        columns.add(SizedBox(width: itemSpacing));
      }
    }

    return columns;
  }
}
