import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// The SDK barrel re-exports the logger's Finder, which collides with the one
// flutter_test is about.
import 'package:stream_video_flutter/stream_video_flutter.dart' hide Finder;

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

MockCallParticipantState _participant(String id) {
  final participant = MockCallParticipantState();
  when(() => participant.name).thenReturn(id);
  when(() => participant.userId).thenReturn(id);
  when(() => participant.sessionId).thenReturn(id);
  when(() => participant.uniqueParticipantKey).thenReturn(id);
  when(() => participant.isLocal).thenReturn(false);
  return participant;
}

Widget _box(BuildContext _, Call __, CallParticipantState participant) =>
    SizedBox.expand(
      key: ValueKey('tile-${participant.sessionId}'),
      child: const ColoredBox(color: Color(0xFF6E7A8A)),
    );

Finder _tile(String id) => find.byKey(ValueKey('tile-$id'));

void main() {
  // StreamScreenSize reads MediaQuery.sizeOf, so the case's width has to come
  // from the surface itself — a SizedBox inside the default 800x600 one leaves
  // every case laid out at that size and reporting the same breakpoint.
  Future<void> pump(
    WidgetTester tester, {
    required Size size,
    required int barParticipants,
    ParticipantsBarAlignment barAlignment = ParticipantsBarAlignment.bottom,
    StreamCallParticipantsSpotlightStyle? style,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);

    Widget view = CallParticipantsSpotlightView(
      call: MockCall(),
      spotlight: _participant('stage'),
      participants: [
        for (var i = 0; i < barParticipants; i++) _participant('bar$i'),
      ],
      participantBuilder: _box,
      barAlignment: barAlignment,
    );

    if (style != null) {
      view = StreamCallParticipantsSpotlightTheme(
        data: StreamCallParticipantsSpotlightThemeData(style: style),
        child: view,
      );
    }

    return tester.pumpWidget(TestWrapper(child: SizedBox.expand(child: view)));
  }

  group('the stage', () {
    testWidgets('fills what the bar leaves when the view is narrow', (
      tester,
    ) async {
      await pump(tester, size: const Size(400, 656), barParticipants: 1);

      // 8px of padding either side, and the bar's 141 plus the 8 gap below.
      // 507 of height would allow 901 of width at 16:9, so nothing holds it
      // back and it takes all 384.
      expect(
        tester.getSize(_tile('stage')),
        const Size(400 - 16, 656 - 141 - 8),
      );
    });

    testWidgets('fills a tall view rather than keeping 16:9', (tester) async {
      await pump(tester, size: const Size(768, 880), barParticipants: 1);

      // 712 of height allows 1265 of width, well past the 752 there is.
      expect(tester.getSize(_tile('stage')), const Size(752, 880 - 160 - 8));
    });

    testWidgets('stops at 16:9 in a view wider than that', (tester) async {
      await pump(tester, size: const Size(1440, 936), barParticipants: 1);

      // 936 less the bar's 166 and the 8 gap leaves 762, which caps the width
      // at 1354.7 — narrower than the 1424 the padding leaves.
      const height = 936.0 - 166 - 8;
      final stage = tester.getSize(_tile('stage'));
      expect(stage.height, height);
      expect(stage.width, closeTo(height * 16 / 9, 0.01));
    });

    testWidgets('is centred in the room it does not take', (tester) async {
      await pump(tester, size: const Size(1440, 936), barParticipants: 1);

      expect(tester.getCenter(_tile('stage')).dx, 720);
    });

    testWidgets('sits against the bar, not away from it', (tester) async {
      await pump(tester, size: const Size(768, 880), barParticipants: 1);

      // The bar takes its edge and the stage takes the rest, so the only gap
      // between them is the spacing and there is none left over.
      final stage = tester.getRect(_tile('stage'));
      final bar = tester.getRect(_tile('bar0'));

      expect(stage.top, 0);
      expect(bar.top - stage.bottom, 8);
      expect(bar.bottom, 880);
    });

    testWidgets('takes the whole view with an empty bar', (tester) async {
      await pump(tester, size: const Size(400, 656), barParticipants: 0);

      expect(tester.getSize(_tile('stage')), const Size(400 - 16, 656));
    });
  });

  group('the bar', () {
    for (final (size, tileSize) in const <(Size, Size)>[
      (Size(400, 656), Size(188, 141)),
      (Size(768, 880), Size(284, 160)),
      (Size(1440, 936), Size(295, 166)),
    ]) {
      testWidgets('draws ${tileSize}px tiles at ${size.width}px wide', (
        tester,
      ) async {
        await pump(tester, size: size, barParticipants: 2);

        expect(tester.getSize(_tile('bar0')), tileSize);
        expect(tester.getSize(_tile('bar1')), tileSize);
      });
    }

    testWidgets('centres its tiles while they fit', (tester) async {
      await pump(tester, size: const Size(400, 656), barParticipants: 1);

      expect(tester.getCenter(_tile('bar0')).dx, 200);
    });

    testWidgets('bleeds off both edges once they do not', (tester) async {
      await pump(tester, size: const Size(400, 656), barParticipants: 3);

      // 3 × 188 plus two 8px gaps is 580, wider than the 384 the padding
      // leaves, so the row starts flush and scrolls instead of centring.
      expect(tester.getTopLeft(_tile('bar0')).dx, 8);
      final bar = tester.state<ScrollableState>(find.byType(Scrollable));
      expect(bar.position.maxScrollExtent, 580 - 384);
    });

    testWidgets('runs to the edge of the view when it overflows', (
      tester,
    ) async {
      await pump(tester, size: const Size(400, 656), barParticipants: 3);

      // The list itself spans the full width — the padding is its own, so a
      // tile scrolling out slides off the edge rather than stopping 8 short.
      expect(tester.getSize(find.byType(ListView)).width, 400);
    });

    testWidgets('sizes to its tile width when it takes a side', (tester) async {
      await pump(
        tester,
        size: const Size(1024, 624),
        barParticipants: 1,
        barAlignment: ParticipantsBarAlignment.right,
      );

      expect(tester.getSize(_tile('bar0')), const Size(284, 160));
      // The stage keeps the rest: 1024 less the padding, the bar and the gap.
      expect(tester.getSize(_tile('stage')).width, 1024 - 16 - 284 - 8);
    });

    testWidgets('scales down rather than crowding out the stage', (
      tester,
    ) async {
      await pump(tester, size: const Size(400, 300), barParticipants: 1);

      // A third of 300 is 100, so the 141-high tile scales to it.
      expect(tester.getSize(_tile('bar0')).height, 100);
      expect(
        tester.getSize(_tile('bar0')).width,
        closeTo(188 * 100 / 141, 0.01),
      );
    });
  });

  group('the theme', () {
    testWidgets('a local override wins over the default', (tester) async {
      await pump(
        tester,
        size: const Size(400, 656),
        barParticipants: 1,
        style: const StreamCallParticipantsSpotlightStyle(
          compactBarTileSize: Size(120, 90),
        ),
      );

      expect(tester.getSize(_tile('bar0')), const Size(120, 90));
    });

    testWidgets('a partial override leaves the rest alone', (tester) async {
      await pump(
        tester,
        size: const Size(400, 656),
        barParticipants: 1,
        style: const StreamCallParticipantsSpotlightStyle(spacing: 24),
      );

      expect(tester.getSize(_tile('bar0')), const Size(188, 141));
      // The gap grew but the padding did not: the stage loses the extra 16.
      expect(tester.getSize(_tile('stage')).height, 656 - 141 - 24);
    });
  });
}
