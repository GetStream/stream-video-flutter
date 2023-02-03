import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

class IncomingCallContent extends StatelessWidget {
  const IncomingCallContent({
    super.key,
    required this.state,
    required this.onRejectPressed,
    required this.onAcceptPressed,
  });

  final CallStateV2 state;
  final VoidCallback onRejectPressed;
  final VoidCallback onAcceptPressed;

  @override
  Widget build(BuildContext context) {
    final caller = state.callParticipants
        .firstWhereOrNull((it) => it.userId == state.createdByUserId);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Incoming call from ${caller?.name ?? 'unknown'}',
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 52),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: onRejectPressed,
                child: const Text('Reject'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: onAcceptPressed,
                child: const Text('Accept'),
              )
            ],
          )
        ],
      ),
    );
  }
}
