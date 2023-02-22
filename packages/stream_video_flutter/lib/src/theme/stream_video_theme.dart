import 'package:flutter/material.dart' hide TextTheme;

import '../utils/device_segmentation.dart';
import 'incoming_outgoing_call_theme.dart';
import 'lobby_view_theme.dart';
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
    StreamCallControlsThemeData? callControlsTheme,
    StreamUserAvatarThemeData? userAvatarTheme,
    StreamLobbyViewThemeData? lobbyViewTheme,
    StreamCallParticipantThemeData? callParticipantTheme,
    StreamFloatingCallParticipantThemeData? floatingCallParticipantTheme,
    StreamParticipantsInfoTheme? participantsInfoTheme,
    StreamParticipantInfoTheme? participantInfoTheme,
    StreamInvitableUserListTheme? invitableUserListTheme,
    StreamInvitableUserTheme? invitableUserTheme,
    StreamIncomingOutgoingCallThemeData? incomingCallTheme,
    StreamIncomingOutgoingCallThemeData? outgoingCallTheme,
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
      callControlsTheme: callControlsTheme,
      userAvatarTheme: userAvatarTheme,
      lobbyViewTheme: lobbyViewTheme,
      callParticipantTheme: callParticipantTheme,
      floatingCallParticipantTheme: floatingCallParticipantTheme,
      participantsInfoTheme: participantsInfoTheme,
      participantInfoTheme: participantInfoTheme,
      invitableUserListTheme: invitableUserListTheme,
      invitableUserTheme: invitableUserTheme,
      incomingCallTheme: incomingCallTheme,
      outgoingCallTheme: outgoingCallTheme,
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
    required this.callControlsTheme,
    required this.userAvatarTheme,
    required this.lobbyViewTheme,
    required this.callParticipantTheme,
    required this.floatingCallParticipantTheme,
    required this.participantsInfoTheme,
    required this.participantInfoTheme,
    required this.invitableUserListTheme,
    required this.invitableUserTheme,
    required this.incomingCallTheme,
    required this.outgoingCallTheme,
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
      callControlsTheme: StreamCallControlsThemeData(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        backgroundColor: colorTheme.appBg,
        elevation: 8,
        padding: EdgeInsets.all(14),
        spacing: 10,
        optionIconColor: Colors.black,
        inactiveOptionIconColor: Colors.black,
        optionElevation: 2,
        inactiveOptionElevation: 2,
        optionBackgroundColor: Colors.white,
        inactiveOptionBackgroundColor: Colors.white,
        optionShape: CircleBorder(),
        optionPadding: EdgeInsets.all(16),
      ),
      userAvatarTheme: StreamUserAvatarThemeData(
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
      lobbyViewTheme: StreamLobbyViewThemeData(
        backgroundColor: Colors.white,
        cardBackgroundColor: const Color(0xFFF2F2F2),
        userAvatarTheme: StreamUserAvatarThemeData(
          constraints: const BoxConstraints.tightFor(
            height: 100,
            width: 100,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          initialsTextStyle: textTheme.title1.copyWith(color: Colors.white),
          selectionColor: colorTheme.accentPrimary,
          selectionThickness: 4,
        ),
      ),
      callParticipantTheme: StreamCallParticipantThemeData(
        showDominantSpeakerBorder: true,
        borderRadius: isDesktopDevice
            ? const BorderRadius.all(Radius.circular(12))
            : BorderRadius.zero,
        dominantSpeakerBorderColor: colorTheme.accentInfo,
        dominantSpeakerBorderThickness: 4,
        backgroundColor: const Color(0xFF272A30),
        userAvatarTheme: StreamUserAvatarThemeData(
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
      floatingCallParticipantTheme: StreamFloatingCallParticipantThemeData(
        streamCallParticipantTheme: StreamCallParticipantThemeData(
          showDominantSpeakerBorder: false,
          backgroundColor: const Color(0xFF272A30),
          userAvatarTheme: StreamUserAvatarThemeData(
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
        userAvatarTheme: StreamUserAvatarThemeData(
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
        userAvatarTheme: StreamUserAvatarThemeData(
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
      incomingCallTheme: StreamIncomingOutgoingCallThemeData(
        singleParticipantAvatarTheme: StreamUserAvatarThemeData(
          initialsTextStyle: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: colorTheme.barsBg,
          ),
          constraints: const BoxConstraints(
            minHeight: 160,
            minWidth: 160,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(80),
          ),
        ),
        multipleParticipantAvatarTheme: StreamUserAvatarThemeData(
          initialsTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colorTheme.barsBg,
          ),
          constraints: const BoxConstraints(
            minHeight: 80,
            minWidth: 80,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        singleParticipantTextStyle: TextStyle(
          fontSize: 28,
          color: colorTheme.barsBg,
          fontWeight: FontWeight.bold,
        ),
        multipleParticipantTextStyle: TextStyle(
          fontSize: 20,
          color: colorTheme.barsBg,
        ),
        callingLabelTextStyle: TextStyle(
          fontSize: 20,
          color: colorTheme.barsBg.withOpacity(0.6),
          fontWeight: FontWeight.bold,
        ),
      ),
      outgoingCallTheme: StreamIncomingOutgoingCallThemeData(
        singleParticipantAvatarTheme: StreamUserAvatarThemeData(
          initialsTextStyle: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: colorTheme.barsBg,
          ),
          constraints: const BoxConstraints(
            minHeight: 160,
            minWidth: 160,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(80),
          ),
        ),
        multipleParticipantAvatarTheme: StreamUserAvatarThemeData(
          initialsTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colorTheme.barsBg,
          ),
          constraints: const BoxConstraints(
            minHeight: 80,
            minWidth: 80,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        singleParticipantTextStyle: TextStyle(
          fontSize: 28,
          color: colorTheme.barsBg,
          fontWeight: FontWeight.bold,
        ),
        multipleParticipantTextStyle: TextStyle(
          fontSize: 20,
          color: colorTheme.barsBg,
        ),
        callingLabelTextStyle: TextStyle(
          fontSize: 20,
          color: colorTheme.barsBg.withOpacity(0.6),
          fontWeight: FontWeight.bold,
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
  final StreamCallControlsThemeData callControlsTheme;

  /// Theme for the user avatar widget.
  final StreamUserAvatarThemeData userAvatarTheme;

  /// Theme for the pre-joining view widget.
  final StreamLobbyViewThemeData lobbyViewTheme;

  /// Theme for the call participant widget.
  final StreamCallParticipantThemeData callParticipantTheme;

  /// Theme for the floating pip call participant widget.
  final StreamFloatingCallParticipantThemeData floatingCallParticipantTheme;

  /// Theme for the participants info widget.
  final StreamParticipantsInfoTheme participantsInfoTheme;

  /// Theme for the participant info widget.
  final StreamParticipantInfoTheme participantInfoTheme;

  /// Theme for the invitable user list widget.
  final StreamInvitableUserListTheme invitableUserListTheme;

  /// Theme for the invitable user widget.
  final StreamInvitableUserTheme invitableUserTheme;

  /// Theme for the outgoing call widget.
  final StreamIncomingOutgoingCallThemeData incomingCallTheme;

  /// Theme for the outgoing call widget.
  final StreamIncomingOutgoingCallThemeData outgoingCallTheme;

  /// Creates a copy of [StreamVideoTheme] with specified attributes
  /// overridden.
  @override
  StreamVideoTheme copyWith({
    StreamTextTheme? textTheme,
    StreamColorTheme? colorTheme,
    StreamCallControlsThemeData? callControlsTheme,
    StreamUserAvatarThemeData? userAvatarTheme,
    StreamLobbyViewThemeData? lobbyViewTheme,
    StreamCallParticipantThemeData? callParticipantTheme,
    StreamFloatingCallParticipantThemeData? floatingCallParticipantTheme,
    StreamParticipantInfoTheme? participantInfoTheme,
    StreamParticipantsInfoTheme? participantsInfoTheme,
    StreamInvitableUserListTheme? invitableUserListTheme,
    StreamInvitableUserTheme? invitableUserTheme,
    StreamIncomingOutgoingCallThemeData? incomingCallTheme,
    StreamIncomingOutgoingCallThemeData? outgoingCallTheme,
  }) =>
      StreamVideoTheme.raw(
        textTheme: this.textTheme.merge(textTheme),
        colorTheme: this.colorTheme.merge(colorTheme),
        callControlsTheme: this.callControlsTheme.merge(callControlsTheme),
        userAvatarTheme: this.userAvatarTheme.merge(userAvatarTheme),
        lobbyViewTheme: this.lobbyViewTheme.merge(lobbyViewTheme),
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
        incomingCallTheme: this.incomingCallTheme.merge(incomingCallTheme),
        outgoingCallTheme: this.outgoingCallTheme.merge(outgoingCallTheme),
      );

  /// Merge themes
  StreamVideoTheme merge(StreamVideoTheme? other) {
    if (other == null) return this;
    return copyWith(
      textTheme: textTheme.merge(other.textTheme),
      colorTheme: colorTheme.merge(other.colorTheme),
      callControlsTheme: callControlsTheme.merge(callControlsTheme),
      userAvatarTheme: userAvatarTheme.merge(other.userAvatarTheme),
      lobbyViewTheme: lobbyViewTheme.merge(other.lobbyViewTheme),
      callParticipantTheme:
          callParticipantTheme.merge(other.callParticipantTheme),
      participantsInfoTheme:
          participantsInfoTheme.merge(other.participantsInfoTheme),
      participantInfoTheme:
          participantInfoTheme.merge(other.participantInfoTheme),
      invitableUserListTheme:
          invitableUserListTheme.merge(other.invitableUserListTheme),
      invitableUserTheme: invitableUserTheme.merge(other.invitableUserTheme),
      incomingCallTheme: incomingCallTheme.merge(other.incomingCallTheme),
      outgoingCallTheme: outgoingCallTheme.merge(other.outgoingCallTheme),
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
      userAvatarTheme: userAvatarTheme.lerp(other.userAvatarTheme, t),
      lobbyViewTheme: lobbyViewTheme.lerp(other.lobbyViewTheme, t),
      callParticipantTheme:
          callParticipantTheme.lerp(other.callParticipantTheme, t),
      floatingCallParticipantTheme: floatingCallParticipantTheme.lerp(
        other.floatingCallParticipantTheme,
        t,
      ),
      callControlsTheme: callControlsTheme.lerp(other.callControlsTheme, t),
      participantsInfoTheme:
          participantsInfoTheme.lerp(other.participantsInfoTheme, t),
      participantInfoTheme:
          participantInfoTheme.lerp(other.participantInfoTheme, t),
      invitableUserListTheme:
          invitableUserListTheme.lerp(other.invitableUserListTheme, t),
      invitableUserTheme: invitableUserTheme.lerp(other.invitableUserTheme, t),
      incomingCallTheme: incomingCallTheme.lerp(other.incomingCallTheme, t),
      outgoingCallTheme: outgoingCallTheme.lerp(other.outgoingCallTheme, t),
    );
  }
}
