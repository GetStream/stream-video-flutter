import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// Not exported from the barrel — the grid is internal to the default call
// content — so it is reached directly.
// ignore: implementation_imports
import 'package:stream_video_flutter/src/call_participants/layout/call_participants_grid_view.dart';
// ignore: implementation_imports
import 'package:stream_video_flutter/src/call_participants/layout/participants_navigation_button.dart';
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

// The chevrons scale to 0 when there is nowhere to go that way.
List<double> _chevronScales(WidgetTester tester) => tester
    .widgetList<AnimatedScale>(find.byType(AnimatedScale))
    .map((scale) => scale.scale)
    .toList();

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

      expect(find.byType(ParticipantsNavigationButton), findsNothing);
    });

    testWidgets('chevrons once there is a second page', (tester) async {
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(7),
      );

      expect(find.byType(ParticipantsNavigationButton), findsNWidgets(2));
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

      expect(find.byType(ParticipantsNavigationButton), findsNothing);
    });

    testWidgets('the last page is not stranded when people leave', (
      tester,
    ) async {
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(12),
      );

      await tester.tap(find.byType(ParticipantsNavigationButton).last);
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
      expect(find.byType(ParticipantsNavigationButton), findsNothing);
    });

    /// The visual of the [index]th chevron, without the tap target that
    /// reaches past it.
    Rect chevron(WidgetTester tester, int index) => tester
        .getRect(find.byType(ParticipantsNavigationButton).at(index))
        .deflate((kMinInteractiveDimension - 40) / 2);

    testWidgets('a narrow window keeps its width and is overlaid', (
      tester,
    ) async {
      // Three pages of six, moved onto the middle one so both chevrons are
      // drawn — a hidden one is scaled to nothing and has no width to read.
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(18),
      );
      await tester.tap(find.byType(ParticipantsNavigationButton).last);
      await tester.pumpAndSettle();

      // The design draws the chevron 16 in from the view: the grid's own 8 of
      // padding and 8 more inside it. The tiles keep the full width and run
      // underneath.
      expect(chevron(tester, 0).left, 16);
      expect(400 - chevron(tester, 1).right, 16);
      expect(tester.getRect(_tile('p6')).left, 8);
    });

    testWidgets('a wider window sets the grid between the chevrons', (
      tester,
    ) async {
      // Three pages of twelve at this width, again on the middle one.
      await pump(
        tester,
        size: const Size(768, 880),
        participants: _participants(36),
      );
      await tester.tap(find.byType(ParticipantsNavigationButton).last);
      await tester.pumpAndSettle();

      // 8 of padding, the 40 chevron, then 8 before the tiles start.
      final back = chevron(tester, 0);
      expect(back.left, 8);
      expect(back.width, 40);
      expect(768 - chevron(tester, 1).right, 8);
      expect(
        tester.getRect(_tile('p12')).left,
        greaterThanOrEqualTo(back.right + 8),
      );
    });

    testWidgets('the chevrons name themselves for a screen reader', (
      tester,
    ) async {
      // Disposed inline: a tear-down runs after the check that every handle
      // was let go of.
      final semantics = tester.ensureSemantics();

      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(12),
      );

      for (final (icon, label) in [
        (StreamIconData.chevronLeft, 'Previous participants'),
        (StreamIconData.chevronRight, 'Next participants'),
      ]) {
        final button = find.ancestor(
          of: find.byIcon(icon),
          matching: find.byTooltip(label),
        );
        expect(button, findsOneWidget, reason: '$label is on the wrong button');
        expect(tester.getSemantics(button).tooltip, label);
      }

      semantics.dispose();
    });

    testWidgets('a page that comes back is reachable again', (tester) async {
      // Three pages of six, sitting on the last one.
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(18),
      );
      await tester.tap(find.byType(ParticipantsNavigationButton).last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ParticipantsNavigationButton).last);
      await tester.pumpAndSettle();
      expect(_tile('p12'), findsOneWidget);

      // A page's worth leave, taking the page the grid is on, and come back.
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(12),
      );
      await tester.pumpAndSettle();
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(18),
      );
      await tester.pumpAndSettle();

      // Both chevrons live: the grid is on the middle page of three, not
      // stranded on a third page it has no way back from.
      expect(_chevronScales(tester), [1.0, 1.0]);
    });
  });

  group('the resolver details', () {
    testWidgets('describe this page at this breakpoint', (tester) async {
      final seen = <StreamParticipantGridDetails>[];

      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(7),
        theme: StreamCallParticipantsGridThemeData(
          columnResolver: (details) {
            seen.add(details);
            return null;
          },
        ),
      );

      // Six of the seven are on the page being arranged, and the breakpoint
      // is the window's, not the box's.
      expect(seen.first.count, 6);
      expect(seen.first.screenSize, StreamScreenSize.small);
      expect(seen.first.maxTileAspectRatio, 16 / 9);
    });
  });

  group('the theme sizes the pages', () {
    testWidgets('pageSize splits a roomy window', (tester) async {
      await pump(
        tester,
        size: const Size(1440, 960),
        participants: _participants(6),
        theme: const StreamCallParticipantsGridThemeData(pageSize: 4),
      );

      expect(find.byType(ParticipantsNavigationButton), findsNWidgets(2));
      expect(_tile('p3'), findsOneWidget);
      expect(_tile('p4'), findsNothing);
    });

    testWidgets('compactPageSize splits a narrow one', (tester) async {
      await pump(
        tester,
        size: const Size(400, 672),
        participants: _participants(3),
        theme: const StreamCallParticipantsGridThemeData(compactPageSize: 2),
      );

      expect(find.byType(ParticipantsNavigationButton), findsNWidgets(2));
      expect(_tile('p1'), findsOneWidget);
      expect(_tile('p2'), findsNothing);
    });

    testWidgets('maxTileAspectRatio caps the tile', (tester) async {
      await pump(
        tester,
        size: const Size(1440, 960),
        participants: _participants(1),
        theme: const StreamCallParticipantsGridThemeData(
          maxTileAspectRatio: 1,
        ),
      );

      // A square cap on a box wider than it is tall: the tile takes the
      // height and leaves the rest of the width alone.
      final tile = tester.getSize(_tile('p0'));
      expect(tile.width, tile.height);
    });
  });
}
