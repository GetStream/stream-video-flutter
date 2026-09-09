import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';

// The menu lives above the page — anchored in an Overlay, or in a sheet route —
// and the capture Alchemist uses for the committed CI goldens drops overlay
// content, so an open menu snapshots blank rather than failing. Everything
// about the open menu is asserted here instead of snapshotted.
void main() {
  // The icons the widget resolves off `context.streamIcons`; the defaults are
  // what TestWrapper's theme installs.
  const icons = StreamIcons();

  group('StreamLayoutButton', () {
    testWidgets('draws the icon of the layout in effect', (tester) async {
      for (final (mode, icon) in <(ParticipantLayoutMode, IconData)>[
        (.auto, icons.gridDefaultFill),
        (.grid, icons.gridFill),
        (.speakerTop, icons.speakerTopFill),
        (.speakerBottom, icons.speakerBottomFill),
        (.speakerLeft, icons.speakerLeftFill),
        (.speakerRight, icons.speakerRightFill),
        (.speakerOneToOne, icons.pipFill),
      ]) {
        await tester.pumpWidget(
          TestWrapper(
            child: StreamLayoutButton(
              layout: mode,
              onLayoutModeChanged: (_) {},
            ),
          ),
        );

        expect(
          find.byIcon(icon),
          findsOneWidget,
          reason: '$mode should draw its own icon',
        );
      }
    });

    testWidgets('draws the deprecated aliases as their replacement', (
      tester,
    ) async {
      for (final (mode, icon) in <(ParticipantLayoutMode, IconData)>[
        // ignore: deprecated_member_use
        (ParticipantLayoutMode.spotlight, icons.speakerBottomFill),
        // ignore: deprecated_member_use
        (ParticipantLayoutMode.pictureInPicture, icons.pipFill),
      ]) {
        await tester.pumpWidget(
          TestWrapper(
            child: StreamLayoutButton(
              layout: mode,
              onLayoutModeChanged: (_) {},
            ),
          ),
        );

        expect(find.byIcon(icon), findsOneWidget, reason: '$mode');
      }
    });

    testWidgets('opens an anchored menu of every layout on macOS', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          platform: .macOS,
          child: StreamLayoutButton(
            layouts: ParticipantLayoutModeX.selectable,
            onLayoutModeChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(StreamContextMenuAction<void>), findsNothing);

      await tester.tap(find.byIcon(icons.gridDefaultFill));
      await tester.pumpAndSettle();

      expect(find.byType(StreamContextMenuAction<void>), findsNWidgets(7));
      for (final label in const [
        'Default',
        'Grid',
        'Speaker (Top)',
        'Speaker (Bottom)',
        'Speaker (Left)',
        'Speaker (Right)',
        'Speaker 1:1',
      ]) {
        expect(find.text(label), findsOneWidget, reason: label);
      }
    });

    testWidgets('opens a sheet headed "Layout" on Android', (tester) async {
      await tester.pumpWidget(
        TestWrapper(
          child: StreamLayoutButton(
            layouts: ParticipantLayoutModeX.selectable,
            onLayoutModeChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byIcon(icons.gridDefaultFill));
      await tester.pumpAndSettle();

      expect(find.byType(StreamSheetHeader), findsOneWidget);
      expect(find.text('Layout'), findsOneWidget);
      expect(find.byType(StreamListTile), findsNWidgets(7));
    });

    testWidgets('marks the row of the layout in effect on the sheet', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          child: StreamLayoutButton(
            layout: .speakerLeft,
            layouts: ParticipantLayoutModeX.selectable,
            onLayoutModeChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byIcon(icons.speakerLeftFill).first);
      await tester.pumpAndSettle();

      final selected = tester
          .widgetList<StreamListTile>(find.byType(StreamListTile))
          .where((tile) => tile.props.selected)
          .toList();

      expect(selected, hasLength(1));
      expect(
        find.descendant(
          of: find.byWidget(selected.single),
          matching: find.text('Speaker (Left)'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('fills the row of the layout in effect in the anchored menu', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          platform: .macOS,
          child: StreamLayoutButton(
            layout: .grid,
            layouts: ParticipantLayoutModeX.selectable,
            onLayoutModeChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byIcon(icons.gridFill).first);
      await tester.pumpAndSettle();

      final backgroundSelected = tester
          .element(find.byType(StreamLayoutButton))
          .streamColorScheme
          .backgroundSelected;

      final filled = tester
          .widgetList<TextButton>(
            find.descendant(
              of: find.byType(StreamContextMenuAction<void>),
              matching: find.byType(TextButton),
            ),
          )
          .where(
            (button) =>
                button.style?.backgroundColor?.resolve(const {}) ==
                backgroundSelected,
          );

      expect(filled, hasLength(1));

      // The fill must not cost the row the design's metrics: the selected row
      // re-themes the action, and a theme that dropped the anchor's own would
      // leave it taller and wider than its siblings.
      expect(
        filled.single.style?.minimumSize?.resolve(const {}),
        const Size(200, 32),
      );
    });

    testWidgets('reports the picked layout and closes', (tester) async {
      final picked = <ParticipantLayoutMode>[];

      await tester.pumpWidget(
        TestWrapper(
          platform: .macOS,
          child: StreamLayoutButton(
            layouts: ParticipantLayoutModeX.selectable,
            onLayoutModeChanged: picked.add,
          ),
        ),
      );

      await tester.tap(find.byIcon(icons.gridDefaultFill));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Speaker (Right)'));
      await tester.pumpAndSettle();

      expect(picked, [ParticipantLayoutMode.speakerRight]);
      expect(find.byType(StreamContextMenuAction<void>), findsNothing);
    });

    testWidgets('offers only the layouts it was given', (tester) async {
      await tester.pumpWidget(
        TestWrapper(
          platform: .macOS,
          child: StreamLayoutButton(
            layouts: const [.grid, .speakerOneToOne, .auto],
            onLayoutModeChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byIcon(icons.gridDefaultFill));
      await tester.pumpAndSettle();

      expect(find.byType(StreamContextMenuAction<void>), findsNWidgets(3));
      expect(find.text('Grid'), findsOneWidget);
      expect(find.text('Speaker (Top)'), findsNothing);
    });

    group('with two layouts', () {
      testWidgets('toggles instead of opening a menu', (tester) async {
        final picked = <ParticipantLayoutMode>[];

        await tester.pumpWidget(
          TestWrapper(
            platform: .macOS,
            child: StreamLayoutButton(onLayoutModeChanged: picked.add),
          ),
        );

        // The default pair, and the default layout is the first of them.
        expect(find.byIcon(icons.gridDefaultFill), findsOneWidget);

        await tester.tap(find.byIcon(icons.gridDefaultFill));
        await tester.pumpAndSettle();

        expect(picked, [ParticipantLayoutMode.speakerBottom]);
        expect(find.byType(StreamContextMenuAction<void>), findsNothing);
        expect(find.byType(StreamListTile), findsNothing);
      });

      testWidgets('toggles back from the second layout', (tester) async {
        final picked = <ParticipantLayoutMode>[];

        await tester.pumpWidget(
          TestWrapper(
            child: StreamLayoutButton(
              layout: .speakerBottom,
              onLayoutModeChanged: picked.add,
            ),
          ),
        );

        await tester.tap(find.byIcon(icons.speakerBottomFill));
        await tester.pumpAndSettle();

        expect(picked, [ParticipantLayoutMode.auto]);
      });

      testWidgets('moves to the first entry from a layout outside the pair', (
        tester,
      ) async {
        final picked = <ParticipantLayoutMode>[];

        await tester.pumpWidget(
          TestWrapper(
            child: StreamLayoutButton(
              layout: .speakerLeft,
              onLayoutModeChanged: picked.add,
            ),
          ),
        );

        // Still draws what is actually in effect, not something from the pair.
        expect(find.byIcon(icons.speakerLeftFill), findsOneWidget);

        await tester.tap(find.byIcon(icons.speakerLeftFill));
        await tester.pumpAndSettle();

        expect(picked, [ParticipantLayoutMode.auto]);
      });

      testWidgets('is disabled when its one layout is already in effect', (
        tester,
      ) async {
        await tester.pumpWidget(
          TestWrapper(
            child: StreamLayoutButton(
              layout: .grid,
              layouts: const [.grid],
              onLayoutModeChanged: (_) {},
            ),
          ),
        );

        expect(
          tester
              .widget<CallControlButton>(find.byType(CallControlButton))
              .onPressed,
          isNull,
        );
      });
    });

    testWidgets('is disabled when it has no layouts to offer', (tester) async {
      await tester.pumpWidget(
        TestWrapper(
          child: StreamLayoutButton(
            layouts: const [],
            onLayoutModeChanged: (_) {},
          ),
        ),
      );

      expect(
        tester.widget<CallControlButton>(find.byType(CallControlButton))
            .onPressed,
        isNull,
      );
    });
  });
}
