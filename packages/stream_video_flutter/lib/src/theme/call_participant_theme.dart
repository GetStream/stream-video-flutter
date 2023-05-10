import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Defines default property values for [StreamCallParticipant] widgets.
@immutable
class StreamCallParticipantThemeData with Diagnosticable {
  /// Creates a new instance of [StreamCallParticipantThemeData].
  const StreamCallParticipantThemeData({
    this.backgroundColor = const Color(0xffB4B7BB),
    this.borderRadius = BorderRadius.zero,
    this.userAvatarTheme = const StreamUserAvatarThemeData(
      constraints: BoxConstraints.tightFor(
        height: 100,
        width: 100,
      ),
      borderRadius: BorderRadius.all(Radius.circular(50)),
      initialsTextStyle: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      selectionColor: const Color(0xFF005FFF),
      selectionThickness: 4,
    ),
    this.showSpeakerBorder = true,
    this.speakerBorderThickness = 4,
    this.speakerBorderColor = const Color(0xff005FFF),
    this.showParticipantLabel = true,
    this.participantLabelTextStyle = const TextStyle(
      fontSize: 12,
      color: Colors.white,
    ),
    this.participantLabelAlignment = Alignment.bottomLeft,
    this.audioLevelIndicatorColor = const Color(0xff005FFF),
    this.enabledMicrophoneColor = Colors.white,
    this.disabledMicrophoneColor = const Color(0xffFF3842),
    this.showConnectionQualityIndicator = true,
    this.connectionLevelActiveColor = const Color(0xff005FFF),
    this.connectionLevelInactiveColor = Colors.white,
    this.connectionLevelAlignment = Alignment.bottomRight,
  });

  /// The background color of the call participant.
  final Color backgroundColor;

  /// The border radius of the call participant.
  final BorderRadius borderRadius;

  /// The theme for the avatar.
  final StreamUserAvatarThemeData userAvatarTheme;

  /// Whether to highlight the participant when he/she is speaking.
  final bool showSpeakerBorder;

  /// The thickness of the speaker border.
  final double speakerBorderThickness;

  /// The color of the speaker border.
  final Color speakerBorderColor;

  /// Whether to show the label with participant name and mute status.
  final bool showParticipantLabel;

  /// Text style for the participant label.
  final TextStyle participantLabelTextStyle;

  /// Alignment for the participant label.
  final AlignmentGeometry participantLabelAlignment;

  /// The color of an audio level indicator.
  final Color audioLevelIndicatorColor;

  /// The color of an enabled microphone icon.
  final Color enabledMicrophoneColor;

  /// The color of a disabled microphone icon.
  final Color disabledMicrophoneColor;

  /// Whether to show the connection quality indicator.
  final bool showConnectionQualityIndicator;

  /// The color of an active connection quality level.
  final Color connectionLevelActiveColor;

  /// The color of an inactive connection quality level.
  final Color connectionLevelInactiveColor;

