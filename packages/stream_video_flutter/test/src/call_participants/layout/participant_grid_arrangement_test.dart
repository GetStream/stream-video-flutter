import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

StreamParticipantGridArrangement solve(
  Size box,
  int count, {
  double spacing = 8,
}) => solveParticipantGrid(
  StreamParticipantGridDetails(
    box: box,
    count: count,
    mainAxisSpacing: spacing,
    crossAxisSpacing: spacing,
    maxTileAspectRatio: 16 / 9,
    screenSize: StreamScreenSize.fromWidth(box.width),
  ),
);

void main() {
  // Every case below is a frame from the design, measured off the drawing: the
  // box is the frame less the app bar and the controls, less the 8px of side
  // padding, and the tile is what Figma draws in it.
  group('the design', () {
    // 400x800 frame, 656 of content.
    group('small, 384x656', () {
      const box = Size(384, 656);

      test('2 stack', () {
        final grid = solve(box, 2);

        expect(grid.columns, 1);
        expect(grid.rows, 2);
        expect(grid.tileSize, const Size(384, 324));
      });

      test('3 stack', () {
        final grid = solve(box, 3);

        expect(grid.columns, 1);
        expect(grid.rows, 3);
        expect(grid.tileSize.height, closeTo(213.33, 0.01));
        // Figma draws 384 here, 5px wider than 16:9 allows at this height.
        expect(grid.tileSize.width, closeTo(379.26, 0.01));
      });

      test('4 go two by two', () {
        final grid = solve(box, 4);

        expect(grid.columns, 2);
        expect(grid.rows, 2);
        expect(grid.tileSize, const Size(188, 324));
      });

      test('6 go two by three', () {
        final grid = solve(box, 6);

        expect(grid.columns, 2);
        expect(grid.rows, 3);
        expect(grid.tileSize.width, 188);
        expect(grid.tileSize.height, closeTo(213.33, 0.01));
      });
    });

    // 768x1024 frame, 880 of content.
    test('medium, 752x880, 3 stack', () {
      final grid = solve(const Size(752, 880), 3);

      expect(grid.columns, 1);
      expect(grid.rows, 3);
      expect(grid.tileSize, const Size(512, 288));
    });

    // 1024x768 frame, 624 of content.
    group('wide, 1008x624', () {
      const box = Size(1008, 624);

      test('2 stack', () {
        final grid = solve(box, 2);

        expect(grid.columns, 1);
        expect(grid.tileSize.width, closeTo(547.56, 0.01));
        expect(grid.tileSize.height, 308);
      });

      test('3 go two by two', () {
        final grid = solve(box, 3);

        expect(grid.columns, 2);
        expect(grid.rows, 2);
        expect(grid.tileSize.width, 500);
      });

      test('4 go two by two', () {
        final grid = solve(box, 4);

        expect(grid.columns, 2);
        expect(grid.rows, 2);
      });

      test('5 go two by three', () {
        final grid = solve(box, 5);

        expect(grid.columns, 2);
        expect(grid.rows, 3);
        expect(grid.tileSize.width, closeTo(360.30, 0.01));
        expect(grid.tileSize.height, closeTo(202.67, 0.01));
      });

      test('6 go two by three', () {
        final grid = solve(box, 6);

        expect(grid.columns, 2);
        expect(grid.rows, 3);
      });
    });

    // 1440x960 frame, 816 of content.
    group('extra wide, 1424x816', () {
      const box = Size(1424, 816);

      test('3 go two by two', () {
        final grid = solve(box, 3);

        expect(grid.columns, 2);
        expect(grid.rows, 2);
        expect(grid.tileSize.width, 708);
      });

      test('5 go two by three', () {
        final grid = solve(box, 5);

        expect(grid.columns, 2);
        expect(grid.rows, 3);
        expect(grid.tileSize.width, closeTo(474.07, 0.01));
        expect(grid.tileSize.height, closeTo(266.67, 0.01));
      });
    });
  });

  group('where the rule departs from the design', () {
    test('a full page at extra wide takes 3 columns, not 4', () {
      // Figma draws 4x3 tiles of 324x182. Three columns of four fits a larger
      // tile, and the rule takes the larger tile.
      final grid = solve(const Size(1320, 816), 12);

      expect(grid.columns, 3);
      expect(grid.rows, 4);
      expect(grid.tileSize.width, closeTo(352, 0.5));
    });
  });

  group('the shape of the window', () {
    test('a short wide window puts four in a row', () {
      final grid = solve(const Size(1884, 330), 4);

      expect(grid.columns, 4);
      expect(grid.rows, 1);
    });

    test('a tall window stacks the same four', () {
      final grid = solve(const Size(384, 656), 4);

      expect(grid.columns, 2);
    });

    test('a window far wider than it is tall drops the square preference', () {
      // The preference is what keeps four square on a phone. It stops applying
      // past 2:1, where four in a row is the point.
      expect(solve(const Size(660, 330), 4).columns, 2);
      expect(solve(const Size(1884, 330), 4).columns, 4);
    });

    test('one participant takes the whole box, capped at the ratio', () {
      final grid = solve(const Size(1008, 624), 1);

      expect(grid.columns, 1);
      expect(grid.rows, 1);
      expect(grid.tileSize.width, closeTo(1008, 0.01));
      expect(grid.tileSize.height, 624);
    });
  });

  group('degenerate boxes', () {
    test('no participants arrange to nothing', () {
      final grid = solve(const Size(1008, 624), 0);

      expect(grid.columns, 0);
      expect(grid.rows, 0);
      expect(grid.tileSize, Size.zero);
    });

    test('a box too small for the tiles never reports a negative size', () {
      final grid = solve(const Size(20, 10), 12);

      expect(grid.tileSize.width, greaterThanOrEqualTo(0));
      expect(grid.tileSize.height, greaterThanOrEqualTo(0));
    });

    test('an empty box arranges without dividing by zero', () {
      final grid = solve(Size.zero, 4);

      expect(grid.tileSize, Size.zero);
    });
  });
}
