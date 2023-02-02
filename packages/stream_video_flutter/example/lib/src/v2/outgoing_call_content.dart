import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:collection/collection.dart';

class OutgoingCallContent extends StatelessWidget {
  const OutgoingCallContent({
    super.key,
    required this.call,
    required this.onBackPressed,
  });

  final CallV2 call;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    final state = call.state.value;

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
                onPressed: _cancelCall,
                child: const Text('Cancel'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _cancelCall() async {
    await call.apply(const CancelCall());
    await call.disconnect();
    onBackPressed();
  }
}
