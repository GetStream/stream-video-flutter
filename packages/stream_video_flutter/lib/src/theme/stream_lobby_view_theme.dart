import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'stream_avatar_theme.dart';

/// A style of a pre-joining screen.
class StreamLobbyViewTheme with Diagnosticable {
  /// Constructor for creating [StreamLobbyViewTheme].
  const StreamLobbyViewTheme({
    this.cardBackgroundColor = const Color(0xFFF2F2F2),
    this.backgroundColor = Colors.white,
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
      selectionColor: Color(0xFF005FFF),
      selectionThickness: 4,
    ),
  });

  /// The color of the background behind avatar.
  final Color backgroundColor;

  /// The color of the focus border.
  final Color cardBackgroundColor;

  /// Theme for the avatar.
  final StreamAvatarTheme avatarTheme;

  StreamLobbyViewTheme copyWith({
    Color? backgroundColor,
    Color? cardBackgroundColor,
    StreamAvatarTheme? avatarTheme,
  }) {
    return StreamLobbyViewTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      avatarTheme: avatarTheme ?? this.avatarTheme,
    );
  }

  /// Linearly interpolate between two [StreamLobbyViewTheme] themes.
  ///
  /// All the properties must be non-null.
  StreamLobbyViewTheme lerp(StreamLobbyViewTheme other, double t) {
    return StreamLobbyViewTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      cardBackgroundColor:
          Color.lerp(cardBackgroundColor, other.cardBackgroundColor, t)!,
      avatarTheme: avatarTheme.lerp(other.avatarTheme, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamLobbyViewTheme &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          cardBackgroundColor == other.cardBackgroundColor &&
          avatarTheme == other.avatarTheme;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      cardBackgroundColor.hashCode ^
      avatarTheme.hashCode;

  /// Merges one [StreamLobbyViewTheme] with the another.
  StreamLobbyViewTheme merge(StreamLobbyViewTheme? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      cardBackgroundColor: other.cardBackgroundColor,
      avatarTheme: other.avatarTheme,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty('cardBackgroundColor', cardBackgroundColor))
      ..add(DiagnosticsProperty('avatarTheme', avatarTheme));
  }
}
