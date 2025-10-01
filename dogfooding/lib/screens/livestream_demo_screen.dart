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

  @override
  void initState() {
    super.initState();
    _joinCall();
  }

  Future<void> _joinCall() async {
    final userId = randomId(size: 6);

    final tokenResponse = await _tokenService.loadToken(
      userId: userId,
      environment: Environment.livestream,
    );

    final streamVideo = StreamVideo.create(
      tokenResponse.apiKey,
      user: User.regular(userId: userId),
      tokenLoader: (userId) async {
        final token = await _tokenService.loadToken(
          userId: userId,
          environment: Environment.livestream,
        );
        return token.token;
      },
    );

    final call = streamVideo.makeCall(
      callType: StreamCallType.liveStream(),
      id: widget.callId,
    );
    final result = await call.getOrCreate();

    if (!mounted) {
      return;
    }

    _streamVideo = streamVideo;

    result.fold(
      success: (data) {
        _call = call;
        if (mounted) {
          setState(() {});
        }
      },
      failure: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      },
    );
  }

  @override
  void dispose() {
    _call?.leave().then((value) {
      _streamVideo?.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final textTheme = streamVideoTheme.textTheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titleSpacing: 4,
        centerTitle: false,
        title: Text('Livestream Demo', style: textTheme.body),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
        ],
      ),
      body: switch (_call) {
        null => const Center(child: CircularProgressIndicator()),
        final Call call => LivestreamPlayer(call: call),
      },
    );
  }
}
