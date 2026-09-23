import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../utils/screen_size.dart';

/// How a page of the participants grid is arranged.
@immutable
class StreamParticipantGridArrangement {
  /// Creates an arrangement of [columns] by [rows] tiles of [tileSize].
  const StreamParticipantGridArrangement({
    required this.columns,
    required this.rows,
    required this.tileSize,
  }) : assert(columns >= 0 && rows >= 0, 'A grid cannot have negative extent.'),
       assert((columns == 0) == (rows == 0), 'Empty is 0 x 0 or nothing.');

  /// A page with nothing to arrange.
  static const empty = StreamParticipantGridArrangement(
    columns: 0,
    rows: 0,
    tileSize: Size.zero,
  );

  /// How many tiles a full row holds.
  final int columns;

  /// How many rows the page needs, the last one possibly short.
  final int rows;

  /// The size every tile is drawn at.
  final Size tileSize;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamParticipantGridArrangement &&
          other.columns == columns &&
          other.rows == rows &&
          other.tileSize == tileSize;

  @override
  int get hashCode => Object.hash(columns, rows, tileSize);

  @override
  String toString() =>
      'StreamParticipantGridArrangement($columns x $rows, tile: $tileSize)';
}

/// Describes the space a page of the participants grid has to fill.
@immutable
class StreamParticipantGridDetails {
  /// Creates the details of a page about to be arranged.
  const StreamParticipantGridDetails({
    required this.box,
    required this.count,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.maxTileAspectRatio,
    required this.screenSize,
  });

  /// The space the tiles have, already inset by the grid's padding.
  final Size box;

  /// How many participants this page shows.
  final int count;

  /// The gap between rows.
  final double mainAxisSpacing;

  /// The gap between the tiles within a row.
  final double crossAxisSpacing;

  /// The widest a tile may be drawn, as a width-to-height ratio.
  final double maxTileAspectRatio;

  /// The breakpoint of the surrounding window.
  ///
  /// Carried for an override's benefit; the default rule does not read it.
  final StreamScreenSize screenSize;
}

/// Returns how many columns a page should use, or null to keep the default.
///
/// The rows and the tile size follow from the count, so an override cannot
/// produce an arrangement that disagrees with itself. A count outside
/// `1..details.count` is clamped into it.
///
/// Hoist the function rather than allocating a closure on each build, so that
/// equal themes compare as equal.
///
/// {@tool snippet}
///
/// Two people side by side, whatever the window says:
///
/// ```dart
/// StreamCallParticipantsGridThemeData(
///   columnResolver: (details) => details.count == 2 ? 2 : null,
/// )
/// ```
/// {@end-tool}
typedef StreamParticipantGridColumnResolver =
    int? Function(StreamParticipantGridDetails details);

/// How much wider than tall a container may be and still keep a square count
/// square.
///
/// Four people on a phone are drawn two by two, not stacked four deep, even
/// though stacking scores better. A window far wider than it is tall is the
/// case that rule would spoil — there, four in a row is the whole point — so
/// the preference stops applying past this.
const _maxSquareAspectRatio = 2.0;

/// How much taller than wide a container must be before its tiles are scored
/// as squares rather than at the tile ratio.
///
/// Five people on a phone are drawn two by two by one, not stacked five deep.
/// Scored at 16:9, a column of short wide tiles wins, though it leaves most of
/// the width empty; scored as squares, the grid does.
const _minTallAspectRatio = 1.5;

/// Arranges [details] into the grid that renders the video largest, except
/// that a square count stays square while the box is no wider than 2:1.
///
/// Each candidate column count is scored by the largest
/// [StreamParticipantGridDetails.maxTileAspectRatio] rectangle that fits one of
/// its cells — how big a participant actually appears, rather than how much of
/// the cell they are handed. In a box more than 1.5 times taller than wide,
/// such as an upright phone, the largest square is scored instead. The tile is
/// then drawn filling its cell, except that it is never wider than
/// [StreamParticipantGridDetails.maxTileAspectRatio] allows.
///
/// A page of no participants comes back as
/// [StreamParticipantGridArrangement.empty].
StreamParticipantGridArrangement solveParticipantGrid(
  StreamParticipantGridDetails details,
) {
  if (details.count <= 0) return StreamParticipantGridArrangement.empty;

  return arrangeParticipantGrid(details, _bestColumns(details));
}

/// Arranges [details] into [columns], however many that leaves per row.
///
/// The count is clamped to between 1 and the participant count, so an override
/// returning a number out of range still produces a grid.
StreamParticipantGridArrangement arrangeParticipantGrid(
  StreamParticipantGridDetails details,
  int columns,
) {
  if (details.count <= 0) return StreamParticipantGridArrangement.empty;

  final resolved = columns.clamp(1, details.count);
  final cell = _cellSize(details, resolved);

  return StreamParticipantGridArrangement(
    columns: resolved,
    rows: (details.count / resolved).ceil(),
    tileSize: Size(
      math.min(cell.width, cell.height * details.maxTileAspectRatio),
      cell.height,
    ),
  );
}

int _bestColumns(StreamParticipantGridDetails details) {
  final count = details.count;

  final root = math.sqrt(count).round();
  if (root * root == count &&
      details.box.width <= details.box.height * _maxSquareAspectRatio) {
    return root;
  }

  final scoredAspectRatio =
      details.box.height > details.box.width * _minTallAspectRatio
      ? math.min(1, details.maxTileAspectRatio).toDouble()
      : details.maxTileAspectRatio;

  var best = 1;
  var bestArea = -1.0;
  for (var columns = 1; columns <= count; columns++) {
    final cell = _cellSize(details, columns);
    final width = math.min(cell.width, cell.height * scoredAspectRatio);
    final area = width * width / scoredAspectRatio;

    if (area > bestArea) {
      bestArea = area;
      best = columns;
    }
  }

  return best;
}

Size _cellSize(StreamParticipantGridDetails details, int columns) {
  final rows = (details.count / columns).ceil();
  final width =
      (details.box.width - (columns - 1) * details.crossAxisSpacing) / columns;
  final height =
      (details.box.height - (rows - 1) * details.mainAxisSpacing) / rows;

  // A box too small for this many tiles gives a negative extent, which would
  // otherwise come back out of the scoring as a positive area.
  return Size(
    width.clamp(0, double.infinity).toDouble(),
    height.clamp(0, double.infinity).toDouble(),
  );
}
