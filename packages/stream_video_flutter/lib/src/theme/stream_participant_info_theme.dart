import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'user_avatar_theme.dart';

/// {@template participantInfoTheme}
/// A style that overrides the default appearance of participants info widget.
/// {@endtemplate}
class StreamParticipantInfoTheme with Diagnosticable {
  /// {@macro participantInfoTheme}
  const StreamParticipantInfoTheme({
    this.usernameTextStyle = const TextStyle(fontSize: 18.0),
    this.iconActiveColor = Colors.black54,
    this.iconInactiveColor = Colors.red,
    this.userAvatarTheme = const StreamUserAvatarThemeData(
      initialsTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      constraints: BoxConstraints(
        minHeight: 56,
        minWidth: 56,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(32),
      ),
    ),
  });

  /// [TextStyle] for the user name.
  final TextStyle usernameTextStyle;

  /// Color of the active icon.
  final Color iconActiveColor;

  /// Color of the inactive icon.
  final Color iconInactiveColor;

  /// Theme for the user avatar widget.
  final StreamUserAvatarThemeData? userAvatarTheme;

  /// Returns a new [StreamParticipantInfoTheme] replacing some of its
  /// properties
  StreamParticipantInfoTheme copyWith({
    TextStyle? usernameTextStyle,
    Color? iconActiveColor,
    Color? iconInactiveColor,
    StreamUserAvatarThemeData? userAvatarTheme,
  }) {
    return StreamParticipantInfoTheme(
      usernameTextStyle: usernameTextStyle ?? this.usernameTextStyle,
      iconActiveColor: iconActiveColor ?? this.iconActiveColor,
      iconInactiveColor: iconInactiveColor ?? this.iconInactiveColor,
      userAvatarTheme: userAvatarTheme ?? this.userAvatarTheme,
    );
  }

  /// Linearly interpolate between two [StreamCallParticipantsInfoView] themes.
  ///
  /// All the properties must be non-null.
  StreamParticipantInfoTheme lerp(StreamParticipantInfoTheme other, double t) {
    return StreamParticipantInfoTheme(
        usernameTextStyle:
            TextStyle.lerp(usernameTextStyle, other.usernameTextStyle, t)!,
        iconActiveColor: Color.lerp(iconActiveColor, other.iconActiveColor, t)!,
        iconInactiveColor:
            Color.lerp(iconInactiveColor, other.iconInactiveColor, t)!,
        userAvatarTheme:
            userAvatarTheme != null && other.userAvatarTheme != null
                ? userAvatarTheme!.lerp(other.userAvatarTheme!, t)
                : other.userAvatarTheme ?? userAvatarTheme);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamParticipantInfoTheme &&
          runtimeType == other.runtimeType &&
          usernameTextStyle == other.usernameTextStyle &&
          iconActiveColor == other.iconActiveColor &&
          iconInactiveColor == other.iconInactiveColor &&
          userAvatarTheme == other.userAvatarTheme;

  @override
  int get hashCode =>
      usernameTextStyle.hashCode ^
      iconActiveColor.hashCode ^
      iconInactiveColor.hashCode ^
      userAvatarTheme.hashCode;

  /// Merges one [StreamParticipantInfoTheme] with the another
  StreamParticipantInfoTheme merge(StreamParticipantInfoTheme? other) {
    if (other == null) return this;
    return copyWith(
      usernameTextStyle: other.usernameTextStyle,
      iconActiveColor: other.iconActiveColor,
      iconInactiveColor: other.iconInactiveColor,
      userAvatarTheme: other.userAvatarTheme,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('usernameTextStyle', usernameTextStyle))
      ..add(DiagnosticsProperty('iconActiveColor', iconActiveColor))
      ..add(DiagnosticsProperty('iconInactiveColor', iconInactiveColor))
      ..add(DiagnosticsProperty('userAvatarTheme', userAvatarTheme));
  }
}
