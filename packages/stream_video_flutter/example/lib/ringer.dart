import 'package:example/buttons.dart';
import 'package:flutter/material.dart';

class RingerDialog extends StatelessWidget {
  final String caller;
  const RingerDialog({
    Key? key,
    required this.caller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("Iconming call from $caller"),
      actions: [
        CallAcceptButton(
          onTap: () {
            print("accepting call");
          },
        ),
        CallRejectButton(
          onTap: () {
            print("rejecting call");
          },
        )
      ],
    );
  }
}
