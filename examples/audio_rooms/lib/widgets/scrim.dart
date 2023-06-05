import 'package:flutter/material.dart';

class Scrim extends StatelessWidget {
  final bool applied;
  final Widget child;

  final double opacity;
  final Duration speed;
  final Color color;

  const Scrim({
    Key? key,
    required this.applied,
    required this.child,
    this.opacity = 0.75,
    this.color = Colors.white,
    this.speed = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: applied,
      child: AnimatedContainer(
        duration: speed,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
        foregroundDecoration: BoxDecoration(
          color: color.withOpacity(applied ? opacity : 0.0),
        ),
        child: child,
      ),
    );
  }
}