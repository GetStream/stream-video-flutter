import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    hide StreamUserAvatar;
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:video_with_chat/app_config.dart';
import 'package:video_with_chat/screen/call_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _textController = TextEditingController();

  late StreamChatClient chatClient;
  final videoClient = StreamVideo.instance;

  var _isInProgress = false;

  @override
  Widget build(BuildContext context) {
    chatClient = StreamChat.of(context).client;
    final currentUser = videoClient.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: currentUser != null
                ? StreamUserAvatar(user: currentUser)
                : SizedBox()),
        title: Text("Video with Chat"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              _logout(context);
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  final callId = 'call${Random().nextInt(10000)}';
                  _joinOrCreateCall(callId);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Start a Call',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  isDense: true,
                  border: const OutlineInputBorder(),
                  labelText: 'Enter Call ID',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final callId = _textController.text;
                  await _joinOrCreateCall(callId);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Join Call',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
              if (_isInProgress)
                Center(
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _joinOrCreateCall(String callId) async {
    setState(() => _isInProgress = true);

    try {
      final call = await _initVideoCall(callId: callId);
      final channel = await _initChatChannel(channelId: callId);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CallScreen(
              call: call,
              channel: channel,
            );
          },
        ),
      );
    } catch (e, stk) {
      debugPrint('Error occurred: $e');
      debugPrint(stk.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error starting or joining a call"),
        ),
      );
    } finally {
      setState(() => _isInProgress = false);
    }
  }

  Future<Call> _initVideoCall({required String callId}) async {
    final call = videoClient.makeCall(type: 'default', id: callId);
    await call.getOrCreateCall();
    return call;
  }

  Future<Channel> _initChatChannel({required String channelId}) async {
    final currentUserId = chatClient.state.currentUser!.id;

    final memberIds = defaultUsers
        .map((user) => user.id)
        .where((id) => id != currentUserId)
        .toList();

    /// TODO: check if can use "livestream" channel type here.
    final channel = chatClient.channel(
      'messaging',
      id: channelId,
      extraData: {
        'name': 'Meeting Chat',
        "members": memberIds,
      },
    );

    await channel.watch();
    return channel;
  }

  /// Disconnect the currently logged in user from both Video and Chat APIs.
  Future<void> _logout(BuildContext context) async {
    await videoClient.disconnectUser();
    await chatClient.disconnectUser();

    Navigator.of(context).pop();
  }
}
