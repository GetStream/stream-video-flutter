import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class CallIdTextField extends StatelessWidget {
  const CallIdTextField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(),
        labelText: 'Enter call id',
        // suffix button to generate a random call id
        suffixIcon: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            // generate a 10 character nanoId for call id
            final callId = generateAlphanumericString(10);
            controller.value = TextEditingValue(
              text: callId,
              selection: TextSelection.collapsed(offset: callId.length),
            );
          },
        ),
      ),
    );
  }
}
