import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'stream_call_participant_theme.dart';

/// A style that overrides the default appearance of the floating pip widget in [StreamCallParticipants].
class StreamFloatingCallParticipantTheme with Diagnosticable {
  const StreamFloatingCallParticipantTheme({
    this.streamCallParticipantTheme = const StreamCallParticipantTheme(),
    this.height = 140.0,
    this.width = 220.0,
    this.avatarSize,
    this.avatarBorderRadius,
  });

  /// List divider color.
  final StreamCallParticipantTheme streamCallParticipantTheme;

  /// List divider indent.
  final double height;

  /// List divider height.
  final double width;

  /// Sets the avatar size in the floating participant.
  final double? avatarSize;

  /// Sets the avatar border radius.
  final BorderRadius? avatarBorderRadius;

  /// Returns a new [StreamFloatingCallParticipantTheme] replacing some of its
  /// properties.
  StreamFloatingCallParticipantTheme copyWith({
    StreamCallParticipantTheme? streamCallParticipantTheme,
    double? height,
    double? width,
    double? avatarSize,
    BorderRadius? avatarBorderRadius,
  }) {
    return StreamFloatingCallParticipantTheme(
      streamCallParticipantTheme:
          streamCallParticipantTheme ?? this.streamCallParticipantTheme,
      height: height ?? this.height,
      width: width ?? this.width,
      avatarSize: avatarSize ?? this.avatarSize,
      avatarBorderRadius: avatarBorderRadius ?? this.avatarBorderRadius,
    );
  }

  /// Linearly interpolate between two [StreamFloatingCallParticipantTheme] themes.
  ///
  /// All the properties must be non-null.
  StreamFloatingCallParticipantTheme lerp(
      StreamFloatingCallParticipantTheme other, double t) {
    return StreamFloatingCallParticipantTheme(
      streamCallParticipantTheme:
          streamCallParticipantTheme.lerp(other.streamCallParticipantTheme, t),
      height: lerpDouble(height, other.height, t)!,
      width: lerpDouble(width, other.width, t)!,
      avatarSize: lerpDouble(avatarSize ?? 0, other.avatarSize ?? 0, t)!,
      avatarBorderRadius: BorderRadius.lerp(
        avatarBorderRadius ?? BorderRadius.zero,
        other.avatarBorderRadius ?? BorderRadius.zero,
        t,
      )!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamFloatingCallParticipantTheme &&
          runtimeType == other.runtimeType &&
          streamCallParticipantTheme == other.streamCallParticipantTheme &&
          height == other.height &&
          width == other.width &&
          avatarSize == other.avatarSize &&
          avatarBorderRadius == other.avatarBorderRadius;

  @override
  int get hashCode =>
      streamCallParticipantTheme.hashCode ^
      height.hashCode ^
      width.hashCode ^
      avatarSize.hashCode ^
      avatarBorderRadius.hashCode;

  /// Merges one [StreamFloatingCallParticipantTheme] with the another.
  StreamFloatingCallParticipantTheme merge(
      StreamFloatingCallParticipantTheme? other) {
    if (other == null) return this;
    return copyWith(
      streamCallParticipantTheme: other.streamCallParticipantTheme,
      height: other.height,
      width: other.width,
      avatarSize: other.avatarSize,
      avatarBorderRadius: other.avatarBorderRadius,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty(
          'streamCallParticipantTheme', streamCallParticipantTheme))
      ..add(DiagnosticsProperty('height', height))
      ..add(DiagnosticsProperty('width', width))
      ..add(DiagnosticsProperty('avatarSize', avatarSize))
      ..add(DiagnosticsProperty('avatarBorderRadius', avatarBorderRadius));
  }
}
