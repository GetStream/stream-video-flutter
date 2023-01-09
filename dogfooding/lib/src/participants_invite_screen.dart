import 'package:dogfooding/src/utils/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class CallParticipantsInviteScreen extends StatefulWidget {
  const CallParticipantsInviteScreen({
    super.key,
    required this.call,
  });

  static const routeName = '/call/participants/invite';

  final Call call;

  @override
  State<CallParticipantsInviteScreen> createState() =>
      _CallParticipantsInviteScreenState();
}

class _CallParticipantsInviteScreenState
    extends State<CallParticipantsInviteScreen> {
  late StreamInvitableUserListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StreamInvitableUserListController(
        call: widget.call, usersProvider: MockUsersProvider());
    _controller.doInitialLoad();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Participants'),
        actions: [
          StreamInviteButton(
            controller: _controller,
          )
        ],
      ),
      body: StreamInvitableUserListView(controller: _controller),
    );
  }
}
