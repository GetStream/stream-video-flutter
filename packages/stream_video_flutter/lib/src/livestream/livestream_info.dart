import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import '../theme/themes.dart';
import 'livestream_speakerphone_option.dart';

/// A control bar style widget meant for displaying livestream controls and
/// actions.
class LivestreamInfo extends StatelessWidget {
  /// Creates a [LivestreamInfo] widget.
  ///
  /// * [call] is the livestream call intended to be viewed.
  ///
  /// * [callState] is the livestream call state.
  ///
  /// * [fullscreen] denotes if the video renderer is in cover or contain mode.
  ///
  /// * [onStateChanged] notifies the implementing widget of a state change.
  ///
  /// * [duration] denotes the current call duration.
  ///
  /// * [showParticipantCount] defines if the call should show participant count.
  const LivestreamInfo({
    super.key,
    required this.call,
    required this.callState,
    required this.fullscreen,
    required this.onStateChanged,
    required this.duration,
    required this.showParticipantCount,
  });

  /// The livestream call to display/modify.
  final Call call;

  /// The livestream call state.
  final CallState callState;

  /// Denotes if the video renderer is in cover or contain mode.
  final bool fullscreen;

  /// Notifies the implementing widget of a requested state change.
  final VoidCallback onStateChanged;

  /// The current duration of the call.
  final Duration duration;

  /// Boolean to display participant count.
  ///
  /// Defaults to true.
  final bool showParticipantCount;

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final theme = streamVideoTheme.livestreamTheme;
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
                  style: theme.callStateButtonTextStyle,
                ),
              ),
              if (showParticipantCount)
                Row(
                  children: [
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
                      style: theme.participantCountTextStyle,
                    ),
                  ],
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
                style: theme.durationTextStyle,
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
