import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/participant_info/theme/call_participant_info_theme.dart';
import 'package:stream_video_flutter/participant_info/theme/invitable_user_theme.dart';

/// {@template participantsInfoTheme}
/// A style that overrides the default appearance of participants info widget.
/// {@endtemplate}
class StreamInvitableUserListTheme with Diagnosticable {
  /// {@macro participantsInfoTheme}
  const StreamInvitableUserListTheme({
    this.dividerColor = Colors.grey,
    this.dividerIndent = 16.0,
    this.dividerHeight = 0.0,
    this.invitableUserTheme = const StreamInvitableUserTheme(),
  });

  /// List divider color.
  final Color dividerColor;

  /// List divider indent.
  final double dividerIndent;

  /// List divider height.
  final double dividerHeight;

  /// Theme for the participant info.
  final StreamInvitableUserTheme invitableUserTheme;

  StreamInvitableUserListTheme copyWith({
    Color? dividerColor,
    double? dividerIndent,
    double? dividerHeight,
    StreamInvitableUserTheme? invitableUserTheme,
  }) {
    return StreamInvitableUserListTheme(
      dividerColor: dividerColor ?? this.dividerColor,
      dividerIndent: dividerIndent ?? this.dividerIndent,
      dividerHeight: dividerHeight ?? this.dividerHeight,
      invitableUserTheme: invitableUserTheme ?? this.invitableUserTheme,
    );
  }

  /// Linearly interpolate between two [StreamCallParticipantsInfoView] themes.
  ///
  /// All the properties must be non-null.
  StreamInvitableUserListTheme lerp(
      StreamInvitableUserListTheme other, double t) {
    return StreamInvitableUserListTheme(
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      dividerIndent: lerpDouble(dividerIndent, other.dividerIndent, t)!,
      dividerHeight: lerpDouble(dividerHeight, other.dividerHeight, t)!,
      invitableUserTheme: invitableUserTheme.lerp(other.invitableUserTheme, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamInvitableUserListTheme &&
          runtimeType == other.runtimeType &&
          dividerColor == other.dividerColor &&
          dividerIndent == other.dividerIndent &&
          dividerHeight == other.dividerHeight &&
          invitableUserTheme == other.invitableUserTheme;

  @override
  int get hashCode =>
      dividerColor.hashCode ^
      dividerIndent.hashCode ^
      dividerHeight.hashCode ^
      invitableUserTheme.hashCode;

  /// Merges one [StreamInvitableUserListTheme] with the another
  StreamInvitableUserListTheme merge(StreamInvitableUserListTheme? other) {
    if (other == null) return this;
    return copyWith(
      dividerColor: other.dividerColor,
      dividerIndent: other.dividerIndent,
      dividerHeight: other.dividerHeight,
      invitableUserTheme: other.invitableUserTheme,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('dividerColor', dividerColor))
      ..add(DiagnosticsProperty('dividerIndent', dividerIndent))
      ..add(DiagnosticsProperty('dividerHeight', dividerHeight))
      ..add(DiagnosticsProperty('invitableUserTheme', invitableUserTheme));
  }
}
