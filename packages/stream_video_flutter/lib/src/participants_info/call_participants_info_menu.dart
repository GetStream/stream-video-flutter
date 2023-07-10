import 'dart:async';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'call_participants_info_options.dart';
import 'invite_user_list_controller.dart';
import 'invite_user_list_view.dart';

/// Builder function used to build a participant info view.
typedef ParticipantInfoViewBuilder = Widget Function(
  BuildContext context,
  int index,
  CallParticipantState participant,
);

/// Builder function used to build a participant info divider.
typedef ParticipantInfoDividerBuilder = Widget Function(
  BuildContext context,
  int index,
);

/// Displays call participants info.
class StreamCallParticipantsInfoMenu extends StatefulWidget {
  /// Creates a new instance of [StreamCallParticipantsInfoMenu].
  const StreamCallParticipantsInfoMenu({
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
    this.participantInfoViewBuilder,
    this.participantInfoDividerBuilder,
    this.participantDividerColor,
    this.participantDividerIndent,
    this.participantDividerHeight,
    this.participantNameTextStyle,
    this.participantIconActiveColor,
    this.participantIconInactiveColor,
    this.participantUserAvatarTheme,
    this.inviteDividerColor,
    this.inviteDividerIndent,
    this.inviteDividerHeight,
    this.inviteUsernameTextStyle,
    this.inviteSelectedIconColor,
    this.inviteUserAvatarTheme,
  });

  /// Reference to [Call].
  final Call call;

  /// Provider for users that can be invited to the call.
  final StreamUsersProvider usersProvider;

  /// Toggle container for the "video" icons.
  final StreamIconToggle videoIcon;

  /// Toggle container for the "audio" icons.
  final StreamIconToggle audioIcon;

  /// Builder function used to build a participant info view.
  final ParticipantInfoViewBuilder? participantInfoViewBuilder;

  /// Builder function used to build a participant info divider.
  final ParticipantInfoDividerBuilder? participantInfoDividerBuilder;

  /// List divider color.
  final Color? participantDividerColor;

  /// List divider indent.
  final double? participantDividerIndent;

  /// List divider height.
  final double? participantDividerHeight;

  /// [TextStyle] for the user name.
  final TextStyle? participantNameTextStyle;

  /// Color of the active icon.
  final Color? participantIconActiveColor;

  /// Color of the inactive icon.
  final Color? participantIconInactiveColor;

  /// Theme for the user avatar widget.
  final StreamUserAvatarThemeData? participantUserAvatarTheme;

  /// List divider color.
  final Color? inviteDividerColor;

  /// List divider indent.
  final double? inviteDividerIndent;

  /// List divider height.
  final double? inviteDividerHeight;

  /// [TextStyle] for the user name.
  final TextStyle? inviteUsernameTextStyle;

  /// Color of the selected icon.
  final Color? inviteSelectedIconColor;

  /// Theme for the user avatar widget.
  final StreamUserAvatarThemeData? inviteUserAvatarTheme;

  @override
  State<StreamCallParticipantsInfoMenu> createState() =>
      _StreamCallParticipantsInfoMenuState();
}

class _StreamCallParticipantsInfoMenuState
    extends State<StreamCallParticipantsInfoMenu> {
  late StreamInviteUserListController _controller;
  StreamSubscription<CallState>? _callStateSubscription;

  @override
  void initState() {
    super.initState();
    _controller = StreamInviteUserListController(
      call: widget.call,
      usersProvider: widget.usersProvider,
    );

    _callStateSubscription = widget.call.state.listen(_setState);
    _setState(widget.call.state.value);
  }

  @override
  void dispose() {
    _callStateSubscription?.cancel();
    _callStateSubscription = null;
    super.dispose();
  }

  Future<void> _setState(CallState state) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final callState = widget.call.state.value;
    final localParticipant = callState.localParticipant;
    final participants = callState.callParticipants;

    final streamChatTheme = StreamVideoTheme.of(context);
    final theme = StreamCallParticipantsInfoMenuTheme.of(context);
    final participantDividerColor =
        widget.participantDividerColor ?? theme.participantDividerColor;
    final participantDividerIndent =
        widget.participantDividerIndent ?? theme.participantDividerIndent;
    final participantDividerHeight =
        widget.participantDividerHeight ?? theme.participantDividerHeight;
    final participantNameTextStyle =
        widget.participantNameTextStyle ?? theme.participantNameTextStyle;
    final participantIconActiveColor =
        widget.participantIconActiveColor ?? theme.participantIconActiveColor;
    final participantIconInactiveColor = widget.participantIconInactiveColor ??
        theme.participantIconInactiveColor;
    final participantUserAvatarTheme =
        widget.participantUserAvatarTheme ?? theme.participantUserAvatarTheme;
    final inviteDividerColor =
        widget.inviteDividerColor ?? theme.inviteDividerColor;
    final inviteDividerIndent =
        widget.inviteDividerIndent ?? theme.inviteDividerIndent;
    final inviteDividerHeight =
        widget.inviteDividerHeight ?? theme.inviteDividerHeight;
    final inviteUsernameTextStyle =
        widget.inviteUsernameTextStyle ?? theme.inviteUsernameTextStyle;
    final inviteSelectedIconColor =
        widget.inviteSelectedIconColor ?? theme.inviteSelectedIconColor;
    final inviteUserAvatarTheme =
        widget.inviteUserAvatarTheme ?? theme.inviteUserAvatarTheme;

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
                return CallParticipantsInfoItem(
                  participant: participant,
                  videoIcon: widget.videoIcon,
                  audioIcon: widget.audioIcon,
                  participantNameTextStyle: participantNameTextStyle,
                  participantIconActiveColor: participantIconActiveColor,
                  participantIconInactiveColor: participantIconInactiveColor,
                  participantUserAvatarTheme: participantUserAvatarTheme,
                );
              },
              separatorBuilder: (context, index) =>
                  widget.participantInfoDividerBuilder?.call(context, index) ??
                  Divider(
                    indent: participantDividerIndent,
                    height: participantDividerHeight,
                    color: participantDividerColor,
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
                  MaterialPageRoute<void>(
                    builder: (context) => StreamInviteUserListView(
                      controller: _controller,
                      inviteDividerColor: inviteDividerColor,
                      inviteDividerIndent: inviteDividerIndent,
                      inviteDividerHeight: inviteDividerHeight,
                      inviteUsernameTextStyle: inviteUsernameTextStyle,
                      inviteSelectedIconColor: inviteSelectedIconColor,
                      inviteUserAvatarTheme: inviteUserAvatarTheme,
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
