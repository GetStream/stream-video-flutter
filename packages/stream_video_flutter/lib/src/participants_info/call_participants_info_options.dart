import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// {@template streamCallParticipantsInfoView}
/// Displays call participants info.
/// {@endtemplate}
class CallParticipantsInfoOptions extends StatelessWidget {
  /// {@macro CallParticipantsInfoOptionsV2}
  const CallParticipantsInfoOptions({
    super.key,
    required this.call,
    required this.localParticipant,
    required this.inviteButtonTitle,
    required this.muteToggleTitles,
    this.onInviteButtonPress,
  });

  /// Reference to [Call].
  final CallV2 call;

  /// Invite button title.
  final String inviteButtonTitle;

  /// Mute/Unmute button titles.
  final MuteToggleTitles muteToggleTitles;

  /// The action to perform when the Invite button is pressed.
  final VoidCallback? onInviteButtonPress;

  final CallParticipantStateV2 localParticipant;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ButtonBar(
        buttonPadding: const EdgeInsets.all(16),
        alignment: MainAxisAlignment.center,
        children: [
          _InviteButton(
              title: inviteButtonTitle,
              onInviteButtonPress: onInviteButtonPress),
          _MuteToggle(
            titles: muteToggleTitles,
            call: call,
            localParticipant: localParticipant,
          )
        ],
      ),
    );
  }
}

class _InviteButton extends StatelessWidget {
  const _InviteButton({
    required this.title,
    this.onInviteButtonPress,
  });

  final String title;
  final VoidCallback? onInviteButtonPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onInviteButtonPress?.call();
      },
      style: ElevatedButton.styleFrom(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        minimumSize: const Size(144, 48),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}

class _MuteToggle extends StatefulWidget {
  const _MuteToggle({
    required this.titles,
    required this.call,
    required this.localParticipant,
  });

  final MuteToggleTitles titles;
  final CallV2 call;
  final CallParticipantStateV2 localParticipant;

  @override
  State<_MuteToggle> createState() => _MuteToggleState();
}

class _MuteToggleState extends State<_MuteToggle> {
  @override
  Widget build(BuildContext context) {
    final trackState =
        widget.localParticipant.publishedTracks[SfuTrackType.audio];
    final isEnabled = trackState != null && !trackState.muted;

    final streamChatTheme = StreamVideoTheme.of(context);
    return OutlinedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            32.0,
          ),
        ),
        side: BorderSide(
          width: 1,
          color: streamChatTheme.colorTheme.overlay,
        ),
        minimumSize: const Size(144, 48),
      ),
      onPressed: () {
        widget.call.apply(
          SetMicrophoneEnabled(enabled: !isEnabled),
        );
      },
      child: Text(
        isEnabled ? widget.titles.muteTitle : widget.titles.unmuteTitle,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
