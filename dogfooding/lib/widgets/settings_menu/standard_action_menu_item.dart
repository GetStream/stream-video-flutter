import 'package:flutter/material.dart';

import 'settings_menu_item.dart';

class StandardActionMenuItem extends StatelessWidget {
  const StandardActionMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.color,
    this.onPressed,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final Color? color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SettingsMenuItem(
      onPressed: onPressed,
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
          if (trailing != null) trailing!,
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
