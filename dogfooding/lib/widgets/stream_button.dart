import 'package:flutter/material.dart';

class StreamButton extends StatelessWidget {
  const StreamButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    this.borderColor,
    this.icon,
    this.onPressed,
  });

  factory StreamButton.active({
    required String label,
    required VoidCallback onPressed,
    Widget? icon,
  }) {
    return StreamButton(
      label: label,
      icon: icon,
      onPressed: onPressed,
      backgroundColor: const Color(0xff005FFF),
    );
  }

  factory StreamButton.primary({
    required String label,
    required VoidCallback onPressed,
    Widget? icon,
  }) {
    return StreamButton(
      label: label,
      icon: icon,
      onPressed: onPressed,
      backgroundColor: const Color(0xFF19232D),
    );
  }

  factory StreamButton.tertiary({
    required String label,
    required VoidCallback onPressed,
    Widget? icon,
  }) {
    return StreamButton(
      label: label,
      icon: icon,
      onPressed: onPressed,
      backgroundColor: const Color(0xFF101213),
      borderColor: const Color(0xFF323B44),
    );
  }

  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        // fixedSize: const Size.fromHeight(56),
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        shape: RoundedRectangleBorder(
          side: borderColor != null
              ? BorderSide(
                  color: borderColor!,
                  width: 1,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.circular(36),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 12),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
