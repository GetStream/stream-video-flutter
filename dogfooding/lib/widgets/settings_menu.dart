import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

CallReactionData _raisedHandReaction = const CallReactionData(
  emojiCode: ':raise-hand:',
  type: 'Raise hand',
  icon: '✋',
);

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({
    required this.call,
    this.onReactionSend,
    this.onStatsPressed,
    super.key,
  });

  final Call call;
  final void Function(CallReactionData)? onReactionSend;
  final void Function()? onStatsPressed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColorPalette.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: theme.callControlsTheme.callReactions
                .where((element) =>
                    element.emojiCode != _raisedHandReaction.emojiCode)
                .map((e) {
              return InkWell(
                  onTap: () {
                    call.sendReaction(
                      reactionType: e.type,
                      emojiCode: e.emojiCode,
                    );

                    onReactionSend?.call(e);
                  },
                  child: IgnorePointer(
                    child: CallControlOption(
                      icon: Text(
                        e.icon,
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {},
                      padding: const EdgeInsets.all(0),
                    ),
                  ));
            }).toList(),
          ),
          const SizedBox(height: 8),
          SettingsMenuItem(
            child: const Center(child: Text('✋ Raise hand')),
            onPressed: () {
              call.sendReaction(
                reactionType: _raisedHandReaction.type,
                emojiCode: _raisedHandReaction.emojiCode,
              );

              onReactionSend?.call(_raisedHandReaction);
            },
          ),
          const SizedBox(height: 16),
          StandardActionMenuItem(
            icon: Icons.auto_graph,
            label: 'Call stats',
            onPressed: onStatsPressed,
          )
        ],
      ),
    );
  }
}

class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({
    super.key,
    required this.child,
    this.onPressed,
  });

  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints.expand(height: 40),
        decoration: BoxDecoration(
          color: AppColorPalette.buttonSecondary,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}

class StandardActionMenuItem extends StatelessWidget {
  const StandardActionMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SettingsMenuItem(
      onPressed: onPressed,
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
