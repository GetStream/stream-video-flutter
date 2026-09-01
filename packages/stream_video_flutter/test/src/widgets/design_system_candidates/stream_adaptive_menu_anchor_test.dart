import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';

// Both presentations live above the page — the anchored menu in an Overlay, the
// sheet in a route — and the capture Alchemist uses for the committed CI
// goldens drops overlay content, so an open menu snapshots blank rather than
// failing. Everything here is asserted instead of snapshotted.
void main() {
  group('StreamAdaptiveMenuAnchor', () {
    testWidgets('opens a sheet on Android', (tester) async {
      await tester.pumpWidget(
        // Android happens to be TestWrapper's default, but naming it is what
        // makes this test's pair with the macOS one legible.
        // ignore: avoid_redundant_argument_values
        const TestWrapper(platform: .android, child: _Menu()),
      );

      expect(find.byType(StreamListTile), findsNothing);

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(StreamSheetHeader), findsOneWidget);
      expect(find.byType(StreamListTile), findsNWidgets(3));
      expect(find.byType(StreamContextMenuAction<void>), findsNothing);
    });

    testWidgets('opens a sheet on iOS', (tester) async {
      await tester.pumpWidget(
        const TestWrapper(platform: .iOS, child: _Menu()),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(StreamListTile), findsNWidgets(3));
    });

    testWidgets('opens an anchored menu on macOS', (tester) async {
      await tester.pumpWidget(
        const TestWrapper(platform: .macOS, child: _Menu()),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(StreamContextMenuAction<void>), findsNWidgets(3));
      expect(find.byType(StreamSheetHeader), findsNothing);
      expect(find.byType(StreamListTile), findsNothing);
    });

    // A menu is not always a choice: a list that only shows something — the
    // people already in a call — has no radio indicators and nothing to press.
    for (final platform in [TargetPlatform.android, TargetPlatform.macOS]) {
      final name = platform.name;

      testWidgets('draws a plain row where there is no choice on $name', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestWrapper(
            platform: platform,
            child: const _Menu(
              sections: [
                StreamMenuSection(
                  options: [
                    StreamMenuOption(
                      label: 'Rene',
                      leading: Icon(Icons.person),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        expect(find.text('Rene'), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
        // No choice, so no radio and no heading.
        expect(find.byType(StreamRadioIndicator), findsNothing);
        expect(find.byType(StreamContextMenuHeading), findsNothing);
      });
    }

    // A device menu carries 16px icons, so it keeps the design's row and is
    // not dragged along by the roomier one an avatar list asks for.
    testWidgets('keeps the design row when no override is given', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestWrapper(platform: .macOS, child: _Menu()),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final row = tester.getSize(
        find.byType(StreamContextMenuAction<void>).first,
      );
      expect(row.height, 32);
    });

    // MenuAnchor clips its panel to the panel's own bounds by default, which
    // cuts off the shadow the menu's Material draws outside them — the shadow
    // stops dead along the bottom edge rather than fading out, and raising the
    // elevation changes nothing because the extra shadow is clipped too.
    testWidgets('does not let the panel clip the menu shadow', (tester) async {
      await tester.pumpWidget(
        const TestWrapper(platform: .macOS, child: _Menu()),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(
        tester.widget<MenuAnchor>(find.byType(MenuAnchor)).clipBehavior,
        Clip.none,
      );
    });

    testWidgets('menuElevation reaches the menu', (tester) async {
      await tester.pumpWidget(
        const TestWrapper(
          platform: .macOS,
          child: _Menu(menuElevation: 0),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<StreamContextMenu>(find.byType(StreamContextMenu))
            .elevation,
        0,
      );
    });

    // A selected row's fill is rounded, and running it flush into the sheet's
    // edges looks like a rendering mistake.
    testWidgets('insets sheet rows so a selected fill clears the edges', (
      tester,
    ) async {
      await tester.pumpWidget(
        // Android is TestWrapper's default, but naming it says which
        // presentation this is about.
        // ignore: avoid_redundant_argument_values
        const TestWrapper(platform: .android, child: _Menu()),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final sheet = tester.getRect(find.byType(StreamSheetHeader).first);
      final row = tester.getRect(find.byType(StreamListTile).first);

      expect(row.left - sheet.left, 4);
      expect(sheet.right - row.right, 4);
    });

    testWidgets('useSheet overrides the platform', (tester) async {
      await tester.pumpWidget(
        const TestWrapper(platform: .macOS, child: _Menu(useSheet: true)),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(StreamListTile), findsNWidgets(3));
    });

    // The anchor has to be given loose constraints for a SizedBox inside it to
    // mean anything: TestWrapper's Material is sized to the viewport and hands
    // its child tight constraints.
    Future<double> openMenuUnder(
      WidgetTester tester, {
      required double anchorWidth,
      required bool matchAnchorWidth,
    }) async {
      await tester.pumpWidget(
        TestWrapper(
          platform: TargetPlatform.macOS,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: anchorWidth,
              child: _Menu(matchAnchorWidth: matchAnchorWidth),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      return tester.getSize(find.byType(StreamContextMenu).first).width;
    }

    testWidgets('sizes the menu to its content by default', (tester) async {
      final width = await openMenuUnder(
        tester,
        anchorWidth: 600,
        matchAnchorWidth: false,
      );

      // Content-sized, and capped by the anchor's own maximum.
      expect(width, lessThan(600));
      expect(
        width,
        lessThanOrEqualTo(StreamContextMenuAnchor.defaultConstraints.maxWidth),
      );
    });

    testWidgets('matchAnchorWidth stretches the menu to the anchor', (
      tester,
    ) async {
      final width = await openMenuUnder(
        tester,
        anchorWidth: 600,
        matchAnchorWidth: true,
      );

      expect(width, 600);
    });

    // A field narrower than the row's own 200px minimum: the tight width has
    // to win, or the panel overflows its field.
    testWidgets('matchAnchorWidth holds below the row minimum width', (
      tester,
    ) async {
      final width = await openMenuUnder(
        tester,
        anchorWidth: 160,
        matchAnchorWidth: true,
      );

      expect(width, 160);
    });

    // The presentation is the anchor's business; what the builder sees must not
    // depend on it, or an anchor's caret would rotate on one platform only.
    for (final platform in [TargetPlatform.android, TargetPlatform.macOS]) {
      final name = platform.name;

      testWidgets('reports isOpen to the builder on $name', (tester) async {
        await tester.pumpWidget(
          TestWrapper(platform: platform, child: const _Menu()),
        );

        expect(find.text('closed'), findsOneWidget);

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        expect(find.text('showing'), findsOneWidget);
      });

      testWidgets('closes itself before reporting the choice on $name', (
        tester,
      ) async {
        String? picked;

        await tester.pumpWidget(
          TestWrapper(
            platform: platform,
            child: _Menu(onPicked: (label) => picked = label),
          ),
        );

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Jabra Evolve2 65'));
        await tester.pumpAndSettle();

        expect(picked, 'Jabra Evolve2 65');
        expect(find.text('closed'), findsOneWidget);
      });

      testWidgets('shows every section heading on $name', (tester) async {
        await tester.pumpWidget(
          TestWrapper(platform: platform, child: const _Menu()),
        );

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        expect(find.text('Speaker'), findsOneWidget);
        // 'Microphone' is both the sheet title and a section heading, so it is
        // matched loosely.
        expect(find.text('Microphone'), findsWidgets);
      });
    }
  });
}

/// An anchor over two sections, whose button reports the handle's open state.
class _Menu extends StatelessWidget {
  const _Menu({
    this.useSheet,
    this.onPicked,
    this.matchAnchorWidth = false,
    this.menuElevation,
    this.sections,
  });

  final bool? useSheet;
  final ValueChanged<String>? onPicked;
  final bool matchAnchorWidth;
  final double? menuElevation;
  final List<StreamMenuSection>? sections;

  @override
  Widget build(BuildContext context) {
    StreamMenuOption option(String label, {bool selected = false}) =>
        StreamMenuOption(
          label: label,
          selected: selected,
          onSelected: () => onPicked?.call(label),
        );

    return StreamAdaptiveMenuAnchor(
      title: 'Microphone',
      useSheet: useSheet,
      matchAnchorWidth: matchAnchorWidth,
      menuElevation: menuElevation,
      sections:
          sections ??
          [
            StreamMenuSection(
              heading: 'Microphone',
              options: [
                option('MacBook Pro Microphone', selected: true),
                option('Jabra Evolve2 65'),
              ],
            ),
            StreamMenuSection(
              heading: 'Speaker',
              options: [option('MacBook Pro Speakers', selected: true)],
            ),
          ],
      builder: (context, handle) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(handle.isOpen ? 'showing' : 'closed'),
          TextButton(onPressed: handle.toggle, child: const Text('open')),
        ],
      ),
    );
  }
}
