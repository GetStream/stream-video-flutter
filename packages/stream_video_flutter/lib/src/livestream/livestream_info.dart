import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import '../l10n/localization_extension.dart';
import '../theme/themes.dart';
import '../widgets/partial_call_state_builder.dart';
import 'livestream_speakerphone_option.dart';

/// A control bar style widget meant for displaying livestream controls and
/// actions.
class LivestreamInfo extends StatelessWidget {
  /// Creates a [LivestreamInfo] widget.
  ///
  /// * [call] is the livestream call intended to be viewed.
  ///
  /// * [fullscreen] denotes if the video renderer is in cover or contain mode.
  ///
  /// * [onFullscreenTapped] is a callback function that notifies when the fullscreen button is tapped.
  ///
  /// * [duration] denotes the current call duration.
  ///
  /// * [showParticipantCount] defines if the call should show participant count.
  ///
  /// * [includeAnonymousParticipantsCount] defines if the participant count should include anonymous participants.
  const LivestreamInfo({
    super.key,
    required this.call,
    required this.fullscreen,
    required this.onFullscreenTapped,
    required this.duration,
    this.showParticipantCount = true,
    this.includeAnonymousParticipantsCount = true,
  });

  /// The livestream call to display/modify.
  final Call call;

  /// Denotes if the video renderer is in cover or contain mode.
  final bool fullscreen;

  /// Callback function that notifies when the fullscreen button is tapped.
  final VoidCallback onFullscreenTapped;

  /// The current duration of the call.
  final Duration duration;

  /// Boolean to display participant count.
  ///
  /// Defaults to true.
  final bool showParticipantCount;

  /// Boolean to include anonymous participants in the count.
  ///
  /// Defaults to true.
  final bool includeAnonymousParticipantsCount;

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final theme = streamVideoTheme.livestreamTheme;
    final colorTheme = StreamVideoTheme.of(context).colorTheme;
    final translations = context.translations;

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

    return PartialCallStateBuilder(
      call: call,
      selector: (state) => (
        isBackstage: state.isBackstage,
        participantCount: state.participantCount,
        anonymousParticipantCount: state.anonymousParticipantCount,
      ),
      builder: (context, callData) {
        return ColoredBox(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: theme.liveButtonColor,
                    ),
                    child: Text(
                      callData.isBackstage
                          ? translations.livestreamBackstage
                          : translations.livestreamLive,
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
                          includeAnonymousParticipantsCount
                              ? (callData.participantCount +
                                        callData.anonymousParticipantCount)
                                    .toString()
                              : callData.participantCount.toString(),
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
                    disabledSpeakerphoneIconTheme:
                        speakerphoneDisabledIconTheme,
                  ),
                  IconButton(
                    onPressed: onFullscreenTapped,
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
      },
    );
  }
}
