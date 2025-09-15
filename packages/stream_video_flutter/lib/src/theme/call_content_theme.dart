import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Defines default property values for [StreamCallContent] widgets.
@immutable
class StreamCallContentThemeData with Diagnosticable {
  /// Creates a new instance of [StreamCallContentThemeData].
  const StreamCallContentThemeData({
    this.callContentBackgroundColor = const Color(0XFF272A30),
  });

  /// Theme for the avatar in a call with one participant.
  final Color callContentBackgroundColor;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  StreamCallContentThemeData copyWith({
    Color? callContentBackgroundColor,
  }) {
    return StreamCallContentThemeData(
      callContentBackgroundColor:
          callContentBackgroundColor ?? this.callContentBackgroundColor,
    );
  }

  /// Linearly interpolate between two [StreamCallContentThemeData]
  /// themes.
  ///
  /// All the properties must be non-null.
  StreamCallContentThemeData lerp(
    StreamCallContentThemeData other,
    double t,
  ) {
    return StreamCallContentThemeData(
      callContentBackgroundColor: Color.lerp(
        callContentBackgroundColor,
        other.callContentBackgroundColor,
        t,
      )!,
    );
  }

  @override
  int get hashCode => Object.hashAll(
    [
      callContentBackgroundColor,
    ],
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is StreamCallContentThemeData &&
        runtimeType == other.runtimeType &&
        callContentBackgroundColor == other.callContentBackgroundColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty(
        'callContentBackgroundColor',
        callContentBackgroundColor,
      ),
    );
  }

  /// Merges one [StreamCallContentThemeData] with the another.
  StreamCallContentThemeData merge(
    StreamCallContentThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      callContentBackgroundColor: other.callContentBackgroundColor,
    );
  }
}

/// Applies a theme to descendant [StreamCallContent]
class StreamCallContentTheme extends InheritedWidget {
  /// Creates a new instance of [StreamCallContentTheme].
  const StreamCallContentTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [StreamCallContent] widgets.
  final StreamCallContentThemeData data;

  /// Returns the configuration [data] from the closest
  /// [StreamCallContentTheme] ancestor. If there is no ancestor,
  /// it returns [StreamVideoTheme.callContentTheme].
  static StreamCallContentThemeData incomingCallThemeOf(
    BuildContext context,
  ) {
    final incomingOutgoingCallTheme = context
        .dependOnInheritedWidgetOfExactType<StreamCallContentTheme>();
    return incomingOutgoingCallTheme?.data ??
        StreamVideoTheme.of(context).callContentTheme;
  }

  @override
  bool updateShouldNotify(StreamCallContentTheme oldWidget) {
    return data != oldWidget.data;
  }
}
