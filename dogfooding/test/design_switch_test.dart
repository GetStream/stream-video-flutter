import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/app/app_accent_color.dart';
import 'package:flutter_dogfooding/app/app_design.dart';
import 'package:flutter_dogfooding/app/app_theme.dart';
import 'package:flutter_dogfooding/app/design/app_design_spec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => designGoogleFontsEnabled = false);

  Widget app(AppDesign design) => MaterialApp(
    theme: buildAppTheme(
      design: design,
      brightness: Brightness.dark,
      accent: AppAccentColor.designDefault,
    ),
    home: const Scaffold(
      body: ExpansionTile(title: Text('Share'), children: [Text('Link')]),
    ),
  );

  for (final from in AppDesign.values) {
    for (final to in AppDesign.values) {
      if (from == to) continue;
      testWidgets('switches from ${from.name} to ${to.name}', (tester) async {
        await tester.pumpWidget(app(from));
        await tester.pumpWidget(app(to));
        for (var i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 50));
          expect(tester.takeException(), isNull);
        }
      });
    }
  }
}
