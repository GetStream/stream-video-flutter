import 'package:example/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);
  final VoidCallback onRefresh;
  VideoRoom room(BuildContext context) =>
      StreamVideoProvider.of(context).client.participants.currentRoom;
  StreamLocalParticipant localParticipant(BuildContext context) =>
      StreamVideoProvider.of(context)
          .client
          .participants
          .currentRoom
          .localParticipant!;

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
                    onTap: () async {
                      print("DISABLE AUDIO");

                      isMicrophoneEnabled(context)
                          ? room(context).disableAudio()
                          : room(context).enableAudio();
                      await Future.delayed(const Duration(milliseconds: 300));

                      onRefresh();
                    },
                    icon: Icon(
                      isMicrophoneEnabled(context) ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                    ),
                    text: Text(
                        "${isMicrophoneEnabled(context) ? 'Disable' : 'Enable'} Audio")),
              ),
              BottomControl(
                  onTap: () async {
                    print("DISABLE VIDEO");

                    isCameraEnabled(context)
                        ? room(context).disableVideo()
                        : room(context).enableVideo();
                    await Future.delayed(const Duration(milliseconds: 300));
                    onRefresh();
                  },
                  icon: Icon(
                    isCameraEnabled(context)
                        ? Icons.videocam_off
                        : Icons.videocam,
                    color: Colors.white,
                  ),
                  text: Text(
                      "${isCameraEnabled(context) ? 'Disable' : 'Enable'} Video")),
              BottomControl(
                  icon: Icon(
                    Icons.call_end_outlined,
                    color: Colors.red,
                  ),
                  text: Text("Hang up")),
              BottomControl(
                icon: Stack(
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

  isMicrophoneEnabled(BuildContext context) =>
      localParticipant(context).isMicrophoneEnabled();

  isCameraEnabled(BuildContext context) =>
      localParticipant(context).isCameraEnabled();
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
