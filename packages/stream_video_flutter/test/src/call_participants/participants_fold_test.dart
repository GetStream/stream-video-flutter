import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// The content widget and the grid are internal to the default call content.
// ignore: implementation_imports
import 'package:stream_video_flutter/src/call_participants/regular_call_participants_content.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide Finder;

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

MockCallParticipantState _participant(String id, {bool isLocal = false}) {
  final participant = MockCallParticipantState();
  when(() => participant.name).thenReturn(id);
  when(() => participant.userId).thenReturn(id);
  when(() => participant.sessionId).thenReturn(id);
  when(() => participant.uniqueParticipantKey).thenReturn(id);
  when(() => participant.isLocal).thenReturn(isLocal);
  return participant;
}

Widget _box(BuildContext _, Call __, CallParticipantState participant) =>
    SizedBox.expand(
      key: ValueKey('tile-${participant.sessionId}'),
      child: const ColoredBox(color: Color(0xFF6E7A8A)),
    );

Finder _tile(String id) => find.byKey(ValueKey('tile-$id'));

// The iPhone Duo held as a book: the fold is 475.5 in, and the status rail
// takes the last 84.
const _window = Size(951, 669);
const _bookFold = Rect.fromLTWH(475.5, 0, 0, 669);
const _tabletopFold = Rect.fromLTWH(0, 334.5, 951, 0);

