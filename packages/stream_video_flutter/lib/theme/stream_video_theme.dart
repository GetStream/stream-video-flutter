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
    StreamCallControlsBarTheme? callControlsBarTheme,
    StreamAvatarTheme? avatarTheme,
    StreamCallParticipantTheme? callParticipantTheme,
  }) {
    final isDark = brightness == Brightness.dark;
    textTheme ??=
        isDark ? const StreamTextTheme.dark() : const StreamTextTheme.light();
    colorTheme ??=
        isDark ? const StreamColorTheme.dark() : const StreamColorTheme.light();

    final defaultTheme = StreamVideoTheme.fromColorAndTextTheme(
      colorTheme,
      textTheme,
    );

    final customizedTheme = defaultTheme.copyWith(
      textTheme: textTheme,
      colorTheme: colorTheme,
      callControlsBarTheme: callControlsBarTheme,
      avatarTheme: avatarTheme,
      callParticipantTheme: callParticipantTheme,
    );

    return defaultTheme.merge(customizedTheme);
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
    required this.callControlsBarTheme,
    required this.avatarTheme,
    required this.callParticipantTheme,
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
      callControlsBarTheme: StreamCallControlsBarTheme.fromColorAndTextTheme(
        colorTheme,
        textTheme,
      ),
      avatarTheme: StreamAvatarTheme(
        borderRadius: BorderRadius.circular(20),
        constraints: const BoxConstraints.tightFor(
          height: 40,
          width: 40,
        ),
        initialsTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: colorTheme.barsBg,
        ),
        selectionColor: colorTheme.accentPrimary,
        selectionThickness: 4,
      ),
      callParticipantTheme: StreamCallParticipantTheme(
        focusedColor: colorTheme.accentPrimary,
        backgroundColor: const Color(0xFF272A30),
        avatarTheme: StreamAvatarTheme(
          constraints: const BoxConstraints.tightFor(
            height: 100,
            width: 100,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          initialsTextStyle: textTheme.title1.copyWith(color: Colors.white),
          selectionColor: colorTheme.accentPrimary,
          selectionThickness: 4,
        ),
        audioLevelIndicatorColor: colorTheme.accentPrimary,
        participantLabelTextStyle:
            textTheme.footnote.copyWith(color: Colors.white),
        disabledMicrophoneColor: colorTheme.accentError,
        enabledMicrophoneColor: Colors.white,
        connectionLevelActiveColor: colorTheme.accentPrimary,
        connectionLevelInactiveColor: Colors.white,
      ),
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

  /// The text themes used in the widgets.
  final StreamTextTheme textTheme;

  /// The color themes used in the widgets.
  final StreamColorTheme colorTheme;

  /// The color themes used in CallControlsView
  final StreamCallControlsBarTheme callControlsBarTheme;

  /// Theme for the user avatar widget.
  final StreamAvatarTheme avatarTheme;

  /// Theme for the call participant widget.
  final StreamCallParticipantTheme callParticipantTheme;

  /// Creates a copy of [StreamVideoTheme] with specified attributes
  /// overridden.
  @override
  StreamVideoTheme copyWith({
    StreamTextTheme? textTheme,
    StreamColorTheme? colorTheme,
    StreamCallControlsBarTheme? callControlsBarTheme,
    StreamAvatarTheme? avatarTheme,
    StreamCallParticipantTheme? callParticipantTheme,
  }) =>
      StreamVideoTheme.raw(
        textTheme: this.textTheme.merge(textTheme),
        colorTheme: this.colorTheme.merge(colorTheme),
        callControlsBarTheme:
            this.callControlsBarTheme.merge(callControlsBarTheme),
        avatarTheme: this.avatarTheme.merge(avatarTheme),
        callParticipantTheme:
            this.callParticipantTheme.merge(callParticipantTheme),
      );

  /// Merge themes
  StreamVideoTheme merge(StreamVideoTheme? other) {
    if (other == null) return this;
    return copyWith(
      textTheme: textTheme.merge(other.textTheme),
      colorTheme: colorTheme.merge(other.colorTheme),
      avatarTheme: avatarTheme.merge(other.avatarTheme),
      callParticipantTheme:
          callParticipantTheme.merge(other.callParticipantTheme),
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
      callControlsBarTheme:
          callControlsBarTheme.lerp(other.callControlsBarTheme, t),
      avatarTheme: avatarTheme.lerp(avatarTheme, t),
      callParticipantTheme: callParticipantTheme.lerp(callParticipantTheme, t),
    );
  }
}
