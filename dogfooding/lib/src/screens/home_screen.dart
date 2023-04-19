import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    hide StreamUserAvatar;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../repos/app_repository.dart';
import '../routes/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final streamVideoClient = StreamVideo.instance;
  late final currentUser = streamVideoClient.currentUser!;
  Call? call;
  Channel? chatChannel;

  final _callIdController = TextEditingController();

  void _handleCallNavigation(CallConnectOptions options) {
    if (call != null) {
      Navigator.of(context).pushNamed(
        Routes.call,
        arguments: [call, options, chatChannel],
      );
    }
  }

  Future<void> _joinOrCreateCall() async {
    final callId = _callIdController.text;
    final chatClient = AppRepository.instance.streamChatClient;
    if (callId.isEmpty) return debugPrint('Call ID is empty');

    try {
      final callCid = StreamCallCid.from(type: 'default', id: callId);
      final data = await streamVideoClient.getOrCreateCall(cid: callCid);
      call = Call.fromCreated(data: data.getDataOrNull()!.data);

      final callMemberIDs = call?.state.value.callParticipants
          .map((CallParticipantState participant) => participant.userId)
          .where((id) => id != chatClient?.state.currentUser?.id)
          .toList(
            growable: false,
          );

      final channelName = call?.state.value.callCid;

      chatChannel = await AppRepository.instance.createChatChannel(
        channelId: call!.callCid.id,
        channelMembers: callMemberIDs!,
        channelName: '$channelName Chat',
      );

      if (mounted) {
        await Navigator.of(context).pushNamed(
          Routes.lobby,
          arguments: [call, _handleCallNavigation],
        );
      }
    } catch (e, stk) {
      debugPrint('Error joining or creating call: $e');
      debugPrint(stk.toString());
    } finally {}
  }

  Future<void> _logout() async {
    await AppRepository.instance.endSession();
    if (mounted) {
      unawaited(Navigator.of(context).pushReplacementNamed(Routes.login));
    }
  }

  @override
  void dispose() {
    _callIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = currentUser.name;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: StreamUserAvatar(user: currentUser),
        ),
        title: Text(name),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome: $name',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'Start or join a meeting by entering the call ID.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Call ID Number',
                    style: TextStyle(
                      color: Color(0xFF979797),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _callIdController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(),
                      labelText: 'Enter call id',
                      labelStyle: const TextStyle(color: Colors.white),
                      // suffix button to generate a random call id
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          // generate a 10 character nanoId for call id
                          final callId = generateAlphanumericString(10);
                          _callIdController.value = TextEditingValue(
                            text: callId,
                            selection:
                                TextSelection.collapsed(offset: callId.length),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                backgroundColor: const MaterialStatePropertyAll<Color>(
                  Color(0xFF005FFF),
                ),
              ),
              onPressed: _joinOrCreateCall,
              child: const Text('Join or Create call'),
            ),
            // circular progress to show when joining a call
          ],
        ),
      ),
    );
  }
}
