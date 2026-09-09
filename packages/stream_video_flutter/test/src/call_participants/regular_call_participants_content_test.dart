import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// Neither the content widget nor the grid is exported from the barrel — both
// are internal to the default call content — so they are reached directly.
// ignore: implementation_imports
import 'package:stream_video_flutter/src/call_participants/layout/call_participants_grid_view.dart';
// ignore: implementation_imports
import 'package:stream_video_flutter/src/call_participants/regular_call_participants_content.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

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

void main() {
  // `enableLocalVideo` is passed explicitly throughout: its default reads a
  // platform detector with no test override, so leaving it off would make
  // these depend on the host OS.
  Future<void> pump(
    WidgetTester tester, {
    required ParticipantLayoutMode layoutMode,
    required List<CallParticipantState> participants,
    bool? enableLocalVideo = true,
  }) => tester.pumpWidget(
    TestWrapper(
      child: SizedBox(
        width: 800,
        height: 600,
        child: RegularCallParticipantsContent(
          call: MockCall(),
          participants: participants,
          layoutMode: layoutMode,
          enableLocalVideo: enableLocalVideo,
          callParticipantBuilder: _box,
          // The self-view otherwise falls back to the real participant tile,
          // which asks the mock far more than a layout test cares to stub.
          localVideoParticipantBuilder: _box,
        ),
      ),
    ),
  );

  Iterable<String> gridSessionsOf(WidgetTester tester) => tester
      .widget<CallParticipantsGridView>(find.byType(CallParticipantsGridView))
      .participants
      .map((participant) => participant.sessionId);

  ParticipantsBarAlignment barAlignmentOf(WidgetTester tester) => tester
      .widget<CallParticipantsSpotlightView>(
        find.byType(CallParticipantsSpotlightView),
      )
      .barAlignment;

  group('the four bar layouts', () {
    for (final (mode, alignment)
        in <(ParticipantLayoutMode, ParticipantsBarAlignment)>[
          (.speakerTop, .top),
          (.speakerBottom, .bottom),
          (.speakerLeft, .left),
          (.speakerRight, .right),
        ]) {
      testWidgets('$mode spotlights with the bar $alignment', (tester) async {
        await pump(
          tester,
          layoutMode: mode,
          participants: [
            _participant('remote-1'),
            _participant('remote-2'),
            _participant('local', isLocal: true),
          ],
        );

        expect(find.byType(CallParticipantsSpotlightView), findsOneWidget);
        expect(barAlignmentOf(tester), alignment);

        // Everybody but the spotlight is in the bar, the local participant
        // included: these layouts give them a tile rather than floating them.
        final view = tester.widget<CallParticipantsSpotlightView>(
          find.byType(CallParticipantsSpotlightView),
        );
        expect(view.participants, hasLength(2));
        expect(find.byType(StreamLocalVideo), findsNothing);
      });
    }

    testWidgets('spotlight is still the bottom bar', (tester) async {
      await pump(
        tester,
        // ignore: deprecated_member_use
        layoutMode: ParticipantLayoutMode.spotlight,
        participants: [
          _participant('remote-1'),
          _participant('remote-2'),
          _participant('local', isLocal: true),
        ],
      );

      expect(barAlignmentOf(tester), ParticipantsBarAlignment.bottom);
    });
  });

  group('speakerOneToOne', () {
    testWidgets('shows the speaker alone with the self-view floating', (
      tester,
    ) async {
      await pump(
        tester,
        layoutMode: .speakerOneToOne,
        participants: [
          _participant('remote-1'),
          _participant('remote-2'),
          _participant('local', isLocal: true),
        ],
      );

      final view = tester.widget<CallParticipantsSpotlightView>(
        find.byType(CallParticipantsSpotlightView),
      );
      expect(view.participants, isEmpty);
      expect(find.byType(StreamLocalVideo), findsOneWidget);
    });

    testWidgets('floats the self-view even where the default is off', (
      tester,
    ) async {
      // `enableLocalVideo` defaults to off on desktop, which under this layout
      // used to drop the local participant altogether: the bar is empty, so
      // without the self-view they were nowhere on screen.
      await pump(
        tester,
        layoutMode: .speakerOneToOne,
        enableLocalVideo: null,
        participants: [
          _participant('remote-1'),
          _participant('local', isLocal: true),
        ],
      );

      expect(find.byType(StreamLocalVideo), findsOneWidget);
    });

    testWidgets('still obeys an explicit enableLocalVideo: false', (
      tester,
    ) async {
      await pump(
        tester,
        layoutMode: .speakerOneToOne,
        enableLocalVideo: false,
        participants: [
          _participant('remote-1'),
          _participant('local', isLocal: true),
        ],
      );

      expect(find.byType(StreamLocalVideo), findsNothing);
    });

    testWidgets('spotlights a remote even when the local one sorts first', (
      tester,
    ) async {
      // The speaker sorting can put the local participant first. Spotlighting
      // them would show them twice: full frame and floating.
      await pump(
        tester,
        layoutMode: .speakerOneToOne,
        participants: [
          _participant('local', isLocal: true),
          _participant('remote-1'),
          _participant('remote-2'),
        ],
      );

      final view = tester.widget<CallParticipantsSpotlightView>(
        find.byType(CallParticipantsSpotlightView),
      );
      expect(view.spotlight.sessionId, 'remote-1');
      expect(find.byType(StreamLocalVideo), findsOneWidget);
    });

    testWidgets('spotlights the local participant when alone in the call', (
      tester,
    ) async {
      await pump(
        tester,
        layoutMode: .speakerOneToOne,
        participants: [_participant('local', isLocal: true)],
      );

      final view = tester.widget<CallParticipantsSpotlightView>(
        find.byType(CallParticipantsSpotlightView),
      );
      expect(view.spotlight.sessionId, 'local');
      expect(find.byType(StreamLocalVideo), findsNothing);
    });
  });

  group('grid', () {
    testWidgets('gives the local participant a tile of its own', (
      tester,
    ) async {
      await pump(
        tester,
        layoutMode: .grid,
        participants: [
          _participant('remote-1'),
          _participant('remote-2'),
          _participant('local', isLocal: true),
        ],
      );

      expect(find.byType(CallParticipantsSpotlightView), findsNothing);
      // No self-view on top: it would show the local participant twice.
      expect(find.byType(StreamLocalVideo), findsNothing);
      expect(gridSessionsOf(tester), ['remote-1', 'remote-2', 'local']);
    });
  });

  group('auto', () {
    testWidgets('spotlights the other person in a one-on-one call', (
      tester,
    ) async {
      await pump(
        tester,
        layoutMode: .auto,
        participants: [
          _participant('remote-1'),
          _participant('local', isLocal: true),
        ],
      );

      final view = tester.widget<CallParticipantsSpotlightView>(
        find.byType(CallParticipantsSpotlightView),
      );
      expect(view.spotlight.sessionId, 'remote-1');
      expect(view.participants, isEmpty);
      expect(find.byType(StreamLocalVideo), findsOneWidget);
    });

    testWidgets('falls back to a grid with a floating self-view in a group', (
      tester,
    ) async {
      await pump(
        tester,
        layoutMode: .auto,
        participants: [
          _participant('remote-1'),
          _participant('remote-2'),
          _participant('local', isLocal: true),
        ],
      );

      expect(find.byType(CallParticipantsSpotlightView), findsNothing);
      expect(find.byType(StreamLocalVideo), findsOneWidget);
      // The local participant floats instead of taking a cell in the grid.
      expect(gridSessionsOf(tester), ['remote-1', 'remote-2']);
    });

    testWidgets('keeps everybody in the grid when the self-view is off', (
      tester,
    ) async {
      await pump(
        tester,
        layoutMode: .auto,
        enableLocalVideo: false,
        participants: [
          _participant('remote-1'),
          _participant('remote-2'),
          _participant('local', isLocal: true),
        ],
      );

      expect(find.byType(StreamLocalVideo), findsNothing);
      expect(gridSessionsOf(tester), ['remote-1', 'remote-2', 'local']);
    });

    testWidgets('draws a grid while nobody else has joined', (tester) async {
      await pump(
        tester,
        layoutMode: .auto,
        participants: [_participant('local', isLocal: true)],
      );

      expect(find.byType(CallParticipantsSpotlightView), findsNothing);
      expect(find.byType(StreamLocalVideo), findsNothing);
      expect(gridSessionsOf(tester), ['local']);
    });
  });
}
