import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter_l10n.dart';

import '../../app/app_display_settings.dart';
import '../../di/injector.dart';
import 'settings_select.dart';

/// Each language's name in that language, so it can be found whatever the app
/// is shown in.
const _languageNames = {'en': 'English', 'nl': 'Nederlands'};

/// The settings window's language tab: which language the app is shown in.
///
/// Offers every language the SDK is translated into, and following the
/// device.
StreamModalWindowTab languageTab(BuildContext context) => StreamModalWindowTab(
  icon: Icon(context.streamIcons.language),
  label: const Text('Language'),
  builder: (context) => const _LanguageSettings(),
);

class _LanguageSettings extends StatelessWidget {
  const _LanguageSettings();

  @override
  Widget build(BuildContext context) {
    final settings = locator.get<AppDisplaySettings>();

    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => SettingsSelect<Locale?>(
        title: 'Change Language',
        description: 'Select the language used across this demo.',
        icon: context.streamIcons.translate,
        choices: [
          const SettingsChoice(value: null, label: 'System'),
          for (final locale in StreamVideoFlutterLocalizations.supportedLocales)
            SettingsChoice(
              value: locale,
              label: _languageNames[locale.languageCode] ?? locale.toString(),
            ),
        ],
        value: settings.locale,
        onChanged: settings.setLocale,
      ),
    );
  }
}
