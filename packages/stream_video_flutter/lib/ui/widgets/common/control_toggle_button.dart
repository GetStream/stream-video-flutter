import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

class ControlToggleButton extends StatefulWidget {
  const ControlToggleButton(
      this.enabledIcon, this.disabledIcon, this.participant,
      {Key? key})
      : super(key: key);

  final LocalParticipant participant;
  final IconData enabledIcon;
  final IconData disabledIcon;

  @override
  State<ControlToggleButton> createState() => _ControlToggleButtonState();
}

class _ControlToggleButtonState extends State<ControlToggleButton> {
  @override
  Widget build(BuildContext context) {
    return button();
  }

  Widget button() {
    return IconButton(
      icon: muteButtonIcon(
        widget.participant.isMicrophoneEnabled,
        !widget.participant.isMuted,
      ),
      onPressed: () => {},
      color: buttonColor(widget.participant.isMicrophoneEnabled),
    );
  }

  Color buttonColor(bool permissionEnabled) {
    return permissionEnabled ? Colors.red : Colors.white;
  }

  Icon muteButtonIcon(bool permissionEnabled, bool audioEnabled) {
    return Icon(
      color: buttonColor(permissionEnabled),
      permissionEnabled && audioEnabled
          ? widget.enabledIcon
          : widget.disabledIcon,
    );
  }
}
