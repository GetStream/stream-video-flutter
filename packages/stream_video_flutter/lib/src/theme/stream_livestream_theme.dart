import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Defines default property values for [StreamLivestreamThemeData] widgets.
@immutable
class StreamLivestreamThemeData with Diagnosticable {
  /// Creates a new instance of [StreamLivestreamThemeData].
  const StreamLivestreamThemeData({
    this.playIconTheme = const IconThemeData(
      color: Colors.white,
    ),
    this.pauseIconTheme = const IconThemeData(
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
    this.participantIconTheme = const IconThemeData(
      color: Colors.white,
    ),
    this.speakerEnabledIconTheme = const IconThemeData(
      color: Colors.white,
    ),
    this.speakerDisabledIconTheme = const IconThemeData(
      color: Colors.white,
    ),
    this.expandIconTheme = const IconThemeData(
      color: Colors.white,
    ),
    this.contractIconTheme = const IconThemeData(
      color: Colors.white,
    ),
  });

  /// The icon theme for the play icon for playing the livestream
  final IconThemeData playIconTheme;

  /// The icon theme for the pause icon for pausing the livestream
  final IconThemeData pauseIconTheme;

  /// The size of the play/pause icon
  final double playPauseIconSize;

  /// The color of the "live" button on the control bar
  final Color liveButtonColor;

  /// The color of the "backstage" button on the control bar
  final Color backstageButtonColor;

  /// The [TextStyle] for the live/backstage button
  final TextStyle callStateButtonTextStyle;

  /// The [TextStyle] for the participant count
  final TextStyle participantCountTextStyle;

  /// The [TextStyle] for the duration count
  final TextStyle durationTextStyle;

  /// The icon theme for the participant icon
  final IconThemeData participantIconTheme;

  /// The icon theme for the speaker enabled icon on the control bar
  final IconThemeData speakerEnabledIconTheme;

  /// The icon theme for the speaker disabled icon on the control bar
  final IconThemeData speakerDisabledIconTheme;

  /// The icon theme for the expand icon on the control bar
  final IconThemeData expandIconTheme;

  /// The icon theme for the contract icon on the control bar
  final IconThemeData contractIconTheme;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  StreamLivestreamThemeData copyWith({
    IconThemeData? playIconTheme,
    IconThemeData? pauseIconTheme,
    double? playPauseIconSize,
    Color? liveButtonColor,
    Color? backstageButtonColor,
    TextStyle? callStateButtonTextStyle,
    TextStyle? participantCountTextStyle,
    TextStyle? durationTextStyle,
    IconThemeData? participantIconTheme,
    IconThemeData? speakerEnabledIconTheme,
    IconThemeData? speakerDisabledIconTheme,
    IconThemeData? expandIconTheme,
    IconThemeData? contractIconTheme,
  }) {
    return StreamLivestreamThemeData(
      playIconTheme: playIconTheme ?? this.playIconTheme,
      pauseIconTheme: pauseIconTheme ?? this.pauseIconTheme,
      playPauseIconSize: playPauseIconSize ?? this.playPauseIconSize,
      liveButtonColor: liveButtonColor ?? this.liveButtonColor,
      backstageButtonColor: backstageButtonColor ?? this.backstageButtonColor,
      callStateButtonTextStyle:
          callStateButtonTextStyle ?? this.callStateButtonTextStyle,
      participantCountTextStyle:
          participantCountTextStyle ?? this.participantCountTextStyle,
      durationTextStyle: durationTextStyle ?? this.durationTextStyle,
      participantIconTheme: participantIconTheme ?? this.participantIconTheme,
      speakerEnabledIconTheme:
          speakerEnabledIconTheme ?? this.speakerEnabledIconTheme,
      speakerDisabledIconTheme:
          speakerDisabledIconTheme ?? this.speakerDisabledIconTheme,
      expandIconTheme: expandIconTheme ?? this.expandIconTheme,
      contractIconTheme: contractIconTheme ?? this.contractIconTheme,
    );
  }

  /// Linearly interpolate between two [StreamLivestreamThemeData] themes.
  ///
  /// All the properties must be non-null.
  StreamLivestreamThemeData lerp(
    StreamLivestreamThemeData other,
    double t,
  ) {
    return StreamLivestreamThemeData(
      playIconTheme: IconThemeData.lerp(playIconTheme, other.playIconTheme, t),
      pauseIconTheme:
          IconThemeData.lerp(pauseIconTheme, other.pauseIconTheme, t),
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
      durationTextStyle: TextStyle.lerp(
        durationTextStyle,
        other.durationTextStyle,
        t,
      )!,
      participantIconTheme: IconThemeData.lerp(
        participantIconTheme,
        other.participantIconTheme,
        t,
      ),
      speakerEnabledIconTheme: IconThemeData.lerp(
        speakerEnabledIconTheme,
        other.speakerEnabledIconTheme,
        t,
      ),
      speakerDisabledIconTheme: IconThemeData.lerp(
        speakerDisabledIconTheme,
        other.speakerDisabledIconTheme,
        t,
      ),
      expandIconTheme: IconThemeData.lerp(
        expandIconTheme,
        other.expandIconTheme,
        t,
      ),
      contractIconTheme: IconThemeData.lerp(
        contractIconTheme,
        other.contractIconTheme,
        t,
      ),
    );
  }

  @override
  int get hashCode => Object.hash(
        playIconTheme,
        pauseIconTheme,
        playPauseIconSize,
        liveButtonColor,
        backstageButtonColor,
        callStateButtonTextStyle,
        participantCountTextStyle,
        durationTextStyle,
        participantIconTheme,
        speakerEnabledIconTheme,
        speakerDisabledIconTheme,
        expandIconTheme,
        contractIconTheme,
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
        other.playIconTheme == playIconTheme &&
        other.pauseIconTheme == pauseIconTheme &&
        other.playPauseIconSize == playPauseIconSize &&
        other.liveButtonColor == liveButtonColor &&
        other.backstageButtonColor == backstageButtonColor &&
        other.callStateButtonTextStyle == callStateButtonTextStyle &&
        other.participantCountTextStyle == participantCountTextStyle &&
        other.durationTextStyle == durationTextStyle &&
        other.participantIconTheme == participantIconTheme &&
        other.speakerEnabledIconTheme == speakerEnabledIconTheme &&
        other.speakerDisabledIconTheme == speakerDisabledIconTheme &&
        other.expandIconTheme == expandIconTheme &&
        other.contractIconTheme == contractIconTheme;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('playIconTheme', playIconTheme))
      ..add(DiagnosticsProperty('pauseIconTheme', pauseIconTheme))
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
      ..add(DiagnosticsProperty('participantIconTheme', participantIconTheme))
      ..add(
        DiagnosticsProperty('speakerEnabledIconTheme', speakerEnabledIconTheme),
      )
      ..add(
        DiagnosticsProperty(
          'speakerDisabledIconTheme',
          speakerDisabledIconTheme,
        ),
      )
      ..add(DiagnosticsProperty('expandIconTheme', expandIconTheme))
      ..add(DiagnosticsProperty('contractIconTheme', contractIconTheme));
  }

