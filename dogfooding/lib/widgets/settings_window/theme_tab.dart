import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../app/app_display_settings.dart';
import '../../di/injector.dart';
import 'settings_select.dart';

/// The settings window's theme tab: whether the app is light, dark or follows
/// the device.
StreamModalWindowTab themeTab(BuildContext context) => StreamModalWindowTab(
  icon: Icon(context.streamIcons.lightMode),
  label: const Text('Theme'),
  builder: (context) => const _ThemeSettings(),
);

class _ThemeSettings extends StatelessWidget {
  const _ThemeSettings();

  @override
  Widget build(BuildContext context) {
    final settings = locator.get<AppDisplaySettings>();
    final icons = context.streamIcons;

    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => SettingsSelect<ThemeMode>(
        title: 'Appearance',
        description: 'Choose how the app looks.',
        choices: [
          SettingsChoice(
            value: ThemeMode.system,
            label: 'System',
            icon: icons.presentDesktopFill,
          ),
          SettingsChoice(
            value: ThemeMode.light,
            label: 'Light',
            icon: icons.lightMode,
          ),
          SettingsChoice(
            value: ThemeMode.dark,
            label: 'Dark',
            icon: icons.darkMode,
          ),
        ],
        value: settings.themeMode,
        onChanged: settings.setThemeMode,
      ),
    );
  }
}
