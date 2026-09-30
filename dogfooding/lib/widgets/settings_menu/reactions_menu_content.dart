import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// The reaction that raises a hand.
///
/// Held apart from the rest because it is not one of the strip's emoji: the
/// design gives it a button of its own below them.
const _raiseHandReaction = CallReactionData(
  emojiCode: ':raise-hand:',
  type: 'Raise hand',
  icon: '✋',
);

/// The reactions at the top of the more menu: a row of emoji over a button
/// that raises a hand.
///
/// Sending anything from here closes the menu, through [onReactionSent].
class ReactionsMenuContent extends StatelessWidget {
  const ReactionsMenuContent({
    required this.call,
    this.onReactionSent,
    super.key,
  });

  final Call call;

  final VoidCallback? onReactionSent;

  void _send(CallReactionData reaction) {
    call.sendReaction(
      reactionType: reaction.type,
      emojiCode: reaction.emojiCode,
    );

    onReactionSent?.call();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final reactions = StreamVideoTheme.of(context)
        .callControlsTheme
        .callReactions
        .where((it) => it.emojiCode != _raiseHandReaction.emojiCode);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Scrolls rather than wraps: the menu is as narrow as 320 on a
        // desktop popup, and a row of emoji that reflows changes the menu's
        // height as the theme's reaction list grows.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: spacing.xxs,
            children: [
              for (final reaction in reactions)
                StreamEmojiButton(
                  emoji: StreamUnicodeEmoji(reaction.icon),
                  onPressed: () => _send(reaction),
                ),
            ],
          ),
        ),
        SizedBox(height: spacing.xs),
        SizedBox(
          width: double.infinity,
          child: StreamButton(
            iconLeft: Icon(context.streamIcons.raiseHandFill),
            onPressed: () => _send(_raiseHandReaction),
            child: const Text('Raise hand'),
          ),
        ),
      ],
    );
  }
}
