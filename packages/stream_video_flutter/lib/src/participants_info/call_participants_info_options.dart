import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// Displays call participants info.
class CallParticipantsInfoOptions extends StatelessWidget {
  /// Creates a new instance of [CallParticipantsInfoOptions].
  const CallParticipantsInfoOptions({
    super.key,
    required this.call,
    required this.localParticipant,
    required this.inviteButtonTitle,
    required this.muteToggleTitles,
    this.onInviteButtonPress,
  });

  /// Represents a call.
  final Call call;

  /// The current local participant.
  final CallParticipantState localParticipant;

  /// Invite button title.
  final String inviteButtonTitle;

  /// Mute/Unmute button titles.
  final MuteToggleTitles muteToggleTitles;

  /// The action to perform when the Invite button is pressed.
  final VoidCallback? onInviteButtonPress;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ButtonBar(
        buttonPadding: const EdgeInsets.all(16),
        alignment: MainAxisAlignment.center,
        children: [
          _InviteButton(
            title: inviteButtonTitle,
            onInviteButtonPress: onInviteButtonPress,
          ),
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
          borderRadius: BorderRadius.circular(32),
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

  /// Represents a call.
  final Call call;

  /// The current local participant.
  final CallParticipantState localParticipant;

  /// Contains titles for muted and unmuted states.
  final MuteToggleTitles titles;

  @override
  State<_MuteToggle> createState() => _MuteToggleState();
}

class _MuteToggleState extends State<_MuteToggle> {
  @override
  Widget build(BuildContext context) {
    final enabled = widget.localParticipant.isAudioEnabled;

    final streamChatTheme = StreamVideoTheme.of(context);
    return OutlinedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            32,
          ),
        ),
        side: BorderSide(
          color: streamChatTheme.colorTheme.overlay,
        ),
        minimumSize: const Size(144, 48),
      ),
      onPressed: () {
        widget.call.setMicrophoneEnabled(enabled: !enabled);
      },
      child: Text(
        enabled ? widget.titles.muteTitle : widget.titles.unmuteTitle,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
