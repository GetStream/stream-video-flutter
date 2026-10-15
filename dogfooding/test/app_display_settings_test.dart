import 'package:flutter/widgets.dart';
import 'package:flutter_dogfooding/app/app_display_settings.dart';
import 'package:flutter_dogfooding/core/repos/app_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  });
}
