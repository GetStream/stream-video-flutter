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
    this.localVideoWidth = 125,
    this.localVideoHeight = 150,
    this.localVideoPadding = 16,
    this.initialAlignment = FloatingViewAlignment.topRight,
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
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.shadowColor = const Color(0xFF212121),
  });

  /// The width of the local video item.
  final double localVideoWidth;

  /// The height of the local video item.
  final double localVideoHeight;

  /// The padding between local video item and [StreamCallParticipants] borders.
  final double localVideoPadding;

  /// The initial position of the local video view.
  final FloatingViewAlignment initialAlignment;

  /// If the local video should be automatically anchored to one of the
  /// corners.
  final bool enableSnappingBehavior;

  /// The theme for the avatar.
  final StreamUserAvatarThemeData userAvatarTheme;

  /// The border radius of the local video.
  final BorderRadius borderRadius;

  /// The color of shadow.
  final Color shadowColor;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  StreamLocalVideoThemeData copyWith({
    double? localVideoWidth,
    double? localVideoHeight,
    double? localVideoPadding,
    FloatingViewAlignment? initialAlignment,
    bool? enableSnappingBehavior,
    StreamUserAvatarThemeData? userAvatarTheme,
    BorderRadius? borderRadius,
    Color? shadowColor,
  }) {
    return StreamLocalVideoThemeData(
      localVideoWidth: localVideoWidth ?? this.localVideoWidth,
      localVideoHeight: localVideoHeight ?? this.localVideoHeight,
      localVideoPadding: localVideoPadding ?? this.localVideoPadding,
      initialAlignment: initialAlignment ?? this.initialAlignment,
      enableSnappingBehavior:
          enableSnappingBehavior ?? this.enableSnappingBehavior,
      userAvatarTheme: userAvatarTheme ?? this.userAvatarTheme,
      borderRadius: borderRadius ?? this.borderRadius,
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
      localVideoWidth: lerpDouble(localVideoWidth, other.localVideoWidth, t)!,
      localVideoHeight:
          lerpDouble(localVideoHeight, other.localVideoHeight, t)!,
      localVideoPadding:
          lerpDouble(localVideoPadding, other.localVideoPadding, t)!,
      initialAlignment: t < 0.5 ? initialAlignment : other.initialAlignment,
      enableSnappingBehavior:
          t < 0.5 ? enableSnappingBehavior : other.enableSnappingBehavior,
      userAvatarTheme: userAvatarTheme.lerp(other.userAvatarTheme, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
    );
  }

  @override
  int get hashCode => Object.hash(
        localVideoWidth,
        localVideoHeight,
        localVideoPadding,
        initialAlignment,
        enableSnappingBehavior,
        userAvatarTheme,
        borderRadius,
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
        localVideoWidth == other.localVideoWidth &&
        localVideoHeight == other.localVideoHeight &&
        localVideoPadding == other.localVideoPadding &&
        initialAlignment == other.initialAlignment &&
        enableSnappingBehavior == other.enableSnappingBehavior &&
        userAvatarTheme == other.userAvatarTheme &&
        borderRadius == other.borderRadius &&
        shadowColor == other.shadowColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('localVideoWidth', localVideoWidth))
      ..add(DiagnosticsProperty('localVideoHeight', localVideoHeight))
      ..add(DiagnosticsProperty('localVideoPadding', localVideoPadding))
      ..add(DiagnosticsProperty('initialAlignment', initialAlignment))
      ..add(
        DiagnosticsProperty('enableSnappingBehavior', enableSnappingBehavior),
      )
      ..add(DiagnosticsProperty('userAvatarTheme', userAvatarTheme))
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(DiagnosticsProperty('shadowColor', shadowColor));
  }

  /// Merges one [StreamLocalVideoThemeData] with the another.
  StreamLocalVideoThemeData merge(
    StreamLocalVideoThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      localVideoWidth: other.localVideoWidth,
      localVideoHeight: other.localVideoHeight,
      localVideoPadding: other.localVideoPadding,
      initialAlignment: other.initialAlignment,
      enableSnappingBehavior: other.enableSnappingBehavior,
      userAvatarTheme: other.userAvatarTheme,
      borderRadius: other.borderRadius,
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
    final localVideoTheme =
        context.dependOnInheritedWidgetOfExactType<StreamLocalVideoTheme>();
    return localVideoTheme?.data ??
        StreamVideoTheme.of(context).localVideoTheme;
  }

  @override
  bool updateShouldNotify(StreamLocalVideoTheme oldWidget) {
    return data != oldWidget.data;
  }
}
