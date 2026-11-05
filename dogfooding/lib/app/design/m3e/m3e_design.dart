// The split button is only exported through core's experimental video library.
// ignore_for_file: experimental_member_use

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:stream_core_flutter/video.dart'
    show StreamSplitButtonProps, StreamSplitButtonVariant;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../app_accent_color.dart';
import '../app_design_spec.dart';
import '../material_text_input.dart';
import 'm3e_icons.dart';

/// Material 3 Expressive: a tonal palette seeded from the accent, large
/// rounded shapes, the Roboto Flex font and Material's rounded icons, with
/// the m3e component packages' shape-morphing buttons and wavy progress.
class M3EDesign extends AppDesignSpec {
  const M3EDesign();

  @override
  List<String> get packages => const [
    'm3e_collection',
    'dynamic_color',
    'google_fonts',
  ];

  /// Material's baseline seed.
  static const _baselineSeed = Color(0xFF6750A4);

  /// The device's accent color, which the design takes when no accent is
  /// picked, or null on a platform that has none.
  static Color? deviceAccent;

  /// Reads [deviceAccent]: the wallpaper's primary color on Android 12 and
  /// later, the system accent color on macOS, Windows and Linux.
  static Future<void> loadDeviceAccent() async {
    try {
      final palette = await DynamicColorPlugin.getCorePalette();
      if (palette != null) {
        deviceAccent = Color(palette.primary.get(40));
        return;
      }
      deviceAccent = await DynamicColorPlugin.getAccentColor();
    } on PlatformException {
      deviceAccent = null;
    } on MissingPluginException {
      deviceAccent = null;
    }
  }

  /// A picked accent keeps its hue, so its primary matches the swatch. The
  /// device's accent is used as the system uses it. Without either, the
  /// expressive variant shifts the baseline seed's hue for the design's own
  /// colors.
  ColorScheme _materialColorScheme(
    Brightness brightness,
    AppAccentColor accent,
  ) {
    final picked = accent.paletteColor(brightness);
    final device = deviceAccent;
    return ColorScheme.fromSeed(
      seedColor: picked ?? device ?? _baselineSeed,
      brightness: brightness,
      dynamicSchemeVariant: switch ((picked, device)) {
        (_?, _) => DynamicSchemeVariant.fidelity,
        (null, _?) => DynamicSchemeVariant.tonalSpot,
        (null, null) => DynamicSchemeVariant.expressive,
      },
    );
  }

  @override
  Color defaultAccent(Brightness brightness) =>
      _materialColorScheme(brightness, AppAccentColor.designDefault).primary;

  // The tile's 28dp corner is 8dp rounder than the SDK default, so the
  // overflow button moves 8dp in to keep clear of it.
  @override
  StreamParticipantTileThemeData get participantTileTheme =>
      const StreamParticipantTileThemeData(
        style: StreamParticipantTileStyle(
          topToolbarPadding: EdgeInsets.all(8),
        ),
      );

  @override
  StreamTheme streamTheme(Brightness brightness, AppAccentColor accent) {
    final material = _materialColorScheme(brightness, accent);
    final colorScheme = designColorScheme(
      brightness: brightness,
      // The tonal palette is seeded from the accent, so its primary is used
      // whichever accent is picked.
      accent: AppAccentColor.designDefault,
      defaultAccent: material.primary,
      textOnDefaultAccent: material.onPrimary,
      accentError: material.error,
      textPrimary: material.onSurface,
      textSecondary: material.onSurfaceVariant,
      backgroundApp: material.surface,
      backgroundElevation1: material.surfaceContainerLow,
      backgroundSurfaceCard: material.surfaceContainer,
      backgroundSurfaceSubtle: material.surfaceContainerHighest,
      borderDefault: material.outlineVariant,
      borderSubtle: material.outlineVariant,
    );

    return StreamTheme(
      brightness: brightness,
      icons: m3eStreamIcons,
      colorScheme: colorScheme,
      textTheme: designTextTheme(
        colorScheme.textPrimary,
        fontFamily: designGoogleFontsEnabled
            ? GoogleFonts.robotoFlex().fontFamily
            : null,
      ),
      // Expressive shapes run large: 12dp controls, 16-28dp containers.
      radius: const StreamRadius(
        xxs: Radius.circular(8),
        xs: Radius.circular(12),
        sm: Radius.circular(12),
        md: Radius.circular(16),
        lg: Radius.circular(20),
        xl: Radius.circular(28),
        xxl: Radius.circular(28),
        xxxl: Radius.circular(32),
      ),
    );
  }