void main() {
  Future<void> pump(
    WidgetTester tester, {
    required List<CallParticipantState> participants,
    Rect fold = _bookFold,
    ParticipantLayoutMode layoutMode = ParticipantLayoutMode.auto,
    EdgeInsets margin = const EdgeInsets.only(right: 84),
    TextDirection textDirection = TextDirection.ltr,
    StreamFoldLayoutStyle? foldStyle,
    StreamFoldLayoutStyle? gridFoldStyle,
    StreamFoldLayoutStyle? spotlightFoldStyle,
  }) async {
    tester.view
      ..physicalSize = _window
      ..devicePixelRatio = 1
      ..displayFeatures = [
        DisplayFeature(
          bounds: fold,
          type: DisplayFeatureType.fold,
          state: DisplayFeatureState.postureHalfOpened,
        ),
      ];
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      TestWrapper(
        child: Directionality(
          textDirection: textDirection,
          child: StreamCallParticipantsGridTheme(
            data: StreamCallParticipantsGridThemeData(
              foldStyle: gridFoldStyle ?? foldStyle,
            ),
            child: StreamCallParticipantsSpotlightTheme(
              data: StreamCallParticipantsSpotlightThemeData(
                foldStyle: spotlightFoldStyle ?? foldStyle,
              ),
              child: Padding(
                padding: margin,
                child: RegularCallParticipantsContent(
                  call: MockCall(),
                  participants: participants,
                  layoutMode: layoutMode,
                  callParticipantBuilder: _box,
                  floatingSelfViewBuilder: _box,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void expectOffFold(WidgetTester tester, Iterable<String> ids, Rect fold) {
    for (final id in ids) {
      final rect = tester.getRect(_tile(id));
      final clear = fold.width == 0 && fold.height > 0
          ? rect.right <= fold.left || rect.left >= fold.right
          : rect.bottom <= fold.top || rect.top >= fold.bottom;
      expect(clear, isTrue, reason: '$id at $rect crosses $fold');
    }
  }

  testWidgets('builds no tiles until the fold is measured', (tester) async {
    await pump(
      tester,
      participants: [_participant('me', isLocal: true), _participant('p1')],
    );

    expect(_tile('me'), findsNothing);

    await tester.pump();

    expect(_tile('me'), findsOneWidget);
    expect(_tile('p1'), findsOneWidget);
  });

  group('book', () {
    testWidgets('puts two participants side by side, centred on the fold', (
      tester,
    ) async {
      await pump(
        tester,
        participants: [_participant('me', isLocal: true), _participant('p1')],
      );
      await tester.pump();

      final me = tester.getRect(_tile('me'));
      final other = tester.getRect(_tile('p1'));

      // The grid's 8 padding and 8 gutter, centred on the fold as in Figma.
      expect(me, const Rect.fromLTRB(92, 8, 471.5, 661));
      expect(other, const Rect.fromLTRB(479.5, 8, 859, 661));
    });

    testWidgets('mirrors in a right-to-left locale', (tester) async {
      await pump(
        tester,
        textDirection: TextDirection.rtl,
        participants: [_participant('me', isLocal: true), _participant('p1')],
      );
      await tester.pump();

      expect(tester.getRect(_tile('me')).left, 479.5);
      expect(tester.getRect(_tile('p1')).right, 471.5);
    });

    testWidgets('gives the first of three a side to themselves', (
      tester,
    ) async {
      await pump(
        tester,
        participants: [
          _participant('p1'),
          _participant('p2'),
          _participant('me', isLocal: true),
        ],
      );
      await tester.pump();

      expectOffFold(tester, ['p1', 'p2', 'me'], _bookFold);
      expect(tester.getRect(_tile('p1')).right, lessThan(_bookFold.left));
      expect(tester.getRect(_tile('p2')).left, greaterThan(_bookFold.left));
      expect(tester.getRect(_tile('me')).left, greaterThan(_bookFold.left));
    });

    testWidgets('waits for others on the other side when alone', (
      tester,
    ) async {
      await pump(tester, participants: [_participant('me', isLocal: true)]);
      await tester.pump();

      expect(tester.getRect(_tile('me')).right, 471.5);
      final waiting = tester.getRect(
        find.byType(StreamWaitingForParticipants),
      );
      expect(waiting.left, 479.5);
    });

    testWidgets('fills a layout that ends at the fold', (tester) async {
      // A panel takes the trailing half, from the fold to the window edge.
      await pump(
        tester,
        margin: const EdgeInsets.only(right: 951 - 475.5),
        participants: [_participant('me', isLocal: true), _participant('p1')],
      );
      await tester.pump();

      expect(find.byType(StreamWaitingForParticipants), findsNothing);
      expectOffFold(tester, ['me', 'p1'], _bookFold);
      expect(tester.getRect(_tile('me')).left, 8);
    });

    testWidgets('lays out as normal with avoidFold off', (tester) async {
      await pump(
        tester,
        foldStyle: const StreamFoldLayoutStyle(avoidFold: false),
        participants: [_participant('me', isLocal: true), _participant('p1')],
      );
      await tester.pump();

      // One-on-one again: the remote full frame, under the floating self.
      expect(tester.getRect(_tile('p1')).width, greaterThan(800));
    });

    testWidgets('keeps one-to-one with avoidFold off for the spotlight', (
      tester,
    ) async {
      await pump(
        tester,
        spotlightFoldStyle: const StreamFoldLayoutStyle(avoidFold: false),
        participants: [_participant('me', isLocal: true), _participant('p1')],
      );
      await tester.pump();

      // The grid still avoids the fold, but auto picks one-on-one: the remote
      // full frame, under the floating self.
      expect(tester.getRect(_tile('p1')).width, greaterThan(800));
    });

    testWidgets('lays the grid out as normal with avoidFold off for the grid', (
      tester,
    ) async {
      await pump(
        tester,
        gridFoldStyle: const StreamFoldLayoutStyle(avoidFold: false),
        participants: [_participant('me', isLocal: true), _participant('p1')],
      );
      await tester.pump();

      // One-on-one would avoid the fold, so auto picks the grid, which then
      // lays out as if there were no fold: the remote fills it, under the
      // floating self.
      expect(tester.getRect(_tile('p1')).width, greaterThan(800));
      expect(_tile('me'), findsOneWidget);
    });

    testWidgets('fills both sides with centerOnFold off', (tester) async {
      await pump(
        tester,
        foldStyle: const StreamFoldLayoutStyle(centerOnFold: false),
        participants: [_participant('me', isLocal: true), _participant('p1')],
      );
      await tester.pump();

      expect(tester.getRect(_tile('me')).left, 8);
      expect(tester.getRect(_tile('p1')).left, 479.5);
    });

    testWidgets('puts the speaker on one side and the bar on the other', (
      tester,
    ) async {
      await pump(
        tester,
        layoutMode: ParticipantLayoutMode.speakerTop,
        participants: [
          _participant('p1'),
          _participant('p2'),
          _participant('me', isLocal: true),
        ],
      );
      await tester.pump();

      expectOffFold(tester, ['p1', 'p2', 'me'], _bookFold);
      expect(tester.getRect(_tile('p1')).right, lessThan(_bookFold.left));
    });

    testWidgets('one-to-one shows the local participant beside the speaker', (
      tester,
    ) async {
      await pump(
        tester,
        layoutMode: ParticipantLayoutMode.speakerOneToOne,
        participants: [_participant('me', isLocal: true), _participant('p1')],
      );
      await tester.pump();

      expect(_tile('me'), findsOneWidget);
      expectOffFold(tester, ['p1', 'me'], _bookFold);
    });
  });

  group('tabletop', () {
    testWidgets('stacks two participants either side of the fold', (
      tester,
    ) async {
      await pump(
        tester,
        fold: _tabletopFold,
        margin: EdgeInsets.zero,
        participants: [_participant('me', isLocal: true), _participant('p1')],
      );
      await tester.pump();

      expectOffFold(tester, ['me', 'p1'], _tabletopFold);
      expect(tester.getRect(_tile('me')).bottom, 330.5);
      expect(tester.getRect(_tile('p1')).top, 338.5);
    });

    testWidgets('puts the first of three above, the others below', (
      tester,
    ) async {
      await pump(
        tester,
        fold: _tabletopFold,
        margin: EdgeInsets.zero,
        participants: [
          _participant('p1'),
          _participant('p2'),
          _participant('me', isLocal: true),
        ],
      );
      await tester.pump();

      expectOffFold(tester, ['p1', 'p2', 'me'], _tabletopFold);
      expect(tester.getRect(_tile('p1')).bottom, lessThan(334.5));
      final p2 = tester.getRect(_tile('p2'));
      final me = tester.getRect(_tile('me'));
      expect(p2.top, greaterThan(334.5));
      expect(me.top, p2.top);
    });
  });
}
