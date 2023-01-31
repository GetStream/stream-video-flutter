import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'call_participant_info_view.dart';

/// {@template participantsInfoViewBuilder}
/// Builder function used to build a participant info view.
/// {@endtemplate}
typedef ParticipantInfoViewBuilder = Widget Function(
  BuildContext context,
  int index,
  CallParticipantState participant,
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
class StreamCallParticipantsInfoView extends StatefulWidget {
  /// {@macro streamCallParticipantsInfoView}
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

  /// Reference to [Call].
  final Call call;

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
  State<StreamCallParticipantsInfoView> createState() =>
      _StreamCallParticipantsInfoViewState();
}

class _StreamCallParticipantsInfoViewState
    extends State<StreamCallParticipantsInfoView> {
  Function? _cancelListener;
  final participants = <CallParticipantState>[];

  late StreamInviteUserListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StreamInviteUserListController(
      call: widget.call,
      usersProvider: widget.usersProvider,
    );

    _setParticipants();
    _cancelListener = widget.call.events.listen((event) {
      if (event is ParticipantJoinedEvent ||
          event is ParticipantLeftEvent ||
          event is ParticipantInfoUpdatedEvent) {
        setState(_setParticipants);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cancelListener?.call();
  }

  /// Applies participants from the given [widget.call].
  void _setParticipants() {
    participants.clear();
    final localParticipant = widget.call.localParticipant;
    final localState = localParticipant != null
        ? _mapToState(localParticipant.info, self: true)
        : null;
    if (localState != null) {
      participants.add(localState);
    }
    participants.addAll(
      widget.call.participants.values.map((participant) {
        return _mapToState(participant.info, self: false);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamVideoTheme.of(context);
    final participantsInfoTheme =
        widget.participantsInfoTheme ?? streamChatTheme.participantsInfoTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Participants (${widget.call.participants.length + 1})'),
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
