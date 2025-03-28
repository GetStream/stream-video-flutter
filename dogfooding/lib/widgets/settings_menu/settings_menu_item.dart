import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';

class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({
    super.key,
    required this.child,
    this.onPressed,
  });

  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints.expand(height: 40),
        decoration: BoxDecoration(
          color: AppColorPalette.buttonSecondary,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}
