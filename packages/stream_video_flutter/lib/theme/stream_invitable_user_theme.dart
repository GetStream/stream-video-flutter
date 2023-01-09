import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/theme/stream_avatar_theme.dart';

/// {@template invitableUserTheme}
/// A style that overrides the default appearance of invitable user widget.
/// {@endtemplate}
class StreamInvitableUserTheme with Diagnosticable {
  /// {@macro invitableUserTheme}
  const StreamInvitableUserTheme({
    this.usernameTextStyle = const TextStyle(fontSize: 18.0),
    this.selectedIconColor = Colors.blue,
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

  /// Color of the selected icon.
  final Color selectedIconColor;

  /// Theme for the user avatar widget.
  final StreamAvatarTheme? avatarTheme;

  /// Returns a new [StreamInvitableUserTheme] replacing some of its
  /// properties
  StreamInvitableUserTheme copyWith({
    TextStyle? usernameTextStyle,
    Color? selectedIconColor,
    StreamAvatarTheme? avatarTheme,
  }) {
    return StreamInvitableUserTheme(
      usernameTextStyle: usernameTextStyle ?? this.usernameTextStyle,
      selectedIconColor: selectedIconColor ?? this.selectedIconColor,
      avatarTheme: avatarTheme ?? this.avatarTheme,
    );
  }

  /// Linearly interpolate between two [StreamCallParticipantsInfoView] themes.
  ///
  /// All the properties must be non-null.
  StreamInvitableUserTheme lerp(StreamInvitableUserTheme other, double t) {
    return StreamInvitableUserTheme(
        usernameTextStyle:
            TextStyle.lerp(usernameTextStyle, other.usernameTextStyle, t)!,
        selectedIconColor:
            Color.lerp(selectedIconColor, other.selectedIconColor, t)!,
        avatarTheme: avatarTheme != null && other.avatarTheme != null
            ? avatarTheme!.lerp(other.avatarTheme!, t)
            : other.avatarTheme ?? avatarTheme);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamInvitableUserTheme &&
          runtimeType == other.runtimeType &&
          usernameTextStyle == other.usernameTextStyle &&
          selectedIconColor == other.selectedIconColor &&
          avatarTheme == other.avatarTheme;

  @override
  int get hashCode =>
      usernameTextStyle.hashCode ^
      selectedIconColor.hashCode ^
      avatarTheme.hashCode;

  /// Merges one [StreamInvitableUserTheme] with the another.
  StreamInvitableUserTheme merge(StreamInvitableUserTheme? other) {
    if (other == null) return this;
    return copyWith(
      usernameTextStyle: other.usernameTextStyle,
      selectedIconColor: other.selectedIconColor,
      avatarTheme: other.avatarTheme,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('usernameTextStyle', usernameTextStyle))
      ..add(DiagnosticsProperty('selectedIconColor', selectedIconColor))
      ..add(DiagnosticsProperty('avatarTheme', avatarTheme));
  }
}
