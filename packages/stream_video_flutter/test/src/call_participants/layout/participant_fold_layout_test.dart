import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
// The regions are internal to the participant layouts.
// ignore: implementation_imports
import 'package:stream_video_flutter/src/call_participants/layout/participant_fold_layout.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

const _book = StreamDisplayFold(
  bounds: Rect.fromLTWH(475.5, 0, 0, 669),
  posture: StreamFoldPosture.book,
);

const _tabletop = StreamDisplayFold(
  bounds: Rect.fromLTWH(0, 300, 800, 0),
  posture: StreamFoldPosture.tabletop,
);

StreamLocalFold _local(
  StreamDisplayFold fold,
  Size size,
  double at, {
  double width = 0,
}) => StreamLocalFold(fold: fold, size: size, start: at, end: at + width);

FoldRegions _regions(
  Size size,
  StreamLocalFold fold, {
  double gap = 8,
  Size minTileSize = const Size(222, 125),
  bool centerOnFold = true,
  TextDirection textDirection = TextDirection.ltr,
}) => resolveFoldRegions(
  size: size,
  fold: fold,
  gap: gap,
  minTileSize: minTileSize,
  centerOnFold: centerOnFold,
  textDirection: textDirection,
);

StreamParticipantFoldSplitDetails _split(
  int count, {
  Size startSize = const Size(380, 600),
  Size endSize = const Size(380, 600),
  StreamFoldPosture posture = StreamFoldPosture.book,
  Size minTileSize = const Size(222, 125),
  int maxExtra = 2,
}) => StreamParticipantFoldSplitDetails(
  count: count,
  startSize: startSize,
  endSize: endSize,
  posture: posture,
  foldBounds: Rect.zero,
  reportedExtent: 0,
  mainAxisSpacing: 8,
  crossAxisSpacing: 8,
  maxTileAspectRatio: 16 / 9,
  minTileSize: minTileSize,
  maxExtraTilesOnSmallerSide: maxExtra,
  screenSize: StreamScreenSize.medium,
);

void main() {
  group('resolveFoldRegions', () {
    // The iPhone Duo's book frame: the status rail leaves 851 of the window
    // to the layout, and the fold is 467.5 into it.
    const size = Size(851, 653);

    test('centres an off-centre fold, the space left on the wider side', () {
      final regions = _regions(size, _local(_book, size, 467.5));

      expect(regions, isA<FoldRegionsSplit>());
      final split = regions as FoldRegionsSplit;
      expect(split.start, const Rect.fromLTRB(84, 0, 463.5, 653));
      expect(split.end, const Rect.fromLTRB(471.5, 0, 851, 653));
    });

    test('fills both sides when not centring', () {
      final split =
          _regions(size, _local(_book, size, 467.5), centerOnFold: false)
              as FoldRegionsSplit;

      expect(split.start, const Rect.fromLTRB(0, 0, 463.5, 653));
      expect(split.end, const Rect.fromLTRB(471.5, 0, 851, 653));
    });

    test('centres the gap on a hinge, running into its width', () {
      final split =
          _regions(size, _local(_book, size, 420, width: 20))
              as FoldRegionsSplit;

      expect(split.start.right, 426);
      expect(split.end.left, 434);
    });

    test('swaps the sides in a right-to-left locale', () {
      final split =
          _regions(
                size,
                _local(_book, size, 467.5),
                textDirection: TextDirection.rtl,
              )
              as FoldRegionsSplit;

      expect(split.start.left, 471.5);
      expect(split.end.right, 463.5);
    });

    test('keeps top and bottom in a right-to-left locale', () {
      const size = Size(800, 600);
      final split =
          _regions(
                size,
                _local(_tabletop, size, 300),
                textDirection: TextDirection.rtl,
              )
              as FoldRegionsSplit;

      expect(split.start, const Rect.fromLTRB(0, 0, 800, 296));
      expect(split.end, const Rect.fromLTRB(0, 304, 800, 600));
    });

    test('puts everything on the larger side when the nearer one is too '
        'small for a tile', () {
      final regions = _regions(size, _local(_book, size, 150));

      expect(regions, isA<FoldRegionsSingle>());
      expect(
        (regions as FoldRegionsSingle).rect,
        const Rect.fromLTRB(154, 0, 851, 653),
      );
    });

    test('lays out as normal when the fold is within the gap of an edge', () {
      final regions = _regions(size, _local(_book, size, 2));

      expect((regions as FoldRegionsSingle).rect, Offset.zero & size);
    });
  });

  group('solveParticipantFoldSplit', () {
    test('puts one participant on the start side', () {
      expect(solveParticipantFoldSplit(_split(1)), 1);
    });

    test('shares two evenly', () {
      expect(solveParticipantFoldSplit(_split(2)), 1);
    });

    test('gives the speaker a side of their own on a tie', () {
      expect(solveParticipantFoldSplit(_split(3)), 1);
      expect(
        solveParticipantFoldSplit(
          _split(
            3,
            startSize: const Size(800, 292),
            endSize: const Size(800, 292),
            posture: StreamFoldPosture.tabletop,
          ),
        ),
        1,
      );
    });

    test('matches the tiles of unequal sides', () {
      // A narrow side stacks its tiles, which keeps them close in shape to
      // the wide side's.
      final start = solveParticipantFoldSplit(
        _split(
          4,
          startSize: const Size(240, 600),
          endSize: const Size(700, 600),
        ),
      );

      expect(start, inInclusiveRange(1, 3));
    });

    test('holds the smaller side to the extra-tile limit', () {
      final solved = solveParticipantFoldSplit(
        _split(
          8,
          startSize: const Size(300, 900),
          endSize: const Size(500, 900),
          maxExtra: 0,
        ),
      );

      expect(solved, lessThanOrEqualTo(8 - solved));
    });

    test('leaves a side too small for one tile empty', () {
      expect(
        solveParticipantFoldSplit(
          _split(
            2,
            startSize: const Size(200, 600),
            endSize: const Size(600, 600),
          ),
        ),
        0,
      );
    });

    test('puts everybody on the roomier side when they cannot share', () {
      // Equal widths allow no uneven split, so three go on one side. Both
      // hold them, and the taller start side gives them the larger tiles.
      expect(
        solveParticipantFoldSplit(
          _split(
            3,
            startSize: const Size(700, 600),
            endSize: const Size(700, 300),
            maxExtra: 0,
          ),
        ),
        3,
      );
    });

    test('keeps the split with the largest smallest tile when none fits', () {
      final start = solveParticipantFoldSplit(
        _split(
          12,
          startSize: const Size(300, 300),
          endSize: const Size(300, 300),
        ),
      );

      expect(start, 6);
    });
  });
}
