import 'package:flutter/widgets.dart';
import 'package:stream_core_flutter/core.dart';

/// What a place shows while it has nothing in it: an icon over a title and a
/// short description, centred.
///
/// Mirrors the `Web / Empty State` component from the design.
///
/// It has no theme yet: its sizes and colors come from the design tokens.
///
/// This is a design-system candidate: it lives in this SDK until the
/// component is finalized and can graduate to stream_core_flutter.
class StreamEmptyState extends StatelessWidget {
  /// Creates an empty state.
  const StreamEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.action,
  });

  /// The icon at the top, typically an [Icon]. Drawn at 32px.
  final Widget icon;

  /// What is missing.
  final Widget title;

  /// Why, or what would fill it.
  final Widget? description;

  /// A button under the description, such as one to try again.
  final Widget? action;

  // The width the title and description wrap at.
  static const double _maxTextWidth = 320;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.xl,
        vertical: spacing.xxxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: spacing.sm,
        children: [
          IconTheme.merge(
            data: IconThemeData(size: 32, color: colorScheme.textSecondary),
            child: icon,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxTextWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: spacing.xxs,
              children: [
                DefaultTextStyle.merge(
                  textAlign: TextAlign.center,
                  style: textTheme.headingXs.copyWith(
                    color: colorScheme.textPrimary,
                  ),
                  child: title,
                ),
                if (description case final description?)
                  DefaultTextStyle.merge(
                    textAlign: TextAlign.center,
                    style: textTheme.captionDefault.copyWith(
                      color: colorScheme.textSecondary,
                    ),
                    child: description,
                  ),
              ],
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}
