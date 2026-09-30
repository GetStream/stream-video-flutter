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

Widget _stageBox(BuildContext _, Call __, CallParticipantState participant) =>
    SizedBox.expand(
      key: ValueKey('stage-${participant.sessionId}'),
      child: const ColoredBox(color: Color(0xFF123456)),
    );

Finder _stageTile(String id) => find.byKey(ValueKey('stage-$id'));

/// The target scale of the [AnimatedScale] around the button carrying [icon].
///
/// The bar's buttons are scaled away rather than taken out, so this reads what
/// the button is meant to be doing without waiting on the animation.
double _buttonScale(WidgetTester tester, IconData icon) => tester
    .widget<AnimatedScale>(
      find
          .ancestor(of: find.byIcon(icon), matching: find.byType(AnimatedScale))
          .first,
    )
    .scale;

double _scrolled(WidgetTester tester) =>
    tester.state<ScrollableState>(find.byType(Scrollable)).position.pixels;

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
    EdgeInsetsGeometry? padding,
    CallParticipantBuilder? spotlightBuilder,
    CallParticipantBuilder participantBuilder = _box,
    TextDirection textDirection = TextDirection.ltr,
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
      participantBuilder: participantBuilder,
      spotlightBuilder: spotlightBuilder,
      barAlignment: barAlignment,
      padding: padding,
    );

    if (style != null) {
      view = StreamCallParticipantsSpotlightTheme(
        data: StreamCallParticipantsSpotlightThemeData(style: style),
        child: view,
      );
    }

    return tester.pumpWidget(
      TestWrapper(
        child: Directionality(
          textDirection: textDirection,
          child: SizedBox.expand(child: view),
        ),
      ),
    );
  }

  group('the stage', () {
    testWidgets('fills what the bar leaves when the view is narrow', (
      tester,
    ) async {
      await pump(tester, size: const Size(400, 656), barParticipants: 1);

      // 8px of padding either side, and the bar's 125 plus the 8 gap below.
      // 523 of height would allow 929 of width at 16:9, so nothing holds it
      // back and it takes all 384.
      expect(
        tester.getSize(_tile('stage')),
        const Size(400 - 16, 656 - 125 - 8),
      );
    });

    testWidgets('fills a tall view rather than keeping 16:9', (tester) async {
      await pump(tester, size: const Size(768, 880), barParticipants: 1);

      // 747 of height allows 1328 of width, well past the 752 there is.
      expect(tester.getSize(_tile('stage')), const Size(752, 880 - 125 - 8));
    });

    testWidgets('stops at 16:9 in a view wider than that', (tester) async {
      await pump(tester, size: const Size(1440, 600), barParticipants: 1);

      // 600 less the bar's 125 and the 8 gap leaves 467, which allows 830 of
      // width — well short of the 1424 the padding leaves, so the cap binds.
      const height = 600.0 - 125 - 8;
      final stage = tester.getSize(_tile('stage'));
      expect(stage.height, height);
      expect(stage.width, closeTo(height * 16 / 9, 0.01));
    });

    testWidgets('is centred in the room it does not take', (tester) async {
      await pump(tester, size: const Size(1440, 600), barParticipants: 1);

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
    for (final size in const [
      Size(400, 656),
      Size(768, 880),
      Size(1440, 936),
    ]) {
      testWidgets('draws the same tiles at ${size.width}px wide', (
        tester,
      ) async {
        await pump(tester, size: size, barParticipants: 2);

        expect(tester.getSize(_tile('bar0')), const Size(222, 125));
        expect(tester.getSize(_tile('bar1')), const Size(222, 125));
      });
    }

    testWidgets('centres its tiles while they fit', (tester) async {
      await pump(tester, size: const Size(400, 656), barParticipants: 1);

      expect(tester.getCenter(_tile('bar0')).dx, 200);
    });

    testWidgets('bleeds off both edges once they do not', (tester) async {
      await pump(tester, size: const Size(400, 656), barParticipants: 3);

      // 3 x 222 plus two 8px gaps is 682, wider than the 384 the padding
      // leaves, so the row starts flush and scrolls instead of centring.
      expect(tester.getTopLeft(_tile('bar0')).dx, 8);
      final bar = tester.state<ScrollableState>(find.byType(Scrollable));
      expect(bar.position.maxScrollExtent, 682 + 16 - 400);
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

      expect(tester.getSize(_tile('bar0')), const Size(222, 125));
      // The stage keeps the rest: 1024 less the padding, the bar and the gap.
      expect(tester.getSize(_tile('stage')).width, 1024 - 16 - 222 - 8);
    });

    testWidgets('scales down rather than crowding out the stage', (
      tester,
    ) async {
      await pump(tester, size: const Size(400, 300), barParticipants: 1);

      // A third of 300 is 100, so the 125-high tile scales to it.
      expect(tester.getSize(_tile('bar0')).height, 100);
      expect(
        tester.getSize(_tile('bar0')).width,
        closeTo(222 * 100 / 125, 0.01),
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
          barTileSize: Size(120, 90),
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

      expect(tester.getSize(_tile('bar0')), const Size(222, 125));
      // The gap grew but the padding did not: the stage loses the extra 16.
      expect(tester.getSize(_tile('stage')).height, 656 - 125 - 24);
    });
  });

  group('the spotlight builder', () {
    testWidgets('builds the stage when one is given', (tester) async {
      await pump(
        tester,
        size: const Size(400, 656),
        barParticipants: 2,
        spotlightBuilder: _stageBox,
      );

      // The stage is the spotlight builder's; the bar is still the other one.
      expect(_stageTile('stage'), findsOneWidget);
      expect(_tile('stage'), findsNothing);
      expect(_tile('bar0'), findsOneWidget);
    });

    testWidgets('falls back to the participant builder', (tester) async {
      await pump(tester, size: const Size(400, 656), barParticipants: 2);

      expect(_tile('stage'), findsOneWidget);
      expect(_stageTile('stage'), findsNothing);
    });
  });

  group('the bar takes the edge it is aligned to', () {
    testWidgets('top', (tester) async {
      await pump(
        tester,
        size: const Size(400, 656),
        barParticipants: 2,
        barAlignment: ParticipantsBarAlignment.top,
      );

      expect(
        tester.getRect(_tile('bar0')).bottom,
        lessThanOrEqualTo(tester.getRect(_tile('stage')).top),
      );
    });

    testWidgets('bottom', (tester) async {
      await pump(
        tester,
        size: const Size(400, 656),
        barParticipants: 2,
        barAlignment: ParticipantsBarAlignment.bottom,
      );

      expect(
        tester.getRect(_tile('bar0')).top,
        greaterThanOrEqualTo(tester.getRect(_tile('stage')).bottom),
      );
    });

    testWidgets('left', (tester) async {
      await pump(
        tester,
        size: const Size(1024, 656),
        barParticipants: 2,
        barAlignment: ParticipantsBarAlignment.left,
      );

      expect(
        tester.getRect(_tile('bar0')).right,
        lessThanOrEqualTo(tester.getRect(_tile('stage')).left),
      );
    });

    testWidgets('right', (tester) async {
      await pump(
        tester,
        size: const Size(1024, 656),
        barParticipants: 2,
        barAlignment: ParticipantsBarAlignment.right,
      );

      expect(
        tester.getRect(_tile('bar0')).left,
        greaterThanOrEqualTo(tester.getRect(_tile('stage')).right),
      );
    });
  });

  group("the bar's scroll buttons", () {
    const overflowing = Size(400, 656);

    Future<void> pumpBar(
      WidgetTester tester, {
      int barParticipants = 5,
      Size size = overflowing,
      ParticipantsBarAlignment barAlignment = ParticipantsBarAlignment.bottom,
      TextDirection textDirection = TextDirection.ltr,
    }) async {
      await pump(
        tester,
        size: size,
        barParticipants: barParticipants,
        barAlignment: barAlignment,
        textDirection: textDirection,
      );
      // The list reports its metrics in a microtask after it lays out, so the
      // buttons come in a frame behind the first one, and then scale up.
      await tester.pumpAndSettle();
    }

    testWidgets('stay away while the tiles fit', (tester) async {
      await pumpBar(tester, barParticipants: 1);

      expect(_buttonScale(tester, StreamIconData.chevronLeft), 0);
      expect(_buttonScale(tester, StreamIconData.chevronRight), 0);
    });

    testWidgets('offer the way on once they do not', (tester) async {
      await pumpBar(tester);

      // Nothing behind the bar to start with, and the rest of it ahead.
      expect(_buttonScale(tester, StreamIconData.chevronLeft), 0);
      expect(_buttonScale(tester, StreamIconData.chevronRight), 1);
    });

    testWidgets('bring the tile cut off at the end to the start', (
      tester,
    ) async {
      await pumpBar(tester);

      await tester.tap(find.byIcon(StreamIconData.chevronRight));
      await tester.pumpAndSettle();

      // The second 222 tile ran from 238 to 460, past the 400 the view is
      // wide. It now starts the 8 of padding in, where the first one did.
      expect(_scrolled(tester), 230);
      expect(tester.getRect(_tile('bar1')).left, 8);
    });

    testWidgets('bring the tile cut off at the start to the end', (
      tester,
    ) async {
      await pumpBar(tester);

      for (var i = 0; i < 2; i++) {
        await tester.tap(find.byIcon(StreamIconData.chevronRight));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.byIcon(StreamIconData.chevronLeft));
      await tester.pumpAndSettle();

      // Two steps on, at 460, the third tile starts the view and the second,
      // at 238 to 460, sits just before it. Back ends that one 8 short of
      // the far edge.
      expect(tester.getRect(_tile('bar1')).right, 392);
    });

    testWidgets('scroll back to the start', (tester) async {
      await pumpBar(tester);

      await tester.tap(find.byIcon(StreamIconData.chevronRight));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(StreamIconData.chevronLeft));
      await tester.pumpAndSettle();

      expect(_scrolled(tester), 0);
    });

    testWidgets('stop at the end rather than overshooting it', (tester) async {
      await pumpBar(tester, barParticipants: 3);

      for (var i = 0; i < 2; i++) {
        await tester.tap(find.byIcon(StreamIconData.chevronRight));
        await tester.pumpAndSettle();
      }

      // 3 x 222 and two 8px gaps is 682, plus the 16 of padding, less the 400
      // the view is wide.
      expect(_scrolled(tester), 298);
    });

    testWidgets('turn around at the end of the bar', (tester) async {
      await pumpBar(tester, barParticipants: 3);

      for (var i = 0; i < 2; i++) {
        await tester.tap(find.byIcon(StreamIconData.chevronRight));
        await tester.pumpAndSettle();
      }

      expect(_buttonScale(tester, StreamIconData.chevronRight), 0);
      expect(_buttonScale(tester, StreamIconData.chevronLeft), 1);
    });

    testWidgets('both show in the middle of the bar', (tester) async {
      await pumpBar(tester);

      await tester.tap(find.byIcon(StreamIconData.chevronRight));
      await tester.pumpAndSettle();

      // 5 tiles run to 1142, so 400 in leaves something either way.
      expect(_buttonScale(tester, StreamIconData.chevronLeft), 1);
      expect(_buttonScale(tester, StreamIconData.chevronRight), 1);
    });

    testWidgets('sit at the ends of the bar, inside it', (tester) async {
      // Both of them, so the one at the start is drawn rather than scaled to
      // nothing — a zero transform leaves it no position to read.
      await pumpBar(tester);
      await tester.tap(find.byIcon(StreamIconData.chevronRight));
      await tester.pumpAndSettle();

      final bar = tester.getRect(find.byType(ListView));
      final back = tester.getCenter(find.byIcon(StreamIconData.chevronLeft));
      final on = tester.getCenter(find.byIcon(StreamIconData.chevronRight));

      // 12 of inset and half of the 40-wide button.
      expect(back.dx - bar.left, 32);
      expect(bar.right - on.dx, 32);
      expect(back.dy, bar.center.dy);
      expect(on.dy, bar.center.dy);
    });

    for (final alignment in const [
      ParticipantsBarAlignment.top,
      ParticipantsBarAlignment.bottom,
    ]) {
      testWidgets('run along a bar aligned ${alignment.name}', (tester) async {
        await pumpBar(tester, barAlignment: alignment);

        expect(_buttonScale(tester, StreamIconData.chevronRight), 1);

        await tester.tap(find.byIcon(StreamIconData.chevronRight));
        await tester.pumpAndSettle();

        expect(_scrolled(tester), 230);
      });
    }

    for (final alignment in const [
      ParticipantsBarAlignment.left,
      ParticipantsBarAlignment.right,
    ]) {
      testWidgets('run up and down a bar aligned ${alignment.name}', (
        tester,
      ) async {
        // 8 tiles of 125 and seven 8px gaps is 1056 against the 656 the view
        // is tall, so 400 of the bar hangs below it.
        await pumpBar(
          tester,
          size: const Size(1024, 656),
          barParticipants: 8,
          barAlignment: alignment,
        );

        expect(_buttonScale(tester, StreamIconData.chevronUp), 0);
        expect(_buttonScale(tester, StreamIconData.chevronDown), 1);

        await tester.tap(find.byIcon(StreamIconData.chevronDown));
        await tester.pumpAndSettle();

        expect(_scrolled(tester), 400);
        expect(_buttonScale(tester, StreamIconData.chevronUp), 1);
        expect(_buttonScale(tester, StreamIconData.chevronDown), 0);
      });
    }

    testWidgets('name themselves for a screen reader', (tester) async {
      // Disposed inline: a tear-down runs after the check that every handle
      // was let go of.
      final semantics = tester.ensureSemantics();

      await pumpBar(tester);

      // Both of them, so the one at the start is named as well as the one on.
      await tester.tap(find.byIcon(StreamIconData.chevronRight));
      await tester.pumpAndSettle();

      // The chevron each label belongs to, so they cannot be the wrong way
      // round, and then the semantics the label actually reaches.
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

    testWidgets('lead the other way when the bar reads right to left', (
      tester,
    ) async {
      await pumpBar(tester, textDirection: TextDirection.rtl);

      // The bar starts at its right-hand edge, so the button pointing further
      // along it is the one on the left.
      expect(_buttonScale(tester, StreamIconData.chevronLeft), 1);
      expect(_buttonScale(tester, StreamIconData.chevronRight), 0);

      await tester.tap(find.byIcon(StreamIconData.chevronLeft));
      await tester.pumpAndSettle();

      // Measured from the right, the second tile now starts where the first
      // did.
      expect(_scrolled(tester), 230);
      expect(400 - tester.getRect(_tile('bar1')).right, 8);
    });

    testWidgets('sit at the ends of a bar that reads right to left', (
      tester,
    ) async {
      await pumpBar(tester, textDirection: TextDirection.rtl);
      await tester.tap(find.byIcon(StreamIconData.chevronLeft));
      await tester.pumpAndSettle();

      // The start is on the right, so the chevron back along the bar is the
      // right-hand one.
      final bar = tester.getRect(find.byType(ListView));
      final back = tester.getCenter(find.byIcon(StreamIconData.chevronRight));
      final on = tester.getCenter(find.byIcon(StreamIconData.chevronLeft));

      expect(bar.right - back.dx, 32);
      expect(on.dx - bar.left, 32);
    });

    testWidgets('sit at the ends of a vertical bar', (tester) async {
      await pumpBar(
        tester,
        size: const Size(1024, 656),
        barParticipants: 8,
        barAlignment: ParticipantsBarAlignment.right,
      );
      await tester.tap(find.byIcon(StreamIconData.chevronDown));
      await tester.pumpAndSettle();

      final bar = tester.getRect(find.byType(ListView));
      final up = tester.getCenter(find.byIcon(StreamIconData.chevronUp));
      final down = tester.getCenter(find.byIcon(StreamIconData.chevronDown));

      expect(up.dy - bar.top, 32);
      expect(bar.bottom - down.dy, 32);
      expect(up.dx, bar.center.dx);
    });

    testWidgets('come in when a participant joins a bar that fit', (
      tester,
    ) async {
      await pumpBar(tester, barParticipants: 1);
      expect(_buttonScale(tester, StreamIconData.chevronRight), 0);

      // Nothing scrolls: the list only changes length.
      await pumpBar(tester);

      expect(_buttonScale(tester, StreamIconData.chevronRight), 1);
    });

    testWidgets('go away when the window grows to fit the bar', (
      tester,
    ) async {
      await pumpBar(tester, barParticipants: 3);
      expect(_buttonScale(tester, StreamIconData.chevronRight), 1);

      await pumpBar(tester, barParticipants: 3, size: const Size(1024, 656));

      expect(_buttonScale(tester, StreamIconData.chevronRight), 0);
    });

    testWidgets('a hidden button lets a tap through to the tile', (
      tester,
    ) async {
      var tapped = 0;
      await pump(
        tester,
        size: overflowing,
        barParticipants: 5,
        participantBuilder: (context, call, participant) => GestureDetector(
          onTap: () => tapped++,
          child: _box(context, call, participant),
        ),
      );
      await tester.pumpAndSettle();

      // Where the back button would be, were there anything before the bar.
      final bar = tester.getRect(find.byType(ListView));
      await tester.tapAt(Offset(bar.left + 32, bar.center.dy));

      expect(tapped, 1);
    });
  });

  group('the padding argument', () {
    testWidgets('overrides the style', (tester) async {
      await pump(
        tester,
        size: const Size(400, 656),
        barParticipants: 1,
        padding: const EdgeInsets.symmetric(horizontal: 24),
      );

      expect(tester.getRect(_tile('stage')).left, 24);
    });

    testWidgets('leaves the style in charge when it is null', (tester) async {
      await pump(
        tester,
        size: const Size(400, 656),
        barParticipants: 1,
        style: const StreamCallParticipantsSpotlightStyle(
          padding: EdgeInsets.symmetric(horizontal: 32),
        ),
      );

      expect(tester.getRect(_tile('stage')).left, 32);
    });
  });
}
