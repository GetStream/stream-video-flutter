

import 'package:example/buttons.dart';
import 'package:example/checkbox.dart';
import 'package:example/checkbox_controller.dart';
import 'package:example/dropdown_user.dart';
import 'package:flutter/material.dart';

class StartCallView extends StatelessWidget {
  static const Icon tabIcon = Icon(Icons.video_call);
  const StartCallView({
    Key? key,
    required this.currentUserController,
    required this.controller,
  }) : super(key: key);

  final CurrentUserController currentUserController;
  final CheckboxController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Who are you?"),
        ),
        UserDropDropdown(currentUserController),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Select Participants"),
        ),
        Expanded(child: UserCheckBoxInListView(controller)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StartCallButton(onTap: () {
            print("currentUser ${currentUserController.value}");
            print("participants ${controller.getIsChecked()}");
            print("startCall");
          }),
        )
      ],
    );
  }
}