import 'package:flutter/material.dart';

const buttonPadding = 16.0;

class ControlToggleButton extends StatefulWidget {
  const ControlToggleButton(
      this.enabledIcon, this.disabledIcon, this.enabled, this.onPressed,
      {Key? key})
      : super(key: key);

  final bool enabled;
  final IconData enabledIcon;
  final IconData disabledIcon;
  final Function() onPressed;

  @override
  State<ControlToggleButton> createState() => _ControlToggleButtonState();
}

class _ControlToggleButtonState extends State<ControlToggleButton> {
  @override
  Widget build(BuildContext context) {
    return button();
  }

  Widget button() {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(buttonPadding),
        backgroundColor: backgroundColor(widget.enabled),
        // <-- Button color
        foregroundColor: Colors.grey, // <-- Splash color
      ),
      child: icon(widget.enabled),
    );
  }

  Color backgroundColor(bool enabled) {
    return enabled ? Colors.white : Colors.white;
  }

  Icon icon(bool enabled) {
    return Icon(
      color: enabled ? Colors.black : Colors.grey,
      enabled ? widget.enabledIcon : widget.disabledIcon,
    );
  }
}

class ControlButton extends StatelessWidget {
  const ControlButton(this.iconData, this.onPressed,
      {Key? key, required this.backgroundColor, required this.iconColor})
      : super(key: key);

  final IconData iconData;
  final Color backgroundColor;
  final Color iconColor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return button();
  }

  Widget button() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(buttonPadding),
        backgroundColor: backgroundColor,
        foregroundColor: Colors.grey, // <-- Splash color
      ),
      child: Icon(iconData, color: iconColor),
    );
  }
}
