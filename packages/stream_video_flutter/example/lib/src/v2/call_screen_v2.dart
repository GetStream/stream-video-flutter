import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/stream_video.dart';

import 'view/call_participant.dart';
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
  late final CallV2 _call = widget.call;
  late CallStateV2 _state;

  final _renderers = <String, ParticipantRenderer>{};

  @override
  void initState() {
    super.initState();
    widget.call.state.listen(_setState);
    _setState(widget.call.state.value);
    _start();
  }

  Future<void> _setState(CallStateV2 state) async {
    for (final participantState in state.callParticipants) {
      final userId = participantState.userId;
      final sessionId = participantState.sessionId;
      final trackId = participantState.trackIdPrefix;
      final track = _call.getTrack(trackId, SfuTrackType.video);
      print('(SV:CallScreenState): [setState] userId: $userId, track: $track');
      if (track == null) {
        await _renderers[sessionId]?.dispose();
        _renderers.remove(sessionId);
      } else {
        final renderer = _renderers[sessionId] ?? ParticipantRenderer();
        await renderer.initialize();
        renderer.srcObject(track, SfuTrackType.video);
        _renderers[sessionId] = renderer;
      }
    }
    setState(() {
      _state = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    final participants = _state.callParticipants.take(4).map((pState) {
      return CallParticipantV2(
        state: pState,
        renderer: _renderers[pState.userId],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              await _hangUp();
              widget.onBackPressed();
            },
          ),
        ],
        title: Text('CallId: ${widget.call.state.value.callCid}'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            'Status: ${_state.status.runtimeType}',
          ),
          const SizedBox(height: 10),
          Text(
            'Users: ${_state.callParticipants.map(
                  (it) => it.userId,
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
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await _hangUp();
                widget.onBackPressed();
              },
              child: const Text('Hang Up'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildParticipant(List<CallParticipantV2> participants, int pIndex) {
    final participant =
        participants.firstWhereIndexedOrNull((index, _) => index == pIndex);

    return Container(
      color: Colors.yellow,
      child: CallParticipantView(
        call: _call,
        participant: participant,
      ),
    );
  }

  Future<void> _start() async {
    if (_state.status.isIdle) {
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
  }

  Future<void> _hangUp() async {
    await widget.call.apply(const CancelCall());
    await widget.call.disconnect();
  }
}
