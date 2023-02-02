import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:collection/collection.dart';

class IncomingCallContent extends StatelessWidget {
  const IncomingCallContent({
    super.key,
    required this.call,
    required this.onBackPressed,
  });

  final CallV2 call;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    final state = call.state.value;
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
                onPressed: _rejectCall,
                child: const Text('Reject'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _acceptCall,
                child: const Text('Accept'),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _rejectCall() async {
    await call.apply(const RejectCall());
    await call.disconnect();
    onBackPressed();
  }

  Future<void> _acceptCall() async {
    await call.apply(const AcceptCall());
    await call.connect();
  }
}
