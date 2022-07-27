import 'package:example/buttons.dart';
import 'package:flutter/material.dart';

class JoinCallView extends StatelessWidget {
  static const Icon tabIcon = Icon(Icons.switch_video);

  const JoinCallView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("The Call ID"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter the Call ID',
            ),
          ),
        ),
        Spacer(),
        JoinCallButton(onTap: () {
          print("join call ${controller.text}");
        }),
      ],
    );
  }
}
