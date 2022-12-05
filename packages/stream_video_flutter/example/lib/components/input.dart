import 'package:flutter/material.dart';

class CallInput extends StatelessWidget {
  final List<Widget>? children;
  final TextEditingController controller;

  const CallInput({Key? key, this.children, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("The Call ID"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter the Call ID',
            ),
          ),
        ),
        ...?children
      ],
    );
  }
}
