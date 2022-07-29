
import 'package:example/bottom_sheet.dart';
import 'package:flutter/material.dart';


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
            ]));
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
