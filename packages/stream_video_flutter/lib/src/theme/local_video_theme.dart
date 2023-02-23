import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../widgets/floating_view/floating_view_alignment.dart';

/// Defines default property values for [StreamLocalVideo] widgets.
@immutable
class StreamLocalVideoThemeData with Diagnosticable {
  /// Creates a new instance of [StreamLocalVideoThemeData].
  const StreamLocalVideoThemeData({
    this.floatingParticipantHeight = 150,
    this.floatingParticipantWidth = 125,
    this.floatingParticipantPadding = 16,
    this.floatingViewAlignment = FloatingViewAlignment.topRight,
    this.enableSnappingBehavior = true,
    this.userAvatarTheme = const StreamUserAvatarThemeData(
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
    ),
    this.shadowColor = const Color(0xFF212121),
  });

  /// The height of the floating participant item.
  final double floatingParticipantHeight;

  /// The width of the floating participant item.
  final double floatingParticipantWidth;

  /// The padding between floating participant item and [StreamCallParticipants].
  final double floatingParticipantPadding;

  /// The initial position of the floating view.
  final FloatingViewAlignment floatingViewAlignment;

  /// If the floating view should be automatically anchored to one of the
  /// corners.
  final bool enableSnappingBehavior;

  /// The theme for the avatar.
  final StreamUserAvatarThemeData userAvatarTheme;

  /// The color of shadow.
  final Color shadowColor;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  StreamLocalVideoThemeData copyWith({
    double? floatingParticipantHeight,
    double? floatingParticipantWidth,
    double? floatingParticipantPadding,
    FloatingViewAlignment? floatingViewAlignment,
    bool? enableSnappingBehavior,
    StreamUserAvatarThemeData? userAvatarTheme,
    Color? shadowColor,
  }) {
    return StreamLocalVideoThemeData(
      floatingParticipantHeight:
          floatingParticipantHeight ?? this.floatingParticipantHeight,
      floatingParticipantWidth:
          floatingParticipantWidth ?? this.floatingParticipantWidth,
      floatingParticipantPadding:
          floatingParticipantPadding ?? this.floatingParticipantPadding,
      floatingViewAlignment:
          floatingViewAlignment ?? this.floatingViewAlignment,
      enableSnappingBehavior:
          enableSnappingBehavior ?? this.enableSnappingBehavior,
      userAvatarTheme: userAvatarTheme ?? this.userAvatarTheme,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  /// Linearly interpolate between two [StreamLocalVideoThemeData]
  /// themes.
  ///
  /// All the properties must be non-null.
  StreamLocalVideoThemeData lerp(
    StreamLocalVideoThemeData other,
    double t,
  ) {
    return StreamLocalVideoThemeData(
      floatingParticipantHeight: lerpDouble(
          floatingParticipantHeight, other.floatingParticipantHeight, t)!,
      floatingParticipantWidth: lerpDouble(
          floatingParticipantWidth, other.floatingParticipantWidth, t)!,
      floatingParticipantPadding: lerpDouble(
          floatingParticipantPadding, other.floatingParticipantPadding, t)!,
      floatingViewAlignment:
          t < 0.5 ? floatingViewAlignment : other.floatingViewAlignment,
      enableSnappingBehavior:
          t < 0.5 ? enableSnappingBehavior : other.enableSnappingBehavior,
      userAvatarTheme: userAvatarTheme.lerp(other.userAvatarTheme, t),
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
    );
  }

  @override
  int get hashCode => Object.hash(
        floatingParticipantHeight,
        floatingParticipantWidth,
        floatingParticipantPadding,
        floatingViewAlignment,
        enableSnappingBehavior,
        userAvatarTheme,
        shadowColor,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is StreamLocalVideoThemeData &&
        floatingParticipantHeight == other.floatingParticipantHeight &&
        floatingParticipantWidth == other.floatingParticipantWidth &&
        floatingParticipantPadding == other.floatingParticipantPadding &&
        floatingViewAlignment == other.floatingViewAlignment &&
        enableSnappingBehavior == other.enableSnappingBehavior &&
        userAvatarTheme == other.userAvatarTheme &&
        shadowColor == other.shadowColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty(
          'floatingParticipantHeight', floatingParticipantHeight))
      ..add(DiagnosticsProperty(
          'floatingParticipantWidth', floatingParticipantWidth))
      ..add(DiagnosticsProperty(
          'floatingParticipantPadding', floatingParticipantPadding))
      ..add(DiagnosticsProperty('floatingViewAlignment', floatingViewAlignment))
      ..add(
          DiagnosticsProperty('enableSnappingBehavior', enableSnappingBehavior))
      ..add(DiagnosticsProperty('userAvatarTheme', userAvatarTheme))
      ..add(DiagnosticsProperty('shadowColor', shadowColor));
  }

  /// Merges one [StreamLocalVideoThemeData] with the another.
  StreamLocalVideoThemeData merge(
    StreamLocalVideoThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      floatingParticipantHeight: other.floatingParticipantHeight,
      floatingParticipantWidth: other.floatingParticipantWidth,
      floatingParticipantPadding: other.floatingParticipantPadding,
      floatingViewAlignment: other.floatingViewAlignment,
      enableSnappingBehavior: other.enableSnappingBehavior,
      userAvatarTheme: other.userAvatarTheme,
      shadowColor: other.shadowColor,
    );
  }
}

/// Applies a local video theme to descendant [StreamLocalVideo] widgets.
class StreamLocalVideoTheme extends InheritedWidget {
  /// Creates a new instance of [StreamLocalVideoTheme].
  const StreamLocalVideoTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [StreamLocalVideo] widgets.
  final StreamLocalVideoThemeData data;

  /// Returns the configuration [data] from the closest
  /// [StreamLocalVideoTheme] ancestor. If there is no ancestor,
  /// it returns [StreamVideoTheme.localVideoTheme].
  static StreamLocalVideoThemeData of(BuildContext context) {
    final floatingCallParticipantTheme =
        context.dependOnInheritedWidgetOfExactType<StreamLocalVideoTheme>();
    return floatingCallParticipantTheme?.data ??
        StreamVideoTheme.of(context).localVideoTheme;
  }

  @override
  bool updateShouldNotify(StreamLocalVideoTheme oldWidget) {
    return data != oldWidget.data;
  }
}
