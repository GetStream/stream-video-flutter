import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../app/app_display_settings.dart';
import '../../di/injector.dart';
import '../../l10n/localizations/app_localizations.dart';
import 'settings_select.dart';

/// The settings window's theme tab: whether the app is light, dark or follows
/// the device.
StreamModalWindowTab themeTab(BuildContext context) => StreamModalWindowTab(
  icon: Icon(context.streamIcons.lightMode),
  label: const _ThemeTabLabel(),
  builder: (context) => const _ThemeSettings(),
);

class _ThemeTabLabel extends StatelessWidget {
  const _ThemeTabLabel();

  @override
  Widget build(BuildContext context) =>
      Text(AppLocalizations.of(context).themeTab);
}

class _ThemeSettings extends StatelessWidget {
  const _ThemeSettings();

  @override
  Widget build(BuildContext context) {
    final settings = locator.get<AppDisplaySettings>();
    final icons = context.streamIcons;
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => SettingsSelect<ThemeMode>(
        title: l10n.themeTitle,
        description: l10n.themeDescription,
        choices: [
          SettingsChoice(
            value: ThemeMode.system,
            label: l10n.settingsSystem,
            icon: icons.settings,
          ),
          SettingsChoice(
            value: ThemeMode.light,
            label: l10n.themeLight,
            icon: icons.lightMode,
          ),
          SettingsChoice(
            value: ThemeMode.dark,
            label: l10n.themeDark,
            icon: icons.darkMode,
          ),
        ],
        value: settings.themeMode,
        onChanged: settings.setThemeMode,
      ),
    );
  }
}
