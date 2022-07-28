import 'package:flutter/material.dart';

class ParticipantsView extends StatelessWidget {
  static String routeName = "/participants";
  const ParticipantsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.close,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Text("Participants"),
        ),
      ),
    );
  }
}
