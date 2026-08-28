// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../widgets/avatar_size_from_constraints.dart';

/// Defines default property values for [StreamParticipantTile] widgets.
///
/// Nothing reads this any more. It survives so existing code keeps compiling,
/// and is translated onto the component themes once — in the
/// [StreamVideoTheme] factory. Reaching it any other way, through
/// [StreamVideoTheme.copyWith] or the [StreamCallParticipantTheme] widget,
/// sets the value without restyling anything.
@Deprecated(
  'Use participantTileTheme, participantLabelTheme, '
  'connectionQualityIndicatorTheme and callParticipantsGridTheme instead. '
  'Will be removed in the next major version.',
)
@immutable
class StreamCallParticipantThemeData with Diagnosticable {
  /// Creates a new instance of [StreamCallParticipantThemeData].
  @Deprecated(
    'Use participantTileTheme, participantLabelTheme, '
    'connectionQualityIndicatorTheme and callParticipantsGridTheme instead. '
    'Will be removed in the next major version.',
  )
  const StreamCallParticipantThemeData({
    this.videoFit,
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
    this.pausedVideoIndicatorColor = Colors.white,
    this.showConnectionQualityIndicator = true,
    this.connectionLevelActiveColor = const Color(0xff005FFF),
    this.connectionLevelInactiveColor = Colors.white,
    this.connectionLevelAlignment = Alignment.bottomRight,
    this.participantsGridPadding = const EdgeInsets.all(8),
    this.participantsGridMainAxisSpacing = 8,
    this.participantsGridCrossAxisSpacing = 8,
  });

  // ignore: comment_references
  /// The fit of the [VideoRenderer] widget.
  ///
  /// When `null`, [defaultVideoFit] is used, which resolves to
  /// [VideoFit.adaptive] on web and desktop and [VideoFit.cover] on mobile.
  final VideoFit? videoFit;

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

  /// The color of a paused video track icon.
  final Color pausedVideoIndicatorColor;

  /// Whether to show the connection quality indicator.
  final bool showConnectionQualityIndicator;

  /// The color of an active connection quality level.
  final Color connectionLevelActiveColor;

  /// The color of an inactive connection quality level.
  final Color connectionLevelInactiveColor;

  /// Alignment for the connection level.
  final AlignmentGeometry connectionLevelAlignment;

  /// The padding between the participants in the grid layout.
  final EdgeInsets participantsGridPadding;

  /// Main axis spacing between the participants in the grid layout.
  final double participantsGridMainAxisSpacing;

