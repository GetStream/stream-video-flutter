import 'dart:math';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

class FloatingView extends StatefulWidget {
  const FloatingView({
    super.key,
    required this.topWidget,
    required this.bottomWidget,
    this.floatingParticipantTheme,
  });

  final Widget topWidget;
  final Widget bottomWidget;

  /// Theme for participant pip window
  final StreamFloatingCallParticipantTheme? floatingParticipantTheme;

  @override
  State<FloatingView> createState() => _FloatingViewState();
}

class _FloatingViewState extends State<FloatingView> {
  Offset bottomRightOffset = const Offset(0, double.infinity);

  @override
  Widget build(BuildContext context) {
    final streamChatTheme =
        StreamVideoTheme.of(context).floatingCallParticipantTheme;
    final floatingTheme = widget.floatingParticipantTheme ?? streamChatTheme;
    final floatingParticipantWidth = floatingTheme.floatingParticipantWidth;
    final floatingParticipantHeight = floatingTheme.floatingParticipantHeight;
    final floatingParticipantPadding = floatingTheme.floatingParticipantPadding;

    return LayoutBuilder(
      builder: (context, constraints) {
        final parentSize = constraints.biggest;

        final maxRightOffset = parentSize.width -
            floatingParticipantWidth -
            2 * floatingParticipantPadding;
        final maxBottomOffset = parentSize.height -
            floatingParticipantHeight -
            2 * floatingParticipantPadding;

        // If window is resized, this resets the floating window.
        bottomRightOffset = Offset(
          min(bottomRightOffset.dx, maxRightOffset),
          min(bottomRightOffset.dy, maxBottomOffset),
        );

        final offset = bottomRightOffset;

        return Stack(
          children: [
            widget.bottomWidget,
            Positioned(
              right: offset.dx,
              bottom: offset.dy,
              child: GestureDetector(
                onPanUpdate: (drag) {
                  final dx = drag.delta.dx;
                  final dy = drag.delta.dy;

                  setState(() {
                    bottomRightOffset = Offset(
                      max(0, min(offset.dx - dx, maxRightOffset)),
                      max(0, min(offset.dy - dy, maxBottomOffset)),
                    );
                  });
                },
                child: widget.topWidget,
              ),
            ),
          ],
        );
      },
    );
  }
}
