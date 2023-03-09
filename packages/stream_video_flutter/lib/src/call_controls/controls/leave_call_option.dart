import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A widget that represents a call control option to leave a call.
class LeaveCallOption extends StatelessWidget {
  /// Creates a new instance of [LeaveCallOption].
  const LeaveCallOption({
    super.key,
    required this.call,
    this.onLeaveCallTap,
  });

  /// Represents a call.
  final Call call;

  /// The action to perform when the leave call button is tapped.
  final VoidCallback? onLeaveCallTap;

  @override
  Widget build(BuildContext context) {
    return CallControlOption(
      icon: const Icon(Icons.call_rounded),
      iconColor: Colors.white,
      backgroundColor: Colors.red,
      onPressed: () => _onLeaveCallTap(context),
    );
  }

  Future<void> _onLeaveCallTap(BuildContext context) async {
    if (onLeaveCallTap != null) {
      onLeaveCallTap!();
    } else {
      await call.apply(const CancelCall());
      await call.disconnect();
    }
  }
}
