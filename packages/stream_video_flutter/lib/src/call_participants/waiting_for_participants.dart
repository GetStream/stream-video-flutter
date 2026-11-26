import 'package:flutter/widgets.dart';
import 'package:stream_core_flutter/core.dart';

import '../l10n/localization_extension.dart';

/// The empty side of a half-open foldable while the local participant is
/// alone in the call: a spinner and "Waiting for others to join", on a
/// surface shaped like a participant tile.
class StreamWaitingForParticipants extends StatelessWidget {
  /// Creates the waiting placeholder.
  const StreamWaitingForParticipants({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final spacing = context.streamSpacing;
    final borderRadius = BorderRadius.all(context.streamRadius.xxl);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.backgroundSurfaceSubtle,
        borderRadius: borderRadius,
        border: Border.all(color: colorScheme.borderDefault),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: spacing.sm,
            children: [
              StreamLoadingSpinner(),
              Text(
                context.translations.participantsWaitingForOthers,
                textAlign: TextAlign.center,
                style: context.streamTextTheme.bodyDefault.copyWith(
                  color: colorScheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
