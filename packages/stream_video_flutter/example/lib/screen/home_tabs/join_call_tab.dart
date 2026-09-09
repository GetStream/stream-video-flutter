import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../utils.dart';
import 'call_text_field.dart';

class JoinCallTab extends StatefulWidget {
  const JoinCallTab({super.key, required this.onNavigateToCall});

  final void Function(Call call, {CallConnectOptions options}) onNavigateToCall;

  @override
  State<JoinCallTab> createState() => _JoinCallTabState();
}

class _JoinCallTabState extends State<JoinCallTab> {
  final _callIdController = TextEditingController();

  final bool _callInProgress = false;
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
          CallIdTextField(controller: _callIdController),
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
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_callInProgress)
            const CircularProgressIndicator(strokeWidth: 2)
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

    final call = StreamVideo.instance.makeCall(
      callType: StreamCallType.defaultType(),
      id: callId,
    );

    if (!_useLobby) {
      widget.onNavigateToCall(call);
      return;
    }

    // The lobby reads the call rather than creating it, so an id typed in here
    // has to be brought into existence before there is a waiting room for it.
    final result = await call.getOrCreate();
    if (!mounted) return;

    if (result case final Failure failure) {
      context.showSnackBar(failure.videoError.message);
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (context) => _LobbyScreen(
          call: call,
          onJoinCallPressed: (options) {
            Navigator.of(context).pop();
            widget.onNavigateToCall(call, options: options);
            return true;
          },
        ),
      ),
    );
  }
}

/// Wraps [StreamLobbyView] in the screen chrome it deliberately does not
/// build: the view is body-only, so it can be embedded in a screen that
/// already has a Scaffold.
class _LobbyScreen extends StatelessWidget {
  const _LobbyScreen({required this.call, required this.onJoinCallPressed});

  final Call call;
  final StreamLobbyJoinCallback onJoinCallPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.streamSpacing.md),
          child: StreamLobbyView(
            call: call,
            onJoinCallPressed: onJoinCallPressed,
          ),
        ),
      ),
    );
  }
}
