import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// The livestream tile's surface with a centred message, for the states that
/// have no video to show: ended, backstage, connecting and no host video.
@internal
class LivestreamStatusCard extends StatelessWidget {
  /// Creates a [LivestreamStatusCard].
  const LivestreamStatusCard({
    super.key,
    required this.title,
    this.subtitle,
    this.children = const [],
  });

  /// The message's first line.
  final String title;

  /// The line under [title].
  final String? subtitle;

  /// Anything shown under the message.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final borderRadius = BorderRadius.all(context.streamRadius.xxl);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.backgroundSurfaceSubtle,
        borderRadius: borderRadius,
        border: Border.all(color: colorScheme.borderDefault),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: spacing.xxs,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.bodyEmphasis.copyWith(
                  color: colorScheme.textPrimary,
                ),
              ),
              if (subtitle case final subtitle?)
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyDefault.copyWith(
                    color: colorScheme.textSecondary,
                  ),
                ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
