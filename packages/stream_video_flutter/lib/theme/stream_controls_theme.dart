import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class StreamControlsTheme with Diagnosticable {
  static const double _borderRadiusTop = 20.0;
  static const double buttonPadding = 16.0;
  static const double defaultElevation = 10.0;
  static const double defaultPadding = 15.0;
  static const double defaultButtonsSpacing = 16.0;
  static const Color defaultIconColorEnabledLight = Colors.black;
  static const Color defaultIconColorEnabledDark = Colors.white;

  final bool isLightTheme;

  final BorderRadius borderRadius;
  final double elevation;
  final EdgeInsets padding;

  final ButtonStyle? toggleSpeakerStyle;
  final Icon toggleSpeakerIconEnabled;
  final Icon toggleSpeakerIconDisabled;

  final ButtonStyle? toggleVideoStyle;
  final Icon toggleVideoIconEnabled;
  final Icon toggleVideoIconDisabled;

  final ButtonStyle? toggleMicStyle;
  final Icon toggleMicIconEnabled;
  final Icon toggleMicIconDisabled;

  final ButtonStyle? switchCameraStyle;
  final Icon switchCameraIcon;

  final ButtonStyle? hangUpStyle;
  final Icon handUpCameraIcon;

  final WrapAlignment buttonsAlignmentDesktop;
  final WrapAlignment buttonsAlignmentMobile;
  final double buttonsSpacing;

  get defaultButtonStyle => ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(buttonPadding),
        backgroundColor: isLightTheme ? Colors.white : Colors.black54,
        foregroundColor: Colors.grey, // <-- Splash color
      );

  ButtonStyle getToggleSpeakerStyle() {
    return toggleSpeakerStyle ?? defaultButtonStyle;
  }

  ButtonStyle getToggleVideoStyle() {
    return toggleVideoStyle ?? defaultButtonStyle;
  }

  ButtonStyle getToggleMicStyle() {
    return toggleMicStyle ?? defaultButtonStyle;
  }

  ButtonStyle getSwitchCameraStyle() {
    return switchCameraStyle ?? defaultButtonStyle;
  }

  ButtonStyle getHangUpStyle() {
    return hangUpStyle ??
        ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(buttonPadding),
          backgroundColor: Colors.red,
          foregroundColor: Colors.grey, // <-- Splash color
        );
  }

  const StreamControlsTheme.light({
    this.isLightTheme = true,
    this.elevation = defaultElevation,
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(_borderRadiusTop),
      topRight: Radius.circular(_borderRadiusTop),
    ),
    this.padding = const EdgeInsets.all(defaultPadding),
    this.toggleSpeakerStyle,
    this.toggleSpeakerIconEnabled = const Icon(
      color: defaultIconColorEnabledLight,
      Icons.volume_up,
    ),
    this.toggleSpeakerIconDisabled = const Icon(
      color: Colors.grey,
      Icons.volume_up_outlined,
    ),
    this.toggleVideoStyle,
    this.toggleVideoIconEnabled = const Icon(
      color: defaultIconColorEnabledLight,
      Icons.video_camera_front,
    ),
    this.toggleVideoIconDisabled = const Icon(
      color: Colors.grey,
      Icons.video_camera_front_outlined,
    ),
    this.toggleMicStyle,
    this.toggleMicIconEnabled = const Icon(
      color: defaultIconColorEnabledLight,
      Icons.mic,
    ),
    this.toggleMicIconDisabled = const Icon(
      color: Colors.grey,
      Icons.mic_off,
    ),
    this.switchCameraStyle,
    this.switchCameraIcon = const Icon(
      color: defaultIconColorEnabledLight,
      Icons.flip_camera_ios,
    ),
    this.hangUpStyle,
    this.handUpCameraIcon = const Icon(
      color: Colors.white,
      Icons.phone,
    ),
    this.buttonsAlignmentDesktop = WrapAlignment.center,
    this.buttonsAlignmentMobile = WrapAlignment.spaceEvenly,
    this.buttonsSpacing = defaultButtonsSpacing,
  });

  const StreamControlsTheme.dark({
    this.isLightTheme = false,
    this.elevation = defaultElevation,
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(_borderRadiusTop),
      topRight: Radius.circular(_borderRadiusTop),
    ),
    this.padding = const EdgeInsets.all(defaultPadding),
    this.toggleSpeakerStyle,
    this.toggleSpeakerIconEnabled = const Icon(
      color: defaultIconColorEnabledDark,
      Icons.volume_up,
    ),
    this.toggleSpeakerIconDisabled = const Icon(
      color: Colors.grey,
      Icons.volume_up_outlined,
    ),
    this.toggleVideoStyle,
    this.toggleVideoIconEnabled = const Icon(
      color: defaultIconColorEnabledDark,
      Icons.video_camera_front,
    ),
    this.toggleVideoIconDisabled = const Icon(
      color: Colors.grey,
      Icons.video_camera_front_outlined,
    ),
    this.toggleMicStyle,
    this.toggleMicIconEnabled = const Icon(
      color: defaultIconColorEnabledDark,
      Icons.mic,
    ),
    this.toggleMicIconDisabled = const Icon(
      color: Colors.grey,
      Icons.mic_off,
    ),
    this.switchCameraStyle,
    this.switchCameraIcon = const Icon(
      color: defaultIconColorEnabledDark,
      Icons.flip_camera_ios,
    ),
    this.hangUpStyle,
    this.handUpCameraIcon = const Icon(
      color: Colors.white,
      Icons.phone,
    ),
    this.buttonsAlignmentDesktop = WrapAlignment.spaceEvenly,
    this.buttonsAlignmentMobile = WrapAlignment.center,
    this.buttonsSpacing = defaultButtonsSpacing,
  });

  StreamControlsTheme.raw({
    required this.isLightTheme,
    required this.borderRadius,
    required this.elevation,
    required this.padding,
    required this.toggleSpeakerStyle,
    required this.toggleSpeakerIconEnabled,
    required this.toggleSpeakerIconDisabled,
    required this.toggleVideoStyle,
    required this.toggleVideoIconEnabled,
    required this.toggleVideoIconDisabled,
    required this.toggleMicStyle,
    required this.toggleMicIconEnabled,
    required this.toggleMicIconDisabled,
    required this.switchCameraStyle,
    required this.switchCameraIcon,
    required this.hangUpStyle,
    required this.handUpCameraIcon,
    required this.buttonsAlignmentDesktop,
    required this.buttonsAlignmentMobile,
    required this.buttonsSpacing,
  });

  StreamControlsTheme copyWith(
    bool? isLightTheme,
    BorderRadius? borderRadius,
    double? elevation,
    EdgeInsets? padding,
    ButtonStyle? toggleSpeakerStyle,
    Icon? toggleSpeakerIconEnabled,
    Icon? toggleSpeakerIconDisabled,
    ButtonStyle? toggleVideoStyle,
    Icon? toggleVideoIconEnabled,
    Icon? toggleVideoIconDisabled,
    ButtonStyle? toggleMicStyle,
    Icon? toggleMicIconEnabled,
    Icon? toggleMicIconDisabled,
    ButtonStyle? switchCameraStyle,
    Icon? switchCameraIcon,
    ButtonStyle? hangUpStyle,
    Icon? handUpCameraIcon,
    WrapAlignment? buttonsAlignmentDesktop,
    WrapAlignment? buttonsAlignmentMobile,
    double? buttonsSpacing,
  ) {
    return StreamControlsTheme.raw(
      isLightTheme: isLightTheme ?? this.isLightTheme,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      padding: padding ?? this.padding,
      toggleSpeakerStyle: toggleSpeakerStyle ?? this.toggleSpeakerStyle,
      toggleSpeakerIconEnabled:
          toggleSpeakerIconEnabled ?? this.toggleSpeakerIconEnabled,
      toggleSpeakerIconDisabled:
          toggleSpeakerIconDisabled ?? this.toggleSpeakerIconDisabled,
      toggleVideoStyle: toggleVideoStyle ?? this.toggleVideoStyle,
      toggleVideoIconEnabled:
          toggleVideoIconEnabled ?? this.toggleVideoIconEnabled,
      toggleVideoIconDisabled:
          toggleVideoIconDisabled ?? this.toggleVideoIconDisabled,
      toggleMicStyle: toggleMicStyle ?? this.toggleMicStyle,
      toggleMicIconEnabled: toggleMicIconEnabled ?? this.toggleMicIconEnabled,
      toggleMicIconDisabled:
          toggleMicIconDisabled ?? this.toggleMicIconDisabled,
      switchCameraStyle: switchCameraStyle ?? this.switchCameraStyle,
      switchCameraIcon: switchCameraIcon ?? this.switchCameraIcon,
      hangUpStyle: hangUpStyle ?? this.hangUpStyle,
      handUpCameraIcon: handUpCameraIcon ?? this.handUpCameraIcon,
      buttonsAlignmentDesktop:
          buttonsAlignmentDesktop ?? this.buttonsAlignmentDesktop,
      buttonsAlignmentMobile:
          buttonsAlignmentMobile ?? this.buttonsAlignmentMobile,
      buttonsSpacing: buttonsSpacing ?? this.buttonsSpacing,
    );
  }

  StreamControlsTheme merge(StreamControlsTheme? controlsTheme) {
    if (controlsTheme == null) return this;
    return copyWith(
      controlsTheme.isLightTheme,
      controlsTheme.borderRadius,
      controlsTheme.elevation,
      controlsTheme.padding,
      controlsTheme.toggleSpeakerStyle,
      controlsTheme.toggleSpeakerIconEnabled,
      controlsTheme.toggleSpeakerIconDisabled,
      controlsTheme.toggleVideoStyle,
      controlsTheme.toggleVideoIconEnabled,
      controlsTheme.toggleVideoIconDisabled,
      controlsTheme.toggleMicStyle,
      controlsTheme.toggleMicIconEnabled,
      controlsTheme.toggleMicIconDisabled,
      controlsTheme.switchCameraStyle,
      controlsTheme.switchCameraIcon,
      controlsTheme.hangUpStyle,
      controlsTheme.handUpCameraIcon,
      controlsTheme.buttonsAlignmentDesktop,
      controlsTheme.buttonsAlignmentMobile,
      controlsTheme.buttonsSpacing,
    );
  }
}
