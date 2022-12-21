import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/theme/stream_color_theme.dart';
import 'package:stream_video_flutter/theme/stream_text_theme.dart';

class StreamControlsTheme with Diagnosticable {
  static const double _borderRadiusTop = 20.0;
  static const double buttonPadding = 16.0;
  static const double defaultElevation = 10.0;
  static const double defaultPadding = 15.0;
  static const double defaultButtonsSpacing = 16.0;
  static const Color defaultIconColorEnabledLight = Colors.black;
  static const Color defaultIconColorEnabledDark = Colors.white;

  static const defaultEnabledSpeakerIcon = Icons.volume_up;
  static const defaultDisabledSpeakerIcon = Icons.volume_up_outlined;

  static const defaultEnabledVideoIcon = Icons.video_camera_front;
  static const defaultDisabledVideoIcon = Icons.video_camera_front_outlined;

  static const defaultEnabledMicIcon = Icons.mic;
  static const defaultDisabledMicIcon = Icons.mic_off;

  static const defaultFlipCameraIcon = Icons.flip_camera_ios;

  static const defaultPhoneIcon = Icons.phone;

  static const defaultButtonsAlignmentDesktop = WrapAlignment.center;

  static const defaultButtonsAlignmentMobile = WrapAlignment.spaceEvenly;

  final BorderRadius borderRadius;
  final Color bgColor;
  final double elevation;
  final EdgeInsets padding;

  final ButtonStyle toggleSpeakerStyle;
  final Icon toggleSpeakerIconEnabled;
  final Icon toggleSpeakerIconDisabled;

  final ButtonStyle toggleVideoStyle;
  final Icon toggleVideoIconEnabled;
  final Icon toggleVideoIconDisabled;

  final ButtonStyle toggleMicStyle;
  final Icon toggleMicIconEnabled;
  final Icon toggleMicIconDisabled;

  final ButtonStyle switchCameraStyle;
  final Icon switchCameraIcon;

  final ButtonStyle hangUpStyle;
  final Icon handUpCameraIcon;

  final WrapAlignment buttonsAlignmentDesktop;
  final WrapAlignment buttonsAlignmentMobile;
  final double buttonsSpacing;