  @override
  ThemeData materialTheme(
    Brightness brightness,
    AppAccentColor accent,
    StreamTheme streamTheme,
  ) {
    final colorScheme = _materialColorScheme(brightness, accent);
    final base = designMaterialTheme(
      streamTheme,
      materialColorScheme: colorScheme,
      textTheme: designGoogleFontsEnabled
          ? GoogleFonts.robotoFlexTextTheme(
              ThemeData(brightness: brightness).textTheme,
            )
          : null,
    );
    return base.copyWith(extensions: [M3ETheme.defaults(colorScheme)]);
  }

  @override
  StreamComponentBuilders builders(
    Iterable<StreamComponentBuilderExtension<Object>> extensions,
  ) => StreamComponentBuilders(
    button: (context, props) => M3EStreamButton(props: props),
    splitButton: (context, props) => M3EStreamSplitButton(props: props),
    checkbox: (context, props) => Checkbox(
      value: props.value,
      semanticLabel: props.semanticLabel,
      onChanged: switch (props.onChanged) {
        final onChanged? => (value) => onChanged(value ?? false),
        null => null,
      },
    ),
    toggleSwitch: (context, props) => Semantics(
      toggled: props.value,
      label: props.semanticLabel,
      child: Switch(
        value: props.value,
        onChanged: props.onChanged,
        // Expressive switches carry a check on the thumb when on.
        thumbIcon: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? const Icon(Icons.check_rounded)
              : null,
        ),
      ),
    ),
    textInput: (context, props) =>
        MaterialStreamTextInput(props: props, filled: true),
    progressBar: (context, props) => LinearProgressIndicatorM3E(
      value: props.value,
      activeColor: props.fillColor,
      trackColor: props.trackColor,
    ),
    loadingSpinner: (context, props) {
      final dimension = spinnerDimension(props.size);
      return SizedBox.square(
        dimension: dimension,
        child: FittedBox(
          child: switch (props.value) {
            // Without progress to show, the expressive loading indicator
            // morphs between shapes.
            null => LoadingIndicatorM3E(color: props.color),
            final value => CircularProgressIndicatorM3E(
              value: value,
              size: CircularProgressM3ESize.s,
              activeColor: props.color,
              trackColor: props.trackColor,
            ),
          },
        ),
      );
    },
    extensions: extensions,
  );
}

/// The theme for a button in the error color, for the destructive style.
ThemeData _destructiveTheme(ThemeData theme) {
  final colorScheme = theme.colorScheme;
  return theme.copyWith(
    colorScheme: colorScheme.copyWith(
      primary: colorScheme.error,
      onPrimary: colorScheme.onError,
      secondaryContainer: colorScheme.errorContainer,
      onSecondaryContainer: colorScheme.onErrorContainer,
    ),
  );
}

/// A [StreamButton] drawn as an M3E [ButtonM3E] or [IconButtonM3E]: filled
/// for solid primary, tonal for other solid buttons, outlined and standard
/// (text) for the outline and ghost types.
class M3EStreamButton extends StatelessWidget {
  const M3EStreamButton({required this.props, super.key});

  final StreamButtonProps props;

