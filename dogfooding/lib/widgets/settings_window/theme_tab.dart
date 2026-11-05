import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_accent_color.dart';
import '../../app/app_design.dart';
import '../../app/app_display_settings.dart';
import '../../di/injector.dart';
import '../../l10n/localizations/app_localizations.dart';
import 'settings_select.dart';

/// The settings window's theme tab: the design system the app is drawn with,
/// whether it is light, dark or follows the device, and its accent color.
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: context.streamSpacing.xs,
            children: [
              SettingsSelect<AppDesign>(
                title: l10n.designTitle,
                description: l10n.designDescription,
                choices: [
                  for (final design in AppDesign.values)
                    SettingsChoice(value: design, label: design.label(l10n)),
                ],
                value: settings.design,
                onChanged: settings.setDesign,
              ),
              if (settings.design.spec.packages case final packages
                  when packages.isNotEmpty)
                _DesignPackages(packages: packages),
            ],
          ),
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
            design: settings.design,
            value: settings.accentColor,
            onChanged: settings.setAccentColor,
          ),
        ],
      ),
    );
  }
}

/// The pub.dev packages the chosen design is drawn with, each a link to its
/// page.
class _DesignPackages extends StatelessWidget {
  const _DesignPackages({required this.packages});

  final List<String> packages;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final style = context.streamTextTheme.metadataDefault;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '${AppLocalizations.of(context).designPackages} ',
          style: style.copyWith(color: colorScheme.textTertiary),
        ),
        for (final (index, package) in packages.indexed) ...[
          _PackageLink(package: package, style: style),
          if (index < packages.length - 1)
            Text(', ', style: style.copyWith(color: colorScheme.textTertiary)),
        ],
      ],
    );
  }
}

class _PackageLink extends StatelessWidget {
  const _PackageLink({required this.package, required this.style});

  final String package;
  final TextStyle style;

  Future<void> _open() async {
    final url = Uri.https('pub.dev', '/packages/$package');
    try {
      final opened = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!opened) debugPrint('Could not open $url');
    } catch (e) {
      debugPrint('Could not open $url: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.streamColorScheme.accentPrimary;

    return Semantics(
      link: true,
      child: InkWell(
        onTap: _open,
        child: Text(
          package,
          style: style.copyWith(
            color: color,
            decoration: TextDecoration.underline,
            decorationColor: color,
          ),
        ),
      ),
    );
  }
}

/// The palettes the app can take its brand color from, as a row of swatches
/// with the chosen one ringed and named.
class _AccentColorPicker extends StatelessWidget {
  const _AccentColorPicker({
    required this.design,
    required this.value,
    required this.onChanged,
  });

  /// The design the swatches show their colors in.
  final AppDesign design;
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
                design: design,
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
    required this.design,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  static const _size = 24.0;
  static const _ringGap = 2.0;
  static const _ringWidth = 2.0;

  final AppDesign design;
  final AppAccentColor color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final fill = color.swatchColor(colorScheme.brightness, design);
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

extension on AppDesign {
  String label(AppLocalizations l10n) => switch (this) {
    AppDesign.stream => l10n.designStream,
    AppDesign.shad => l10n.designShad,
    AppDesign.yaru => l10n.designYaru,
    AppDesign.fluent => l10n.designFluent,
    AppDesign.liquidGlass => l10n.designLiquidGlass,
    AppDesign.material3Expressive => l10n.designMaterial3Expressive,
  };
}

extension on AppAccentColor {
  String label(AppLocalizations l10n) => switch (this) {
    AppAccentColor.designDefault => l10n.accentColorDefault,
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
