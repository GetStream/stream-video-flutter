import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// A style that overrides the default appearance of the floating
/// participant widget in [StreamCallParticipants].
class StreamFloatingCallParticipantTheme with Diagnosticable {
  const StreamFloatingCallParticipantTheme({
    this.streamCallParticipantTheme = const StreamCallParticipantTheme(),
    this.floatingParticipantHeight = 150,
    this.floatingParticipantWidth = 125,
    this.floatingParticipantPadding = 16,
    this.avatarSize,
    this.avatarBorderRadius,
  });

  /// The theme for the participant item.
  final StreamCallParticipantTheme streamCallParticipantTheme;

  /// The height of the floating participant item.
  final double floatingParticipantHeight;

  /// The width of the floating participant item.
  final double floatingParticipantWidth;

  /// The padding between floating participant item and [StreamCallParticipants].
  final double floatingParticipantPadding;

  /// Sets the avatar size in the floating participant.
  final double? avatarSize;

  /// Sets the avatar border radius.
  final BorderRadius? avatarBorderRadius;

  /// Returns a new [StreamFloatingCallParticipantTheme] replacing some of its
  /// properties.
  StreamFloatingCallParticipantTheme copyWith({
    StreamCallParticipantTheme? streamCallParticipantTheme,
    double? floatingParticipantHeight,
    double? floatingParticipantWidth,
    double? floatingParticipantPadding,
    double? avatarSize,
    BorderRadius? avatarBorderRadius,
  }) {
    return StreamFloatingCallParticipantTheme(
      streamCallParticipantTheme:
          streamCallParticipantTheme ?? this.streamCallParticipantTheme,
      floatingParticipantHeight:
          floatingParticipantHeight ?? this.floatingParticipantHeight,
      floatingParticipantWidth:
          floatingParticipantWidth ?? this.floatingParticipantWidth,
      floatingParticipantPadding:
          floatingParticipantPadding ?? this.floatingParticipantPadding,
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
      floatingParticipantHeight: lerpDouble(
          floatingParticipantHeight, other.floatingParticipantHeight, t)!,
      floatingParticipantWidth: lerpDouble(
          floatingParticipantWidth, other.floatingParticipantWidth, t)!,
      floatingParticipantPadding: lerpDouble(
          floatingParticipantPadding, other.floatingParticipantPadding, t)!,
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
          floatingParticipantHeight == other.floatingParticipantHeight &&
          floatingParticipantWidth == other.floatingParticipantWidth &&
          floatingParticipantPadding == other.floatingParticipantPadding &&
          avatarSize == other.avatarSize &&
          avatarBorderRadius == other.avatarBorderRadius;

  @override
  int get hashCode =>
      streamCallParticipantTheme.hashCode ^
      floatingParticipantHeight.hashCode ^
      floatingParticipantWidth.hashCode ^
      floatingParticipantPadding.hashCode ^
      avatarSize.hashCode ^
      avatarBorderRadius.hashCode;

  /// Merges one [StreamFloatingCallParticipantTheme] with the another.
  StreamFloatingCallParticipantTheme merge(
      StreamFloatingCallParticipantTheme? other) {
    if (other == null) return this;
    return copyWith(
      streamCallParticipantTheme: other.streamCallParticipantTheme,
      floatingParticipantHeight: other.floatingParticipantHeight,
      floatingParticipantWidth: other.floatingParticipantWidth,
      floatingParticipantPadding: other.floatingParticipantPadding,
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
      ..add(DiagnosticsProperty(
          'floatingParticipantHeight', floatingParticipantHeight))
      ..add(DiagnosticsProperty(
          'floatingParticipantWidth', floatingParticipantWidth))
      ..add(DiagnosticsProperty(
          'floatingParticipantPadding', floatingParticipantPadding))
      ..add(DiagnosticsProperty('avatarSize', avatarSize))
      ..add(DiagnosticsProperty('avatarBorderRadius', avatarBorderRadius));
  }
}
