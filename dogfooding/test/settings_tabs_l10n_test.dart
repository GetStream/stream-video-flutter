import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/app/app_display_settings.dart';
import 'package:flutter_dogfooding/core/repos/app_preferences.dart';
import 'package:flutter_dogfooding/di/injector.dart';
import 'package:flutter_dogfooding/l10n/localizations/app_localizations.dart';
import 'package:flutter_dogfooding/widgets/settings_window/language_tab.dart';
import 'package:flutter_dogfooding/widgets/settings_window/theme_tab.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter_l10n.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = AppPreferences(prefs: await SharedPreferences.getInstance());
    locator.registerSingleton(AppDisplaySettings(preferences: prefs));
  });

  tearDown(() => locator.reset());

  Future<void> pump(WidgetTester tester, Locale locale) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...StreamVideoFlutterLocalizations.localizationsDelegates,
        ],
        home: Builder(
          builder: (context) => StreamModalWindow(
            tabs: [themeTab(context), languageTab(context)],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the theme and language tabs follow the app language', (
    tester,
  ) async {
    await pump(tester, const Locale('nl'));

    expect(find.text('Thema'), findsWidgets);
    expect(find.text('Taal'), findsOneWidget);
    expect(find.text('Weergave'), findsOneWidget);
    expect(find.text('Systeem'), findsOneWidget);
  });

  testWidgets('System follows the device with a settings icon', (
    tester,
  ) async {
    await pump(tester, const Locale('en'));

    expect(find.text('System'), findsOneWidget);
    expect(find.byIcon(const StreamIcons().settings), findsOneWidget);
  });
}
