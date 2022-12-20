import 'package:flutter/material.dart';

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
