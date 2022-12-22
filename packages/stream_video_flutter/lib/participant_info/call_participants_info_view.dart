import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/participant_info/model/mute_toggle_titles.dart';
import 'package:stream_video_flutter/participant_info/model/call_participant_state.dart';
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

/// {@template onInviteButtonPress}
/// The action to perform when the Invite button is pressed.
/// {@endtemplate}
typedef OnInviteButtonPress = void Function();

class StreamCallParticipantsInfoView extends StatefulWidget {
  const StreamCallParticipantsInfoView({
    super.key,
    required this.call,
    required this.inviteButtonTitle,
    required this.muteToggleTitles,
    this.onInviteButtonPress,
    this.participantInfoViewBuilder,
    this.participantInfoDividerBuilder,
  });

  final Call call;

  final String inviteButtonTitle;

  final MuteToggleTitles muteToggleTitles;

  /// {@macro onInviteButtonPress}
  final OnInviteButtonPress? onInviteButtonPress;

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
    return Column(
      children: [
        Expanded(
            child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                itemBuilder: (context, index) {
                  final participant = participants[index];
                  return widget.participantInfoViewBuilder
                          ?.call(context, index, participant) ??
                      StreamCallParticipantInfoView(
                        participant: participant,
                      );
                },
                separatorBuilder: (context, index) =>
                    widget.participantInfoDividerBuilder
                        ?.call(context, index) ??
                    const Divider(
                      indent: 16,
                      height: 0,
                      color: Colors.grey,
                    ),
                itemCount: participants.length)),
        Material(
          elevation: 8,
          child: SafeArea(
            child: ButtonBar(
              buttonPadding: const EdgeInsets.all(16),
              alignment: MainAxisAlignment.center,
              children: [
                _InviteButton(
                    title: widget.inviteButtonTitle,
                    onInviteButtonPress: widget.onInviteButtonPress),
                _MuteToggle(titles: widget.muteToggleTitles, call: widget.call)
              ],
            ),
          ),
        )
      ],
    );
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

class _InviteButton extends StatelessWidget {
  const _InviteButton(
      {super.key, required this.title, this.onInviteButtonPress});

  final String title;
  final OnInviteButtonPress? onInviteButtonPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onInviteButtonPress?.call();
      },
      style: ElevatedButton.styleFrom(
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        minimumSize: const Size(144, 48),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class _MuteToggle extends StatelessWidget {
  const _MuteToggle({super.key, required this.titles, required this.call});

  final MuteToggleTitles titles;
  final Call call;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
          minimumSize: const Size(144, 48),
        ),
        onPressed: () async {
          await call.localParticipant?.toggleMicrophone();
        },
        child: Text(
          call.localParticipant?.info.hasPublishedAudioTrack() == true
              ? titles.muteTitle
              : titles.unmuteTitle,
          style: const TextStyle(fontSize: 16),
        ));
  }
}
