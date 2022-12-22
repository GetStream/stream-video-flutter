import 'package:flutter/material.dart';
import 'package:stream_video_flutter/theme/stream_controls_theme.dart';
import 'package:stream_video/stream_video.dart';

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
  }) : super(key: key);

  final StreamControlsTheme theme;
  final bool isPhoneSpeakerSelected;
  final Participant participant;
  final VoidCallback toggleSpeaker;
  final VoidCallback toggleVideo;
  final VoidCallback toggleMic;
  final VoidCallback switchCamera;
  final VoidCallback hangUp;

  @override
  State<ControlButtonWrapper> createState() => _ControlButtonWrapperState();
}

class _ControlButtonWrapperState extends State<ControlButtonWrapper> {
  bool get isMobile =>
      Theme.of(context).platform == TargetPlatform.iOS ||
      Theme.of(context).platform == TargetPlatform.android;

  WrapAlignment getButtonsAlignment() {
    if (isMobile) {
      return widget.theme.buttonsAlignmentMobile;
    } else {
      return widget.theme.buttonsAlignmentDesktop;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: getButtonsAlignment(),
      spacing: widget.theme.buttonsSpacing,
      children: [
        if (isMobile)
          ControlToggleButton.speaker(
            theme: widget.theme,
            isPhoneSpeakerSelected: widget.isPhoneSpeakerSelected,
            onPressed: widget.toggleSpeaker,
          ),
        ControlToggleButton.video(
          theme: widget.theme,
          participant: widget.participant,
          onPressed: widget.toggleVideo,
        ),
        ControlToggleButton.microphone(
          theme: widget.theme,
          participant: widget.participant,
          onPressed: widget.toggleMic,
        ),
        if (isMobile)
          ControlButton.switchCamera(
            theme: widget.theme,
            onPressed: widget.switchCamera,
          ),
        ControlButton.handUp(theme: widget.theme, onPressed: widget.hangUp)
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
    required VoidCallback onPressed,
  }) {
    return ControlToggleButton(
      theme.toggleSpeakerIconEnabled,
      theme.toggleSpeakerIconDisabled,
      isPhoneSpeakerSelected,
      theme.toggleSpeakerStyle,
      onPressed,
    );
  }

  // Creates the button to enable/disable video camera.
  factory ControlToggleButton.video({
    required StreamControlsTheme theme,
    required Participant participant,
    required VoidCallback onPressed,
  }) {
    return ControlToggleButton(
      theme.toggleVideoIconEnabled,
      theme.toggleVideoIconDisabled,
      participant.isCameraEnabled,
      theme.toggleVideoStyle,
      onPressed,
    );
  }

  // Creates the button to enable/disable video microphone.
  factory ControlToggleButton.microphone({
    required StreamControlsTheme theme,
    required Participant participant,
    required VoidCallback onPressed,
  }) {
    return ControlToggleButton(
      theme.toggleMicIconEnabled,
      theme.toggleMicIconDisabled,
      participant.isMicrophoneEnabled,
      theme.toggleMicStyle,
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
  const ControlButton(
    this.icon,
    this.buttonStyle,
    this.onPressed, {
    Key? key,
  }) : super(key: key);

  final Icon icon;
  final VoidCallback onPressed;
  final ButtonStyle buttonStyle;

  // Creates the button to switch camera.
  factory ControlButton.switchCamera({
    required StreamControlsTheme theme,
    required VoidCallback onPressed,
  }) {
    return ControlButton(
      theme.switchCameraIcon,
      theme.switchCameraStyle,
      onPressed,
    );
  }

  // Creates the button to hang up the call.
  factory ControlButton.handUp({
    required StreamControlsTheme theme,
    required VoidCallback onPressed,
  }) {
    return ControlButton(
      theme.handUpCameraIcon,
      theme.hangUpStyle,
      onPressed,
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
