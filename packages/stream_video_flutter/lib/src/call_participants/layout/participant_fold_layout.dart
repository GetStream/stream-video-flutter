import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../utils/display_fold.dart';
import '../../utils/screen_size.dart';
import 'participant_grid_arrangement.dart';

/// Which side of a fold a group of tiles is on.
enum StreamFoldSide {
  /// Before the fold: the leading half in the book posture, the top half in
  /// tabletop.
  start,

  /// After the fold: the trailing half in the book posture, the bottom half in
  /// tabletop.
  end,
}

/// The fold as a participant layout sees it, handed to the layout's
/// resolvers.
@immutable
class StreamParticipantFoldDetails {
  /// Creates the fold details of one side of a layout.
  const StreamParticipantFoldDetails({
    required this.side,
    required this.posture,
    required this.foldBounds,
    required this.reportedExtent,
    required this.layoutSize,
    required this.otherSideSize,
    required this.otherSideCount,
  });

  /// The side being arranged.
  final StreamFoldSide side;

  /// Whether the fold runs top to bottom or across.
  final StreamFoldPosture posture;

  /// The fold in the layout's own coordinates.
  final Rect foldBounds;

  /// The width of the fold as the platform reported it, zero for a fold in a
  /// flexible screen.
  final double reportedExtent;

  /// The size of the whole layout, both sides and the fold.
  final Size layoutSize;

  /// The size of the side not being arranged.
  final Size otherSideSize;

  /// How many tiles the side not being arranged holds.
  final int otherSideCount;
}

/// Describes how a page of participants could be shared between the two sides
/// of a fold.
@immutable
class StreamParticipantFoldSplitDetails {
  /// Creates the details of a page about to be split at a fold.
  const StreamParticipantFoldSplitDetails({
    required this.count,
    required this.startSize,
    required this.endSize,
    required this.posture,
    required this.foldBounds,
    required this.reportedExtent,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.maxTileAspectRatio,
    required this.minTileSize,
    required this.maxExtraTilesOnSmallerSide,
    required this.screenSize,
  });

  /// How many participants this page shows.
  final int count;

  /// The space the start side has: leading in the book posture, top in
  /// tabletop.
  final Size startSize;

  /// The space the end side has: trailing in the book posture, bottom in
  /// tabletop.
  final Size endSize;

  /// Whether the fold runs top to bottom or across.
  final StreamFoldPosture posture;

  /// The fold in the layout's own coordinates.
  final Rect foldBounds;

  /// The width of the fold as the platform reported it.
  final double reportedExtent;

  /// The gap between rows.
  final double mainAxisSpacing;

  /// The gap between the tiles within a row.
  final double crossAxisSpacing;

  /// The widest a tile may be drawn, as a width-to-height ratio.
  final double maxTileAspectRatio;

  /// The smallest a tile may be drawn on either side.
  final Size minTileSize;

  /// How many more tiles the smaller side may hold than the larger one.
  final int maxExtraTilesOnSmallerSide;

  /// The breakpoint of the surrounding window.
  final StreamScreenSize screenSize;

  /// The details of one side holding [count] tiles.
  StreamParticipantGridDetails sideDetails(StreamFoldSide side, int count) =>
      StreamParticipantGridDetails(
        box: side == StreamFoldSide.start ? startSize : endSize,
        count: count,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        maxTileAspectRatio: maxTileAspectRatio,
        screenSize: screenSize,
      );
}

/// Returns how many participants of a page go on the start side of a fold, or
/// null to keep the default.
///
/// Hoist the function rather than allocating a closure on each build, so that
/// equal themes compare as equal.
typedef StreamParticipantFoldSplitResolver =
    int? Function(StreamParticipantFoldSplitDetails details);