  /// Merges one [StreamLivestreamThemeData] with the another.
  StreamLivestreamThemeData merge(StreamLivestreamThemeData? other) {
    if (other == null) return this;
    return copyWith(
      playIconTheme: other.playIconTheme,
      pauseIconTheme: other.pauseIconTheme,
      playPauseIconSize: other.playPauseIconSize,
      liveButtonColor: other.liveButtonColor,
      backstageButtonColor: other.backstageButtonColor,
      callStateButtonTextStyle: other.callStateButtonTextStyle,
      participantCountTextStyle: other.participantCountTextStyle,
      durationTextStyle: other.durationTextStyle,
      participantIconTheme: other.participantIconTheme,
      speakerEnabledIconTheme: other.speakerEnabledIconTheme,
      speakerDisabledIconTheme: other.speakerDisabledIconTheme,
      expandIconTheme: other.expandIconTheme,
      contractIconTheme: other.contractIconTheme,
    );
  }
}

/// Applies a call controls theme to descendant [StreamLivestreamThemeData]
/// widgets.
class StreamLivestreamTheme extends InheritedWidget {
  /// Creates a new instance of [StreamLivestreamTheme].
  const StreamLivestreamTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used for all descendant [StreamLivestreamThemeData] widgets.
  final StreamLivestreamThemeData data;

  /// Returns the configuration [data] from the closest
  /// [StreamLivestreamTheme] ancestor. If there is no ancestor,
  /// it returns [StreamVideoTheme.livestreamTheme].
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
