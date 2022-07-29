
import 'package:example/participant.dart';
import 'package:flutter/material.dart';

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
