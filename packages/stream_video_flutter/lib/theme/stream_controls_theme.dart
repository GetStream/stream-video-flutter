import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const _borderRadiusTop = 20.0;
const buttonPadding = 16.0;
const defaultElevation = 10.0;
const defaultPadding = 15.0;
const defaultButtonsSpacing = 16.0;

class StreamControlsTheme with Diagnosticable {
  static const Color defaultIconColorEnabledLight = Colors.black;

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

  get defaultButtonStyle =>
      ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(buttonPadding),
        backgroundColor: Colors.white,
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

  StreamControlsTheme({
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
    this.buttonsAlignmentDesktop = WrapAlignment.spaceEvenly,
    this.buttonsAlignmentMobile = WrapAlignment.center,
    this.buttonsSpacing = defaultButtonsSpacing
  });
}
