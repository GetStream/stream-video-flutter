import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class StreamCircleAvatar extends StatelessWidget {
  final String initial;
  const StreamCircleAvatar({Key? key, required this.initial}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text(
        initial,
        style: TextStyle(fontSize: 10),
      ),
    ));
  }
}
