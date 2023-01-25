import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import 'login_screen_v2.dart';

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
  late final CallV2 call = widget.call;
  late CallStateV2 state;

  @override
  void initState() {
    super.initState();
    widget.call.state.listen((value) {
      setState(() {
        state = widget.call.state.value;
      });
    });
    setState(() {
      state = widget.call.state.value;
    });
    _start();
  }

  @override
  Widget build(BuildContext context) {
    // final call = CallV2.fromCid(callCid: callCid);
    // await call.getOrCreate();
    // final result = await call.connect();
    // if (result.isFailure) {
    //   return;
    // }
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
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
          Text(
            'Status: ${state.status.runtimeType}',
          ),
          Text(
            'Users: ${state.callParticipants.values.map(
                  (it) => it.userId,
                ).toList()}',
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          children: [
            TextButton(
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

  Future<void> _start() async {
    if (state.status.isIdle) {
      await widget.call.getOrCreate();
    }
    await widget.call.connect();
  }

  Future<void> _hangUp() async {
    await widget.call.cancelCall();
    await widget.call.disconnect();
  }
}
