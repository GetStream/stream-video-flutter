
import 'package:flutter/material.dart';

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
