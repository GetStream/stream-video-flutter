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

    testWidgets('useSheet overrides the platform', (tester) async {
      await tester.pumpWidget(
        const TestWrapper(platform: .macOS, child: _Menu(useSheet: true)),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(StreamListTile), findsNWidgets(3));
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
  const _Menu({this.useSheet, this.onPicked});

  final bool? useSheet;
  final ValueChanged<String>? onPicked;

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
      sections: [
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
