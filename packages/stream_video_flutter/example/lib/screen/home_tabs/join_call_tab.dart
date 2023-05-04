import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../utils.dart';
import 'call_text_field.dart';

class JoinCallTab extends StatefulWidget {
  const JoinCallTab({
    super.key,
    required this.onNavigateToCall,
  });

  final void Function(Call call, {CallConnectOptions options}) onNavigateToCall;

  @override
  State<JoinCallTab> createState() => _JoinCallTabState();
}

class _JoinCallTabState extends State<JoinCallTab> {
  final _callIdController = TextEditingController();

  bool _callInProgress = false;
  bool _useLobby = false;

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
          Row(
            children: [
              const Text('Start With Lobby'),
              Switch(
                value: _useLobby,
                onChanged: (value) {
                  setState(() {
                    _useLobby = value;
                  });
                },
              )
            ],
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

    final call = StreamVideo.instance.makeCall(type: 'default', id: callId);

    if (!_useLobby) {
      widget.onNavigateToCall(call);
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamLobbyView(
          call: call,
          onJoinCallPressed: (options) {
            Navigator.of(context).pop();
            widget.onNavigateToCall(call, options: options);
          },
        ),
      ),
    );
  }
}
