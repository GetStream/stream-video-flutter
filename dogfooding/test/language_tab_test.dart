import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/app/app_display_settings.dart';
import 'package:flutter_dogfooding/core/repos/app_preferences.dart';
import 'package:flutter_dogfooding/di/injector.dart';
import 'package:flutter_dogfooding/l10n/localizations/app_localizations.dart';
import 'package:flutter_dogfooding/widgets/settings_window/language_tab.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter_l10n.dart';

void main() {
  late AppDisplaySettings settings;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = AppPreferences(prefs: await SharedPreferences.getInstance());
    settings = AppDisplaySettings(preferences: prefs);
    locator.registerSingleton(settings);
  });

  tearDown(() => locator.reset());

  testWidgets('picking a language from the tab sets the app language', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.macOS),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...StreamVideoFlutterLocalizations.localizationsDelegates,
        ],
        home: Builder(
          builder: (context) => StreamModalWindow(tabs: [languageTab(context)]),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('System'), findsOneWidget);

    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nederlands'));
    await tester.pumpAndSettle();

    expect(settings.locale, const Locale('nl'));
    expect(find.text('Nederlands'), findsOneWidget);
  });
}
