import 'package:example/controls.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

// class CallArgs {
//   final String callId;
//   CallArgs({required this.callId});
// }

class StageView extends StatelessWidget {
  final ParticipantController controller;
  static String routeName = "/stageView";

  const StageView({Key? key, required this.controller}) : super(key: key);

  // List<RoomParticipant> get roomParticipants =>
  //     controller.room.allParticipants.values.toList();

  @override
  Widget build(BuildContext context) {
    final List<Map> myProducts = List.generate(
        100000, (index) => {"id": index, "name": "Product $index"}).toList();
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar:
            BottomAppBar(color: Colors.blue, child: BottomControls()),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: myProducts.length, //roomParticipants.length
              itemBuilder: (BuildContext ctx, index) {
                return VideoView(
                    myProducts: myProducts,
                    index: index); //StreamVideoTrackRenderer(
                // roomParticipants[index].mainVideoTrack!)
              }),
        ),
      ),
    );
  }
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
