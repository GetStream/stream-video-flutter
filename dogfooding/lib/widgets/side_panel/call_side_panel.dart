import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// The panels the call screen can put beside — or over — the video grid.
enum CallSidePanel {
  /// The participants and members of the call.
  participants,

  /// The call's chat channel.
  chat,

  /// The call's live statistics.
  stats,
}

/// The chrome shared by every [CallSidePanel]: a header with a title and a
/// close button, over the panel's own content.
///
/// The panel is not a route, so closing it is the caller's business — pass
/// [onClose].
class CallSidePanelSurface extends StatelessWidget {
  /// Creates the chrome for a side panel showing [child].
  const CallSidePanelSurface({
    super.key,
    required this.title,
    required this.onClose,
    required this.child,
    this.docked = true,
    this.dockedPadding,
  });

  /// The panel's heading, centred in the header.
  final Widget title;

  /// Called when the header's close button is pressed.
  final VoidCallback onClose;

  /// Whether the panel stands beside the video grid rather than over it.
  ///
  /// Docked, it reads as one more tile: flat, with the participant tiles'
  /// corners and outline, inset by [dockedPadding]. Covering the whole screen
  /// it fills its space square and flush, having no edges to sit inside.
  final bool docked;

  /// The room around a [docked] card.
  ///
  /// Defaults to none.
  final EdgeInsetsGeometry? dockedPadding;

  /// The panel's content, filling everything below the header.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final surface = Material(
      color: colorScheme.backgroundElevation1,
      shape: docked
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.all(context.streamRadius.xxl),
              side: BorderSide(color: colorScheme.borderDefault),
            )
          : null,
      // The content scrolls, so clip it to the corners it is drawn inside.
      clipBehavior: docked ? Clip.antiAlias : Clip.none,
      child: Column(
        children: [
          StreamSheetHeader(
            // The panel lives on the call screen's own route, so an implied
            // leading button would offer to pop the call, not the panel.
            automaticallyImplyLeading: false,
            title: title,
            trailing: StreamButton.icon(
              style: StreamButtonStyle.secondary,
              type: StreamButtonType.outline,
              icon: Icon(context.streamIcons.xmark),
              onPressed: onClose,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );

    if (!docked) return surface;
    return Padding(
      padding: dockedPadding ?? EdgeInsets.zero,
      child: surface,
    );
  }
}
