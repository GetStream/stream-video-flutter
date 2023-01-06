import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/theme/themes.dart';

///Container of all buttons of control for Call.
///The buttons may change accordingly with the platform
///and resources available. Example: There's no switch camera button for
///a chrome user.
class ControlButtonWrapper extends StatefulWidget {
  const ControlButtonWrapper({
    Key? key,
    required this.theme,
    required this.isPhoneSpeakerSelected,
    required this.toggleSpeaker,
    required this.toggleVideo,
    required this.toggleMic,
    required this.switchCamera,
    required this.hangUp,
    required this.participant,
    this.buttonsAlignmentMobile,
    this.buttonsAlignmentDesktop,
    this.buttonsSpacing,
    this.toggleSpeakerIconEnabled,
    this.toggleSpeakerIconDisabled,
    this.toggleVideoStyle,
    this.toggleVideoIconEnabled,
    this.toggleVideoIconDisabled,
    this.toggleMicStyle,
    this.toggleMicIconEnabled,
    this.toggleMicIconDisabled,
    this.switchCameraStyle,
    this.switchCameraIcon,
    this.hangUpStyle,
    this.handUpIcon,
  }) : super(key: key);

  final StreamControlsTheme theme;
  final bool isPhoneSpeakerSelected;
  final Participant participant;

  /// Icon for the speaker toggle button.
  final Icon? toggleSpeakerIconEnabled;
  final Icon? toggleSpeakerIconDisabled;

  /// The style of video toggle button.
  final ButtonStyle? toggleVideoStyle;

  /// Icon of video toggle button.
  final Icon? toggleVideoIconEnabled;

  /// Icon of video toggle button.
  final Icon? toggleVideoIconDisabled;

  /// The style of microphone toggle button.
  final ButtonStyle? toggleMicStyle;

  /// Icon of microphone toggle button.
  final Icon? toggleMicIconEnabled;

  /// Icon of microphone toggle button.
  final Icon? toggleMicIconDisabled;

  /// The style of camera switch button.
  final ButtonStyle? switchCameraStyle;

  /// Icon of camera switch button.
  final Icon? switchCameraIcon;

  /// The style of hand up button.
  final ButtonStyle? hangUpStyle;

  /// Icon of hand up button.
  final Icon? handUpIcon;

  final WrapAlignment? buttonsAlignmentMobile;
  final WrapAlignment? buttonsAlignmentDesktop;
  final double? buttonsSpacing;
  final VoidCallback toggleSpeaker;
  final VoidCallback toggleVideo;
  final VoidCallback toggleMic;
  final VoidCallback switchCamera;
  final VoidCallback hangUp;

  @override
  State<ControlButtonWrapper> createState() => _ControlButtonWrapperState();
}

class _ControlButtonWrapperState extends State<ControlButtonWrapper> {
  StreamControlsTheme get theme => widget.theme;

  bool get isMobile =>
      Theme.of(context).platform == TargetPlatform.iOS ||
      Theme.of(context).platform == TargetPlatform.android;

  WrapAlignment getButtonsAlignment() {
    if (isMobile) {
      return widget.buttonsAlignmentMobile ?? theme.buttonsAlignmentMobile;
    } else {
      return widget.buttonsAlignmentMobile ?? theme.buttonsAlignmentDesktop;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: getButtonsAlignment(),
      spacing: widget.buttonsSpacing ?? theme.buttonsSpacing,
      children: [
        if (isMobile)
          ControlToggleButton.speaker(
            theme: theme,
            isPhoneSpeakerSelected: widget.isPhoneSpeakerSelected,
            onPressed: widget.toggleSpeaker,
          ),
        ControlToggleButton.video(
          theme: theme,
          participant: widget.participant,
          onPressed: widget.toggleVideo,
        ),
        ControlToggleButton.microphone(
          theme: theme,
          participant: widget.participant,
          onPressed: widget.toggleMic,
        ),
        if (isMobile)
          ControlButton.switchCamera(
            theme: theme,
            onPressed: widget.switchCamera,
          ),
        ControlButton.handUp(
          theme: theme,
          icon: widget.handUpIcon,
          onPressed: widget.hangUp,
        )
      ],
    );
  }
}

