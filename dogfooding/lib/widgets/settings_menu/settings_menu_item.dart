import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({super.key, required this.child, this.onPressed});

  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = StreamTheme.of(context).colorScheme;

    return InkWell(
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints(minHeight: 40),
        decoration: BoxDecoration(
          color: colorScheme.backgroundSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}
