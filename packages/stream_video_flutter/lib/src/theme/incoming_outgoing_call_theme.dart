import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Defines default property values for [StreamIncomingCallContent] and
/// [StreamOutgoingCallContent] widgets.
@immutable
class StreamIncomingOutgoingCallThemeData with Diagnosticable {
  /// Creates a new instance of [StreamIncomingOutgoingCallThemeData].
  const StreamIncomingOutgoingCallThemeData({
    this.singleParticipantAvatarTheme = const StreamUserAvatarThemeData(
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
    this.multipleParticipantAvatarTheme = const StreamUserAvatarThemeData(
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
  final StreamUserAvatarThemeData singleParticipantAvatarTheme;

  /// Theme for the avatar in a call with multiple participants.
  final StreamUserAvatarThemeData multipleParticipantAvatarTheme;

  /// Text style for the participant label in a call with one participant.
  final TextStyle singleParticipantTextStyle;

  /// Text style for the participant label in a call with multiple participants.
  final TextStyle multipleParticipantTextStyle;

  /// Text style for the calling label.
  final TextStyle callingLabelTextStyle;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  StreamIncomingOutgoingCallThemeData copyWith({
    StreamUserAvatarThemeData? singleParticipantAvatarTheme,
    StreamUserAvatarThemeData? multipleParticipantAvatarTheme,
    TextStyle? singleParticipantTextStyle,
    TextStyle? multipleParticipantTextStyle,
    TextStyle? callingLabelTextStyle,
  }) {
    return StreamIncomingOutgoingCallThemeData(
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

  /// Linearly interpolate between two [StreamIncomingOutgoingCallThemeData]
  /// themes.
  ///
  /// All the properties must be non-null.
  StreamIncomingOutgoingCallThemeData lerp(
    StreamIncomingOutgoingCallThemeData other,
    double t,
  ) {
    return StreamIncomingOutgoingCallThemeData(
      singleParticipantAvatarTheme: singleParticipantAvatarTheme.lerp(
        other.singleParticipantAvatarTheme,
        t,
      ),
      multipleParticipantAvatarTheme: multipleParticipantAvatarTheme.lerp(
        other.multipleParticipantAvatarTheme,
        t,
      ),
      singleParticipantTextStyle: TextStyle.lerp(
        singleParticipantTextStyle,
        other.singleParticipantTextStyle,
        t,
      )!,
      multipleParticipantTextStyle: TextStyle.lerp(
        multipleParticipantTextStyle,
        other.multipleParticipantTextStyle,
        t,
      )!,
      callingLabelTextStyle: TextStyle.lerp(
        callingLabelTextStyle,
        other.callingLabelTextStyle,
        t,
      )!,
    );
  }

  @override
  int get hashCode => Object.hash(
        singleParticipantAvatarTheme,
        multipleParticipantAvatarTheme,
        singleParticipantTextStyle,
        multipleParticipantTextStyle,
        callingLabelTextStyle,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is StreamIncomingOutgoingCallThemeData &&
        runtimeType == other.runtimeType &&
        singleParticipantAvatarTheme == other.singleParticipantAvatarTheme &&
        multipleParticipantAvatarTheme ==
            other.multipleParticipantAvatarTheme &&
        singleParticipantTextStyle == other.singleParticipantTextStyle &&
        multipleParticipantTextStyle == other.multipleParticipantTextStyle &&
        callingLabelTextStyle == other.callingLabelTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty(
          'singleParticipantAvatarTheme',
          singleParticipantAvatarTheme,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'multipleParticipantAvatarTheme',
          multipleParticipantAvatarTheme,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'singleParticipantTextStyle',
          singleParticipantTextStyle,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'multipleParticipantTextStyle',
          multipleParticipantTextStyle,
        ),
      )
      ..add(
        DiagnosticsProperty('callingLabelTextStyle', callingLabelTextStyle),
      );
  }

  /// Merges one [StreamIncomingOutgoingCallThemeData] with the another.
  StreamIncomingOutgoingCallThemeData merge(
    StreamIncomingOutgoingCallThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      singleParticipantAvatarTheme: other.singleParticipantAvatarTheme,
      multipleParticipantAvatarTheme: other.multipleParticipantAvatarTheme,
      singleParticipantTextStyle: other.singleParticipantTextStyle,
      multipleParticipantTextStyle: other.multipleParticipantTextStyle,
      callingLabelTextStyle: other.callingLabelTextStyle,
    );
  }
}

/// Applies a incoming/outgoing call theme to descendant [StreamIncomingCallContent]
/// and [StreamOutgoingCallContent] widgets.
class StreamIncomingOutgoingCallTheme extends InheritedWidget {
  /// Creates a new instance of [StreamIncomingOutgoingCallTheme].
  const StreamIncomingOutgoingCallTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [StreamIncomingCallContent] and
  /// [StreamOutgoingCallContent] widgets.
  final StreamIncomingOutgoingCallThemeData data;

  /// Returns the configuration [data] from the closest
  /// [StreamIncomingOutgoingCallTheme] ancestor. If there is no ancestor,
  /// it returns [StreamVideoTheme.incomingCallTheme].
  static StreamIncomingOutgoingCallThemeData incomingCallThemeOf(
    BuildContext context,
  ) {
    final incomingOutgoingCallTheme = context
        .dependOnInheritedWidgetOfExactType<StreamIncomingOutgoingCallTheme>();
    return incomingOutgoingCallTheme?.data ??
        StreamVideoTheme.of(context).incomingCallTheme;
  }

  /// Returns the configuration [data] from the closest
  /// [StreamIncomingOutgoingCallTheme] ancestor. If there is no ancestor,
  /// it returns [StreamVideoTheme.outgoingCallTheme].
  static StreamIncomingOutgoingCallThemeData outgoingCallThemeOf(
    BuildContext context,
  ) {
    final incomingOutgoingCallTheme = context
        .dependOnInheritedWidgetOfExactType<StreamIncomingOutgoingCallTheme>();
    return incomingOutgoingCallTheme?.data ??
        StreamVideoTheme.of(context).outgoingCallTheme;
  }

  @override
  bool updateShouldNotify(StreamIncomingOutgoingCallTheme oldWidget) {
    return data != oldWidget.data;
  }
}
