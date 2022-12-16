import 'package:example/src/widgets/controls.dart';
import 'package:example/src/widgets/participant_widget.dart';
import 'package:example/src/widgets/participant_info.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:stream_video/stream_video.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key, required this.call}) : super(key: key);

  final Call call;

  static const routeName = '/call';

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  List<ParticipantTrack> participantTracks = [];

  List<Participant> allParticipants = [];

  // void _onCallEnded(SfuEvent event) {
  //   final payload = event.callEnded;
  //   debugPrint('Call Ended: ${payload.message}');
  //   Navigator.of(context).pop();
  // }

  void _onParticipantUpdate() {
    allParticipants = [
      ...widget.call.participants.values,
      if (widget.call.localParticipant != null) widget.call.localParticipant!,
    ];

    setState(() {});

    List<ParticipantTrack> userMediaTracks = [];
    List<ParticipantTrack> screenTracks = [];
    for (var participant in widget.call.participants.values) {
      for (var t in participant.videoTracks) {
        screenTracks.add(ParticipantTrack(
          participant: participant,
          videoTrack: t.track,
          isScreenShare: t.isScreenShare,
        ));
      }
    }
    // sort speakers for the grid
    userMediaTracks.sort((a, b) {
      // loudest speaker first
      if (a.participant.isSpeaking && b.participant.isSpeaking) {
        if (a.participant.audioLevel > b.participant.audioLevel) {
          return -1;
        } else {
          return 1;
        }
      }

      // last spoken at
      final aSpokeAt = a.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
      final bSpokeAt = b.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;

      if (aSpokeAt != bSpokeAt) {
        return aSpokeAt > bSpokeAt ? -1 : 1;
      }

      // video on
      if (a.participant.hasVideo != b.participant.hasVideo) {
        return a.participant.hasVideo ? -1 : 1;
      }

      // joinedAt
      return a.participant.joinedAt.millisecondsSinceEpoch -
          b.participant.joinedAt.millisecondsSinceEpoch;
    });

    final localParticipantTracks = widget.call.localParticipant?.videoTracks;
    if (localParticipantTracks != null) {
      for (var t in localParticipantTracks) {
        screenTracks.add(ParticipantTrack(
          participant: widget.call.localParticipant!,
          videoTrack: t.track,
          isScreenShare: t.isScreenShare,
        ));
      }
    }
    setState(() {
      participantTracks = [...screenTracks, ...userMediaTracks];
    });
  }

  @override
  void initState() {
    super.initState();
    _onParticipantUpdate();
    widget.call.events
      ..listen((_) {
        _onParticipantUpdate();
      });
    // widget.call.addListener(SfuEvent_EventPayload.callEnded.name, _onCallEnded);
  }

  @override
  void dispose() async {
    // widget.call.removeListener(
    //   SfuEvent_EventPayload.callEnded.name,
    //   _onCallEnded,
    // );
    await widget.call.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final grid = GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: allParticipants.length,
      itemBuilder: (context, index) {
        final participant = allParticipants[index];
        if (participant is RemoteParticipant) {
          print('All tracks: ${participant.videoTracks.length}');
          print(
              'Track: ${participant.videoTracks.map((e) => e.track?.mediaStreamTrack)}');
        }
        final participantTrack = ParticipantTrack(
          participant: participant,
          videoTrack: participant.videoTracks.firstOrNull?.track as VideoTrack?,
          isScreenShare: false,
        );
        return ParticipantWidget.widgetFor(participantTrack);
      },
    );

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: grid),
          SizedBox(
            width: double.infinity,
            child: Material(
              elevation: 4,
              // color: ,
              child: ControlsWidget(
                widget.call,
                widget.call.localParticipant!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
