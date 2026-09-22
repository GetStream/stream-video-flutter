import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stream_core_flutter/core.dart';

/// Shows [builder] as a modal dialog over a blurred scrim.
///
/// The dialog itself is typically a [StreamModalDialog], which supplies the
/// surface, the header and the footer.
///
/// Mirrors the `Web / Blur Scrim` component from the design: the barrier is
/// the scrim color over a backdrop blur, rather than the flat translucent
/// black Material's [showDialog] paints.
///
/// Returns the value the dialog was popped with, or null when it was
/// dismissed.
Future<T?> showStreamModalDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  final scrimColor = context.streamColorScheme.backgroundScrim;

  return showGeneralDialog<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    barrierDismissible: barrierDismissible,
    barrierLabel:
        barrierLabel ??
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
    // The scrim is drawn as part of the transition instead, so that it can
    // carry the blur. A colored barrier here would paint a second, flat one
    // underneath it.
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curve = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return FadeTransition(
        opacity: curve,
        child: Stack(
          children: [
            // Behind the dialog and out of the way of the modal barrier that
            // sits below, which is what a tap outside dismisses.
            Positioned.fill(
              child: IgnorePointer(child: StreamBlurScrim(color: scrimColor)),
            ),
            ScaleTransition(
              scale: Tween<double>(begin: 0.96, end: 1).animate(curve),
              child: child,
            ),
          ],
        ),
      );
    },
  );
}

/// The scrim a modal surface sits on: a translucent fill over a blur of
/// whatever is behind it.
///
/// Mirrors the `Web / Blur Scrim` component from the design.
///
/// This is a design-system candidate: it lives in this SDK until the
/// component is finalized and can graduate to stream_core_flutter.
class StreamBlurScrim extends StatelessWidget {
  /// Creates a blur scrim.
  const StreamBlurScrim({super.key, this.color, this.blurSigma = 12.5});

  /// The fill drawn over the blur.
  ///
  /// Defaults to `colorScheme.backgroundScrim`.
  final Color? color;

  /// The blur applied to whatever sits behind the scrim.
  ///
  /// Defaults to 12.5. Set to `0` to skip the blur, which costs a render
  /// layer the size of the window.
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final fill = ColoredBox(
      color: color ?? context.streamColorScheme.backgroundScrim,
    );

    if (blurSigma <= 0) return fill;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
      child: fill,
    );
  }
}

/// A centered modal surface with a title, an optional row of header actions
/// and an optional row of footer actions.
///
/// Mirrors the `Web / Modal Dialog Header` and `Web / Modal Dialog Footer`
/// components from the design, on an elevation-1 surface.
///
/// Pass it to [showStreamModalDialog], which supplies the scrim:
///
/// {@tool snippet}
///
/// ```dart
/// final confirmed = await showStreamModalDialog<bool>(
///   context: context,
///   builder: (context) => StreamModalDialog(
///     title: const Text('Leave the call?'),
///     actions: [
///       StreamButton(
///         style: StreamButtonStyle.secondary,
///         type: StreamButtonType.ghost,
///         onPressed: () => Navigator.pop(context, false),
///         child: const Text('Stay'),
///       ),
///       StreamButton(
///         style: StreamButtonStyle.destructive,
///         onPressed: () => Navigator.pop(context, true),
///         child: const Text('Leave'),
///       ),
///     ],
///     child: const Text('Everyone else stays in the call.'),
///   ),
/// );
/// ```
/// {@end-tool}
///
/// This is a design-system candidate: it lives in this SDK until the
/// component is finalized and can graduate to stream_core_flutter.
class StreamModalDialog extends StatelessWidget {
  /// Creates a modal dialog.
  const StreamModalDialog({
    super.key,
    this.title,
    this.headerActions = const [],
    this.showCloseButton = true,
    this.onClose,
    this.actions = const [],
    this.constraints = defaultConstraints,
    required this.child,
  });

  /// The size the design gives a modal window.
  ///
  /// A maximum rather than a fixed size: the dialog shrinks with the window,
  /// and takes only the height its content needs.
  static const defaultConstraints = BoxConstraints(
    maxWidth: 720,
    maxHeight: 640,
  );

  /// The dialog's title, drawn at the leading edge of the header.
  final Widget? title;

  /// Buttons drawn in the header, before the close button.
  ///
  /// Typically [StreamButton.icon]s.
  final List<Widget> headerActions;

  /// Whether the header draws a close button after [headerActions].
  final bool showCloseButton;

  /// Called when the close button is pressed.
  ///
  /// Defaults to popping the dialog with no value.
  final VoidCallback? onClose;

  /// Buttons drawn in the footer, aligned to the trailing edge.
  ///
  /// An empty list draws no footer at all.
  final List<Widget> actions;

  /// The bounds of the dialog.
  ///
  /// Defaults to [defaultConstraints].
  final BoxConstraints constraints;

  /// The dialog's body, between the header and the footer.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final spacing = context.streamSpacing;

    return Dialog(
      backgroundColor: colorScheme.backgroundElevation1,
      surfaceTintColor: Colors.transparent,
      elevation: context.streamElevation.level4,
      clipBehavior: Clip.antiAlias,
      insetPadding: EdgeInsets.all(spacing.xxl),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(context.streamRadius.xl),
      ),
      child: ConstrainedBox(
        constraints: constraints,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ModalDialogHeader(
              title: title,
              actions: [
                ...headerActions,
                if (showCloseButton)
                  StreamButton.icon(
                    icon: Icon(context.streamIcons.xmark),
                    style: StreamButtonStyle.secondary,
                    type: StreamButtonType.ghost,
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                  ),
              ],
            ),
            Flexible(child: child),
            if (actions.isNotEmpty) _ModalDialogFooter(actions: actions),
          ],
        ),
      ),
    );
  }
}

class _ModalDialogHeader extends StatelessWidget {
  const _ModalDialogHeader({required this.title, required this.actions});

  final Widget? title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return Padding(
      padding: EdgeInsets.all(spacing.xl),
      child: Row(
        spacing: spacing.md,
        children: [
          Expanded(
            child: DefaultTextStyle.merge(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.streamTextTheme.headingSm.copyWith(
                color: context.streamColorScheme.textPrimary,
              ),
              child: title ?? const SizedBox.shrink(),
            ),
          ),
          if (actions.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: spacing.xs,
              children: actions,
            ),
        ],
      ),
    );
  }
}

class _ModalDialogFooter extends StatelessWidget {
  const _ModalDialogFooter({required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return Padding(
      padding: EdgeInsets.all(spacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: spacing.xs,
        children: actions,
      ),
    );
  }
}
