import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';

void main() {
  const icons = StreamIcons();

  Future<IconData> iconOn(WidgetTester tester, TargetPlatform platform) async {
    late IconData resolved;

    await tester.pumpWidget(
      TestWrapper(
        platform: platform,
        child: Builder(
          builder: (context) {
            resolved = context.streamPresentIcon;
            return const SizedBox();
          },
        ),
      ),
    );

    return resolved;
  }

  testWidgets('is the mobile glyph on Android and iOS', (tester) async {
    expect(
      await iconOn(tester, TargetPlatform.android),
      icons.presentMobileFill,
    );
    expect(await iconOn(tester, TargetPlatform.iOS), icons.presentMobileFill);
  });

  testWidgets('is the desktop glyph everywhere else', (tester) async {
    expect(
      await iconOn(tester, TargetPlatform.macOS),
      icons.presentDesktopFill,
    );
    expect(
      await iconOn(tester, TargetPlatform.windows),
      icons.presentDesktopFill,
    );
    expect(
      await iconOn(tester, TargetPlatform.linux),
      icons.presentDesktopFill,
    );
  });
}
