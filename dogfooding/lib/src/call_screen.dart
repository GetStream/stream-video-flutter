import 'package:dogfooding/src/widgets/controls.dart';
import 'package:dogfooding/src/widgets/participant_info.dart';
import 'package:dogfooding/src/widgets/participant_widget.dart';
import 'package:flutter/material.dart';
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

  void _onCallEnded(SfuEvent event) {
    final payload = event.callEnded;
    debugPrint('Call Ended: ${payload.message}');
    Navigator.of(context).pop();
  }

  void _onParticipantUpdate(List<CallParticipant> participants) {
    List<ParticipantTrack> screenTracks = [];
    List<ParticipantTrack> userMediaTracks = [];
    for (var participant in participants.where((it) => !it.isLocal)) {
      final videoTracks = participant.videoTracks;
      if (videoTracks != null && videoTracks.isNotEmpty) {
        for (var track in videoTracks) {
          if (track.isScreenShare) {
            screenTracks.add(ParticipantTrack(
              participant: participant,
              videoTrack: track,
              isScreenShare: true,
            ));
          } else {
            userMediaTracks.add(ParticipantTrack(
              participant: participant,
              videoTrack: track,
              isScreenShare: false,
            ));
          }
        }
      }
    }

    final localParticipant = widget.call.localParticipant;
    final localParticipantTracks = localParticipant?.videoTracks;
    if (localParticipantTracks != null) {
      for (var track in localParticipantTracks) {
        if (track.isScreenShare) {
          screenTracks.add(ParticipantTrack(
            participant: localParticipant!,
            videoTrack: track,
            isScreenShare: true,
          ));
        } else {
          userMediaTracks.add(ParticipantTrack(
            participant: localParticipant!,
            videoTrack: track,
            isScreenShare: false,
          ));
        }
      }
    }

    setState(() {
      participantTracks = [...screenTracks, ...userMediaTracks];
    });
  }

  @override
  void initState() {
    super.initState();
    _onParticipantUpdate(widget.call.participants);
    widget.call.participantsStream.listen(_onParticipantUpdate);
    widget.call.addListener(SfuEvent_EventPayload.callEnded.name, _onCallEnded);
  }

  @override
  void dispose() async {
    widget.call.removeListener(
      SfuEvent_EventPayload.callEnded.name,
      _onCallEnded,
    );
    await widget.call.leave();
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
      itemCount: participantTracks.length,
      itemBuilder: (context, index) {
        final participantTrack = participantTracks[index];
        return ParticipantWidget(
          track: participantTrack,
        );
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

    return Scaffold(
      body: Column(
        children: [
          participantTracks.isEmpty
              ? Container()
              : Expanded(
                  // Creates a grid of all the participants in the call.
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: participantTracks.length,
                    itemBuilder: (context, index) {
                      final participantTrack = participantTracks[index];
                      return ParticipantWidget(
                        // participant: participantTrack.participant,
                        // videoTrack: participantTrack.videoTrack,
                        // isScreenShare: participantTrack.isScreenShare,
                        track: participantTrack,
                      );
                    },
                  ),
                ),
          Expanded(
            child: Column(
              children: [
                // Expanded(
                //   child: Center(
                //     child: ParticipantInfo(
                //       participant: widget.call.localParticipant!,
                //     ),
                //   ),
                // ),
                ControlsWidget(
                  widget.call,
                  widget.call.localParticipant!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//                   child: ListView.builder(
//                     // gridDelegate:
//                     //     const SliverGridDelegateWithMaxCrossAxisExtent(
//                     //   maxCrossAxisExtent: 200,
//                     //   // childAspectRatio: 3 / 2,
//                     //   crossAxisSpacing: 20,
//                     //   mainAxisSpacing: 20,
//                     // ),
//                     itemCount: participantTracks.length, //
//                     itemBuilder: (BuildContext ctx, int index) {
//                       final track = participantTracks[index];
//
//                       return Container(
//                         child: ParticipantWidget(track: track),
//                       );
//                     },
//                   ),
//                 ),
//           if (widget.call.localParticipant != null)
//             SafeArea(
//               top: false,
//               child: ControlsWidget(
//                 widget.call,
//                 widget.call.localParticipant!,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
