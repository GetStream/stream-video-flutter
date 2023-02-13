import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'routes/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final streamVideoClient = StreamVideoV2.instance;
  late final currentUser = streamVideoClient.currentUser!;

  final _callIdController = TextEditingController();

  var _isInProgress = false;

  Future<void> _joinOrCreateCall() async {
    final callId = _callIdController.text;
    if (callId.isEmpty) return debugPrint('Call ID is empty');

    setState(() => _isInProgress = true);

    try {
      final callCid = StreamCallCid.from(type: 'default', id: callId);
      final data = await streamVideoClient.getOrCreateCall(cid: callCid);
      final call = CallV2.fromCreated(data: data.getOrNull()!.data);

      await Navigator.of(context).pushReplacementNamed(
        Routes.CALL,
        arguments: call,
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

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamUserAvatar(user: currentUser),
        ),
        title: const Text('Stream Dog Fooding'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await streamVideoClient.disconnectUser();
              await Navigator.of(context).pushReplacementNamed(Routes.LOGIN);
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
