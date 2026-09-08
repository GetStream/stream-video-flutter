import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';

// ignore: avoid_implementing_value_types
class _RecordingCanvas extends Mock implements Canvas {}

// The bars are painted rather than laid out, so the only way to see what the
// theme did to them is to replay the painter onto a canvas that remembers.
List<Paint> _paintsOf(WidgetTester tester, {required double at}) {
  final painter = tester.widget<CustomPaint>(find.byType(CustomPaint)).painter!;
  final canvas = _RecordingCanvas();
  painter.paint(canvas, Size.square(at));

  return verify(
    () => canvas.drawLine(captureAny(), captureAny(), captureAny()),
  ).captured.whereType<Paint>().toList();
}

BoxDecoration _decorationOf(WidgetTester tester) {
  final box = tester.widget<DecoratedBox>(
    find
        .descendant(
          of: find.byType(DefaultStreamConnectionQualityIndicator),
          matching: find.byType(DecoratedBox),
        )
        .first,
  );
  return box.decoration as BoxDecoration;
}

Widget _indicator({StreamConnectionQualityIndicatorStyle? style}) {
  final indicator = StreamConnectionQualityIndicator(
    connectionQuality: SfuConnectionQuality.excellent,
  );

  return TestWrapper(
    child: Center(
      child: style == null
          ? indicator
          : StreamConnectionQualityIndicatorTheme(
              data: StreamConnectionQualityIndicatorThemeData(style: style),
              child: indicator,
            ),
    ),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(Offset.zero);
    registerFallbackValue(Paint());
  });

  group('StreamConnectionQualityIndicator', () {
    testWidgets('is a filled circle by default', (tester) async {
      await tester.pumpWidget(_indicator());

      final decoration = _decorationOf(tester);
      expect(decoration.shape, BoxShape.circle);
      expect(
        decoration.color,
        streamTestTheme().extension<StreamTheme>()!
            .colorScheme
            .backgroundOverlayDarkStrong,
      );
    });

    testWidgets('takes its whole decoration from the theme', (tester) async {
      // The point of carrying a decoration rather than a colour: the chip can
      // be reshaped, not just recoloured.
      const decoration = BoxDecoration(
        color: Color(0xFF112233),
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.fromBorderSide(BorderSide(color: Color(0xFFFFFFFF))),
      );

      await tester.pumpWidget(
        _indicator(
          style: const StreamConnectionQualityIndicatorStyle(
            decoration: decoration,
          ),
        ),
      );

      expect(_decorationOf(tester), decoration);
    });

    testWidgets('takes the bar thickness from the theme', (tester) async {
      await tester.pumpWidget(
        _indicator(
          style: const StreamConnectionQualityIndicatorStyle(strokeWidth: 5),
        ),
      );

      final paints = _paintsOf(tester, at: 24);
      expect(paints, hasLength(3));
      expect(paints.map((it) => it.strokeWidth), everyElement(5.0));
    });

    testWidgets('scales the bar thickness with the glyph', (tester) async {
      // The thickness is in the glyph's own 24-unit space, so shrinking the
      // icon thins the bars with it rather than leaving them stubby.
      await tester.pumpWidget(
        _indicator(
          style: const StreamConnectionQualityIndicatorStyle(
            iconSize: 12,
            strokeWidth: 4,
          ),
        ),
      );

      final paints = _paintsOf(tester, at: 12);
      expect(paints.map((it) => it.strokeWidth), everyElement(2.0));
    });

    testWidgets('defaults the bar thickness to 2', (tester) async {
      await tester.pumpWidget(_indicator());

      final paints = _paintsOf(tester, at: 24);
      expect(paints.map((it) => it.strokeWidth), everyElement(2.0));
    });
  });
}
