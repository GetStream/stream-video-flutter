import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'stream_avatar_theme.dart';

/// {@template participantInfoTheme}
/// A style that overrides the default appearance of participants info widget.
/// {@endtemplate}
class StreamParticipantInfoTheme with Diagnosticable {
  /// {@macro participantInfoTheme}
  const StreamParticipantInfoTheme({
    this.usernameTextStyle = const TextStyle(fontSize: 18.0),
    this.iconActiveColor = Colors.black54,
    this.iconInactiveColor = Colors.red,
    this.avatarTheme = const StreamAvatarTheme(
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
  final StreamAvatarTheme? avatarTheme;

  /// Returns a new [StreamParticipantInfoTheme] replacing some of its
  /// properties
  StreamParticipantInfoTheme copyWith({
    TextStyle? usernameTextStyle,
    Color? iconActiveColor,
    Color? iconInactiveColor,
    StreamAvatarTheme? avatarTheme,
  }) {
    return StreamParticipantInfoTheme(
      usernameTextStyle: usernameTextStyle ?? this.usernameTextStyle,
      iconActiveColor: iconActiveColor ?? this.iconActiveColor,
      iconInactiveColor: iconInactiveColor ?? this.iconInactiveColor,
      avatarTheme: avatarTheme ?? this.avatarTheme,
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
        avatarTheme: avatarTheme != null && other.avatarTheme != null
            ? avatarTheme!.lerp(other.avatarTheme!, t)
            : other.avatarTheme ?? avatarTheme);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamParticipantInfoTheme &&
          runtimeType == other.runtimeType &&
          usernameTextStyle == other.usernameTextStyle &&
          iconActiveColor == other.iconActiveColor &&
          iconInactiveColor == other.iconInactiveColor &&
          avatarTheme == other.avatarTheme;

  @override
  int get hashCode =>
      usernameTextStyle.hashCode ^
      iconActiveColor.hashCode ^
      iconInactiveColor.hashCode ^
      avatarTheme.hashCode;

  /// Merges one [StreamParticipantInfoTheme] with the another
  StreamParticipantInfoTheme merge(StreamParticipantInfoTheme? other) {
    if (other == null) return this;
    return copyWith(
      usernameTextStyle: other.usernameTextStyle,
      iconActiveColor: other.iconActiveColor,
      iconInactiveColor: other.iconInactiveColor,
      avatarTheme: other.avatarTheme,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('usernameTextStyle', usernameTextStyle))
      ..add(DiagnosticsProperty('iconActiveColor', iconActiveColor))
      ..add(DiagnosticsProperty('iconInactiveColor', iconInactiveColor))
      ..add(DiagnosticsProperty('avatarTheme', avatarTheme));
  }
}
