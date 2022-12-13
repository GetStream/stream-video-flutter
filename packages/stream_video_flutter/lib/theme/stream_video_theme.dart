import 'package:flutter/material.dart' hide TextTheme;

import 'themes.dart';

/// {@template streamChatThemeData}
/// Theme data for Stream Chat
/// {@endtemplate}
class StreamVideoThemeData {
  /// Creates a theme from scratch
  factory StreamVideoThemeData({
    Brightness? brightness,
    StreamTextTheme? textTheme,
    StreamColorTheme? colorTheme,
  }) {
    brightness ??= colorTheme?.brightness ?? Brightness.light;
    final isDark = brightness == Brightness.dark;
    textTheme ??= isDark ? StreamTextTheme.dark() : StreamTextTheme.light();
    colorTheme ??= isDark ? StreamColorTheme.dark() : StreamColorTheme.light();

    final defaultData = StreamVideoThemeData.fromColorAndTextTheme(
      colorTheme,
      textTheme,
    );

    final customizedData = defaultData.copyWith();

    return defaultData.merge(customizedData);
  }

  /// Theme initialized with light
  factory StreamVideoThemeData.light() =>
      StreamVideoThemeData(brightness: Brightness.light);

  /// Theme initialized with dark
  factory StreamVideoThemeData.dark() =>
      StreamVideoThemeData(brightness: Brightness.dark);

  /// Raw theme initialization
  const StreamVideoThemeData.raw({
    required this.textTheme,
    required this.colorTheme,
  });

  /// Creates a theme from a Material [Theme]
  factory StreamVideoThemeData.fromTheme(ThemeData theme) {
    final defaultTheme = StreamVideoThemeData(brightness: theme.brightness);
    final customizedTheme = StreamVideoThemeData.fromColorAndTextTheme(
      defaultTheme.colorTheme.copyWith(
        accentPrimary: theme.colorScheme.secondary,
      ),
      defaultTheme.textTheme,
    );
    return defaultTheme.merge(customizedTheme);
  }

  /// Creates a theme from a [StreamColorTheme] and a [StreamTextTheme]
  factory StreamVideoThemeData.fromColorAndTextTheme(
    StreamColorTheme colorTheme,
    StreamTextTheme textTheme,
  ) {
    return StreamVideoThemeData.raw(
      textTheme: textTheme,
      colorTheme: colorTheme,
    );
  }

  /// The text themes used in the widgets
  final StreamTextTheme textTheme;

  /// The color themes used in the widgets
  final StreamColorTheme colorTheme;

  /// Creates a copy of [StreamVideoThemeData] with specified attributes
  /// overridden.
  StreamVideoThemeData copyWith({
    StreamTextTheme? textTheme,
    StreamColorTheme? colorTheme,
  }) =>
      StreamVideoThemeData.raw(
        textTheme: this.textTheme.merge(textTheme),
        colorTheme: this.colorTheme.merge(colorTheme),
      );

  /// Merge themes
  StreamVideoThemeData merge(StreamVideoThemeData? other) {
    if (other == null) return this;
    return copyWith(
      textTheme: textTheme.merge(other.textTheme),
      colorTheme: colorTheme.merge(other.colorTheme),
    );
  }
}
