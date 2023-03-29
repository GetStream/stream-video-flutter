import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import 'env/env.dart';

class ParticipantListScreen extends StatefulWidget {
  const ParticipantListScreen({super.key, required this.call});

  final Call call;

  @override
  State<ParticipantListScreen> createState() => _ParticipantListScreenState();
}

class _ParticipantListScreenState extends State<ParticipantListScreen> {
  late CallState _callState;
  StreamSubscription<CallState>? _subscription;

  @override
  void initState() {
    widget.call.connect();

    _callState = widget.call.state.value;
    _subscription = widget.call.state.listen((callState) {
      setState(() {
        _callState = callState;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final callParticipants = _callState.callParticipants;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Participant List'),
      ),
      body: _callState.status.isConnected
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(
                  flex: 5,
                  child: ColoredBox(color: Colors.white),
                ),
                Expanded(
                  child: ColoredBox(
                    color: Colors.black87,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      itemBuilder: (context, index) {
                        return CallParticipantWidget(
                          callParticipantState: callParticipants[index],
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemCount: callParticipants.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class CallParticipantWidget extends StatelessWidget {
  const CallParticipantWidget({super.key, required this.callParticipantState});

  final CallParticipantState callParticipantState;

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      animate: callParticipantState.isDominantSpeaker,
      endRadius: 56,
      glowColor: Colors.blue,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundImage: NetworkImage(
              Env.sampleUserImage00,
            ),
          ),
          Icon(
            callParticipantState.isAudioEnabled
                ? Icons.mic_rounded
                : Icons.mic_off_rounded,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
