import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Defines default property values for [StreamCallControls] widgets.
@immutable
class StreamLivestreamThemeData with Diagnosticable {
  /// Creates a new instance of [StreamLivestreamThemeData].
  const StreamLivestreamThemeData({
    this.playIcon = const Icon(
      Icons.play_arrow_rounded,
      color: Colors.white,
    ),
    this.pauseIcon = const Icon(
      Icons.pause_rounded,
      color: Colors.white,
    ),
    this.playPauseIconSize = 64.0,
    this.liveButtonColor = Colors.blue,
    this.backstageButtonColor = Colors.red,
    this.callStateButtonTextStyle = const TextStyle(
      color: Colors.white,
    ),
    this.participantCountTextStyle = const TextStyle(
      color: Colors.white,
    ),
    this.durationTextStyle = const TextStyle(
      color: Colors.white,
    ),
    this.participantIcon = const Icon(
      Icons.remove_red_eye_outlined,
      color: Colors.white,
    ),
    this.speakerEnabledIcon = const Icon(
      Icons.volume_up_rounded,
      color: Colors.white,
    ),
    this.speakerDisabledIcon = const Icon(
      Icons.volume_off_rounded,
      color: Colors.white,
    ),
    this.expandIcon = const Icon(
      Icons.fullscreen,
      color: Colors.white,
    ),
    this.contractIcon = const Icon(
      Icons.fullscreen_exit,
      color: Colors.white,
    ),
  });

  final Icon playIcon;

  final Icon pauseIcon;

  final double playPauseIconSize;

  final Color liveButtonColor;

  final Color backstageButtonColor;

  final TextStyle callStateButtonTextStyle;

  final TextStyle participantCountTextStyle;

  final TextStyle durationTextStyle;

  final Icon participantIcon;

  final Icon speakerEnabledIcon;

  final Icon speakerDisabledIcon;

  final Icon expandIcon;

  final Icon contractIcon;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  StreamLivestreamThemeData copyWith({
    Icon? playIcon,
    Icon? pauseIcon,
    double? playPauseIconSize,
    Color? liveButtonColor,
    Color? backstageButtonColor,
    TextStyle? callStateButtonTextStyle,
    TextStyle? participantCountTextStyle,
    TextStyle? durationTextStyle,
    Icon? participantIcon,
    Icon? speakerEnabledIcon,
    Icon? speakerDisabledIcon,
    Icon? expandIcon,
    Icon? contractIcon,
  }) {
    return StreamLivestreamThemeData(
      playIcon: playIcon ?? this.playIcon,
      pauseIcon: pauseIcon ?? this.pauseIcon,
      playPauseIconSize: playPauseIconSize ?? this.playPauseIconSize,
      liveButtonColor: liveButtonColor ?? this.liveButtonColor,
      backstageButtonColor: backstageButtonColor ?? this.backstageButtonColor,
      callStateButtonTextStyle:
          callStateButtonTextStyle ?? this.callStateButtonTextStyle,
      participantCountTextStyle:
          participantCountTextStyle ?? this.participantCountTextStyle,
      durationTextStyle: durationTextStyle ?? this.durationTextStyle,
      participantIcon: participantIcon ?? this.participantIcon,
      speakerEnabledIcon: speakerEnabledIcon ?? this.speakerEnabledIcon,
      speakerDisabledIcon: speakerDisabledIcon ?? this.speakerDisabledIcon,
      expandIcon: expandIcon ?? this.expandIcon,
      contractIcon: contractIcon ?? this.contractIcon,
    );
  }

  /// Linearly interpolate between two [StreamCallControlsThemeData] themes.
  ///
  /// All the properties must be non-null.
  StreamLivestreamThemeData lerp(
    StreamLivestreamThemeData other,
    double t,
  ) {
    return StreamLivestreamThemeData(
      playIcon: t < 0.5 ? playIcon : other.playIcon,
      pauseIcon: t < 0.5 ? pauseIcon : other.pauseIcon,
      playPauseIconSize:
          lerpDouble(playPauseIconSize, other.playPauseIconSize, t)!,
      liveButtonColor: Color.lerp(liveButtonColor, other.liveButtonColor, t)!,
      backstageButtonColor:
          Color.lerp(backstageButtonColor, other.backstageButtonColor, t)!,
      callStateButtonTextStyle: TextStyle.lerp(
        callStateButtonTextStyle,
        other.callStateButtonTextStyle,
        t,
      )!,
      participantCountTextStyle: TextStyle.lerp(
        participantCountTextStyle,
        other.participantCountTextStyle,
        t,
      )!,
      durationTextStyle:
          TextStyle.lerp(durationTextStyle, other.durationTextStyle, t)!,
      participantIcon: t < 0.5 ? participantIcon : other.participantIcon,
      speakerEnabledIcon:
          t < 0.5 ? speakerEnabledIcon : other.speakerEnabledIcon,
      speakerDisabledIcon:
          t < 0.5 ? speakerDisabledIcon : other.speakerDisabledIcon,
      expandIcon: t < 0.5 ? expandIcon : other.expandIcon,
      contractIcon: t < 0.5 ? contractIcon : other.contractIcon,
    );
  }

