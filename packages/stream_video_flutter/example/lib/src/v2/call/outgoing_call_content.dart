import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:collection/collection.dart';

class OutgoingCallContent extends StatelessWidget {
  const OutgoingCallContent({
    super.key,
    required this.state,
    required this.onCancelPressed,
  });

  final CallStateV2 state;
  final VoidCallback onCancelPressed;

  @override
  Widget build(BuildContext context) {
    final callee = state.callParticipants
        .where((it) => it.userId != state.createdByUserId)
        .map((it) => it.name)
        .join(', ');
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Dialing $callee',
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 52),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: onCancelPressed,
                child: const Text('Cancel'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