/// How many of [details]' participants go on the start side of the fold.
///
/// Tries every split within the extra-tile limit, arranges each side with
/// [solveParticipantGrid], and keeps the split whose tiles on both sides come
/// closest in aspect ratio. A split is only a candidate when every tile is at
/// least [StreamParticipantFoldSplitDetails.minTileSize]; when none is, the one
/// whose smallest tile is largest is kept. A side is left empty only when no
/// split with tiles on both sides is a candidate, or there is one participant,
/// who goes on the start side.
///
/// On a tie the start side takes fewer, so the first participant, the
/// speaker, gets a side to themselves sooner.
int solveParticipantFoldSplit(StreamParticipantFoldSplitDetails details) {
  final count = details.count;
  if (count <= 1) return count;

  // Splits with tiles on both sides come first; one side is left empty only
  // when none of those fits.
  final bothSides = _splits(details, bothSides: true);
  final oneSide = _splits(details, bothSides: false);

  return _bestFitting(bothSides, details.minTileSize) ??
      _bestFitting(oneSide, details.minTileSize) ??
      _largestSmallestTile([...bothSides, ...oneSide]) ??
      count;
}

/// A candidate split: how many go on the start side, and the tile size on
/// each side that has any.
typedef _Split = ({int start, List<Size> tiles});

/// The splits to consider, fewest on the start side first: those with tiles
/// on both sides within the extra-tile limit, or those with one side empty.
List<_Split> _splits(
  StreamParticipantFoldSplitDetails details, {
  required bool bothSides,
}) => [
  for (var start = 0; start <= details.count; start++)
    if (_isCandidate(details, start, bothSides: bothSides))
      (start: start, tiles: _sideTiles(details, start)),
];

bool _isCandidate(
  StreamParticipantFoldSplitDetails details,
  int start, {
  required bool bothSides,
}) {
  final end = details.count - start;
  final empty = start == 0 || end == 0;
  if (empty == bothSides) return false;
  return !bothSides || _withinLimit(details, start, end);
}

/// Whether the smaller side holds no more than the limit's extra tiles.
bool _withinLimit(
  StreamParticipantFoldSplitDetails details,
  int start,
  int end,
) {
  final startLength = _length(details.startSize, details.posture);
  final endLength = _length(details.endSize, details.posture);
  final extra = details.maxExtraTilesOnSmallerSide;
  return switch (startLength.compareTo(endLength)) {
    < 0 => start <= end + extra,
    > 0 => end <= start + extra,
    _ => (start - end).abs() <= extra,
  };
}

List<Size> _sideTiles(StreamParticipantFoldSplitDetails details, int start) {
  final end = details.count - start;
  return [
    if (start > 0)
      solveParticipantGrid(
        details.sideDetails(StreamFoldSide.start, start),
      ).tileSize,
    if (end > 0)
      solveParticipantGrid(
        details.sideDetails(StreamFoldSide.end, end),
      ).tileSize,
  ];
}

/// The split among [splits] whose tiles all fit [minTileSize] and come closest
/// in aspect ratio across the fold; the first on a tie.
int? _bestFitting(List<_Split> splits, Size minTileSize) {
  int? best;
  var bestScore = double.infinity;
  for (final split in splits) {
    final fits = split.tiles.every(
      (tile) =>
          tile.width >= minTileSize.width && tile.height >= minTileSize.height,
    );
    if (!fits) continue;

    final score = _shapeMismatch(split.tiles);
    if (score < bestScore) {
      bestScore = score;
      best = split.start;
    }
  }
  return best;
}

/// How far apart the two sides' tiles are in shape; 0 for a single side.
double _shapeMismatch(List<Size> tiles) => tiles.length < 2
    ? 0
    : (math.log(_aspectRatio(tiles[0])) - math.log(_aspectRatio(tiles[1])))
          .abs();

/// The split among [splits] whose smallest tile edge is largest; the first on
/// a tie.
int? _largestSmallestTile(List<_Split> splits) {
  int? best;
  var bestSmallest = -1.0;
  for (final split in splits) {
    final smallest = split.tiles
        .map((tile) => math.min(tile.width, tile.height))
        .reduce(math.min);
    if (smallest > bestSmallest) {
      bestSmallest = smallest;
      best = split.start;
    }
  }
  return best;
}

