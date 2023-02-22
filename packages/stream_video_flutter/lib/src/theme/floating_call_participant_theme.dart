import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Defines default property values for [StreamFloatingCallParticipant] widgets.
@immutable
class StreamFloatingCallParticipantThemeData with Diagnosticable {
  /// Creates a new instance of [StreamFloatingCallParticipantThemeData].
  const StreamFloatingCallParticipantThemeData({
    this.streamCallParticipantTheme = const StreamCallParticipantThemeData(),
    this.floatingParticipantHeight = 150,
    this.floatingParticipantWidth = 125,
    this.floatingParticipantPadding = 16,
    this.avatarSize,
    this.avatarBorderRadius,
  });

  /// The theme for the participant item.
  final StreamCallParticipantThemeData streamCallParticipantTheme;

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

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  StreamFloatingCallParticipantThemeData copyWith({
    StreamCallParticipantThemeData? streamCallParticipantTheme,
    double? floatingParticipantHeight,
    double? floatingParticipantWidth,
    double? floatingParticipantPadding,
    double? avatarSize,
    BorderRadius? avatarBorderRadius,
  }) {
    return StreamFloatingCallParticipantThemeData(
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

  /// Linearly interpolate between two [StreamFloatingCallParticipantThemeData]
  /// themes.
  ///
  /// All the properties must be non-null.
  StreamFloatingCallParticipantThemeData lerp(
    StreamFloatingCallParticipantThemeData other,
    double t,
  ) {
    return StreamFloatingCallParticipantThemeData(
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
          t)!,
    );
  }

  @override
  int get hashCode => Object.hash(
        streamCallParticipantTheme,
        floatingParticipantHeight,
        floatingParticipantWidth,
        floatingParticipantPadding,
        avatarSize,
        avatarBorderRadius,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is StreamFloatingCallParticipantThemeData &&
        streamCallParticipantTheme == other.streamCallParticipantTheme &&
        floatingParticipantHeight == other.floatingParticipantHeight &&
        floatingParticipantWidth == other.floatingParticipantWidth &&
        floatingParticipantPadding == other.floatingParticipantPadding &&
        avatarSize == other.avatarSize &&
        avatarBorderRadius == other.avatarBorderRadius;
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

  /// Merges one [StreamFloatingCallParticipantThemeData] with the another.
  StreamFloatingCallParticipantThemeData merge(
    StreamFloatingCallParticipantThemeData? other,
  ) {
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
}

/// Applies a floating call participant theme to descendant
/// [StreamFloatingCallParticipant] widgets.
class StreamFloatingCallParticipantTheme extends InheritedWidget {
  /// Creates a new instance of [StreamFloatingCallParticipantTheme].
  const StreamFloatingCallParticipantTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [StreamFloatingCallParticipant]
  /// widgets.
  final StreamFloatingCallParticipantThemeData data;

  /// Returns the configuration [data] from the closest
  /// [StreamFloatingCallParticipantTheme] ancestor. If there is no ancestor,
  /// it returns [StreamVideoTheme.floatingCallParticipantTheme].
  static StreamFloatingCallParticipantThemeData of(BuildContext context) {
    final floatingCallParticipantTheme =
        context.dependOnInheritedWidgetOfExactType<
            StreamFloatingCallParticipantTheme>();
    return floatingCallParticipantTheme?.data ??
        StreamVideoTheme.of(context).floatingCallParticipantTheme;
  }

  @override
  bool updateShouldNotify(StreamFloatingCallParticipantTheme oldWidget) {
    return data != oldWidget.data;
  }
}
