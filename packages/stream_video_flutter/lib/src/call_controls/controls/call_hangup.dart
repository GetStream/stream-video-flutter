import 'package:flutter/material.dart';

import '../call_controls.dart';

class CallHangup extends StatelessWidget {
  const CallHangup({
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
