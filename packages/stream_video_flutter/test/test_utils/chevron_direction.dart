import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide Finder;

/// Whether the left or right chevron under [finder] is drawn pointing left.
///
/// Core's chevrons mirror themselves under RTL, so the glyph alone does not
/// say which way it points: a right chevron that [Icon] mirrors points left.
bool chevronPointsLeft(WidgetTester tester, Finder finder) {
  final icon = find.descendant(
    of: finder,
    matching: find.byType(Icon),
    matchRoot: true,
  );
  final glyph = tester.widget<Icon>(icon).icon;
  expect(
    glyph,
    anyOf(StreamIconData.chevronLeft, StreamIconData.chevronRight),
    reason: 'Not a left or right chevron.',
  );
  final mirrored = find
      .descendant(of: icon, matching: find.byType(Transform))
      .evaluate()
      .isNotEmpty;
  return (glyph == StreamIconData.chevronLeft) != mirrored;
}