double _aspectRatio(Size tile) =>
    tile.height <= 0 ? 1 : math.max(tile.width, 1) / tile.height;

double _length(Size size, StreamFoldPosture posture) => switch (posture.axis) {
  Axis.horizontal => size.width,
  Axis.vertical => size.height,
};

/// Where a participant layout puts its tiles around a fold.
@internal
sealed class FoldRegions {
  const FoldRegions();
}

/// Lays everything out in [rect] as if there were no fold: the fold misses
/// the layout, or one side is too small for a tile.
@internal
final class FoldRegionsSingle extends FoldRegions {
  const FoldRegionsSingle(this.rect);

  /// The space the layout uses, in its own coordinates.
  final Rect rect;
}

/// Splits the layout into two sides of the fold.
@internal
final class FoldRegionsSplit extends FoldRegions {
  const FoldRegionsSplit({
    required this.start,
    required this.end,
    required this.fold,
    required this.size,
  });

  /// The start side, in the layout's own coordinates: leading in the book
  /// posture, top in tabletop.
  final Rect start;

  /// The end side: trailing in the book posture, bottom in tabletop.
  final Rect end;

  /// The fold as measured against the layout.
  final StreamLocalFold fold;

  /// The size of the whole layout.
  final Size size;

  /// The fold in the layout's own coordinates.
  Rect get foldBounds => switch (fold.axis) {
    Axis.horizontal => Rect.fromLTRB(fold.start, 0, fold.end, size.height),
    Axis.vertical => Rect.fromLTRB(0, fold.start, size.width, fold.end),
  };

  /// The fold details for tiles on [side].
  StreamParticipantFoldDetails details(StreamFoldSide side, int otherCount) =>
      StreamParticipantFoldDetails(
        side: side,
        posture: fold.posture,
        foldBounds: foldBounds,
        reportedExtent: fold.extent,
        layoutSize: size,
        otherSideSize: (side == StreamFoldSide.start ? end : start).size,
        otherSideCount: otherCount,
      );
}

/// Works out where a layout of [size] puts its tiles around [fold].
///
/// The two sides are [gap] apart, centred on the middle of the fold. A tile
/// has room inside its own edges, so it may run into a hinge's reported
/// width. With [centerOnFold] both sides get the room of the
/// nearer one, so the layout is centred on the fold. When the nearer side
/// cannot hold a tile of [minTileSize], everything goes on the larger side.
@internal
FoldRegions resolveFoldRegions({
  required Size size,
  required StreamLocalFold? fold,
  required double gap,
  required Size minTileSize,
  required bool centerOnFold,
  required TextDirection textDirection,
}) {
  final full = Offset.zero & size;
  if (fold == null) return FoldRegionsSingle(full);

  final axis = fold.axis;
  final length = _length(size, fold.posture);
  final (firstEnd, secondStart) = fold.gutter(gap);
  final firstLength = firstEnd;
  final secondLength = length - secondStart;
  if (firstLength <= 0 || secondLength <= 0) return FoldRegionsSingle(full);

  Rect span(double from, double to) => switch (axis) {
    Axis.horizontal => Rect.fromLTRB(from, 0, to, size.height),
    Axis.vertical => Rect.fromLTRB(0, from, size.width, to),
  };

  final minExtent = switch (axis) {
    Axis.horizontal => minTileSize.width,
    Axis.vertical => minTileSize.height,
  };
  final nearer = math.min(firstLength, secondLength);
  if (nearer < minExtent) {
    return FoldRegionsSingle(
      firstLength >= secondLength
          ? span(0, firstEnd)
          : span(secondStart, length),
    );
  }

  final (first, second) = centerOnFold
      ? (
          span(firstEnd - nearer, firstEnd),
          span(secondStart, secondStart + nearer),
        )
      : (span(0, firstEnd), span(secondStart, length));

  final rtl = axis == Axis.horizontal && textDirection == TextDirection.rtl;
  return FoldRegionsSplit(
    start: rtl ? second : first,
    end: rtl ? first : second,
    fold: fold,
    size: size,
  );
}
