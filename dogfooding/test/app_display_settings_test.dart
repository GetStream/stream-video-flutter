import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/app/app_accent_color.dart';
import 'package:flutter_dogfooding/app/app_display_settings.dart';
import 'package:flutter_dogfooding/core/repos/app_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  Future<AppPreferences> preferences([Map<String, Object> values = const {}]) {
    SharedPreferences.setMockInitialValues(values);
    return SharedPreferences.getInstance().then(
      (prefs) => AppPreferences(prefs: prefs),
    );
  }

  group('AppDisplaySettings', () {
    test('follows the device until a language is picked', () async {
      final settings = AppDisplaySettings(preferences: await preferences());

      expect(settings.locale, isNull);
    });

    test('starts on the language picked before', () async {
      final settings = AppDisplaySettings(
        preferences: await preferences({'language_code': 'nl'}),
      );

      expect(settings.locale, const Locale('nl'));
    });

    test('a language no longer offered falls back to the device', () async {
      final settings = AppDisplaySettings(
        preferences: await preferences({'language_code': 'xx'}),
      );

      expect(settings.locale, isNull);
    });

    test('keeps a picked language and tells its listeners', () async {
      final prefs = await preferences();
      final settings = AppDisplaySettings(preferences: prefs);
      var notified = 0;
      settings.addListener(() => notified++);

      await settings.setLocale(const Locale('nl'));

      expect(settings.locale, const Locale('nl'));
      expect(notified, 1);
      expect(prefs.languageCode, 'nl');
    });

    test('going back to the device forgets the language', () async {
      final prefs = await preferences({'language_code': 'nl'});
      final settings = AppDisplaySettings(preferences: prefs);

      await settings.setLocale(null);

      expect(settings.locale, isNull);
      expect(prefs.languageCode, isNull);
    });

    test('follows the device until a theme is picked', () async {
      final settings = AppDisplaySettings(preferences: await preferences());

      expect(settings.themeMode, ThemeMode.system);
    });

    test('keeps a picked theme and tells its listeners', () async {
      final prefs = await preferences();
      final settings = AppDisplaySettings(preferences: prefs);
      var notified = 0;
      settings.addListener(() => notified++);

      await settings.setThemeMode(ThemeMode.dark);

      expect(settings.themeMode, ThemeMode.dark);
      expect(notified, 1);
      expect(prefs.themeMode, ThemeMode.dark);
      expect(
        AppDisplaySettings(preferences: prefs).themeMode,
        ThemeMode.dark,
      );
    });

    test('keeps a picked accent color, and forgets it for blue', () async {
      final prefs = await preferences();
      final settings = AppDisplaySettings(preferences: prefs);
      expect(settings.accentColor, AppAccentColor.blue);

      await settings.setAccentColor(AppAccentColor.violet);
      expect(
        AppDisplaySettings(preferences: prefs).accentColor,
        AppAccentColor.violet,
      );

      await settings.setAccentColor(AppAccentColor.blue);
      expect(prefs.accentColor, AppAccentColor.blue);
    });
  });

  group('AppAccentColor', () {
    test('blue leaves the brand color to the design system', () {
      for (final brightness in Brightness.values) {
        expect(AppAccentColor.blue.brand(brightness), isNull);
      }
    });

    test('a light theme takes the palette as it is', () {
      expect(AppAccentColor.red.brand(Brightness.light), StreamColors.red);
    });

    test('a dark theme runs the palette in reverse', () {
      final brand = AppAccentColor.red.brand(Brightness.dark)!;
      final red = StreamColors.red;

      expect(brand.shade50, red.shade900);
      expect(brand.shade400, red.shade400);
      expect(brand.shade500, red.shade300);
      expect(brand.shade900, red.shade50);
    });
  });
}
