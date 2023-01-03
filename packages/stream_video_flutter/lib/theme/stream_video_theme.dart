import 'package:flutter/material.dart' hide TextTheme;
import 'package:stream_video_flutter/theme/stream_avatar_theme.dart';

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
    StreamAvatarTheme? avatarTheme,
    StreamParticipantsInfoTheme? participantsInfoTheme,
    StreamInvitableUserListTheme? invitableUserListTheme,
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
      avatarTheme: avatarTheme,
      participantsInfoTheme: participantsInfoTheme,
      invitableUserListTheme: invitableUserListTheme,
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
    required this.avatarTheme,
    required this.participantsInfoTheme,
    required this.invitableUserListTheme,
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
        participantsInfoTheme: StreamParticipantsInfoTheme(
          dividerColor: colorTheme.overlayDark,
          dividerIndent: 16.0,
          dividerHeight: 0.0,
          participantInfoTheme: StreamParticipantInfoTheme(
            usernameTextStyle:
                TextStyle(color: colorTheme.textHighEmphasis, fontSize: 18.0),
            iconActiveColor: colorTheme.highlightDark,
            iconInactiveColor: colorTheme.accentError,
            avatarTheme: StreamAvatarTheme(
                initialsTextStyle: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorTheme.barsBg,
                ),
                constraints: const BoxConstraints(
                  minHeight: 56,
                  minWidth: 56,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(32))),
          ),
        ),
        invitableUserListTheme: StreamInvitableUserListTheme(
          dividerColor: colorTheme.overlayDark,
          dividerIndent: 16.0,
          dividerHeight: 0.0,
          invitableUserTheme: StreamInvitableUserTheme(
            usernameTextStyle:
                TextStyle(color: colorTheme.textHighEmphasis, fontSize: 18.0),
            selectedIconColor: colorTheme.accentPrimary,
            avatarTheme: StreamAvatarTheme(
                initialsTextStyle: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorTheme.barsBg,
                ),
                constraints: const BoxConstraints(
                  minHeight: 56,
                  minWidth: 56,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(32))),
          ),
        ));
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

  /// Theme for the user avatar widget.
  final StreamAvatarTheme avatarTheme;

  /// Theme for the participants info widget.
  final StreamParticipantsInfoTheme participantsInfoTheme;

  /// Theme for the invitable user list widget.
  final StreamInvitableUserListTheme invitableUserListTheme;

  /// Creates a copy of [StreamVideoTheme] with specified attributes
  /// overridden.
  @override
  StreamVideoTheme copyWith({
    StreamTextTheme? textTheme,
    StreamColorTheme? colorTheme,
    StreamAvatarTheme? avatarTheme,
    StreamParticipantsInfoTheme? participantsInfoTheme,
    StreamInvitableUserListTheme? invitableUserListTheme,
  }) =>
      StreamVideoTheme.raw(
        textTheme: this.textTheme.merge(textTheme),
        colorTheme: this.colorTheme.merge(colorTheme),
        avatarTheme: this.avatarTheme.merge(avatarTheme),
        participantsInfoTheme:
            this.participantsInfoTheme.merge(participantsInfoTheme),
        invitableUserListTheme:
            this.invitableUserListTheme.merge(invitableUserListTheme),
      );

  /// Merge themes
  StreamVideoTheme merge(StreamVideoTheme? other) {
    if (other == null) return this;
    return copyWith(
      textTheme: textTheme.merge(other.textTheme),
      colorTheme: colorTheme.merge(other.colorTheme),
      avatarTheme: avatarTheme.merge(other.avatarTheme),
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
      avatarTheme: avatarTheme.lerp(other.avatarTheme, t),
      participantsInfoTheme:
          participantsInfoTheme.lerp(other.participantsInfoTheme, t),
      invitableUserListTheme:
          invitableUserListTheme.lerp(other.invitableUserListTheme, t),
    );
  }
}
