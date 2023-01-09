import 'package:flutter/material.dart';
import 'package:stream_video_flutter/call_controls/call_controls.dart';

class CallHangup extends StatelessWidget {
  const CallHangup({
    Key? key,
    required this.onHangup,
  }) : super(key: key);

  final VoidCallback onHangup;

  @override
  Widget build(BuildContext context) {
    return CallControlOption(
      icon: const Icon(Icons.call_rounded),
      iconColor: Colors.white,
      backgroundColor: Colors.red,
      onPressed: onHangup,
    );
  }
}