  /// Cross axis spacing between the participants in the grid layout.
  final double participantsGridCrossAxisSpacing;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  StreamCallParticipantThemeData copyWith({
    VideoFit? videoFit,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    StreamUserAvatarThemeData? userAvatarTheme,
    bool? showSpeakerBorder,
    double? speakerBorderThickness,
    Color? speakerBorderColor,
    bool? showParticipantLabel,
    TextStyle? participantLabelTextStyle,
    AlignmentGeometry? participantLabelAlignment,
    Color? audioLevelIndicatorColor,
    Color? enabledMicrophoneColor,
    Color? disabledMicrophoneColor,
    Color? pausedVideoIndicatorColor,
    bool? showConnectionQualityIndicator,
    Color? connectionLevelActiveColor,
    Color? connectionLevelInactiveColor,
    AlignmentGeometry? connectionLevelAlignment,
    EdgeInsets? participantsGridPadding,
    double? participantsGridMainAxisSpacing,
    double? participantsGridCrossAxisSpacing,
  }) {
    return StreamCallParticipantThemeData(
      videoFit: videoFit ?? this.videoFit,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      userAvatarTheme: userAvatarTheme ?? this.userAvatarTheme,
      showSpeakerBorder: showSpeakerBorder ?? this.showSpeakerBorder,
      speakerBorderThickness:
          speakerBorderThickness ?? this.speakerBorderThickness,
      speakerBorderColor: speakerBorderColor ?? this.speakerBorderColor,
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
      pausedVideoIndicatorColor:
          pausedVideoIndicatorColor ?? this.pausedVideoIndicatorColor,
      showConnectionQualityIndicator:
          showConnectionQualityIndicator ?? this.showConnectionQualityIndicator,
      connectionLevelActiveColor:
          connectionLevelActiveColor ?? this.connectionLevelActiveColor,
      connectionLevelInactiveColor:
          connectionLevelInactiveColor ?? this.connectionLevelInactiveColor,
      connectionLevelAlignment:
          connectionLevelAlignment ?? this.connectionLevelAlignment,
      participantsGridPadding:
          participantsGridPadding ?? this.participantsGridPadding,
      participantsGridMainAxisSpacing:
          participantsGridMainAxisSpacing ??
          this.participantsGridMainAxisSpacing,
      participantsGridCrossAxisSpacing:
          participantsGridCrossAxisSpacing ??
          this.participantsGridCrossAxisSpacing,
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
      videoFit: t < 0.5 ? videoFit : other.videoFit,
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
      showParticipantLabel: t < 0.5
          ? showParticipantLabel
          : other.showParticipantLabel,
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
      enabledMicrophoneColor: Color.lerp(
        enabledMicrophoneColor,
        other.enabledMicrophoneColor,
        t,
      )!,
      disabledMicrophoneColor: Color.lerp(
        disabledMicrophoneColor,
        other.disabledMicrophoneColor,
        t,
      )!,
      pausedVideoIndicatorColor: Color.lerp(
        pausedVideoIndicatorColor,
        other.pausedVideoIndicatorColor,
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
      participantsGridPadding: EdgeInsets.lerp(
        participantsGridPadding,
        other.participantsGridPadding,
        t,
      )!,
      participantsGridMainAxisSpacing: lerpDouble(
        participantsGridMainAxisSpacing,
        other.participantsGridMainAxisSpacing,
        t,
      )!,
      participantsGridCrossAxisSpacing: lerpDouble(
        participantsGridCrossAxisSpacing,
        other.participantsGridCrossAxisSpacing,
        t,
      )!,
    );
  }

  @override
  int get hashCode => Object.hash(
    videoFit,
    backgroundColor,
    borderRadius,
    userAvatarTheme,
    showSpeakerBorder,
    speakerBorderThickness,
    speakerBorderColor,
    showParticipantLabel,
    participantLabelTextStyle,
    participantLabelAlignment,
    showConnectionQualityIndicator,
    connectionLevelAlignment,
    participantsGridPadding,
    participantsGridMainAxisSpacing,
    participantsGridCrossAxisSpacing,
    Object.hash(
      audioLevelIndicatorColor,
      enabledMicrophoneColor,
      disabledMicrophoneColor,
      pausedVideoIndicatorColor,
      connectionLevelActiveColor,
      connectionLevelInactiveColor,
    ),
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
        other.videoFit == videoFit &&
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
        other.pausedVideoIndicatorColor == pausedVideoIndicatorColor &&
        other.showConnectionQualityIndicator ==
            showConnectionQualityIndicator &&
        other.connectionLevelActiveColor == connectionLevelActiveColor &&
        other.connectionLevelInactiveColor == connectionLevelInactiveColor &&
        other.connectionLevelAlignment == connectionLevelAlignment &&
        other.participantsGridPadding == participantsGridPadding &&
        other.participantsGridMainAxisSpacing ==
            participantsGridMainAxisSpacing &&
        other.participantsGridCrossAxisSpacing ==
            participantsGridCrossAxisSpacing;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('videoFit', videoFit))
      ..add(DiagnosticsProperty('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(DiagnosticsProperty('userAvatarTheme', userAvatarTheme))
      ..add(DiagnosticsProperty('showSpeakerBorder', showSpeakerBorder))
      ..add(
        DiagnosticsProperty('speakerBorderThickness', speakerBorderThickness),
      )
      ..add(DiagnosticsProperty('speakerBorderColor', speakerBorderColor))
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
          'pausedVideoIndicatorColor',
          pausedVideoIndicatorColor,
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
      )
      ..add(
        DiagnosticsProperty(
          'participantsGridPadding',
          participantsGridPadding,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'participantsGridMainAxisSpacing',
          participantsGridMainAxisSpacing,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'participantsGridCrossAxisSpacing',
          participantsGridCrossAxisSpacing,
        ),
      );
  }

  /// Merges one [StreamCallParticipantThemeData] with the another.
  StreamCallParticipantThemeData merge(StreamCallParticipantThemeData? other) {
    if (other == null) return this;
    return copyWith(
      videoFit: other.videoFit,
      backgroundColor: other.backgroundColor,
      borderRadius: other.borderRadius,
      userAvatarTheme: other.userAvatarTheme,
      showSpeakerBorder: other.showSpeakerBorder,
      speakerBorderThickness: other.speakerBorderThickness,
      speakerBorderColor: other.speakerBorderColor,
      showParticipantLabel: other.showParticipantLabel,
      participantLabelTextStyle: other.participantLabelTextStyle,
      participantLabelAlignment: other.participantLabelAlignment,
      audioLevelIndicatorColor: other.audioLevelIndicatorColor,
      enabledMicrophoneColor: other.enabledMicrophoneColor,
      disabledMicrophoneColor: other.disabledMicrophoneColor,
      pausedVideoIndicatorColor: other.pausedVideoIndicatorColor,
      showConnectionQualityIndicator: other.showConnectionQualityIndicator,
      connectionLevelActiveColor: other.connectionLevelActiveColor,
      connectionLevelInactiveColor: other.connectionLevelInactiveColor,
      connectionLevelAlignment: other.connectionLevelAlignment,
      participantsGridPadding: other.participantsGridPadding,
      participantsGridMainAxisSpacing: other.participantsGridMainAxisSpacing,
      participantsGridCrossAxisSpacing: other.participantsGridCrossAxisSpacing,
    );
  }

  // ── Migration to the component themes ──────────────────────────────────────
  //
  // `StreamVideoTheme.callParticipantTheme` is null unless an app sets one, so
  // a value reaching here means somebody deliberately styled the tile through
  // the deprecated shape. Everything it carries is translated, defaults
  // included — an app that wants the redesigned tile stops setting it rather
  // than setting parts of it.
  //
  // The translation runs in the `StreamVideoTheme` factory, which is where a
  // theme is built. Reaching the deprecated shape any other way — through
  // `copyWith`, or through the `StreamCallParticipantTheme` widget — sets the
  // field without restyling anything.

  static const _defaults = StreamCallParticipantThemeData();

  /// The subset of this theme that describes the participant tile.
  StreamParticipantTileThemeData toParticipantTileThemeData() {
    return StreamParticipantTileThemeData(
      style: StreamParticipantTileStyle(
        videoFit: videoFit,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        speakingBorder: Border.all(
          color: speakerBorderColor,
          width: speakerBorderThickness,
        ),
        showSpeakerBorder: showSpeakerBorder,
        showParticipantLabel: showParticipantLabel,
        showConnectionQualityIndicator: showConnectionQualityIndicator,
        placeholderStyle: StreamParticipantPlaceholderStyle(
          avatarTheme: StreamAvatarThemeData(
            size: avatarSizeFromConstraints(userAvatarTheme.constraints),
            backgroundColor: userAvatarTheme.initialsBackground,
            foregroundColor: userAvatarTheme.initialsTextStyle.color,
          ),
        ),
      ),
    );
  }

  /// The subset of this theme that describes the participant name pill.
  StreamParticipantLabelThemeData toParticipantLabelThemeData() {
    return StreamParticipantLabelThemeData(
      style: StreamParticipantLabelStyle(
        nameTextStyle: participantLabelTextStyle,
        speakingColor: audioLevelIndicatorColor,
        microphoneOffColor: disabledMicrophoneColor,
        videoOffIconColor: pausedVideoIndicatorColor,
      ),
    );
  }

  /// The subset of this theme that describes the connection quality indicator.
  StreamConnectionQualityIndicatorThemeData
  toConnectionQualityIndicatorThemeData() {
    return StreamConnectionQualityIndicatorThemeData(
      style: StreamConnectionQualityIndicatorStyle(
        // The indicator colours each level apart now. The single colour this
        // theme carries spreads across all three, so it still reads as one
        // flat colour the way it used to.
        poorColor: connectionLevelActiveColor,
        fairColor: connectionLevelActiveColor,
        greatColor: connectionLevelActiveColor,
        inactiveColor: connectionLevelInactiveColor,
      ),
    );
  }

  /// The subset of this theme that describes the participants grid layout.
  StreamCallParticipantsGridThemeData toCallParticipantsGridThemeData() {
    return StreamCallParticipantsGridThemeData(
      padding: participantsGridPadding,
      mainAxisSpacing: participantsGridMainAxisSpacing,
      crossAxisSpacing: participantsGridCrossAxisSpacing,
    );
  }
}

/// Applies a call participant theme to descendant [StreamParticipantTile]
/// widgets.
///
/// The tile and its parts no longer read this, so wrapping a subtree in one
/// restyles nothing. Scope the component themes instead: [
/// StreamParticipantTileTheme], [StreamParticipantLabelTheme],
/// [StreamConnectionQualityIndicatorTheme] and
/// [StreamCallParticipantsGridTheme] each wrap a subtree the same way.
@Deprecated(
  'Use StreamParticipantTileTheme, StreamParticipantLabelTheme, '
  'StreamConnectionQualityIndicatorTheme or StreamCallParticipantsGridTheme '
  'instead. Will be removed in the next major version.',
)
class StreamCallParticipantTheme extends InheritedWidget {
  /// Creates a new instance of [StreamCallParticipantTheme].
  @Deprecated(
    'Use StreamParticipantTileTheme, StreamParticipantLabelTheme, '
    'StreamConnectionQualityIndicatorTheme or StreamCallParticipantsGridTheme '
    'instead. Will be removed in the next major version.',
  )
  const StreamCallParticipantTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [StreamParticipantTile] widgets.
  final StreamCallParticipantThemeData data;

  /// Returns the configuration [data] from the closest
  /// [StreamCallParticipantTheme] ancestor.
  ///
  /// Falls back to [StreamVideoTheme.callParticipantTheme], and then to this
  /// class's own defaults — which nothing reads any more. The tile and its
  /// parts resolve their appearance from the component themes; this survives
  /// only so existing calls keep compiling.
  static StreamCallParticipantThemeData of(BuildContext context) {
    final callParticipantTheme = context
        .dependOnInheritedWidgetOfExactType<StreamCallParticipantTheme>();
    return callParticipantTheme?.data ??
        StreamVideoTheme.of(context).callParticipantTheme ??
        StreamCallParticipantThemeData._defaults;
  }

  @override
  bool updateShouldNotify(StreamCallParticipantTheme oldWidget) {
    return data != oldWidget.data;
  }
}
