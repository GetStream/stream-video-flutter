import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';

void main() {
  Future<void> pumpTabBar(
    WidgetTester tester, {
    required int selectedIndex,
    ValueChanged<int>? onSelected,
  }) {
    return tester.pumpWidget(
      TestWrapper(
        child: SizedBox(
          width: 400,
          child: StreamTabBar(
            selectedIndex: selectedIndex,
            onSelected: onSelected ?? (_) {},
            tabs: const [
              StreamTabBarItem(label: 'Entire Screen'),
              StreamTabBarItem(label: 'Window'),
            ],
          ),
        ),
      ),
    );
  }

  Color labelColorOf(WidgetTester tester, String label) =>
      tester.widget<Text>(find.text(label)).style!.color!;

  group('StreamTabBar', () {
    testWidgets('marks the selected tab with the accent color', (tester) async {
      await pumpTabBar(tester, selectedIndex: 0);

      final colorScheme = StreamTheme.of(
        tester.element(find.text('Entire Screen')),
      ).colorScheme;

      expect(labelColorOf(tester, 'Entire Screen'), colorScheme.accentPrimary);
      expect(labelColorOf(tester, 'Window'), colorScheme.textSecondary);
    });

    testWidgets('reports the index of the tapped tab', (tester) async {
      final tapped = <int>[];
      await pumpTabBar(tester, selectedIndex: 0, onSelected: tapped.add);

      await tester.tap(find.text('Window'));
      await tester.pumpAndSettle();

      expect(tapped, [1]);
    });

    testWidgets('gives every tab an equal share of the width', (tester) async {
      await pumpTabBar(tester, selectedIndex: 0);

      expect(tester.getSize(find.text('Entire Screen')).width, lessThan(200));
      expect(
        tester.getTopLeft(find.text('Window')).dx,
        greaterThanOrEqualTo(200),
      );
    });
  });
}
