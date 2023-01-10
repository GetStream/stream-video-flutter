import 'package:dogfooding/src/home_screen.dart';
import 'package:dogfooding/src/participant_track.dart';
import 'package:dogfooding/src/participants_info_screen.dart';
import 'package:dogfooding/src/widgets/controls.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

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
    super.dispose();
    // widget.call.removeListener(
    //   SfuEvent_EventPayload.callEnded.name,
    //   _onCallEnded,
    // );
    await widget.call.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: StreamCallParticipants(
                  participants: allParticipants,
                  enablePip: true,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Material(
                  elevation: 4,
                  // color: ,
                  child: ControlsWidget(
                    widget.call,
                    widget.call.localParticipant!,
                    onHangUp: () {
                      Navigator.of(context)
                          .pushReplacementNamed(HomeScreen.routeName);
                    },
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.group_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StreamCallParticipantsInfoScreen(
                        call: widget.call,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
