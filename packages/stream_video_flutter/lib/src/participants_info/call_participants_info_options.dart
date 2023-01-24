import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../models/mute_toggle_titles.dart';

/// {@template streamCallParticipantsInfoView}
/// Displays call participants info.
/// {@endtemplate}
class StreamCallParticipantsInfoOptions extends StatelessWidget {
  /// {@macro streamCallParticipantsInfoView}
  const StreamCallParticipantsInfoOptions({
    super.key,
    required this.call,
    required this.inviteButtonTitle,
    required this.muteToggleTitles,
    this.onInviteButtonPress,
  });

  /// Reference to [Call].
  final Call call;

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
              onInviteButtonPress: onInviteButtonPress),
          _MuteToggle(titles: muteToggleTitles, call: call)
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
  });

  final MuteToggleTitles titles;
  final Call call;

  @override
  State<_MuteToggle> createState() => _MuteToggleState();
}

class _MuteToggleState extends State<_MuteToggle> {
  Function? _cancelListener;

  @override
  void initState() {
    super.initState();
    _cancelListener = widget.call.events.listen((event) {
      if (event is ParticipantInfoUpdatedEvent) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cancelListener?.call();
  }

  @override
  Widget build(BuildContext context) {
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
      onPressed: () async {
        await widget.call.localParticipant?.toggleMicrophone();
      },
      child: Text(
        widget.call.localParticipant?.isAudioEnabled == true
            ? widget.titles.muteTitle
            : widget.titles.unmuteTitle,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
