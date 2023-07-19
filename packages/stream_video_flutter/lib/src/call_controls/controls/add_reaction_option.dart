import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../stream_video_flutter.dart';

/// A widget that allows a user to add a reaction
class AddReactionOption extends StatefulWidget {
  /// Creates a new instance of [ToggleCameraOption].
  const AddReactionOption({
    super.key,
    required this.call,
    required this.localParticipant,
    this.reactionIcon = Icons.add_reaction_outlined,
  });

  /// Represents a call.
  final Call call;

  /// The current local participant.
  final CallParticipantState localParticipant;

  /// The icon that is shown when the camera is enabled.
  final IconData reactionIcon;

  @override
  State<AddReactionOption> createState() => _AddReactionOptionState();
}

class _AddReactionOptionState extends State<AddReactionOption> {
  OverlayEntry? overlayEntry;
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('reactionControlKey'),
      child: CallControlOption(
        key: key,
        icon: Icon(widget.reactionIcon),
        onPressed: _toggleOverlay,
      ),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0.0) {
          overlayEntry?.remove();
          overlayEntry = null;
        }
      },
    );
  }

  void _toggleOverlay() {
    final theme = StreamVideoTheme.of(context);
    final overlayState = Overlay.of(context);

    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    } else {
      final renderBox = key.currentContext!.findRenderObject() as RenderBox?;
      final offset = renderBox!.localToGlobal(Offset.zero);

      overlayEntry = OverlayEntry(
        builder: (context) {
          return Positioned(
            left: offset.dx,
            bottom: renderBox.size.height + 16,
            child: Material(
              color: Colors.transparent,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(renderBox.size.width),
                  color: Colors.black,
                ),
                child: Column(
                  children: theme.callControlsTheme.callReactions.map((e) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          widget.call.sendReaction(
                            reactionType: e.type,
                            emojiCode: e.emojiCode,
                          );
                          _toggleOverlay();
                        },
                        child: CircleAvatar(
                          radius: renderBox.size.width / 2,
                          child: Text(
                            e.icon,
                            style: TextStyle(
                              fontSize: renderBox.size.width / 2,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      );
      overlayState.insert(overlayEntry!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    overlayEntry?.remove();
    overlayEntry = null;
  }
}
