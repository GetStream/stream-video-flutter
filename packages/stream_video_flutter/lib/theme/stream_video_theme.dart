import 'package:flutter/material.dart' hide TextTheme;

import 'themes.dart';

/// {@template streamVideoThemeData}
/// Theme data for Stream Video
/// {@endtemplate}
class StreamVideoTheme extends ThemeExtension<StreamVideoTheme> {
  /// Creates a theme from scratch
  factory StreamVideoTheme({
    required Brightness brightness,
    StreamTextTheme? textTheme,
    StreamColorTheme? colorTheme,
  }) {
    final isDark = brightness == Brightness.dark;
    textTheme ??=
        isDark ? const StreamTextTheme.dark() : const StreamTextTheme.light();
    colorTheme ??=
        isDark ? const StreamColorTheme.dark() : const StreamColorTheme.light();

    return StreamVideoTheme.raw(
      textTheme: textTheme,
      colorTheme: colorTheme,
    );
  }

  /// Theme initialized with light
  factory StreamVideoTheme.light() =>
      StreamVideoTheme(brightness: Brightness.light);

  /// Theme initialized with dark
  factory StreamVideoTheme.dark() =>
      StreamVideoTheme(brightness: Brightness.dark);

  /// Raw theme initialization
  const StreamVideoTheme.raw({
    required this.textTheme,
    required this.colorTheme,
  });

  /// Creates a theme from a Material [Theme]
  factory StreamVideoTheme.fromTheme(ThemeData theme) {
    final defaultTheme = StreamVideoTheme(brightness: theme.brightness);
    final customizedTheme = StreamVideoTheme.fromColorAndTextTheme(
      defaultTheme.colorTheme.copyWith(
        accentPrimary: theme.colorScheme.secondary,
      ),
      defaultTheme.textTheme,
    );
    return defaultTheme.merge(customizedTheme);
  }

  /// Creates a theme from a [StreamColorTheme] and a [StreamTextTheme]
  factory StreamVideoTheme.fromColorAndTextTheme(
    StreamColorTheme colorTheme,
    StreamTextTheme textTheme,
  ) {
    return StreamVideoTheme.raw(
      textTheme: textTheme,
      colorTheme: colorTheme,
    );
  }

  static final StreamVideoTheme _kLightFallbackTheme = StreamVideoTheme.light();
  static final StreamVideoTheme _kDarkFallbackTheme = StreamVideoTheme.dark();

  static StreamVideoTheme of(BuildContext context) {
    final theme = Theme.of(context);
    final streamVideoTheme = theme.extension<StreamVideoTheme>();

    if (streamVideoTheme != null) return streamVideoTheme;
    if (theme.brightness == Brightness.light) return _kLightFallbackTheme;
    return _kDarkFallbackTheme;
  }

  /// The text themes used in the widgets
  final StreamTextTheme textTheme;

  /// The color themes used in the widgets
  final StreamColorTheme colorTheme;

  /// Creates a copy of [StreamVideoTheme] with specified attributes
  /// overridden.
  @override
  StreamVideoTheme copyWith({
    StreamTextTheme? textTheme,
    StreamColorTheme? colorTheme,
  }) =>
      StreamVideoTheme.raw(
        textTheme: this.textTheme.merge(textTheme),
        colorTheme: this.colorTheme.merge(colorTheme),
      );

  /// Merge themes
  StreamVideoTheme merge(StreamVideoTheme? other) {
    if (other == null) return this;
    return copyWith(
      textTheme: textTheme.merge(other.textTheme),
      colorTheme: colorTheme.merge(other.colorTheme),
    );
  }

  @override
  ThemeExtension<StreamVideoTheme> lerp(
      ThemeExtension<StreamVideoTheme>? other, double t) {
    if (other is! StreamVideoTheme) {
      return this;
    }
    return StreamVideoTheme.raw(
      textTheme: textTheme.lerp(other.textTheme, t),
      colorTheme: colorTheme.lerp(other.colorTheme, t),
    );
  }
}
