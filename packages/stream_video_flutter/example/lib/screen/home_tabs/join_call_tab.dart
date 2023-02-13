import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import '../../utils.dart';
import 'call_text_field.dart';

class JoinCallTab extends StatefulWidget {
  const JoinCallTab({
    super.key,
    required this.onNavigateToCall,
  });

  final void Function(CallV2 call) onNavigateToCall;

  @override
  State<JoinCallTab> createState() => _JoinCallTabState();
}

class _JoinCallTabState extends State<JoinCallTab> {
  final _callIdController = TextEditingController();

  bool _callInProgress = false;

  @override
  void dispose() {
    _callIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          CallIdTextField(
            controller: _callIdController,
          ),
          const SizedBox(height: 24),
          if (_callInProgress)
            const CircularProgressIndicator(
              strokeWidth: 2,
            )
          else
            ElevatedButton(
              onPressed: _joinCall,
              child: const Text('Join call'),
            ),
        ],
      ),
    );
  }

  Future<void> _joinCall() async {
    final callId = _callIdController.text;
    if (callId.isEmpty) {
      context.showSnackBar('Call ID is empty');
      return;
    }

    final callCid = StreamCallCid.from(type: 'default', id: callId);
    final call = CallV2.fromCid(callCid: callCid);
    widget.onNavigateToCall(call);
  }
}
