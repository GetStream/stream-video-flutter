import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../core/model/environment.dart';
import '../core/repos/token_service.dart';
import 'login_screen.dart';

class LivestreamDemoScreen extends StatefulWidget {
  const LivestreamDemoScreen({super.key, required this.callId});

  final String callId;

  @override
  State<LivestreamDemoScreen> createState() => _LivestreamDemoScreenState();
}

class _LivestreamDemoScreenState extends State<LivestreamDemoScreen> {
  static const _tokenService = TokenService();
  StreamVideo? _streamVideo;
  Call? _call;

  /// Why the livestream could not be opened, null while it can.
  String? _error;

  @override
  void initState() {
    super.initState();
    _joinCall();
  }

  Future<void> _joinCall() async {
    final userId = randomId(size: 6);

    try {
      final tokenResponse = await _tokenService.loadToken(
        userId: userId,
        environment: Environment.livestream,
      );

      final streamVideo = StreamVideo.create(
        tokenResponse.apiKey,
        user: User(id: userId),
        tokenLoader: (userId) async {
          final token = await _tokenService.loadToken(
            userId: userId,
            environment: Environment.livestream,
          );
          return token.token;
        },
      );
      if (!mounted) {
        unawaited(streamVideo.dispose());
        return;
      }
      _streamVideo = streamVideo;

      final call = streamVideo.makeCall(
        callType: StreamCallType.liveStream(),
        id: widget.callId,
      );
      final result = await call.getOrCreate();
      if (!mounted) return;

      setState(() {
        switch (result) {
          case Success():
            _call = call;
          case Failure(:final error):
            _error = '$error';
        }
      });
    } catch (e, stk) {
      debugPrint('Could not open livestream ${widget.callId}: $e');
      debugPrintStack(stackTrace: stk);
      if (mounted) setState(() => _error = '$e');
    }
  }

  @override
  void dispose() {
    final streamVideo = _streamVideo;
    final call = _call;
    if (call == null) {
      unawaited(streamVideo?.dispose());
    } else {
      unawaited(
        call
            .leave(
              reason: const DisconnectReason.left(
                initiator: LeaveInitiator.app,
              ),
            )
            .whenComplete(() => streamVideo?.dispose()),
      );
    }
    super.dispose();
  }

  Widget _closeButton(BuildContext context) => StreamToolbarButton.icon(
    icon: Icon(context.streamIcons.xmark),
    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
    onPressed: () => Navigator.maybePop(context),
  );

  @override
  Widget build(BuildContext context) {
    if (_call case final call?) {
      return LivestreamPlayer(call: call, backButtonBuilder: _closeButton);
    }

    final error = _error;
    return Scaffold(
      appBar: AppBar(leading: _closeButton(context)),
      body: Center(
        child: error == null
            ? const CircularProgressIndicator.adaptive()
            : Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  "Couldn't open the livestream: $error",
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}
