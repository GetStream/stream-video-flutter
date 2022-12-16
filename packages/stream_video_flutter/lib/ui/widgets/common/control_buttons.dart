import 'package:flutter/material.dart';

const buttonPadding = 16.0;

class ControlToggleButton extends StatefulWidget {
  const ControlToggleButton(this.enabledIcon, this.disabledIcon,
      this.permissionEnabled, this.enabled, this.onPressed,
      {Key? key})
      : super(key: key);

  final bool permissionEnabled;
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
      onPressed: widget.permissionEnabled ? widget.onPressed :  widget.onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(buttonPadding),
        backgroundColor: backgroundColor(
          widget.permissionEnabled,
          widget.enabled,
        ),
        // <-- Button color
        foregroundColor: Colors.grey, // <-- Splash color
      ),
      child: icon(widget.permissionEnabled, widget.enabled),
    );
  }

  Color backgroundColor(bool permissionEnabled, bool enabled) {
    return permissionEnabled && enabled ? Colors.white : Colors.white;
  }

  Icon icon(bool permissionEnabled, bool enabled) {
    var buttonEnabled = permissionEnabled && enabled;
    return Icon(
      color: buttonEnabled ? Colors.black : Colors.grey,
      buttonEnabled ? widget.enabledIcon : widget.disabledIcon,
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
      onPressed: () {},
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
