import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter_l10n.dart';

import '../../app/app_display_settings.dart';
import '../../di/injector.dart';
import '../../l10n/localizations/app_localizations.dart';
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
  label: const _LanguageTabLabel(),
  builder: (context) => const _LanguageSettings(),
);

class _LanguageTabLabel extends StatelessWidget {
  const _LanguageTabLabel();

  @override
  Widget build(BuildContext context) =>
      Text(AppLocalizations.of(context).languageTab);
}

class _LanguageSettings extends StatelessWidget {
  const _LanguageSettings();

  @override
  Widget build(BuildContext context) {
    final settings = locator.get<AppDisplaySettings>();
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => SettingsSelect<Locale?>(
        title: l10n.languageTitle,
        description: l10n.languageDescription,
        icon: context.streamIcons.translate,
        choices: [
          SettingsChoice(value: null, label: l10n.settingsSystem),
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
