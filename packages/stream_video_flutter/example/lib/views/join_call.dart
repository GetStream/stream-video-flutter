
import 'package:example/buttons.dart';
import 'package:flutter/material.dart';

class JoinCallView extends StatelessWidget {
  static const Icon tabIcon = Icon(Icons.switch_video);

  const JoinCallView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SwitchVideoButton(),
    );
  }
}