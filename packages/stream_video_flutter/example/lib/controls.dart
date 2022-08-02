import 'package:example/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);
  final VoidCallback onRefresh;

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
                    onTap: () {
                      final controller = StreamVideoProvider.of(context)
                          .client
                          .participants
                          .room
                          .localParticipant!
                          .setMicrophoneEnabled(true);
                    },
                    icon: Icon(
                      Icons.mic_off,
                      color: Colors.white,
                    ),
                    text: Text("Join audio")),
              ),
              BottomControl(
                  onTap: () {
                    print("DISABLE VIDEO");
                    final localParticipant = StreamVideoProvider.of(context)
                        .client
                        .participants
                        .room
                        .localParticipant!;
                    print("HAS VIDEO ${localParticipant.hasVideo}");
                    localParticipant.setCameraEnabled(true);
                    onRefresh();
                    print("HAS VIDEO ${localParticipant.hasVideo}");
                  },
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
                icon: Stack(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                        alignment: FractionalOffset.topRight,
                        child: Text(
                          "2",
                          style: TextStyle(color: Colors.grey),
                        )),
                    Align(
                        alignment: FractionalOffset.bottomLeft,
                        child: Icon(
                          Icons.people,
                          color: Colors.white,
                        )),
                  ],
                ),
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return ParticipantsBottomSheet();
                    },
                  );
                  print("show call participants");
                },
                text: Text("Participants"),
              ),
            ]));
  }
}

class BottomControl extends StatelessWidget {
  final Widget icon;
  final Widget text;
  final VoidCallback? onTap;
  const BottomControl(
      {Key? key, required this.icon, required this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(icon: icon, onPressed: onTap),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: text,
        ),
      ],
    );
  }
}
