import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import 'env/env.dart';
import 'participant_list.dart';

void main() async {
  /// Initialize Stream Video SDK.
  StreamVideo.init(
    Env.streamVideoApiKey,
    logPriority: Priority.info,
  );

  await StreamVideo.instance.connectUser(
    const UserInfo(
      id: Env.sampleUserId00,
      role: Env.sampleUserRole00,
      name: Env.sampleUserName00,
      image: Env.sampleUserImage00,
    ),
    Env.sampleUserVideoToken00,
  );

  runApp(const UICookbook());
}

class UICookbook extends StatelessWidget {
  const UICookbook({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI Cookbook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Cookbook'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OptionButton(
            onPressed: () async {
              final call =
                  await generateCall('default', generateAlphanumericString(10));

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return ParticipantListScreen(
                      call: call,
                    );
                  },
                ),
              );
            },
            label: 'Participant List',
          ),
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  const OptionButton({super.key, required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

const _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
Random _rnd = Random();

Future<Call> generateCall(String type, String id) async {
  final call = StreamVideo.instance.makeCall(
    type: type,
    id: id,
  );
  await call.getOrCreateCall();

  return call;
}

String generateAlphanumericString(int length) => String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
      ),
    );