  @override
  int get hashCode => Object.hash(
        playIcon,
        pauseIcon,
        playPauseIconSize,
        liveButtonColor,
        backstageButtonColor,
        callStateButtonTextStyle,
        participantCountTextStyle,
        durationTextStyle,
        participantIcon,
        speakerEnabledIcon,
        speakerDisabledIcon,
        expandIcon,
        contractIcon,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is StreamLivestreamThemeData &&
        other.playIcon == playIcon &&
        other.pauseIcon == pauseIcon &&
        other.playPauseIconSize == playPauseIconSize &&
        other.liveButtonColor == liveButtonColor &&
        other.backstageButtonColor == backstageButtonColor &&
        other.callStateButtonTextStyle == callStateButtonTextStyle &&
        other.participantCountTextStyle == participantCountTextStyle &&
        other.durationTextStyle == durationTextStyle &&
        other.participantIcon == participantIcon &&
        other.speakerEnabledIcon == speakerEnabledIcon &&
        other.speakerDisabledIcon == speakerDisabledIcon &&
        other.expandIcon == expandIcon &&
        other.contractIcon == contractIcon;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IconDataProperty('playIcon', playIcon.icon))
      ..add(IconDataProperty('pauseIcon', pauseIcon.icon))
      ..add(DoubleProperty('playPauseIconSize', playPauseIconSize))
      ..add(ColorProperty('liveButtonColor', liveButtonColor))
      ..add(ColorProperty('backstageButtonColor', backstageButtonColor))
      ..add(
        DiagnosticsProperty<TextStyle>(
          'callStateButtonTextStyle',
          callStateButtonTextStyle,
        ),
      )
      ..add(
        DiagnosticsProperty<TextStyle>(
          'participantCountTextStyle',
          participantCountTextStyle,
        ),
      )
      ..add(
        DiagnosticsProperty<TextStyle>('durationTextStyle', durationTextStyle),
      )
      ..add(IconDataProperty('participantIcon', participantIcon.icon))
      ..add(IconDataProperty('speakerEnabledIcon', speakerEnabledIcon.icon))
      ..add(IconDataProperty('speakerDisabledIcon', speakerDisabledIcon.icon))
      ..add(IconDataProperty('expandIcon', expandIcon.icon))
      ..add(IconDataProperty('contractIcon', contractIcon.icon));
  }

  /// Merges one [StreamCallControlsThemeData] with the another.
  StreamLivestreamThemeData merge(StreamLivestreamThemeData? other) {
    if (other == null) return this;
    return copyWith(
      playIcon: other.playIcon,
      pauseIcon: other.pauseIcon,
      playPauseIconSize: other.playPauseIconSize,
      liveButtonColor: other.liveButtonColor,
      backstageButtonColor: other.backstageButtonColor,
      callStateButtonTextStyle: other.callStateButtonTextStyle,
      participantCountTextStyle: other.participantCountTextStyle,
      durationTextStyle: other.durationTextStyle,
      participantIcon: other.participantIcon,
      speakerEnabledIcon: other.speakerEnabledIcon,
      speakerDisabledIcon: other.speakerDisabledIcon,
      expandIcon: other.expandIcon,
      contractIcon: other.contractIcon,
    );
  }
}

/// Applies a call controls theme to descendant [StreamCallControls]
/// widgets.
class StreamLivestreamTheme extends InheritedWidget {
  /// Creates a new instance of [StreamCallControlsTheme].
  const StreamLivestreamTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [StreamLivestreamThemeData] widgets.
  final StreamLivestreamThemeData data;

  /// Returns the configuration [data] from the closest
  /// [StreamCallControlsTheme] ancestor. If there is no ancestor,
  /// it returns [StreamVideoTheme.callControlsTheme].
  static StreamLivestreamThemeData of(BuildContext context) {
    final livestreamTheme =
        context.dependOnInheritedWidgetOfExactType<StreamLivestreamTheme>();
    return livestreamTheme?.data ??
        StreamVideoTheme.of(context).livestreamTheme;
  }

  @override
  bool updateShouldNotify(StreamLivestreamTheme oldWidget) {
    return data != oldWidget.data;
  }
}
