import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// Not exported from the barrel — the grid is internal to the default call
// content — so it is reached directly.
// ignore: implementation_imports
import 'package:stream_video_flutter/src/call_participants/layout/call_participants_grid_view.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

// The grid's padding only ever reached a page holding a single participant, so
// `StreamCallParticipantsGridThemeData.padding` did nothing in the common case.
// These pin both halves: the padding is applied per page whatever the page
// holds, and the grid reads it from the theme now that the content widget
// stopped threading it down.

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

void main() {
  group('MobileCallParticipantsGrid padding', () {
    // A page holding more than one participant is the case that used to run
    // edge to edge.
    for (final count in [1, 2, 4]) {
      testWidgets('insets a page of $count participants', (tester) async {
        final participants = [
          for (var i = 0; i < count; i++) _participant('p$i'),
        ];

        await tester.pumpWidget(
          TestWrapper(
            child: SizedBox(
              width: 400,
              height: 600,
              child: MobileCallParticipantsGrid(
                call: MockCall(),
                participants: participants,
                itemBuilder: _box,
                padding: const EdgeInsets.all(24),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
            ),
          ),
        );

        final first = tester.getRect(find.byKey(const ValueKey('tile-p0')));
        expect(first.left, 24);
        expect(first.top, 24);
      });
    }
  });

  group('CallParticipantsGridView reads its theme', () {
    testWidgets('takes the padding from StreamCallParticipantsGridTheme', (
      tester,
    ) async {
      final coreTheme = StreamTheme(brightness: Brightness.light);
      final videoTheme = StreamVideoTheme(
        brightness: Brightness.light,
        callParticipantsGridTheme: const StreamCallParticipantsGridThemeData(
          padding: EdgeInsets.all(40),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[coreTheme, videoTheme],
          ),
          home: Material(
            child: SizedBox(
              width: 400,
              height: 600,
              child: CallParticipantsGridView(
                call: MockCall(),
                participants: [_participant('p0')],
                itemBuilder: _box,
              ),
            ),
          ),
        ),
      );

      final first = tester.getRect(find.byKey(const ValueKey('tile-p0')));
      expect(first.left, 40);
      expect(first.top, 40);
    });

    testWidgets('a passed padding beats the theme', (tester) async {
      final coreTheme = StreamTheme(brightness: Brightness.light);
      final videoTheme = StreamVideoTheme(
        brightness: Brightness.light,
        callParticipantsGridTheme: const StreamCallParticipantsGridThemeData(
          padding: EdgeInsets.all(40),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[coreTheme, videoTheme],
          ),
          home: Material(
            child: SizedBox(
              width: 400,
              height: 600,
              child: CallParticipantsGridView(
                call: MockCall(),
                participants: [_participant('p0')],
                itemBuilder: _box,
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ),
      );

      final first = tester.getRect(find.byKey(const ValueKey('tile-p0')));
      expect(first.left, 12);
    });
  });
}
