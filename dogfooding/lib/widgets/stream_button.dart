import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

enum _StreamButtonVariant { active, primary, tertiary }

class StreamButton extends StatelessWidget {
  const StreamButton._({
    required this.label,
    required _StreamButtonVariant variant,
    this.icon,
    this.onPressed,
  }) : _variant = variant;

  factory StreamButton.active({
    required String label,
    required VoidCallback? onPressed,
    Widget? icon,
  }) {
    return StreamButton._(
      label: label,
      icon: icon,
      onPressed: onPressed,
      variant: _StreamButtonVariant.active,
    );
  }

  factory StreamButton.primary({
    required String label,
    required VoidCallback onPressed,
    Widget? icon,
  }) {
    return StreamButton._(
      label: label,
      icon: icon,
      onPressed: onPressed,
      variant: _StreamButtonVariant.primary,
    );
  }

  factory StreamButton.tertiary({
    required String label,
    required VoidCallback onPressed,
    Widget? icon,
  }) {
    return StreamButton._(
      label: label,
      icon: icon,
      onPressed: onPressed,
      variant: _StreamButtonVariant.tertiary,
    );
  }

  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final _StreamButtonVariant _variant;

  @override
  Widget build(BuildContext context) {
    final colorScheme = StreamTheme.of(context).colorScheme;

    final (backgroundColor, foregroundColor, borderColor) = switch (_variant) {
      _StreamButtonVariant.active => (
        colorScheme.brand,
        colorScheme.textOnAccent,
        null,
      ),
      _StreamButtonVariant.primary => (
        colorScheme.backgroundSurface,
        colorScheme.textPrimary,
        null,
      ),
      _StreamButtonVariant.tertiary => (
        colorScheme.backgroundApp,
        colorScheme.textPrimary,
        colorScheme.borderDefault,
      ),
    };

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        shape: RoundedRectangleBorder(
          side: borderColor != null
              ? BorderSide(color: borderColor)
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
              IconTheme.merge(
                data: IconThemeData(color: foregroundColor),
                child: icon!,
              ),
              const SizedBox(width: 12),
            ],
            Text(
              label,
              style: TextStyle(fontSize: 16, color: foregroundColor),
            ),
          ],
        ),
      ),
    );
  }
}
