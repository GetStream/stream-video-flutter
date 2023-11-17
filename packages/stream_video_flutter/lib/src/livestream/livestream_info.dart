import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import '../theme/themes.dart';
import 'livestream_speakerphone_option.dart';

class LivestreamInfo extends StatelessWidget {
  const LivestreamInfo({
    super.key,
    required this.call,
    required this.callState,
    required this.fullscreen,
    required this.onStateChanged,
    required this.duration,
  });

  final Call call;
  final CallState callState;
  final bool fullscreen;
  final VoidCallback onStateChanged;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final theme = StreamLivestreamTheme.of(context);
    final colorTheme = StreamVideoTheme.of(context).colorTheme;

    final participantIconTheme = IconThemeData(
      color: colorTheme.livestreamCallControlsColor,
    ).merge(theme.participantIconTheme);
    final speakerphoneEnabledIconTheme = IconThemeData(
      color: colorTheme.livestreamCallControlsColor,
    ).merge(theme.speakerEnabledIconTheme);
    final speakerphoneDisabledIconTheme = IconThemeData(
      color: colorTheme.livestreamCallControlsColor,
    ).merge(theme.speakerDisabledIconTheme);
    final expandIconTheme = IconThemeData(
      color: colorTheme.livestreamCallControlsColor,
    ).merge(theme.expandIconTheme);
    final contractIconTheme = IconThemeData(
      color: colorTheme.livestreamCallControlsColor,
    ).merge(theme.contractIconTheme);
    final callStatusButtonTextTheme = const TextStyle(
      color: Colors.white,
    ).merge(theme.callStateButtonTextStyle);
    final participantTextTheme = const TextStyle(
      color: Colors.white,
    ).merge(theme.participantCountTextStyle);
    final durationTextTheme = const TextStyle(
      color: Colors.white,
    ).merge(theme.durationTextStyle);

    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    final formattedDuration =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return ColoredBox(
      color: Colors.black.withOpacity(0.4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                child: Text(
                  callState.isBackstage ? 'Backstage' : 'Live',
                  style: callStatusButtonTextTheme,
                ),
              ),
              IconTheme(
                data: participantIconTheme,
                child: const Icon(
                  Icons.remove_red_eye_outlined,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                callState.otherParticipants.length.toString(),
                style: participantTextTheme,
              ),
            ],
          ),
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.red,
                radius: 4,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                formattedDuration,
                style: durationTextTheme,
              ),
            ],
          ),
          Row(
            children: [
              LivestreamSpeakerphoneOption(
                call: call,
                enabledSpeakerphoneIconTheme: speakerphoneEnabledIconTheme,
                disabledSpeakerphoneIconTheme: speakerphoneDisabledIconTheme,
              ),
              IconButton(
                onPressed: onStateChanged,
                icon: AnimatedCrossFade(
                  firstChild: IconTheme(
                    data: contractIconTheme,
                    child: const Icon(
                      Icons.fullscreen_exit,
                    ),
                  ),
                  secondChild: IconTheme(
                    data: expandIconTheme,
                    child: const Icon(
                      Icons.fullscreen,
                    ),
                  ),
                  crossFadeState: fullscreen
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
