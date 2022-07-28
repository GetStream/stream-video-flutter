import 'package:example/buttons.dart';
import 'package:example/views/staged_view.dart';
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
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(StageView.routeName);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CallRejectButton(
                onTap: () {
                  Navigator.of(context).pop();
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
