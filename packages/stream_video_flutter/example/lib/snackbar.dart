import 'package:example/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Ringer extends StatelessWidget {
  final String caller;
  const Ringer({Key? key, required this.caller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 100.0),
      content: Column(children: [
        Text("Iconming call from $caller"),
        CallAcceptButton(),
        CallRejectButton()
      ]),
    );
  }
}
