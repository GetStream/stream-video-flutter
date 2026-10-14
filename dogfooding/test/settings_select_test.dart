import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/widgets/settings_window/settings_select.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  const icons = StreamIcons();

  Future<void> pump(
    WidgetTester tester, {
    required String value,
    IconData? icon,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettingsSelect<String>(
            title: 'Appearance',
            description: 'Choose how the app looks.',
            icon: icon,
            choices: [
              SettingsChoice(
                value: 'light',
                label: 'Light',
                icon: icons.lightMode,
              ),
              const SettingsChoice(value: 'plain', label: 'Plain'),
            ],
            value: value,
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }

  testWidgets("the field shows the selected choice's icon", (tester) async {
    await pump(tester, value: 'light', icon: icons.language);

    expect(find.byIcon(icons.lightMode), findsOneWidget);
    expect(find.byIcon(icons.language), findsNothing);
  });

  testWidgets('a choice without an icon falls back to the field icon', (
    tester,
  ) async {
    await pump(tester, value: 'plain', icon: icons.language);

    expect(find.byIcon(icons.language), findsOneWidget);
  });
}
