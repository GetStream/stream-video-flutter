import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import 'call_screen_v2.dart';
import 'login_screen_v2.dart';

class HomeScreenV2 extends StatefulWidget {
  const HomeScreenV2({super.key});

  static const routeName = '/v2/home';

  @override
  State<HomeScreenV2> createState() => _HomeScreenStateV2();
}

class _HomeScreenStateV2 extends State<HomeScreenV2> {
  StreamVideoV2 streamVideo = StreamVideoV2.instance;
  late final currentUser = streamVideo.currentUser!;

  final _callIdController = TextEditingController(text: 'call329');

  var _isInProgress = false;

  Future<void> _joinOrCreateCall() async {
    final callId = _callIdController.text;
    if (callId.isEmpty) return debugPrint('Call ID is empty');

    setState(() => _isInProgress = true);

    try {
      final callCid = StreamCallCid.from(type: 'default', id: callId);

      Navigator.of(context).pushReplacementNamed(
        CallScreenV2.routeName,
        arguments: callCid,
      );
    } catch (e, stk) {
      debugPrint('Error joining or creating call: $e');
      debugPrint(stk.toString());
    } finally {
      setState(() => _isInProgress = false);
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
    final imageUrl = currentUser.imageUrl;

    final avatar = imageUrl != null
        ? CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(imageUrl))
        : CircleAvatar(child: Text(name[0].toUpperCase()));

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: avatar,
        ),
        title: const Text('Stream Video UI Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await streamVideo.disconnectUser();
              Navigator.of(context)
                  .pushReplacementNamed(LoginScreenV2.routeName);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome: $name',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _callIdController,
              decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(),
                labelText: 'Enter call id',
                // suffix button to generate a random call id
                suffixIcon: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    // generate a 10 character nanoId for call id
                    final callId = nanoid(10);
                    _callIdController.value = TextEditingValue(
                      text: callId,
                      selection: TextSelection.collapsed(offset: callId.length),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _joinOrCreateCall,
            child: const Text('Join or Create call'),
          ),
          // circular progress to show when joining a call
          if (_isInProgress) ...[
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ],
        ],
      ),
    );
  }
}

/// Generates a nanoId of given length
String nanoid(int length) {
  final random = math.Random.secure();
  final values = List<int>.generate(length, (index) => random.nextInt(256));
  return base64Url.encode(values);
}
