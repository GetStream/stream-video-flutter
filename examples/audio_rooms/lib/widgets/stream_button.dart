import 'package:flutter/material.dart';

class StreamButton extends StatelessWidget {
  const StreamButton({
    super.key,
    required this.child,
    required this.onTap,
    this.backgroundColor = const Color(0xff005FFF),
    this.borderRadius = 7,
    this.height = 45,
  });

  final Widget child;
  final Color backgroundColor;
  final double borderRadius;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        fixedSize: Size.fromHeight(height),
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: child,
      ),
    );
  }
}
