import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'call_participants_info_options.dart';
import 'invite_user_list_controller.dart';
import 'invite_user_list_view.dart';

/// Builder function used to build a participant info view.
typedef ParticipantInfoViewBuilder = Widget Function(
  BuildContext context,
  int index,
  CallParticipantStateV2 participant,
);

/// Builder function used to build a participant info divider.
typedef ParticipantInfoDividerBuilder = Widget Function(
  BuildContext context,
  int index,
);

/// Displays call participants info.
class StreamCallParticipantsInfoView extends StatefulWidget {
  /// Creates a new instance of [StreamCallParticipantsInfoView].
  const StreamCallParticipantsInfoView({
    super.key,
    required this.call,
    required this.usersProvider,
    this.videoIcon = const StreamIconToggle(
      active: Icons.videocam_rounded,
      inactive: Icons.videocam_off_rounded,
    ),
    this.audioIcon = const StreamIconToggle(
      active: Icons.mic,
      inactive: Icons.mic_off,
    ),
    this.participantsInfoTheme,
    this.participantInfoViewBuilder,
    this.participantInfoDividerBuilder,
  });

  /// Reference to [CallV2].
  final CallV2 call;

  /// Provider for users that can be invited to the call.
  final StreamUsersProvider usersProvider;

  /// Toggle container for the "video" icons.
  final StreamIconToggle videoIcon;

  /// Toggle container for the "audio" icons.
  final StreamIconToggle audioIcon;

  /// Theme for the participants info.
  final StreamParticipantsInfoTheme? participantsInfoTheme;

  /// Builder function used to build a participant info view.
  final ParticipantInfoViewBuilder? participantInfoViewBuilder;

  /// Builder function used to build a participant info divider.
  final ParticipantInfoDividerBuilder? participantInfoDividerBuilder;

  @override
  State<StreamCallParticipantsInfoView> createState() =>
      _StreamCallParticipantsInfoViewState();
}

class _StreamCallParticipantsInfoViewState
    extends State<StreamCallParticipantsInfoView> {
  late StreamInviteUserListController _controller;
  final _subscriptions = Subscriptions();

  @override
  void initState() {
    super.initState();
    _controller = StreamInviteUserListController(
      call: widget.call,
      usersProvider: widget.usersProvider,
    );

    _subscriptions.add(0, widget.call.state.listen(_setState));
    _setState(widget.call.state.value);
  }

  @override
  void dispose() {
    super.dispose();
    _subscriptions.cancelAll();
  }

  Future<void> _setState(CallStateV2 state) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final callState = widget.call.state.value;
    final localParticipant = callState.localParticipant;
    final participants = callState.callParticipants;

    final streamChatTheme = StreamVideoTheme.of(context);
    final participantsInfoTheme =
        widget.participantsInfoTheme ?? streamChatTheme.participantsInfoTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Participants (${callState.callParticipants.length})'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16),
              itemBuilder: (context, index) {
                final participant = participants[index];
                final builder = widget.participantInfoViewBuilder;
                if (builder != null) {
                  return builder.call(context, index, participant);
                }
                return CallParticipantInfoView(
                  participant: participant,
                  videoIcon: widget.videoIcon,
                  audioIcon: widget.audioIcon,
                );
              },
              separatorBuilder: (context, index) =>
                  widget.participantInfoDividerBuilder?.call(context, index) ??
                  Divider(
                    indent: participantsInfoTheme.dividerIndent,
                    height: participantsInfoTheme.dividerHeight,
                    color: participantsInfoTheme.dividerColor,
                  ),
              itemCount: participants.length,
            ),
          ),
          Material(
            elevation: 8,
            color: streamChatTheme.colorTheme.appBg,
            child: CallParticipantsInfoOptions(
              localParticipant: localParticipant!,
              call: widget.call,
              inviteButtonTitle: 'Invite',
              muteToggleTitles: const MuteToggleTitles(
                muteTitle: 'Mute Me',
                unmuteTitle: 'Unmute Me',
              ),
              onInviteButtonPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StreamInviteUserListView(
                      controller: _controller,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
