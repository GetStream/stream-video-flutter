import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Defines default property values for [StreamLobbyView] widgets.
@immutable
class StreamLobbyViewThemeData with Diagnosticable {
  /// Creates a new instance of [StreamLobbyViewThemeData].
  const StreamLobbyViewThemeData({
    this.cardBackgroundColor = const Color(0xFFF2F2F2),
    this.backgroundColor = Colors.white,
    this.userAvatarTheme = const StreamUserAvatarThemeData(
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
    this.participantAvatarTheme = const StreamUserAvatarThemeData(
      constraints: BoxConstraints.tightFor(
        height: 50,
        width: 50,
      ),
      borderRadius: BorderRadius.all(Radius.circular(25)),
      initialsTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      selectionColor: Color(0xFF005FFF),
      selectionThickness: 4,
    ),
    this.participantListHeight = 90,
  });

  /// The color of the background behind avatar.
  final Color backgroundColor;

  /// The color of the focus border.
  final Color cardBackgroundColor;

  /// Theme for the avatar.
  final StreamUserAvatarThemeData userAvatarTheme;

  /// Theme for the participant avatar.
  final StreamUserAvatarThemeData participantAvatarTheme;

  /// Theme for the participant list height.
  final double participantListHeight;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  StreamLobbyViewThemeData copyWith({
    Color? backgroundColor,
    Color? cardBackgroundColor,
    StreamUserAvatarThemeData? userAvatarTheme,
    StreamUserAvatarThemeData? participantAvatarTheme,
    double? participantListHeight,
  }) {
    return StreamLobbyViewThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      userAvatarTheme: userAvatarTheme ?? this.userAvatarTheme,
      participantAvatarTheme:
          participantAvatarTheme ?? this.participantAvatarTheme,
      participantListHeight:
          participantListHeight ?? this.participantListHeight,
    );
  }

  /// Linearly interpolate between two [StreamLobbyViewThemeData] themes.
  ///
  /// All the properties must be non-null.
  StreamLobbyViewThemeData lerp(
    StreamLobbyViewThemeData other,
    double t,
  ) {
    return StreamLobbyViewThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      cardBackgroundColor:
          Color.lerp(cardBackgroundColor, other.cardBackgroundColor, t)!,
      userAvatarTheme: userAvatarTheme.lerp(other.userAvatarTheme, t),
      participantAvatarTheme:
          participantAvatarTheme.lerp(other.participantAvatarTheme, t),
      participantListHeight: lerpDouble(
        participantListHeight,
        other.participantListHeight,
        t,
      )!,
    );
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        cardBackgroundColor,
        userAvatarTheme,
        participantAvatarTheme,
        participantListHeight,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is StreamLobbyViewThemeData &&
        other.backgroundColor == backgroundColor &&
        other.cardBackgroundColor == cardBackgroundColor &&
        other.userAvatarTheme == userAvatarTheme &&
        other.participantAvatarTheme == participantAvatarTheme &&
        other.participantListHeight == participantListHeight;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty('cardBackgroundColor', cardBackgroundColor))
      ..add(DiagnosticsProperty('userAvatarTheme', userAvatarTheme))
      ..add(
        DiagnosticsProperty('participantAvatarTheme', participantAvatarTheme),
      )
      ..add(
        DiagnosticsProperty('participantListHeight', participantListHeight),
      );
  }

  /// Merges one [StreamLobbyViewThemeData] with the another.
  StreamLobbyViewThemeData merge(StreamLobbyViewThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      cardBackgroundColor: other.cardBackgroundColor,
      userAvatarTheme: other.userAvatarTheme,
      participantAvatarTheme: other.participantAvatarTheme,
      participantListHeight: other.participantListHeight,
    );
  }
}

/// Applies a lobby view theme to descendant [StreamLobbyView]
/// widgets.
class StreamLobbyViewTheme extends InheritedWidget {
  /// Creates a new instance of [StreamLobbyViewTheme].
  const StreamLobbyViewTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [StreamLobbyView] widgets.
  final StreamLobbyViewThemeData data;

  /// Returns the configuration [data] from the closest
  /// [StreamLobbyViewTheme] ancestor. If there is no ancestor,
  /// it returns [StreamVideoTheme.lobbyViewTheme].
  static StreamLobbyViewThemeData of(BuildContext context) {
    final lobbyViewTheme =
        context.dependOnInheritedWidgetOfExactType<StreamLobbyViewTheme>();
    return lobbyViewTheme?.data ?? StreamVideoTheme.of(context).lobbyViewTheme;
  }

  @override
  bool updateShouldNotify(StreamLobbyViewTheme oldWidget) {
    return data != oldWidget.data;
  }
}
