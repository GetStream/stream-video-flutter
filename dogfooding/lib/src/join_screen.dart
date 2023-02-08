import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'routes/routes.dart';
import 'user_repository.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({
    super.key,
    required this.callId,
  });

  final String callId;

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  var _isInProgress = false;

  @override
  void initState() {
    super.initState();
    _logIn();
    _joinCall(widget.callId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Joining call'),
      ),
      body: Center(
        child: _isInProgress
            ? const CircularProgressIndicator(
                strokeWidth: 2,
              )
            : const SizedBox(),
      ),
    );
  }

  Future<void> _logIn() async {
    final userCredentials = await UserRepository.instance.getUserCredentials();

    if (userCredentials != null) {
      final user = userCredentials.user;
      final token = userCredentials.token;

      await StreamVideo.instance.connectUser(
        user,
        token: Token(token),
      );
    }
  }

  Future<void> _joinCall(String callId) async {
    setState(() => _isInProgress = true);

    try {
      final call = await StreamVideo.instance.joinCall(
        id: callId,
        type: 'default',
      );

      await call.connect();

      await _navigateToCall(call);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => _isInProgress = false);
    }
  }

  Future<void> _navigateToCall(Call call) async {
    await Navigator.of(context).pushReplacementNamed(
      Routes.CALL,
      arguments: call,
    );
  }
}