  @override
  Widget build(BuildContext context) {
    final selected = props.isSelected ?? false;
    final enabled = props.onPressed != null;

    final size = props.size.value;
    Widget button;
    if (props.child == null) {
      // Material's own icon buttons, which take the exact size asked for: the
      // m3e icon button pads itself to a tap target, so it would paint smaller
      // than the SDK's when fitted in.
      final icon = props.iconLeft ?? props.iconRight ?? const SizedBox.shrink();
      final style =
          IconButton.styleFrom(
            fixedSize: Size.square(size),
            minimumSize: Size.square(size),
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.standard,
          ).copyWith(
            // Expressive buttons change shape with their state: round while
            // off, a rounded square while on, and squarer still while pressed.
            shape: WidgetStateProperty.resolveWith(
              (states) => switch (states) {
                _ when states.contains(WidgetState.pressed) =>
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size * 0.2),
                  ),
                _ when states.contains(WidgetState.selected) =>
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size * 0.3),
                  ),
                _ => const StadiumBorder(),
              },
            ),
          );
      button = switch ((props.type, props.style)) {
        _ when selected => IconButton.filled(
          onPressed: props.onPressed,
          tooltip: props.tooltip,
          // Only a selected button is a toggle; false would recolor the
          // others as toggles that are off.
          isSelected: selected ? true : null,
          style: style,
          icon: icon,
        ),
        (StreamButtonType.solid, StreamButtonStyle.secondary) =>
          IconButton.filledTonal(
            onPressed: props.onPressed,
            tooltip: props.tooltip,
            // Only a selected button is a toggle; false would recolor the
            // others as toggles that are off.
            isSelected: selected ? true : null,
            style: style,
            icon: icon,
          ),
        (StreamButtonType.solid, _) => IconButton.filled(
          onPressed: props.onPressed,
          tooltip: props.tooltip,
          // Only a selected button is a toggle; false would recolor the
          // others as toggles that are off.
          isSelected: selected ? true : null,
          style: style,
          icon: icon,
        ),
        (StreamButtonType.outline, _) => IconButton.outlined(
          onPressed: props.onPressed,
          tooltip: props.tooltip,
          // Only a selected button is a toggle; false would recolor the
          // others as toggles that are off.
          isSelected: selected ? true : null,
          style: style,
          icon: icon,
        ),
        (StreamButtonType.ghost, _) => IconButton(
          onPressed: props.onPressed,
          tooltip: props.tooltip,
          // Only a selected button is a toggle; false would recolor the
          // others as toggles that are off.
          isSelected: selected ? true : null,
          style: style,
          icon: icon,
        ),
      };
    } else {
      // The m3e buttons come in fixed sizes, the large one taller than the
      // SDK's, so the height is set here. The width is left free, so a button
      // still stretches where the SDK's would.
      button = SizedBox(
        height: size,
        child: ButtonM3E(
          onPressed: props.onPressed ?? () {},
          enabled: enabled,
          selected: selected,
          icon: props.iconLeft,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Flexible(child: props.child!),
              ?props.iconRight,
            ],
          ),
          size: switch (props.size) {
            StreamButtonSize.small => ButtonM3ESize.xs,
            StreamButtonSize.medium => ButtonM3ESize.sm,
            StreamButtonSize.large => ButtonM3ESize.sm,
          },
          style: switch ((props.type, props.style)) {
            (StreamButtonType.solid, StreamButtonStyle.secondary) =>
              ButtonM3EStyle.tonal,
            (StreamButtonType.solid, _) => ButtonM3EStyle.filled,
            (StreamButtonType.outline, _) => ButtonM3EStyle.outlined,
            (StreamButtonType.ghost, _) => ButtonM3EStyle.text,
          },
        ),
      );
      if (props.tooltip case final tooltip?) {
        button = Tooltip(message: tooltip, child: button);
      }
    }

    if (props.style == StreamButtonStyle.destructive) {
      button = Theme(data: _destructiveTheme(Theme.of(context)), child: button);
    }
    return Semantics(
      selected: props.isSelected,
      child: padToTapTarget(context, button),
    );
  }
}

/// A `StreamSplitButton` drawn as the expressive split button: two halves 2dp
/// apart, fully round on the outside and tightly rounded on the inside,
/// tonal, or filled in the error color when destructive.
///
/// The m3e split button opens its own menu, while the SDK's caret half opens
/// the SDK's, so the halves are put together here.
class M3EStreamSplitButton extends StatelessWidget {
  const M3EStreamSplitButton({required this.props, super.key});

  final StreamSplitButtonProps props;

  static const _outer = Radius.circular(20);
  static const _inner = Radius.circular(4);

  @override
  Widget build(BuildContext context) {
    final destructive = props.variant == StreamSplitButtonVariant.destructive;
    final colorScheme = Theme.of(context).colorScheme;
    final height = designSplitButtonHeight;

    Widget half({
      required Widget icon,
      required VoidCallback? onPressed,
      required String? tooltip,
      required BorderRadius borderRadius,
      required double width,
    }) {
      final style = IconButton.styleFrom(
        fixedSize: Size(width, height),
        minimumSize: Size(width, height),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.standard,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        backgroundColor: destructive ? colorScheme.error : null,
        foregroundColor: destructive ? colorScheme.onError : null,
      );
      return destructive
          ? IconButton.filled(
              onPressed: onPressed,
              tooltip: tooltip,
              style: style,
              icon: icon,
            )
          : IconButton.filledTonal(
              onPressed: onPressed,
              tooltip: tooltip,
              style: style,
              icon: icon,
            );
    }

    return designSplitFrame(
      Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          half(
            icon: props.leadingIcon,
            onPressed: props.onLeadingPressed,
            tooltip: props.leadingTooltip,
            borderRadius: const BorderRadius.horizontal(
              left: _outer,
              right: _inner,
            ),
            width: 48,
          ),
          half(
            icon: props.trailingIcon,
            onPressed: props.onTrailingPressed,
            tooltip: props.trailingTooltip,
            borderRadius: const BorderRadius.horizontal(
              left: _inner,
              right: _outer,
            ),
            width: 36,
          ),
        ],
      ),
    );
  }
}
