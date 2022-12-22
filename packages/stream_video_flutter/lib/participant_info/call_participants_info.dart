import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/participant_info/call_participants_invite.dart';
import 'package:stream_video_flutter/participant_info/model/call_participant_state.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'call_participant_info.dart';

class StreamCallParticipantsInfoWidget extends StatefulWidget {
  StreamCallParticipantsInfoWidget({super.key, required this.call});

  final Call call;

  static const routeName = '/call/participants';

  @override
  State<StreamCallParticipantsInfoWidget> createState() =>
      _StreamCallParticipantsInfoWidgetState();
}

class _StreamCallParticipantsInfoWidgetState
    extends State<StreamCallParticipantsInfoWidget> {
  Function? cancelListener;
  final participants = <CallParticipantState>[];

  @override
  void initState() {
    super.initState();
    _setParticipants();
    cancelListener = widget.call.events.listen((event) {
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
    cancelListener?.call();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Participants (${participants.length})'),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemBuilder: (context, index) {
                    final participant = participants[index];
                    return StreamCallParticipantInfoWidget(
                      participant: participant,
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                        indent: 16,
                        height: 0,
                        color: Colors.grey,
                      ),
                  itemCount: participants.length)),
          // const Divider(
          //   height: 0,
          //   color: Colors.black,
          // ),
          Material(
            elevation: 8,
            child: SafeArea(
              child: ButtonBar(
                buttonPadding: const EdgeInsets.all(16),
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              StreamCallParticipantsInviteWidget(
                                  call: widget.call)));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: const Size(144, 48),
                    ),
                    child: const Text(
                      "Invite",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(144, 48),
                      ),
                      onPressed: () async {
                        await widget.call.localParticipant?.toggleMicrophone();
                      },
                      child: Text(
                        participants
                                    .firstWhere((it) => it.self)
                                    .audioAvailable ==
                                true
                            ? "Mute Me"
                            : "Unmute Me",
                        style: const TextStyle(fontSize: 16),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
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
