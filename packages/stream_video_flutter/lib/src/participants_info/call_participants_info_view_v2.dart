import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'call_participant_info_view_v2.dart';
import 'call_participants_info_options_v2.dart';
import 'invite_user_list_controller_v2.dart';
import 'invite_user_list_view_v2.dart';

/// {@template participantsInfoViewBuilder}
/// Builder function used to build a participant info view.
/// {@endtemplate}
typedef ParticipantInfoViewBuilder = Widget Function(
  BuildContext context,
  int index,
  CallParticipantStateV2 participant,
);

/// {@template participantInfoDividerBuilder}
/// Builder function used to build a participant info divider.
/// {@endtemplate}
typedef ParticipantInfoDividerBuilder = Widget Function(
  BuildContext context,
  int index,
);

/// {@template streamCallParticipantsInfoView}
/// Displays call participants info.
/// {@endtemplate}
class StreamCallParticipantsInfoViewV2 extends StatefulWidget {
  /// {@macro streamCallParticipantsInfoView}
  const StreamCallParticipantsInfoViewV2({
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

  /// {@macro participantsInfoViewBuilder}
  final ParticipantInfoViewBuilder? participantInfoViewBuilder;

  /// {@macro participantInfoDividerBuilder}
  final ParticipantInfoDividerBuilder? participantInfoDividerBuilder;

  @override
  State<StreamCallParticipantsInfoViewV2> createState() =>
      _StreamCallParticipantsInfoViewV2State();
}

const int _idState = 5;

class _StreamCallParticipantsInfoViewV2State
    extends State<StreamCallParticipantsInfoViewV2> {
  Function? _cancelListener;
  // final participants = <CallParticipantState>[];

  late StreamInviteUserListControllerV2 _controller;

  final subscriptions = Subscriptions();

  @override
  void initState() {
    super.initState();
    _controller = StreamInviteUserListControllerV2(
      call: widget.call,
      usersProvider: widget.usersProvider,
    );

    subscriptions.add(_idState, widget.call.state.listen(_setState));
    _setState(widget.call.state.value);
  }

  @override
  void dispose() {
    super.dispose();
    subscriptions.cancelAll();
  }

  Future<void> _setState(CallStateV2 state) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localParticipant = widget.call.state.value.callParticipants
        .where((it) => it.isLocal)!
        .first;
    final participants = widget.call.state.value.callParticipants;

    final streamChatTheme = StreamVideoTheme.of(context);
    final participantsInfoTheme =
        widget.participantsInfoTheme ?? streamChatTheme.participantsInfoTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Participants (${widget.call.state.value.callParticipants.length + 1})'),
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
                return CallParticipantInfoViewV2(
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
            child: CallParticipantsInfoOptionsV2(
              localParticipant: localParticipant,
              call: widget.call,
              inviteButtonTitle: 'Invite',
              muteToggleTitles: const MuteToggleTitles(
                muteTitle: 'Mute Me',
                unmuteTitle: 'Unmute Me',
              ),
              onInviteButtonPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StreamInviteUserListViewV2(
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

  /// Creates [CallParticipantState] from [ParticipantInfo] and [self] flag.
  CallParticipantState _mapToState(
    ParticipantInfo info, {
    required bool self,
  }) {
    //TODO grab role from coordinator User
    return CallParticipantState(
      self: self,
      user: UserInfo(id: info.userId, role: 'member', name: info.userId),
      audioAvailable: info.hasPublishedAudioTrack(),
      videoAvailable: info.hasPublishedVideoTrack(),
    );
  }
}
