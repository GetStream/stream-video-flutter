import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Defines default property values for [StreamCallParticipantsInfoMenu]
/// widgets.
@immutable
class StreamCallParticipantsInfoMenuThemeData with Diagnosticable {
  /// Creates a new instance of [StreamCallParticipantsInfoMenuThemeData].
  const StreamCallParticipantsInfoMenuThemeData({
    this.participantDividerColor = Colors.grey,
    this.participantDividerIndent = 0.0,
    this.participantDividerHeight = 0.0,
    this.participantNameTextStyle = const TextStyle(fontSize: 18),
    this.participantIconActiveColor = Colors.black54,
    this.participantIconInactiveColor = Colors.red,
    this.participantUserAvatarTheme = const StreamUserAvatarThemeData(
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
    this.inviteDividerColor = Colors.grey,
    this.inviteDividerIndent = 16.0,
    this.inviteDividerHeight = 0.0,
    this.inviteUsernameTextStyle = const TextStyle(fontSize: 18),
    this.inviteSelectedIconColor = Colors.blue,
    this.inviteUserAvatarTheme = const StreamUserAvatarThemeData(
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

  /// List divider color.
  final Color participantDividerColor;

  /// List divider indent.
  final double participantDividerIndent;

  /// List divider height.
  final double participantDividerHeight;

  /// [TextStyle] for the user name.
  final TextStyle participantNameTextStyle;

  /// Color of the active icon.
  final Color participantIconActiveColor;

  /// Color of the inactive icon.
  final Color participantIconInactiveColor;

  /// Theme for the user avatar widget.
  final StreamUserAvatarThemeData participantUserAvatarTheme;

  /// List divider color.
  final Color inviteDividerColor;

  /// List divider indent.
  final double inviteDividerIndent;

  /// List divider height.
  final double inviteDividerHeight;

  /// [TextStyle] for the user name.
  final TextStyle inviteUsernameTextStyle;

  /// Color of the selected icon.
  final Color inviteSelectedIconColor;

  /// Theme for the user avatar widget.
  final StreamUserAvatarThemeData inviteUserAvatarTheme;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  StreamCallParticipantsInfoMenuThemeData copyWith({
    Color? participantDividerColor,
    double? participantDividerIndent,
    double? participantDividerHeight,
    TextStyle? participantNameTextStyle,
    Color? participantIconActiveColor,
    Color? participantIconInactiveColor,
    StreamUserAvatarThemeData? participantUserAvatarTheme,
    Color? inviteDividerColor,
    double? inviteDividerIndent,
    double? inviteDividerHeight,
    TextStyle? inviteUsernameTextStyle,
    Color? inviteSelectedIconColor,
    StreamUserAvatarThemeData? inviteUserAvatarTheme,
  }) {
    return StreamCallParticipantsInfoMenuThemeData(
      participantDividerColor:
          participantDividerColor ?? this.participantDividerColor,
      participantDividerIndent:
          participantDividerIndent ?? this.participantDividerIndent,
      participantDividerHeight:
          participantDividerHeight ?? this.participantDividerHeight,
      participantNameTextStyle:
          participantNameTextStyle ?? this.participantNameTextStyle,
      participantIconActiveColor:
          participantIconActiveColor ?? this.participantIconActiveColor,
      participantIconInactiveColor:
          participantIconInactiveColor ?? this.participantIconInactiveColor,
      participantUserAvatarTheme:
          participantUserAvatarTheme ?? this.participantUserAvatarTheme,
      inviteDividerColor: inviteDividerColor ?? this.inviteDividerColor,
      inviteDividerIndent: inviteDividerIndent ?? this.inviteDividerIndent,
      inviteDividerHeight: inviteDividerHeight ?? this.inviteDividerHeight,
      inviteUsernameTextStyle:
          inviteUsernameTextStyle ?? this.inviteUsernameTextStyle,
      inviteSelectedIconColor:
          inviteSelectedIconColor ?? this.inviteSelectedIconColor,
      inviteUserAvatarTheme:
          inviteUserAvatarTheme ?? this.inviteUserAvatarTheme,
    );
  }

  /// Linearly interpolate between two [StreamCallParticipantsInfoMenuThemeData]
  /// themes.
  ///
  /// All the properties must be non-null.
  StreamCallParticipantsInfoMenuThemeData lerp(
    StreamCallParticipantsInfoMenuThemeData other,
    double t,
  ) {
    return StreamCallParticipantsInfoMenuThemeData(
      participantDividerColor: Color.lerp(
        participantDividerColor,
        other.participantDividerColor,
        t,
      )!,
      participantDividerIndent: lerpDouble(
        participantDividerIndent,
        other.participantDividerIndent,
        t,
      )!,
      participantDividerHeight: lerpDouble(
        participantDividerHeight,
        other.participantDividerHeight,
        t,
      )!,
      participantNameTextStyle: TextStyle.lerp(
        participantNameTextStyle,
        other.participantNameTextStyle,
        t,
      )!,
      participantIconActiveColor: Color.lerp(
        participantIconActiveColor,
        other.participantIconActiveColor,
        t,
      )!,
      participantIconInactiveColor: Color.lerp(
        participantIconInactiveColor,
        other.participantIconInactiveColor,
        t,
      )!,
      participantUserAvatarTheme:
          participantUserAvatarTheme.lerp(other.participantUserAvatarTheme, t),
      inviteDividerColor:
          Color.lerp(inviteDividerColor, other.inviteDividerColor, t)!,
      inviteDividerIndent:
          lerpDouble(inviteDividerIndent, other.inviteDividerIndent, t)!,
      inviteDividerHeight:
          lerpDouble(inviteDividerHeight, other.inviteDividerHeight, t)!,
      inviteUsernameTextStyle: TextStyle.lerp(
        inviteUsernameTextStyle,
        other.inviteUsernameTextStyle,
        t,
      )!,
      inviteSelectedIconColor: Color.lerp(
        inviteSelectedIconColor,
        other.inviteSelectedIconColor,
        t,
      )!,
      inviteUserAvatarTheme:
          inviteUserAvatarTheme.lerp(other.inviteUserAvatarTheme, t),
    );
  }

  @override
  int get hashCode => Object.hash(
        participantDividerColor,
        participantDividerIndent,
        participantDividerHeight,
        participantNameTextStyle,
        participantIconActiveColor,
        participantIconInactiveColor,
        participantUserAvatarTheme,
        inviteDividerColor,
        inviteDividerIndent,
        inviteDividerHeight,
        inviteUsernameTextStyle,
        inviteSelectedIconColor,
        inviteUserAvatarTheme,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is StreamCallParticipantsInfoMenuThemeData &&
        participantDividerColor == other.participantDividerColor &&
        participantDividerIndent == other.participantDividerIndent &&
        participantDividerHeight == other.participantDividerHeight &&
        participantNameTextStyle == other.participantNameTextStyle &&
        participantIconActiveColor == other.participantIconActiveColor &&
        participantIconInactiveColor == other.participantIconInactiveColor &&
        participantUserAvatarTheme == other.participantUserAvatarTheme &&
        inviteDividerColor == other.inviteDividerColor &&
        inviteDividerIndent == other.inviteDividerIndent &&
        inviteDividerHeight == other.inviteDividerHeight &&
        inviteUsernameTextStyle == other.inviteUsernameTextStyle &&
        inviteSelectedIconColor == other.inviteSelectedIconColor &&
        inviteUserAvatarTheme == other.inviteUserAvatarTheme;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty(
          'participantDividerColor',
          participantDividerColor,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'participantDividerIndent',
          participantDividerIndent,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'participantDividerHeight',
          participantDividerHeight,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'participantNameTextStyle',
          participantNameTextStyle,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'participantIconActiveColor',
          participantIconActiveColor,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'participantIconInactiveColor',
          participantIconInactiveColor,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'participantUserAvatarTheme',
          participantUserAvatarTheme,
        ),
      )
      ..add(DiagnosticsProperty('inviteDividerColor', inviteDividerColor))
      ..add(DiagnosticsProperty('inviteDividerIndent', inviteDividerIndent))
      ..add(DiagnosticsProperty('inviteDividerHeight', inviteDividerHeight))
      ..add(
        DiagnosticsProperty(
          'inviteUsernameTextStyle',
          inviteUsernameTextStyle,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'inviteSelectedIconColor',
          inviteSelectedIconColor,
        ),
      )
      ..add(
        DiagnosticsProperty('inviteUserAvatarTheme', inviteUserAvatarTheme),
      );
  }

  /// Merges one [StreamCallParticipantsInfoMenuThemeData] with the another.
  StreamCallParticipantsInfoMenuThemeData merge(
    StreamCallParticipantsInfoMenuThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      participantDividerColor: other.participantDividerColor,
      participantDividerIndent: other.participantDividerIndent,
      participantDividerHeight: other.participantDividerHeight,
      participantNameTextStyle: other.participantNameTextStyle,
      participantIconActiveColor: other.participantIconActiveColor,
      participantIconInactiveColor: other.participantIconInactiveColor,
      participantUserAvatarTheme: other.participantUserAvatarTheme,
      inviteDividerColor: other.inviteDividerColor,
      inviteDividerIndent: other.inviteDividerIndent,
      inviteDividerHeight: other.inviteDividerHeight,
      inviteUsernameTextStyle: other.inviteUsernameTextStyle,
      inviteSelectedIconColor: other.inviteSelectedIconColor,
      inviteUserAvatarTheme: other.inviteUserAvatarTheme,
    );
  }
}

/// Applies a call participants info menu theme to descendant
/// [StreamCallParticipantsInfoMenu] widgets.
class StreamCallParticipantsInfoMenuTheme extends InheritedWidget {
  /// Creates a new instance of [StreamCallParticipantsInfoMenuTheme].
  const StreamCallParticipantsInfoMenuTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [StreamCallParticipantsInfoMenu]
  /// widgets.
  final StreamCallParticipantsInfoMenuThemeData data;

  /// Returns the configuration [data] from the closest
  /// [StreamCallParticipantsInfoMenu] ancestor. If there is no ancestor,
  /// it returns [StreamVideoTheme.callParticipantsInfoMenuTheme].
  static StreamCallParticipantsInfoMenuThemeData of(BuildContext context) {
    final callParticipantsInfoMenuTheme =
        context.dependOnInheritedWidgetOfExactType<
            StreamCallParticipantsInfoMenuTheme>();
    return callParticipantsInfoMenuTheme?.data ??
        StreamVideoTheme.of(context).callParticipantsInfoMenuTheme;
  }

  @override
  bool updateShouldNotify(StreamCallParticipantsInfoMenuTheme oldWidget) {
    return data != oldWidget.data;
  }
}
