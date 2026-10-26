import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../stream_video_flutter.dart';

/// A widget that allows a user to add a reaction
class StreamAddReactionButton extends StatefulWidget {
  /// Creates a new instance of [StreamAddReactionButton].
  const StreamAddReactionButton({
    super.key,
    required this.call,
    this.reactionIcon,
  });

  /// Represents a call.
  final Call call;

  /// The icon of the add-reaction button.
  ///
  /// Defaults to `context.streamIcons.emojiAddFill`.
  final IconData? reactionIcon;

  @override
  State<StreamAddReactionButton> createState() =>
      _StreamAddReactionButtonState();
}

class _StreamAddReactionButtonState extends State<StreamAddReactionButton> {
  OverlayEntry? overlayEntry;
  GlobalKey key = GlobalKey();

  // Links the overlay to the button, which it follows wherever the button is
  // laid out.
  final _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('reactionControlKey'),
      child: CompositedTransformTarget(
        link: _link,
        child: CallControlButton(
          key: key,
          icon: Icon(widget.reactionIcon ?? context.streamIcons.emojiAddFill),
          onPressed: _toggleOverlay,
        ),
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
      final renderBox = key.currentContext!.findRenderObject()! as RenderBox;

      overlayEntry = OverlayEntry(
        builder: (context) {
          return Positioned(
            left: 0,
            top: 0,
            child: CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              targetAnchor: Alignment.topCenter,
              followerAnchor: Alignment.bottomCenter,
              offset: const Offset(0, -16),
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
            ),
          );
        },
      );
      overlayState.insert(overlayEntry!);
    }
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    overlayEntry = null;
    super.dispose();
  }
}

/// AddReactionOption is [StreamAddReactionButton] now.
@Deprecated(
  'AddReactionOption is StreamAddReactionButton now, matching the rest of the '
  'call controls. Will be removed in the next major version.',
)
typedef AddReactionOption = StreamAddReactionButton;