  /// Alignment for the connection level.
  final AlignmentGeometry connectionLevelAlignment;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  StreamCallParticipantThemeData copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    StreamUserAvatarThemeData? userAvatarTheme,
    bool? showDominantSpeakerBorder,
    double? dominantSpeakerBorderThickness,
    Color? dominantSpeakerBorderColor,
    bool? showParticipantLabel,
    TextStyle? participantLabelTextStyle,
    AlignmentGeometry? participantLabelAlignment,
    Color? audioLevelIndicatorColor,
    Color? enabledMicrophoneColor,
    Color? disabledMicrophoneColor,
    bool? showConnectionQualityIndicator,
    Color? connectionLevelActiveColor,
    Color? connectionLevelInactiveColor,
    AlignmentGeometry? connectionLevelAlignment,
  }) {
    return StreamCallParticipantThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      userAvatarTheme: userAvatarTheme ?? this.userAvatarTheme,
      showSpeakerBorder: showDominantSpeakerBorder ?? this.showSpeakerBorder,
      speakerBorderThickness:
          dominantSpeakerBorderThickness ?? this.speakerBorderThickness,
      speakerBorderColor: dominantSpeakerBorderColor ?? this.speakerBorderColor,
      showParticipantLabel: showParticipantLabel ?? this.showParticipantLabel,
      participantLabelTextStyle:
          participantLabelTextStyle ?? this.participantLabelTextStyle,
      participantLabelAlignment:
          participantLabelAlignment ?? this.participantLabelAlignment,
      audioLevelIndicatorColor:
          audioLevelIndicatorColor ?? this.audioLevelIndicatorColor,
      enabledMicrophoneColor:
          enabledMicrophoneColor ?? this.enabledMicrophoneColor,
      disabledMicrophoneColor:
          disabledMicrophoneColor ?? this.disabledMicrophoneColor,
      showConnectionQualityIndicator:
          showConnectionQualityIndicator ?? this.showConnectionQualityIndicator,
      connectionLevelActiveColor:
          connectionLevelActiveColor ?? this.connectionLevelActiveColor,
      connectionLevelInactiveColor:
          connectionLevelInactiveColor ?? this.connectionLevelInactiveColor,
      connectionLevelAlignment:
          connectionLevelAlignment ?? this.connectionLevelAlignment,
    );
  }

  /// Linearly interpolate between two [StreamCallParticipantThemeData] themes.
  ///
  /// All the properties must be non-null.
  StreamCallParticipantThemeData lerp(
    StreamCallParticipantThemeData other,
    double t,
  ) {
    return StreamCallParticipantThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      userAvatarTheme: userAvatarTheme.lerp(other.userAvatarTheme, t),
      showSpeakerBorder: t < 0.5 ? showSpeakerBorder : other.showSpeakerBorder,
      speakerBorderThickness: lerpDouble(
        speakerBorderThickness,
        other.speakerBorderThickness,
        t,
      )!,
      speakerBorderColor: Color.lerp(
        speakerBorderColor,
        other.speakerBorderColor,
        t,
      )!,
      showParticipantLabel:
          t < 0.5 ? showParticipantLabel : other.showParticipantLabel,
      participantLabelTextStyle: TextStyle.lerp(
        participantLabelTextStyle,
        other.participantLabelTextStyle,
        t,
      )!,
      participantLabelAlignment: AlignmentGeometry.lerp(
        participantLabelAlignment,
        other.participantLabelAlignment,
        t,
      )!,
      audioLevelIndicatorColor: Color.lerp(
        audioLevelIndicatorColor,
        other.audioLevelIndicatorColor,
        t,
      )!,
      enabledMicrophoneColor:
          Color.lerp(enabledMicrophoneColor, other.enabledMicrophoneColor, t)!,
      disabledMicrophoneColor: Color.lerp(
        disabledMicrophoneColor,
        other.disabledMicrophoneColor,
        t,
      )!,
      showConnectionQualityIndicator: t < 0.5
          ? showConnectionQualityIndicator
          : other.showConnectionQualityIndicator,
      connectionLevelActiveColor: Color.lerp(
        connectionLevelActiveColor,
        other.connectionLevelActiveColor,
        t,
      )!,
      connectionLevelInactiveColor: Color.lerp(
        connectionLevelInactiveColor,
        other.connectionLevelInactiveColor,
        t,
      )!,
      connectionLevelAlignment: AlignmentGeometry.lerp(
        connectionLevelAlignment,
        other.connectionLevelAlignment,
        t,
      )!,
    );
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        borderRadius,
        userAvatarTheme,
        showSpeakerBorder,
        speakerBorderThickness,
        speakerBorderColor,
        showParticipantLabel,
        participantLabelTextStyle,
        participantLabelAlignment,
        audioLevelIndicatorColor,
        enabledMicrophoneColor,
        disabledMicrophoneColor,
        showConnectionQualityIndicator,
        connectionLevelActiveColor,
        connectionLevelInactiveColor,
        connectionLevelAlignment,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is StreamCallParticipantThemeData &&
        other.backgroundColor == backgroundColor &&
        other.borderRadius == borderRadius &&
        other.userAvatarTheme == userAvatarTheme &&
        other.showSpeakerBorder == showSpeakerBorder &&
        other.speakerBorderThickness == speakerBorderThickness &&
        other.speakerBorderColor == speakerBorderColor &&
        other.showParticipantLabel == showParticipantLabel &&
        other.participantLabelTextStyle == participantLabelTextStyle &&
        other.participantLabelAlignment == participantLabelAlignment &&
        other.audioLevelIndicatorColor == audioLevelIndicatorColor &&
        other.enabledMicrophoneColor == enabledMicrophoneColor &&
        other.disabledMicrophoneColor == disabledMicrophoneColor &&
        other.showConnectionQualityIndicator ==
            showConnectionQualityIndicator &&
        other.connectionLevelActiveColor == connectionLevelActiveColor &&
        other.connectionLevelInactiveColor == connectionLevelInactiveColor &&
        other.connectionLevelAlignment == connectionLevelAlignment;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(DiagnosticsProperty('userAvatarTheme', userAvatarTheme))
      ..add(
        DiagnosticsProperty(
          'showDominantSpeakerBorder',
          showSpeakerBorder,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'dominantSpeakerBorderThickness',
          speakerBorderThickness,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'dominantSpeakerBorderColor',
          speakerBorderColor,
        ),
      )
      ..add(DiagnosticsProperty('showParticipantLabel', showParticipantLabel))
      ..add(
        DiagnosticsProperty(
          'participantLabelTextStyle',
          participantLabelTextStyle,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'participantLabelAlignment',
          participantLabelAlignment,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'audioLevelIndicatorColor',
          audioLevelIndicatorColor,
        ),
      )
      ..add(
        DiagnosticsProperty('enabledMicrophoneColor', enabledMicrophoneColor),
      )
      ..add(
        DiagnosticsProperty(
          'disabledMicrophoneColor',
          disabledMicrophoneColor,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'showConnectionQualityIndicator',
          showConnectionQualityIndicator,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'connectionLevelActiveColor',
          connectionLevelActiveColor,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'connectionLevelInactiveColor',
          connectionLevelInactiveColor,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'connectionLevelAlignment',
          connectionLevelAlignment,
        ),
      );
  }

  /// Merges one [StreamCallParticipantThemeData] with the another.
  StreamCallParticipantThemeData merge(StreamCallParticipantThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      borderRadius: other.borderRadius,
      userAvatarTheme: other.userAvatarTheme,
      showDominantSpeakerBorder: other.showSpeakerBorder,
      dominantSpeakerBorderThickness: other.speakerBorderThickness,
      dominantSpeakerBorderColor: other.speakerBorderColor,
      showParticipantLabel: other.showParticipantLabel,
      participantLabelTextStyle: other.participantLabelTextStyle,
      participantLabelAlignment: other.participantLabelAlignment,
      audioLevelIndicatorColor: other.audioLevelIndicatorColor,
      enabledMicrophoneColor: other.enabledMicrophoneColor,
      disabledMicrophoneColor: other.disabledMicrophoneColor,
      showConnectionQualityIndicator: other.showConnectionQualityIndicator,
      connectionLevelActiveColor: other.connectionLevelActiveColor,
      connectionLevelInactiveColor: other.connectionLevelInactiveColor,
      connectionLevelAlignment: other.connectionLevelAlignment,
    );
  }
}

/// Applies a call participant theme to descendant [StreamCallParticipant]
/// widgets.
class StreamCallParticipantTheme extends InheritedWidget {
  /// Creates a new instance of [StreamCallParticipantTheme].
  const StreamCallParticipantTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [StreamCallParticipant] widgets.
  final StreamCallParticipantThemeData data;

  /// Returns the configuration [data] from the closest
  /// [StreamCallParticipantTheme] ancestor. If there is no ancestor,
  /// it returns [StreamVideoTheme.callParticipantTheme].
  static StreamCallParticipantThemeData of(BuildContext context) {
    final callParticipantTheme = context
        .dependOnInheritedWidgetOfExactType<StreamCallParticipantTheme>();
    return callParticipantTheme?.data ??
        StreamVideoTheme.of(context).callParticipantTheme;
  }

  @override
  bool updateShouldNotify(StreamCallParticipantTheme oldWidget) {
    return data != oldWidget.data;
  }
}
