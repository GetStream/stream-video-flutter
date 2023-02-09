import 'package:flutter/material.dart';

import '../call_controls.dart';

class CallHangupV2 extends StatelessWidget {
  const CallHangupV2({
    super.key,
    required this.onHangup,
  });

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
