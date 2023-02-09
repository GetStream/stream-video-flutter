import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../call_participants/call_participant_v2.dart';
import 'incoming_call/incoming_call_v2.dart';
import 'outgoing_call/outgoing_call_v2.dart';

const int _idState = 2;
int _callSeq = 1;

class CallScreenV2 extends StatefulWidget {
  const CallScreenV2({
    super.key,
    required this.call,
    required this.onBackPressed,
    required this.onHangUp,
  });

  final CallV2 call;
  final VoidCallback onBackPressed;
  final VoidCallback onHangUp;

  @override
  State<CallScreenV2> createState() => _CallScreenV2State();
}

class _CallScreenV2State extends State<CallScreenV2> {
  final _logger = taggedLogger(tag: 'CallScreen-${_callSeq++}');
  final subscriptions = Subscriptions();

  @override
  void initState() {
    super.initState();
    _logger.d(() => '[initState] no args');
    subscriptions.add(_idState, widget.call.state.listen(_setState));
    _setState(widget.call.state.value);
    _start();
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d(() => '[dispose] no args');
    subscriptions.cancelAll();
  }

  Future<void> _setState(CallStateV2 state) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final callState = widget.call.state.value;
    final status = callState.status;
    _logger.d(() => '[build] status: $status');
    if (status.isDrop) {
      _disconnect();
    }

    if (status is CallStatusIncoming && !status.acceptedByMe) {
      return IncomingCallV2(
        state: callState,
        onRejectPressed: _rejectCall,
        onAcceptPressed: _acceptCall,
        onMicrophoneTap: () {},
        onCameraTap: () {},
      );
    }
    if (status is CallStatusOutgoing && !status.acceptedByCallee) {
      return OutgoingCallV2(
        state: callState,
        onCancelPressed: _cancelCall,
      );
    }

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
              onPressed: _cancelCall,
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
            FlipCameraButton(
              call: widget.call,
              localParticipant: localParticipant,
            ),
            CallHangup(onHangup: _cancelCall),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _cancelCall,
          ),
        ],
        title: Text('CallId: ${callState.callCid}'),
      ),
      body: Center(
        child: Text(
          'Status: ${status.runtimeType}',
        ),
      ),
    );
  }

  Widget _buildParticipant(
      List<CallParticipantStateV2> participants, int pIndex) {
    final participant =
        participants.firstWhereIndexedOrNull((index, _) => index == pIndex);

    return Container(
      color: Colors.yellow,
      child: CallParticipantV2(
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
          await _cancelCall();
          return;
        }
      }
      final result = await widget.call.connect();
      if (result.isFailure) {
        await _cancelCall();
      }
    } catch (e, stk) {
      await _cancelCall();
    }
  }

  Future<void> _rejectCall() async {
    await widget.call.apply(const RejectCall());
    await widget.call.disconnect();
    widget.onBackPressed();
  }

  Future<void> _acceptCall() async {
    await widget.call.apply(const AcceptCall());
  }

  Future<void> _cancelCall() async {
    _logger.d(() => '[cancelCall] no args');
    await widget.call.apply(const CancelCall());
    await _disconnect();
  }

  Future<void> _disconnect() async {
    _logger.d(() => '[disconnect] no args');
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

class FlipCameraButton extends StatelessWidget {
  const FlipCameraButton({
    super.key,
    required this.call,
    required this.localParticipant,
  });

  final CallV2 call;
  final CallParticipantStateV2 localParticipant;

  @override
  Widget build(BuildContext context) {
    final position = getCurrentCameraPosition();
    return CallControlOption(
      icon: const Icon(Icons.flip_camera_ios_rounded),
      onPressed: position != null
          ? () {
              final newPosition = position == CameraPositionV2.front
                  ? CameraPositionV2.back
                  : CameraPositionV2.front;

              call.apply(
                SetCameraPosition(cameraPosition: newPosition),
              );
            }
          : null,
    );
  }

  CameraPositionV2? getCurrentCameraPosition() {
    final trackState = localParticipant.publishedTracks[SfuTrackType.video];
    if (trackState is! LocalTrackState) return null;

    return trackState.cameraPosition;
  }
}
