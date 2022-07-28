import 'package:example/buttons.dart';
import 'package:flutter/material.dart';

class RingerDialog extends StatelessWidget {
  final String caller;
  const RingerDialog({Key? key, required this.caller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("Incoming call from $caller"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CallAcceptButton(
                onTap: () {
                  print("accepting call");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CallRejectButton(
                onTap: () {
                  print("rejecting call");
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
