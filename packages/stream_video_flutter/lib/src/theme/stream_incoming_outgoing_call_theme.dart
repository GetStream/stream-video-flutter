import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'stream_avatar_theme.dart';

/// {@template participantsInfoTheme}
/// A style that overrides the default appearance of the incoming and outgoing call widget.
/// {@endtemplate}
class StreamIncomingOutgoingCallTheme with Diagnosticable {
  /// {@macro outgoingCallTheme}
  const StreamIncomingOutgoingCallTheme({
    this.singleParticipantAvatarTheme = const StreamAvatarTheme(
      initialsTextStyle: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      constraints: BoxConstraints(
        minHeight: 160,
        minWidth: 160,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(80),
      ),
    ),
    this.multipleParticipantAvatarTheme = const StreamAvatarTheme(
      initialsTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      constraints: BoxConstraints(
        minHeight: 80,
        minWidth: 80,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
    ),
    this.singleParticipantTextStyle = const TextStyle(
      fontSize: 28,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    this.multipleParticipantTextStyle = const TextStyle(
      fontSize: 20,
      color: Colors.white,
    ),
    this.callingLabelTextStyle = const TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  });

  /// Theme for the avatar in a call with one participant.
  final StreamAvatarTheme singleParticipantAvatarTheme;

  /// Theme for the avatar in a call with multiple participants.
  final StreamAvatarTheme multipleParticipantAvatarTheme;

  /// Text style for the participant label in a call with one participant.
  final TextStyle singleParticipantTextStyle;

  /// Text style for the participant label in a call with multiple participants.
  final TextStyle multipleParticipantTextStyle;

  /// Text style for the calling label.
  final TextStyle callingLabelTextStyle;

  StreamIncomingOutgoingCallTheme copyWith({
    StreamAvatarTheme? singleParticipantAvatarTheme,
    StreamAvatarTheme? multipleParticipantAvatarTheme,
    TextStyle? singleParticipantTextStyle,
    TextStyle? multipleParticipantTextStyle,
    TextStyle? callingLabelTextStyle,
  }) {
    return StreamIncomingOutgoingCallTheme(
      singleParticipantAvatarTheme:
          singleParticipantAvatarTheme ?? this.singleParticipantAvatarTheme,
      multipleParticipantAvatarTheme:
          multipleParticipantAvatarTheme ?? this.multipleParticipantAvatarTheme,
      singleParticipantTextStyle:
          singleParticipantTextStyle ?? this.singleParticipantTextStyle,
      multipleParticipantTextStyle:
          multipleParticipantTextStyle ?? this.multipleParticipantTextStyle,
      callingLabelTextStyle:
          callingLabelTextStyle ?? this.callingLabelTextStyle,
    );
  }

  /// Linearly interpolate between two [StreamIncomingOutgoingCallTheme] themes.
  ///
  /// All the properties must be non-null.
  StreamIncomingOutgoingCallTheme lerp(StreamIncomingOutgoingCallTheme other, double t) {
    return StreamIncomingOutgoingCallTheme(
      singleParticipantAvatarTheme: singleParticipantAvatarTheme.lerp(
          other.singleParticipantAvatarTheme, t),
      multipleParticipantAvatarTheme: multipleParticipantAvatarTheme.lerp(
          other.multipleParticipantAvatarTheme, t),
      singleParticipantTextStyle: TextStyle.lerp(
          singleParticipantTextStyle, other.singleParticipantTextStyle, t)!,
      multipleParticipantTextStyle: TextStyle.lerp(
          multipleParticipantTextStyle, other.multipleParticipantTextStyle, t)!,
      callingLabelTextStyle: TextStyle.lerp(
          callingLabelTextStyle, other.callingLabelTextStyle, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamIncomingOutgoingCallTheme &&
          runtimeType == other.runtimeType &&
          singleParticipantAvatarTheme == other.singleParticipantAvatarTheme &&
          multipleParticipantAvatarTheme ==
              other.multipleParticipantAvatarTheme &&
          singleParticipantTextStyle == other.singleParticipantTextStyle &&
          multipleParticipantTextStyle == other.multipleParticipantTextStyle &&
          callingLabelTextStyle == other.callingLabelTextStyle;

  @override
  int get hashCode =>
      singleParticipantAvatarTheme.hashCode ^
      multipleParticipantAvatarTheme.hashCode ^
      singleParticipantTextStyle.hashCode ^
      multipleParticipantTextStyle.hashCode ^
      callingLabelTextStyle.hashCode;

  /// Merges one [StreamIncomingOutgoingCallTheme] with the another.
  StreamIncomingOutgoingCallTheme merge(StreamIncomingOutgoingCallTheme? other) {
    if (other == null) return this;
    return copyWith(
      singleParticipantAvatarTheme: other.singleParticipantAvatarTheme,
      multipleParticipantAvatarTheme: other.multipleParticipantAvatarTheme,
      singleParticipantTextStyle: other.singleParticipantTextStyle,
      multipleParticipantTextStyle: other.multipleParticipantTextStyle,
      callingLabelTextStyle: other.callingLabelTextStyle,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty(
          'singleParticipantAvatarTheme', singleParticipantAvatarTheme))
      ..add(DiagnosticsProperty(
          'multipleParticipantAvatarTheme', multipleParticipantAvatarTheme))
      ..add(DiagnosticsProperty(
          'singleParticipantTextStyle', singleParticipantTextStyle))
      ..add(DiagnosticsProperty(
          'multipleParticipantTextStyle', multipleParticipantTextStyle))
      ..add(
          DiagnosticsProperty('callingLabelTextStyle', callingLabelTextStyle));
  }
}
