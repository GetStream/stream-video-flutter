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

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as CallArgs;
    // controller.room.participants.
    // args.call.payload.call.

    final List<Map> myProducts = List.generate(
        100000, (index) => {"id": index, "name": "Product $index"}).toList();
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar:
            BottomAppBar(color: Colors.blue, child: BottomControls()),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
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
              itemCount: myProducts.length,
              itemBuilder: (BuildContext ctx, index) {
                return VideoView(myProducts: myProducts, index: index);
              }),
        ),
      ),
    );
  }
}

class BottomControls extends StatelessWidget {
  const BottomControls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: BottomControl(
                    icon: Icon(
                      Icons.mic_off,
                      color: Colors.white,
                    ),
                    text: Text("Join audio")),
              ),

              BottomControl(
                  icon: Icon(
                    Icons.videocam,
                    color: Colors.white,
                  ),
                  text: Text("Disable Video")),

              BottomControl(
                  icon: Icon(
                    Icons.call_end_outlined,
                    color: Colors.red,
                  ),
                  text: Text("Hang up")),
              BottomControl(
                icon: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.people,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return ParticipantsBottomSheet();
                          },
                        );
                        print("show call participants");
                      },
                    ),
                    Text(
                      "2",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                text: Text("Participants"),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Icon(
              //     Icons.people,
              //     color: Colors.white,
              //   ),
              // ),
            ]));
  }
}

class ParticipantsBottomSheet extends StatelessWidget {
  const ParticipantsBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.amber,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
                child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Online participants"),
                      ),
                      OnlineParticipant(
                        //TODO: remove hardcoded values
                        participantName: "Alice",
                      ),
                      OnlineParticipant(
                        participantName: "Bob",
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Offline participants"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Trudy"),
                      )
                    ],
                  ),
                )
                //Your content
              ],
            ))
            // ElevatedButton(
            //   child: const Text('Close BottomSheet'),
            //   onPressed: () => Navigator.pop(context),
            // )
          ],
        ),
      ),
    );
  }
}

class OnlineParticipant extends StatelessWidget {
  final String participantName;
  const OnlineParticipant({Key? key, required this.participantName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$participantName"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.mic_off),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.videocam),
        )
      ],
    );
  }
}

class BottomControl extends StatelessWidget {
  final Widget icon;
  final Widget text;
  const BottomControl({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        icon,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: text,
        ),
      ],
    );
  }
}

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
