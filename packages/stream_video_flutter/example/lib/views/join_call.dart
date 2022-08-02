import 'package:example/buttons.dart';
import 'package:example/input.dart';
import 'package:flutter/material.dart';

//  Spacer(),
//     JoinCallButton(onTap: () {
//       print("join call ${controller.text}");
//     }),


class JoinCallView extends StatelessWidget {
    static const Icon tabIcon = Icon(Icons.switch_video);
  const JoinCallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return CallInput(controller: controller, children: [
      Spacer(),
      JoinCallButton(onTap: () {
        print("join call ${controller.text}");
      }),
    ]);
  }
}
