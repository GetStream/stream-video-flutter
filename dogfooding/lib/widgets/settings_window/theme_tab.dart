import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../app/app_accent_color.dart';
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
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.streamSpacing.xl,
        children: [
          SettingsSelect<ThemeMode>(
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
          _AccentColorPicker(
            value: settings.accentColor,
            onChanged: settings.setAccentColor,
          ),
        ],
      ),
    );
  }
}

/// The palettes the app can take its brand color from, as a row of swatches
/// with the chosen one ringed and named.
class _AccentColorPicker extends StatelessWidget {
  const _AccentColorPicker({required this.value, required this.onChanged});

  final AppAccentColor value;
  final ValueChanged<AppAccentColor> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.streamSpacing.sm,
      children: [
        SettingsHeading(
          title: l10n.accentColorTitle,
          description: l10n.accentColorDescription,
        ),
        Wrap(
          spacing: context.streamSpacing.sm,
          runSpacing: context.streamSpacing.xs,
          children: [
            for (final color in AppAccentColor.values)
              _AccentColorSwatch(
                color: color,
                selected: color == value,
                onTap: () => onChanged(color),
              ),
          ],
        ),
      ],
    );
  }
}

class _AccentColorSwatch extends StatelessWidget {
  const _AccentColorSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  static const _size = 24.0;
  static const _ringGap = 2.0;
  static const _ringWidth = 2.0;

  final AppAccentColor color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final fill = color.swatchColor(colorScheme.brightness);
    final name = color.label(AppLocalizations.of(context));
    const ringed = _size + 2 * (_ringGap + _ringWidth);

    return Semantics(
      button: true,
      selected: selected,
      label: name,
      excludeSemantics: true,
      // The ink response's tap is excluded with the rest, so it is given
      // here again.
      onTap: onTap,
      child: SizedBox(
        width: ringed,
        child: Column(
          spacing: context.streamSpacing.xxs,
          children: [
            InkResponse(
              onTap: onTap,
              customBorder: const CircleBorder(),
              radius: ringed / 2,
              child: Container(
                width: ringed,
                height: ringed,
                padding: const EdgeInsets.all(_ringWidth + _ringGap),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: selected
                      ? Border.all(color: fill, width: _ringWidth)
                      : null,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: fill,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // Only the chosen one is named, but every swatch keeps the room,
            // so the row does not shift as the choice moves. The name may be
            // wider than the swatch, and spills over the gaps beside it.
            SizedBox(
              height:
                  textTheme.metadataDefault.fontSize! *
                  (textTheme.metadataDefault.height ?? 1.2),
              child: OverflowBox(
                maxWidth: double.infinity,
                child: Text(
                  selected ? name : '',
                  maxLines: 1,
                  style: textTheme.metadataDefault.copyWith(
                    color: colorScheme.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on AppAccentColor {
  String label(AppLocalizations l10n) => switch (this) {
    AppAccentColor.blue => l10n.accentColorBlue,
    AppAccentColor.purple => l10n.accentColorPurple,
    AppAccentColor.violet => l10n.accentColorViolet,
    AppAccentColor.red => l10n.accentColorRed,
    AppAccentColor.yellow => l10n.accentColorYellow,
    AppAccentColor.lime => l10n.accentColorLime,
    AppAccentColor.green => l10n.accentColorGreen,
    AppAccentColor.cyan => l10n.accentColorCyan,
  };
}
