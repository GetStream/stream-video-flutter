import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/theme/stream_avatar_theme.dart';

/// A style of a single participant on a call.
class StreamCallParticipantTheme with Diagnosticable {
  /// Constructor for creating [StreamCallParticipantTheme].
  const StreamCallParticipantTheme({
    this.focusedColor = const Color(0xff005FFF),
    this.backgroundColor = const Color(0xFF272A30),
    this.avatarTheme = const StreamAvatarTheme(
      constraints: BoxConstraints.tightFor(
        height: 100,
        width: 100,
      ),
      borderRadius: BorderRadius.all(Radius.circular(50)),
      initialsTextStyle: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      selectionColor: Color(0xff005FFF),
      selectionThickness: 4,
    ),
    this.audioLevelIndicatorColor = const Color(0xff005FFF),
    this.participantLabelTextStyle = const TextStyle(
      fontSize: 12,
      color: Colors.white,
    ),
    this.enabledMicrophoneColor = Colors.white,
    this.disabledMicrophoneColor = const Color(0xffFF3842),
    this.connectionLevelActiveColor = const Color(0xff005FFF),
    this.connectionLevelInactiveColor = Colors.white,
  });

  /// The color in the focused state.
  final Color focusedColor;

  /// The color of the background behind avatar.
  final Color backgroundColor;

  /// Theme for the avatar.
  final StreamAvatarTheme avatarTheme;

  /// The color of an audio level indicator.
  final Color audioLevelIndicatorColor;

  /// Text style for the participant label.
  final TextStyle participantLabelTextStyle;

  /// The color of an enabled microphone icon.
  final Color enabledMicrophoneColor;

  /// The color of a disabled microphone icon.
  final Color disabledMicrophoneColor;

  /// The color of an active connection quality level.
  final Color connectionLevelActiveColor;

  /// The color of an inactive connection quality level.
  final Color connectionLevelInactiveColor;

  copyWith({
    Color? focusedColor,
    Color? backgroundColor,
    StreamAvatarTheme? avatarTheme,
    Color? audioLevelIndicatorColor,
    TextStyle? participantLabelTextStyle,
    Color? enabledMicrophoneColor,
    Color? disabledMicrophoneColor,
    Color? connectionLevelActiveColor,
    Color? connectionLevelInactiveColor,
  }) {
    return StreamCallParticipantTheme(
      focusedColor: focusedColor ?? this.focusedColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      avatarTheme: avatarTheme ?? this.avatarTheme,
      audioLevelIndicatorColor:
          audioLevelIndicatorColor ?? this.audioLevelIndicatorColor,
      participantLabelTextStyle:
          participantLabelTextStyle ?? this.participantLabelTextStyle,
      enabledMicrophoneColor:
          enabledMicrophoneColor ?? this.enabledMicrophoneColor,
      disabledMicrophoneColor:
          disabledMicrophoneColor ?? this.disabledMicrophoneColor,
      connectionLevelActiveColor:
          connectionLevelActiveColor ?? this.connectionLevelActiveColor,
      connectionLevelInactiveColor:
          connectionLevelInactiveColor ?? this.connectionLevelInactiveColor,
    );
  }

  /// Linearly interpolate between two [StreamCallParticipantTheme] themes.
  ///
  /// All the properties must be non-null.
  StreamCallParticipantTheme lerp(StreamCallParticipantTheme other, double t) {
    return StreamCallParticipantTheme(
      focusedColor: Color.lerp(focusedColor, other.focusedColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      avatarTheme: avatarTheme.lerp(other.avatarTheme, t),
      audioLevelIndicatorColor: Color.lerp(
          audioLevelIndicatorColor, other.audioLevelIndicatorColor, t)!,
      participantLabelTextStyle: TextStyle.lerp(
          participantLabelTextStyle, other.participantLabelTextStyle, t)!,
      enabledMicrophoneColor:
          Color.lerp(enabledMicrophoneColor, other.enabledMicrophoneColor, t)!,
      disabledMicrophoneColor: Color.lerp(
          disabledMicrophoneColor, other.disabledMicrophoneColor, t)!,
      connectionLevelActiveColor: Color.lerp(
          connectionLevelActiveColor, other.connectionLevelActiveColor, t)!,
      connectionLevelInactiveColor: Color.lerp(
          connectionLevelInactiveColor, other.connectionLevelInactiveColor, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamCallParticipantTheme &&
          runtimeType == other.runtimeType &&
          focusedColor == other.focusedColor &&
          backgroundColor == other.backgroundColor &&
          avatarTheme == other.avatarTheme &&
          audioLevelIndicatorColor == other.audioLevelIndicatorColor &&
          participantLabelTextStyle == other.participantLabelTextStyle &&
          enabledMicrophoneColor == other.enabledMicrophoneColor &&
          disabledMicrophoneColor == other.disabledMicrophoneColor &&
          connectionLevelActiveColor == other.connectionLevelActiveColor &&
          connectionLevelInactiveColor == other.connectionLevelInactiveColor;

  @override
  int get hashCode =>
      focusedColor.hashCode ^
      backgroundColor.hashCode ^
      avatarTheme.hashCode ^
      audioLevelIndicatorColor.hashCode ^
      participantLabelTextStyle.hashCode ^
      enabledMicrophoneColor.hashCode ^
      disabledMicrophoneColor.hashCode ^
      connectionLevelActiveColor.hashCode ^
      connectionLevelInactiveColor.hashCode;

  /// Merges one [StreamCallParticipantTheme] with the another.
  StreamCallParticipantTheme merge(StreamCallParticipantTheme? other) {
    if (other == null) return this;
    return copyWith(
      focusedColor: other.focusedColor,
      backgroundColor: other.backgroundColor,
      avatarTheme: other.avatarTheme,
      audioLevelIndicatorColor: other.audioLevelIndicatorColor,
      participantLabelTextStyle: other.participantLabelTextStyle,
      enabledMicrophoneColor: other.enabledMicrophoneColor,
      disabledMicrophoneColor: other.disabledMicrophoneColor,
      connectionLevelActiveColor: other.connectionLevelActiveColor,
      connectionLevelInactiveColor: other.connectionLevelInactiveColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('focusedColor', focusedColor))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty('avatarTheme', avatarTheme))
      ..add(DiagnosticsProperty(
          'audioLevelIndicatorColor', audioLevelIndicatorColor))
      ..add(DiagnosticsProperty(
          'participantLabelTextStyle', participantLabelTextStyle))
      ..add(
          DiagnosticsProperty('enabledMicrophoneColor', enabledMicrophoneColor))
      ..add(DiagnosticsProperty(
          'disabledMicrophoneColor', disabledMicrophoneColor))
      ..add(DiagnosticsProperty(
          'connectionLevelActiveColor', connectionLevelActiveColor))
      ..add(DiagnosticsProperty(
          'connectionLevelInactiveColor', connectionLevelInactiveColor));
  }
}
