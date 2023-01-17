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
    StreamFloatingCallParticipantTheme? floatingCallParticipantTheme,
    StreamParticipantsInfoTheme? participantsInfoTheme,
    StreamParticipantInfoTheme? participantInfoTheme,
    StreamInvitableUserListTheme? invitableUserListTheme,
    StreamInvitableUserTheme? invitableUserTheme,
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
      floatingCallParticipantTheme: floatingCallParticipantTheme,
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
    required this.callControlsBarTheme,
    required this.avatarTheme,
    required this.callParticipantTheme,
    required this.floatingCallParticipantTheme,
    required this.participantsInfoTheme,
    required this.participantInfoTheme,
    required this.invitableUserListTheme,
    required this.invitableUserTheme,
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
      floatingCallParticipantTheme: StreamFloatingCallParticipantTheme(
        streamCallParticipantTheme: StreamCallParticipantTheme(
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
      ),
      participantsInfoTheme: StreamParticipantsInfoTheme(
        dividerColor: colorTheme.overlayDark,
        dividerIndent: 0.0,
        dividerHeight: 0.0,
      ),
      participantInfoTheme: StreamParticipantInfoTheme(
        usernameTextStyle: TextStyle(
          color: colorTheme.textHighEmphasis,
          fontSize: 17.0,
        ),
        iconActiveColor: colorTheme.textHighEmphasis,
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
          borderRadius: const BorderRadius.all(
            Radius.circular(32),
          ),
        ),
      ),
      invitableUserListTheme: StreamInvitableUserListTheme(
        dividerColor: colorTheme.overlayDark,
        dividerIndent: 16.0,
        dividerHeight: 0.0,
      ),
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
          borderRadius: const BorderRadius.all(
            Radius.circular(32),
          ),
        ),
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

  /// Theme for the floating pip call participant widget.
  final StreamFloatingCallParticipantTheme floatingCallParticipantTheme;

  /// Theme for the participants info widget.
  final StreamParticipantsInfoTheme participantsInfoTheme;

  /// Theme for the participant info widget.
  final StreamParticipantInfoTheme participantInfoTheme;

  /// Theme for the invitable user list widget.
  final StreamInvitableUserListTheme invitableUserListTheme;

  /// Theme for the invitable user widget.
  final StreamInvitableUserTheme invitableUserTheme;

  /// Creates a copy of [StreamVideoTheme] with specified attributes
  /// overridden.
  @override
  StreamVideoTheme copyWith({
    StreamTextTheme? textTheme,
    StreamColorTheme? colorTheme,
    StreamCallControlsBarTheme? callControlsBarTheme,
    StreamAvatarTheme? avatarTheme,
    StreamCallParticipantTheme? callParticipantTheme,
    StreamFloatingCallParticipantTheme? floatingCallParticipantTheme,
    StreamParticipantInfoTheme? participantInfoTheme,
    StreamParticipantsInfoTheme? participantsInfoTheme,
    StreamInvitableUserListTheme? invitableUserListTheme,
    StreamInvitableUserTheme? invitableUserTheme,
  }) =>
      StreamVideoTheme.raw(
        textTheme: this.textTheme.merge(textTheme),
        colorTheme: this.colorTheme.merge(colorTheme),
        callControlsBarTheme:
            this.callControlsBarTheme.merge(callControlsBarTheme),
        avatarTheme: this.avatarTheme.merge(avatarTheme),
        callParticipantTheme:
            this.callParticipantTheme.merge(callParticipantTheme),
        participantsInfoTheme:
            this.participantsInfoTheme.merge(participantsInfoTheme),
        floatingCallParticipantTheme: this
            .floatingCallParticipantTheme
            .merge(floatingCallParticipantTheme),
        participantInfoTheme:
            this.participantInfoTheme.merge(participantInfoTheme),
        invitableUserListTheme:
            this.invitableUserListTheme.merge(invitableUserListTheme),
        invitableUserTheme: this.invitableUserTheme.merge(invitableUserTheme),
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
      avatarTheme: avatarTheme.lerp(other.avatarTheme, t),
      callParticipantTheme:
          callParticipantTheme.lerp(other.callParticipantTheme, t),
      floatingCallParticipantTheme: floatingCallParticipantTheme.lerp(
        other.floatingCallParticipantTheme,
        t,
      ),
      callControlsBarTheme:
          callControlsBarTheme.lerp(other.callControlsBarTheme, t),
      participantsInfoTheme:
          participantsInfoTheme.lerp(other.participantsInfoTheme, t),
      participantInfoTheme:
          participantInfoTheme.lerp(other.participantInfoTheme, t),
      invitableUserListTheme:
          invitableUserListTheme.lerp(other.invitableUserListTheme, t),
      invitableUserTheme: invitableUserTheme.lerp(other.invitableUserTheme, t),
    );
  }
}
