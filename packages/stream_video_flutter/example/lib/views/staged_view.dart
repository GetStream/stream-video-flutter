import 'package:example/controls.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:collection/collection.dart';

// class CallArgs {
//   final String callId;
//   CallArgs({required this.callId});
// }

class StageView extends StatefulWidget {
  final ParticipantController controller;
  static String routeName = "/stageView";

  const StageView({Key? key, required this.controller}) : super(key: key);

  @override
  State<StageView> createState() => _StageViewState();
}

class _StageViewState extends State<StageView> {
  // List<RoomParticipant> get roomParticipants =>
  //     widget.controller.room.allParticipants.values.toList();

  @override
  Widget build(BuildContext context) {
    //TODO: busy widget

    return MaterialApp(
        home: Scaffold(
      bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          child: BottomControls(onRefresh: () {
            //make this cleaner
            setState(() {});
          })),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            allParticipants[0].videoTracks.isNotEmpty
                ? SizedBox(
                    height: 100,
                    width: 100,
                    child: StreamVideoTrackRenderer(//widget.controller.room
                        // .allParticipants[index]!.activeVideoTrack!
                        allParticipants[0].videoTracks[0].track!),
                  )
                : Container(
                    color: Colors.grey,
                  ),
            Text(allParticipants[0].name),
            Text("${allParticipants[0].videoTracks.length}")
          ])
          // GridView.builder(
          //     gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          //         maxCrossAxisExtent: 200,
          //         childAspectRatio: 3 / 2,
          //         crossAxisSpacing: 20,
          //         mainAxisSpacing: 20),
          //     itemCount: allParticipants.length, //
          //     itemBuilder: (BuildContext ctx, int index) {
          //       return Stack(children: [
          //         allParticipants[index].activeVideoTrack != null
          //             ? StreamVideoTrackRenderer(//widget.controller.room
          //                 // .allParticipants[index]!.activeVideoTrack!
          //                 allParticipants[index].activeVideoTrack!)
          //             : Container(
          //                 color: Colors.grey,
          //               ),
          //         Text(allParticipants[index].name),
          //       ]);
          //       // );
          //     })

          ),
      // ),
    ));
  }

  List<RoomParticipant> get allParticipants =>
      widget.controller.room.allParticipants;
}

//Temporary or will be a wrapper widget around StreamVideoTrackRenderer
class VideoView extends StatelessWidget {
  const VideoView({
    Key? key,
    required this.myProducts,
    required this.index,
  }) : super(key: key);

  final List<Map> myProducts;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.amber, borderRadius: BorderRadius.circular(15)),
      child: Text(myProducts[index]["name"]),
    );
  }
}
