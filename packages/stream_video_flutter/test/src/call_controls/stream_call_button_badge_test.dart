import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';

void main() {
  const child = SizedBox(key: Key('anchor'), width: 40, height: 40);

  StreamErrorBadgeProps badge(WidgetTester tester) =>
      tester.widget<StreamErrorBadge>(find.byType(StreamErrorBadge)).props;

  PositionedDirectional position(WidgetTester tester) =>
      tester.widget<PositionedDirectional>(find.byType(PositionedDirectional));

  group('StreamCallButtonBadge', () {
    testWidgets('draws nothing when showErrorBadge is false', (tester) async {
      await tester.pumpWidget(
        const TestWrapper(
          child: StreamCallButtonBadge(showErrorBadge: false, child: child),
        ),
      );

      // The widget itself is always in the tree — it returns the child
      // unwrapped — so the badge is what has to be absent.
      expect(find.byType(StreamErrorBadge), findsNothing);
      expect(find.byType(Stack), findsNothing);
    });

    testWidgets('takes the design system defaults for a call control', (
      tester,
    ) async {
      await tester.pumpWidget(
        const TestWrapper(
          child: StreamCallButtonBadge(showErrorBadge: true, child: child),
        ),
      );

      expect(badge(tester).style, StreamErrorBadgeStyle.warning);
      expect(badge(tester).size, StreamErrorBadgeSize.sm);
      // Core's badge draws a border by default; a call control's does not.
      expect(badge(tester).showBorder, isFalse);
      expect(position(tester).top, -4);
      expect(position(tester).end, -4);
    });

    testWidgets('resolves the global theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: streamTestTheme().copyWith(
            extensions: [
              StreamTheme.light(),
              StreamVideoTheme.light().copyWith(
                callButtonBadgeTheme: const StreamCallButtonBadgeThemeData(
                  style: StreamCallButtonBadgeStyle(
                    badgeStyle: StreamErrorBadgeStyle.error,
                    overhang: 8,
                  ),
                ),
              ),
            ],
          ),
          home: const StreamCallButtonBadge(
            showErrorBadge: true,
            child: child,
          ),
        ),
      );

      expect(badge(tester).style, StreamErrorBadgeStyle.error);
      expect(position(tester).top, -8);
    });

    testWidgets('merges a local override over the global theme', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: streamTestTheme().copyWith(
            extensions: [
              StreamTheme.light(),
              StreamVideoTheme.light().copyWith(
                callButtonBadgeTheme: const StreamCallButtonBadgeThemeData(
                  style: StreamCallButtonBadgeStyle(
                    badgeStyle: StreamErrorBadgeStyle.error,
                    size: StreamErrorBadgeSize.md,
                  ),
                ),
              ),
            ],
          ),
          home: const StreamCallButtonBadgeTheme(
            data: StreamCallButtonBadgeThemeData(
              style: StreamCallButtonBadgeStyle(size: StreamErrorBadgeSize.xs),
            ),
            child: StreamCallButtonBadge(showErrorBadge: true, child: child),
          ),
        ),
      );

      // The local value wins...
      expect(badge(tester).size, StreamErrorBadgeSize.xs);
      // ...and the global one it did not mention survives.
      expect(badge(tester).style, StreamErrorBadgeStyle.error);
    });

    testWidgets('style beats the theme for the properties it sets', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: streamTestTheme().copyWith(
            extensions: [
              StreamTheme.light(),
              StreamVideoTheme.light().copyWith(
                callButtonBadgeTheme: const StreamCallButtonBadgeThemeData(
                  style: StreamCallButtonBadgeStyle(
                    badgeStyle: StreamErrorBadgeStyle.error,
                    size: StreamErrorBadgeSize.md,
                  ),
                ),
              ),
            ],
          ),
          home: const StreamCallButtonBadge(
            showErrorBadge: true,
            style: StreamCallButtonBadgeStyle(size: StreamErrorBadgeSize.xs),
            child: child,
          ),
        ),
      );

      expect(badge(tester).size, StreamErrorBadgeSize.xs);
      expect(badge(tester).style, StreamErrorBadgeStyle.error);
    });

    testWidgets('the overhang follows the text direction', (tester) async {
      await tester.pumpWidget(
        const TestWrapper(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: StreamCallButtonBadge(showErrorBadge: true, child: child),
          ),
        ),
      );

      // `end` is the left edge under RTL, and the vertical half does not flip.
      final rendered = tester.getTopLeft(find.byType(StreamErrorBadge));
      final anchor = tester.getTopLeft(find.byKey(const Key('anchor')));
      expect(rendered.dx, lessThan(anchor.dx));
      expect(rendered.dy, lessThan(anchor.dy));
    });
  });
}
