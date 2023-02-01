import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'view/call_participant_view.dart';

class CallScreenV2 extends StatefulWidget {
  const CallScreenV2({
    super.key,
    required this.call,
    required this.onBackPressed,
    required this.onHangUp,
  });
  static const routeName = '/v2/call';

  final CallV2 call;
  final VoidCallback onBackPressed;
  final VoidCallback onHangUp;

  @override
  State<CallScreenV2> createState() => _CallScreenV2State();
}

class _CallScreenV2State extends State<CallScreenV2> {
  // List<CallParticipantStateV2> participants = [];

  // final _renderers = <String, ParticipantRenderer>{};

  @override
  void initState() {
    super.initState();
    widget.call.state.listen(_setState);
    _setState(widget.call.state.value);
    _start();
  }

  Future<void> _setState(CallStateV2 state) async {
    // for (final participantState in state.callParticipants) {
    //   final userId = participantState.userId;
    //   final sessionId = participantState.sessionId;
    //   final trackId = participantState.trackIdPrefix;
    //   // final track = _call.getTrack(trackId, SfuTrackType.video);
    //   print('(SV:CallScreenState): [setState] userId: $userId, track: $track');
    //
    //   if (track == null) {
    //     await _renderers[sessionId]?.dispose();
    //     _renderers.remove(sessionId);
    //   } else {
    //     final renderer = _renderers[sessionId] ?? ParticipantRenderer();
    //     await renderer.initialize();
    //     renderer.srcObject(track, SfuTrackType.video);
    //     _renderers[sessionId] = renderer;
    //   }
    // }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final callState = widget.call.state.value;
    final status = callState.status;

    if (status.isConnected) {
      final participants = callState.callParticipants.take(4).toList();
      final localParticipant =
          participants.firstWhereOrNull((it) => it.isLocal)!;

      return Scaffold(
        appBar: AppBar(
          elevation: 4,
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                await _hangUp();
              },
            ),
          ],
          title: Text('CallId: ${callState.callCid}'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Status: ${status.runtimeType}',
            ),
            const SizedBox(height: 10),
            Text(
              'Users: ${callState.callParticipants.map(
                    (it) => '${it.userId}(${it.publishedTracks})',
                  ).toList()}',
            ),
            const SizedBox(height: 50),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                padding: const EdgeInsets.all(8),
                children: [
                  _buildParticipant(participants, 0),
                  _buildParticipant(participants, 1),
                  _buildParticipant(participants, 2),
                  _buildParticipant(participants, 3),
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: StreamCallControlsBar(
          options: [
            ToggleMicrophoneButton(
              call: widget.call,
              localParticipant: localParticipant,
            ),
            ToggleCameraButton(
              call: widget.call,
              localParticipant: localParticipant,
            ),
            CallHangup(onHangup: _hangUp),
          ],
        ),
      );
    }

    return Center(
      child: Text(
        'Status: ${status.runtimeType}',
      ),
    );
  }

  Widget _buildParticipant(
      List<CallParticipantStateV2> participants, int pIndex) {
    final participant =
        participants.firstWhereIndexedOrNull((index, _) => index == pIndex);

    return Container(
      color: Colors.yellow,
      child: CallParticipantView(
        call: widget.call,
        participant: participant,
      ),
    );
  }

  Future<void> _start() async {
    try {
      if (widget.call.state.value.status.isIdle) {
        final result = await widget.call.getOrCreate();
        if (result.isFailure) {
          await _hangUp();
          return;
        }
      }
      final result = await widget.call.connect();
      if (result.isFailure) {
        await _hangUp();
      }
    } catch (e, stk) {
      await _hangUp();
    }
  }

  Future<void> _hangUp() async {
    await widget.call.apply(const CancelCall());
    await widget.call.disconnect();
    widget.onBackPressed();
  }
}

class ToggleMicrophoneButton extends StatelessWidget {
  const ToggleMicrophoneButton({
    super.key,
    required this.call,
    required this.localParticipant,
  });

  final CallV2 call;
  final CallParticipantStateV2 localParticipant;

  @override
  Widget build(BuildContext context) {
    final trackState = localParticipant.publishedTracks[SfuTrackType.audio];
    final isEnabled = trackState != null && !trackState.muted;

    return CallControlOption(
      icon: Icon(isEnabled ? Icons.mic_rounded : Icons.mic_off_rounded),
      onPressed: () {
        call.apply(
          SetMicrophoneEnabled(enabled: !isEnabled),
        );
      },
    );
  }
}

class ToggleCameraButton extends StatelessWidget {
  const ToggleCameraButton({
    super.key,
    required this.call,
    required this.localParticipant,
  });

  final CallV2 call;
  final CallParticipantStateV2 localParticipant;

  @override
  Widget build(BuildContext context) {
    final trackState = localParticipant.publishedTracks[SfuTrackType.video];
    final isEnabled = trackState != null && !trackState.muted;

    return CallControlOption(
      icon:
          Icon(isEnabled ? Icons.videocam_rounded : Icons.videocam_off_rounded),
      onPressed: () {
        call.apply(
          SetCameraEnabled(enabled: !isEnabled),
        );
      },
    );
  }
}
