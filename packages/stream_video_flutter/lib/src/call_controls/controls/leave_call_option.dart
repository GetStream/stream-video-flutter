import 'package:flutter/material.dart';

import '../call_control_option.dart';

/// A widget that represents a call control option to leave a call.
class LeaveCallOption extends StatelessWidget {
  /// Creates a new instance of [LeaveCallOption].
  const LeaveCallOption({
    super.key,
    required this.onLeaveCall,
  });

  /// The action to perform when the leave call button is pressed.
  final VoidCallback onLeaveCall;

  @override
  Widget build(BuildContext context) {
    return CallControlOption(
      icon: const Icon(Icons.call_rounded),
      iconColor: Colors.white,
      backgroundColor: Colors.red,
      onPressed: onLeaveCall,
    );
  }
}
