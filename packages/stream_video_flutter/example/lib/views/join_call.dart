import 'package:example/buttons.dart';
import 'package:example/input.dart';
import 'package:example/views/staged_view.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

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
      JoinCallButton(onTap: () async {
        print("join call ${controller.text}");
        await StreamVideoProvider.of(context)
            .client
            .joinExistingCall(id: controller.text, type: StreamCallType.video);
        Navigator.of(context).pushNamed(StageView.routeName);
      }),
    ]);
  }
}