/// Common toggle button for CallControlsView.
class ControlToggleButton extends StatefulWidget {
  const ControlToggleButton(
    this.enabledIcon,
    this.disabledIcon,
    this.enabled,
    this.buttonStyle,
    this.onPressed, {
    Key? key,
  }) : super(key: key);

  final bool enabled;
  final Icon enabledIcon;
  final Icon disabledIcon;
  final VoidCallback onPressed;
  final ButtonStyle buttonStyle;

  // Creates the button to toggle speakers.
  factory ControlToggleButton.speaker({
    required StreamControlsTheme theme,
    required bool isPhoneSpeakerSelected,
    Icon? iconEnabled,
    Icon? iconDisabled,
    ButtonStyle? buttonStyle,
    required VoidCallback onPressed,
  }) {
    return ControlToggleButton(
      iconEnabled ?? theme.toggleSpeakerIconEnabled,
      iconDisabled ?? theme.toggleSpeakerIconDisabled,
      isPhoneSpeakerSelected,
      buttonStyle ?? theme.toggleSpeakerStyle,
      onPressed,
    );
  }

  // Creates the button to enable/disable video camera.
  factory ControlToggleButton.video({
    required StreamControlsTheme theme,
    required Participant participant,
    Icon? iconEnabled,
    Icon? iconDisabled,
    ButtonStyle? buttonStyle,
    required VoidCallback onPressed,
  }) {
    return ControlToggleButton(
      iconEnabled ?? theme.toggleVideoIconEnabled,
      iconDisabled ?? theme.toggleVideoIconDisabled,
      participant.isVideoEnabled,
      buttonStyle ?? theme.toggleVideoStyle,
      onPressed,
    );
  }

  // Creates the button to enable/disable video microphone.
  factory ControlToggleButton.microphone({
    required StreamControlsTheme theme,
    required Participant participant,
    Icon? iconEnabled,
    Icon? iconDisabled,
    ButtonStyle? buttonStyle,
    required VoidCallback onPressed,
  }) {
    return ControlToggleButton(
      iconEnabled ?? theme.toggleMicIconEnabled,
      iconDisabled ?? theme.toggleMicIconDisabled,
      participant.isAudioEnabled,
      buttonStyle ?? theme.toggleMicStyle,
      onPressed,
    );
  }

  @override
  State<ControlToggleButton> createState() => _ControlToggleButtonState();
}

class _ControlToggleButtonState extends State<ControlToggleButton> {
  @override
  Widget build(BuildContext context) {
    return button(widget.enabled);
  }

  Widget button(bool enabled) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: widget.buttonStyle,
      child: enabled ? widget.enabledIcon : widget.disabledIcon,
    );
  }
}

class ControlButton extends StatelessWidget {
  const ControlButton({
    Key? key,
    required this.icon,
    required this.buttonStyle,
    required this.onPressed,
  }) : super(key: key);

  final Icon icon;
  final VoidCallback onPressed;
  final ButtonStyle buttonStyle;

  // Creates the button to switch camera.
  factory ControlButton.switchCamera({
    required StreamControlsTheme theme,
    Icon? icon,
    ButtonStyle? buttonStyle,
    required VoidCallback onPressed,
  }) {
    return ControlButton(
      icon: icon ?? theme.switchCameraIcon,
      buttonStyle: buttonStyle ?? theme.switchCameraStyle,
      onPressed: onPressed,
    );
  }

  // Creates the button to hang up the call.
  factory ControlButton.handUp({
    required StreamControlsTheme theme,
    Icon? icon,
    ButtonStyle? buttonStyle,
    required VoidCallback onPressed,
  }) {
    return ControlButton(
      icon: icon ?? theme.handUpIcon,
      buttonStyle: buttonStyle ?? theme.hangUpStyle,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return button();
  }

  Widget button() {
    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: icon,
    );
  }
}