  static const BorderRadius defaultBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(_borderRadiusTop),
    topRight: Radius.circular(_borderRadiusTop),
  );

  static ButtonStyle defaultButtonStyle(Color backgroundColor) {
    return ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(buttonPadding),
      backgroundColor: backgroundColor,
      foregroundColor: Colors.grey, // <-- Splash color
    );
  }

  static ButtonStyle defaultHangUpButtonStyle() {
    return ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(buttonPadding),
      backgroundColor: Colors.red,
      foregroundColor: Colors.grey, // <-- Splash color
    );
  }

  factory StreamControlsTheme.light([
    double elevation = defaultElevation,
    BorderRadius borderRadius = defaultBorderRadius,
    Color bgColor = Colors.white,
    EdgeInsets padding = const EdgeInsets.all(defaultPadding),
    ButtonStyle? toggleSpeakerStyle,
    Icon toggleSpeakerIconEnabled = const Icon(
        color: defaultIconColorEnabledLight, defaultEnabledSpeakerIcon),
    Icon toggleSpeakerIconDisabled = const Icon(
      color: Colors.grey,
      defaultDisabledSpeakerIcon,
    ),
    ButtonStyle? toggleVideoStyle,
    Icon toggleVideoIconEnabled = const Icon(
      color: defaultIconColorEnabledLight,
      defaultEnabledVideoIcon,
    ),
    Icon toggleVideoIconDisabled = const Icon(
      color: Colors.grey,
      defaultDisabledVideoIcon,
    ),
    ButtonStyle? toggleMicStyle,
    Icon toggleMicIconEnabled = const Icon(
      color: defaultIconColorEnabledLight,
      defaultEnabledMicIcon,
    ),
    Icon toggleMicIconDisabled = const Icon(
      color: Colors.grey,
      defaultDisabledMicIcon,
    ),
    ButtonStyle? switchCameraStyle,
    Icon switchCameraIcon = const Icon(
      color: defaultIconColorEnabledLight,
      defaultFlipCameraIcon,
    ),
    ButtonStyle? hangUpStyle,
    Icon handUpCameraIcon = const Icon(
      color: Color(0xfffcfcfc),
      defaultPhoneIcon,
    ),
    WrapAlignment buttonsAlignmentDesktop = defaultButtonsAlignmentDesktop,
    WrapAlignment buttonsAlignmentMobile = defaultButtonsAlignmentMobile,
    double buttonsSpacing = defaultButtonsSpacing,
  ]) {
    const Color buttonsBackground = Color(0xfffcfcfc);

    return StreamControlsTheme.raw(
      borderRadius: borderRadius,
      elevation: elevation,
      bgColor: bgColor,
      padding: padding,
      toggleSpeakerStyle:
          toggleSpeakerStyle ?? defaultButtonStyle(buttonsBackground),
      toggleSpeakerIconEnabled: toggleSpeakerIconEnabled,
      toggleSpeakerIconDisabled: toggleSpeakerIconDisabled,
      toggleVideoStyle:
          toggleVideoStyle ?? defaultButtonStyle(buttonsBackground),
      toggleVideoIconEnabled: toggleVideoIconEnabled,
      toggleVideoIconDisabled: toggleVideoIconDisabled,
      toggleMicStyle: toggleMicStyle ?? defaultButtonStyle(buttonsBackground),
      toggleMicIconEnabled: toggleMicIconEnabled,
      toggleMicIconDisabled: toggleMicIconDisabled,
      switchCameraStyle:
          switchCameraStyle ?? defaultButtonStyle(buttonsBackground),
      switchCameraIcon: switchCameraIcon,
      hangUpStyle: hangUpStyle ?? defaultHangUpButtonStyle(),
      handUpCameraIcon: handUpCameraIcon,
      buttonsAlignmentDesktop: buttonsAlignmentDesktop,
      buttonsAlignmentMobile: buttonsAlignmentMobile,
      buttonsSpacing: buttonsSpacing,
    );
  }

  factory StreamControlsTheme.dark([
    double elevation = defaultElevation,
    BorderRadius borderRadius = defaultBorderRadius,
    Color bgColor = const Color(0xff101418),
    EdgeInsets padding = const EdgeInsets.all(defaultPadding),
    ButtonStyle? toggleSpeakerStyle,
    Icon toggleSpeakerIconEnabled = const Icon(
        color: defaultIconColorEnabledDark, defaultEnabledSpeakerIcon),
    Icon toggleSpeakerIconDisabled = const Icon(
      color: Colors.grey,
      defaultDisabledSpeakerIcon,
    ),
    ButtonStyle? toggleVideoStyle,
    Icon toggleVideoIconEnabled = const Icon(
      color: defaultIconColorEnabledDark,
      Icons.video_camera_front,
    ),
    Icon toggleVideoIconDisabled = const Icon(
      color: Colors.grey,
      Icons.video_camera_front_outlined,
    ),
    ButtonStyle? toggleMicStyle,
    Icon toggleMicIconEnabled = const Icon(
      color: defaultIconColorEnabledDark,
      Icons.mic,
    ),
    Icon toggleMicIconDisabled = const Icon(
      color: Colors.grey,
      Icons.mic_off,
    ),
    ButtonStyle? switchCameraStyle,
    Icon switchCameraIcon = const Icon(
      color: defaultIconColorEnabledDark,
      Icons.flip_camera_ios,
    ),
    ButtonStyle? hangUpStyle,
    Icon handUpCameraIcon = const Icon(
      color: Color(0xfffcfcfc),
      Icons.phone,
    ),
    WrapAlignment buttonsAlignmentDesktop = WrapAlignment.spaceEvenly,
    WrapAlignment buttonsAlignmentMobile = WrapAlignment.center,
    double buttonsSpacing = defaultButtonsSpacing,
  ]) {
    const Color buttonsBackground = Color(0xff070A0D);

    return StreamControlsTheme.raw(
      borderRadius: borderRadius,
      elevation: elevation,
      bgColor: bgColor,
      padding: padding,
      toggleSpeakerStyle:
          toggleSpeakerStyle ?? defaultButtonStyle(buttonsBackground),
      toggleSpeakerIconEnabled: toggleSpeakerIconEnabled,
      toggleSpeakerIconDisabled: toggleSpeakerIconDisabled,
      toggleVideoStyle:
          toggleVideoStyle ?? defaultButtonStyle(buttonsBackground),
      toggleVideoIconEnabled: toggleVideoIconEnabled,
      toggleVideoIconDisabled: toggleVideoIconDisabled,
      toggleMicStyle: toggleMicStyle ?? defaultButtonStyle(buttonsBackground),
      toggleMicIconEnabled: toggleMicIconEnabled,
      toggleMicIconDisabled: toggleMicIconDisabled,
      switchCameraStyle:
          switchCameraStyle ?? defaultButtonStyle(buttonsBackground),
      switchCameraIcon: switchCameraIcon,
      hangUpStyle: hangUpStyle ?? defaultHangUpButtonStyle(),
      handUpCameraIcon: handUpCameraIcon,
      buttonsAlignmentDesktop: buttonsAlignmentDesktop,
      buttonsAlignmentMobile: buttonsAlignmentMobile,
      buttonsSpacing: buttonsSpacing,
    );
  }

  StreamControlsTheme.raw({
    required this.borderRadius,
    required this.elevation,
    required this.bgColor,
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

  factory StreamControlsTheme.fromColorAndTextTheme(
    StreamColorTheme colorTheme,
    StreamTextTheme textTheme,
  ) {
    return StreamControlsTheme.raw(
      borderRadius: defaultBorderRadius,
      elevation: defaultElevation,
      bgColor: colorTheme.barsBg,
      padding: const EdgeInsets.all(defaultPadding),
      toggleSpeakerStyle: defaultButtonStyle(colorTheme.appBg),
      toggleSpeakerIconEnabled: Icon(
        color: colorTheme.overlayDark,
        defaultEnabledSpeakerIcon,
      ),
      toggleSpeakerIconDisabled: Icon(
        color: colorTheme.disabled,
        defaultDisabledSpeakerIcon,
      ),
      toggleVideoStyle: defaultButtonStyle(colorTheme.appBg),
      toggleVideoIconEnabled: Icon(
        color: colorTheme.overlayDark,
        defaultEnabledVideoIcon,
      ),
      toggleVideoIconDisabled: Icon(
        color: colorTheme.disabled,
        defaultDisabledVideoIcon,
      ),
      toggleMicStyle: defaultButtonStyle(colorTheme.appBg),
      toggleMicIconEnabled: Icon(
        color: colorTheme.overlayDark,
        defaultEnabledMicIcon,
      ),
      toggleMicIconDisabled: Icon(
        color: colorTheme.disabled,
        defaultDisabledMicIcon,
      ),
      switchCameraStyle: defaultButtonStyle(colorTheme.appBg),
      switchCameraIcon: Icon(
        color: colorTheme.overlayDark,
        defaultFlipCameraIcon,
      ),
      hangUpStyle: defaultHangUpButtonStyle(),
      handUpCameraIcon: Icon(
        color: colorTheme.highlight,
        defaultPhoneIcon,
      ),
      buttonsAlignmentDesktop: defaultButtonsAlignmentDesktop,
      buttonsAlignmentMobile: defaultButtonsAlignmentMobile,
      buttonsSpacing: defaultButtonsSpacing,
    );
  }

  StreamControlsTheme copyWith(
    BorderRadius? borderRadius,
    double? elevation,
    Color? bgColor,
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
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      bgColor: bgColor ?? this.bgColor,
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
      controlsTheme.borderRadius,
      controlsTheme.elevation,
      controlsTheme.bgColor,
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
