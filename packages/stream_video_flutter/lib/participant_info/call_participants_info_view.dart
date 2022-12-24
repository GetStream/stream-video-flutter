import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/icon/icon_toggle.dart';
import 'package:stream_video_flutter/participant_info/call_participants_info_options.dart';
import 'package:stream_video_flutter/participant_info/model/mute_toggle_titles.dart';
import 'package:stream_video_flutter/participant_info/model/call_participant_state.dart';
import 'package:stream_video_flutter/participant_info/theme/call_participants_info_theme.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'call_participant_info_view.dart';

/// {@template participantsInfoViewBuilder}
/// Builder function used to build a participant info view.
/// {@endtemplate}
typedef ParticipantInfoViewBuilder = Widget Function(
    BuildContext context, int index, CallParticipantState participant);

/// {@template participantInfoDividerBuilder}
/// Builder function used to build a participant info divider.
/// {@endtemplate}
typedef ParticipantInfoDividerBuilder = Widget Function(
    BuildContext context, int index);

/// {@template streamCallParticipantsInfoView}
/// Displays call participants info.
/// {@endtemplate}
class StreamCallParticipantsInfoView extends StatefulWidget {
  /// {@macro streamCallParticipantsInfoView}
  const StreamCallParticipantsInfoView({
    super.key,
    required this.call,
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

  final StreamIconToggle videoIcon;
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

  @override
  void initState() {
    super.initState();
    _setParticipants();
    _cancelListener = widget.call.events.listen((event) {
      if (event is ParticipantJoinedEvent ||
          event is ParticipantLeftEvent ||
          event is ParticipantInfoUpdatedEvent) {
        setState(() {
          _setParticipants();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cancelListener?.call();
  }

  void _setParticipants() {
    participants.clear();
    final localParticipant = widget.call.localParticipant;
    final localState = localParticipant != null
        ? _mapToState(localParticipant.info, true)
        : null;
    if (localState != null) {
      participants.add(localState);
    }
    participants.addAll(widget.call.participants.values.map((participant) {
      return _mapToState(participant.info, false);
    }));
  }

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamVideoTheme.of(context);
    final participantsInfoTheme =
        widget.participantsInfoTheme ?? streamChatTheme.participantsInfoTheme;
    return ListView.separated(
        padding: const EdgeInsets.only(bottom: 16),
        itemBuilder: (context, index) {
          final participant = participants[index];
          return widget.participantInfoViewBuilder
                  ?.call(context, index, participant) ??
              StreamCallParticipantInfoView(
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
        itemCount: participants.length);
  }

  CallParticipantState _mapToState(ParticipantInfo info, bool self) {
    //TODO grab role from coordinator User
    return CallParticipantState(
        self: self,
        user: UserInfo(id: info.userId, role: "member", name: info.userId),
        audioAvailable: info.hasPublishedAudioTrack(),
        videoAvailable: info.hasPublishedVideoTrack());
  }
}
