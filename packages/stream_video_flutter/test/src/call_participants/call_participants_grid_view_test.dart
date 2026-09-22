import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// Not exported from the barrel — the grid is internal to the default call
// content — so it is reached directly.
// ignore: implementation_imports
import 'package:stream_video_flutter/src/call_participants/layout/call_participants_grid_view.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide Finder;

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

MockCallParticipantState _participant(String id) {
  final participant = MockCallParticipantState();
  when(() => participant.name).thenReturn(id);
  when(() => participant.userId).thenReturn(id);
  when(() => participant.sessionId).thenReturn(id);
  when(() => participant.uniqueParticipantKey).thenReturn(id);
  return participant;
}

// SizedBox.expand, so the tile fills the cell it is given: a childless
// ColoredBox has no intrinsic width and the grid's Column centres it, which
// would collapse it to zero width and measure nothing.
Widget _box(BuildContext _, Call __, CallParticipantState participant) =>
    SizedBox.expand(
      key: ValueKey('tile-${participant.sessionId}'),
      child: const ColoredBox(color: Color(0xFF6E7A8A)),
    );

Finder _tile(String id) => find.byKey(ValueKey('tile-$id'));

List<CallParticipantState> _participants(int count) => [
  for (var i = 0; i < count; i++) _participant('p$i'),
];

void main() {
  // StreamScreenSize reads MediaQuery.sizeOf, so the surface has to carry the
  // width the case is about — the page size is the one thing still keyed to it.
  Future<void> pump(
    WidgetTester tester, {
    required Size size,
    required List<CallParticipantState> participants,
    EdgeInsets? padding,
    StreamCallParticipantsGridThemeData? theme,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);

    Widget grid = CallParticipantsGridView(
      call: MockCall(),
      participants: participants,
      itemBuilder: _box,
      padding: padding,
    );

    if (theme != null) {
      grid = StreamCallParticipantsGridTheme(data: theme, child: grid);
    }

    return tester.pumpWidget(
      TestWrapper(child: SizedBox.expand(child: grid)),
    );
  }

  group('padding', () {
    // The padding reaches every page, not only one holding a single
    // participant.
    for (final count in [1, 2, 4]) {
      testWidgets('insets a page of $count participants', (tester) async {
        await pump(
          tester,
          size: const Size(400, 600),
          participants: _participants(count),
          padding: const EdgeInsets.all(24),
        );

        final first = tester.getRect(_tile('p0'));
        expect(first.left, 24);
        expect(first.top, 24);
      });
    }

    testWidgets('takes it from the theme', (tester) async {
      await pump(
        tester,
        size: const Size(400, 600),
        participants: _participants(1),
        theme: const StreamCallParticipantsGridThemeData(
          padding: EdgeInsets.all(40),
        ),
      );

      final first = tester.getRect(_tile('p0'));
      expect(first.left, 40);
      expect(first.top, 40);
    });

    testWidgets('a passed padding beats the theme', (tester) async {
      await pump(
        tester,
        size: const Size(400, 600),
        participants: _participants(1),
        padding: const EdgeInsets.all(12),
        theme: const StreamCallParticipantsGridThemeData(
          padding: EdgeInsets.all(40),
        ),
      );

      expect(tester.getRect(_tile('p0')).left, 12);
    });
  });

  group('the arrangement follows the shape of the box', () {
    testWidgets('a short wide window puts four in a row', (tester) async {
      await pump(
        tester,
        size: const Size(1900, 346),
        participants: _participants(4),
      );

      // One row: every tile shares a top edge, and they run left to right.
      final tops = [
        for (var i = 0; i < 4; i++) tester.getRect(_tile('p$i')).top,
      ];
      expect(tops.toSet(), hasLength(1));
      expect(
        tester.getRect(_tile('p3')).left,
        greaterThan(tester.getRect(_tile('p0')).left),
      );
    });

    testWidgets('a phone puts the same four two by two', (tester) async {
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(4),
      );

      expect(tester.getRect(_tile('p0')).top, tester.getRect(_tile('p1')).top);
      expect(
        tester.getRect(_tile('p2')).top,
        greaterThan(tester.getRect(_tile('p0')).top),
      );
    });

    testWidgets('a tile is never drawn wider than 16:9', (tester) async {
      await pump(
        tester,
        size: const Size(1900, 346),
        participants: _participants(1),
      );

      final tile = tester.getSize(_tile('p0'));
      expect(tile.width / tile.height, closeTo(16 / 9, 0.01));
    });

    testWidgets('a short last row is centred under the one above', (
      tester,
    ) async {
      await pump(
        tester,
        size: const Size(1440, 960),
        participants: _participants(3),
      );

      final row = tester.getRect(_tile('p0')).width;
      expect(tester.getCenter(_tile('p2')).dx, 720);
      expect(tester.getRect(_tile('p2')).width, row);
    });
  });

  group('columnResolver', () {
    testWidgets('an override wins over the solved count', (tester) async {
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(4),
        theme: StreamCallParticipantsGridThemeData(
          columnResolver: (details) => 1,
        ),
      );

      // One column: every tile shares a left edge.
      final lefts = [
        for (var i = 0; i < 4; i++) tester.getRect(_tile('p$i')).left,
      ];
      expect(lefts.toSet(), hasLength(1));
    });

    testWidgets('returning null keeps the default', (tester) async {
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(4),
        theme: StreamCallParticipantsGridThemeData(
          columnResolver: (details) => details.count == 2 ? 2 : null,
        ),
      );

      // Still the solved 2x2, not one column.
      expect(tester.getRect(_tile('p0')).top, tester.getRect(_tile('p1')).top);
      expect(
        tester.getRect(_tile('p2')).top,
        greaterThan(tester.getRect(_tile('p0')).top),
      );
    });

    testWidgets('a count out of range still draws a grid', (tester) async {
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(4),
        theme: StreamCallParticipantsGridThemeData(
          columnResolver: (details) => 0,
        ),
      );

      expect(tester.getSize(_tile('p0')).width, greaterThan(0));
    });
  });

  group('paging', () {
    testWidgets('no chevrons while everybody fits on one page', (tester) async {
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(6),
      );

      expect(find.byType(PageNavigationButton), findsNothing);
    });

    testWidgets('chevrons once there is a second page', (tester) async {
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(7),
      );

      expect(find.byType(PageNavigationButton), findsNWidgets(2));
      // Six of the seven are on the first page.
      expect(_tile('p5'), findsOneWidget);
      expect(_tile('p6'), findsNothing);
    });

    testWidgets('a wider window fits twelve on a page', (tester) async {
      await pump(
        tester,
        size: const Size(1440, 960),
        participants: _participants(12),
      );

      expect(find.byType(PageNavigationButton), findsNothing);
    });

    testWidgets('the last page is not stranded when people leave', (
      tester,
    ) async {
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(12),
      );

      await tester.tap(find.byType(PageNavigationButton).last);
      await tester.pumpAndSettle();
      expect(_tile('p6'), findsOneWidget);

      // Everybody on the second page leaves.
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(3),
      );
      await tester.pumpAndSettle();

      expect(_tile('p0'), findsOneWidget);
      expect(find.byType(PageNavigationButton), findsNothing);
    });
  });
}
