import 'package:dogfooding/src/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/participant_info/invitable_user_list_controller.dart';
import 'package:stream_video_flutter/participant_info/invitable_user_list_view.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class CallParticipantsInviteScreen extends StatefulWidget {
  const CallParticipantsInviteScreen({super.key, required this.call});

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

  static List<UserInfo> _generateUserInfo() {
    return List<UserInfo>.generate(
      20,
      (index) => UserInfo(
        id: "user$index",
        role: "admin",
        name: "John $index",
        imageUrl:
            "https://ca.slack-edge.com/T02RM6X6B-U034NG4FPNG-688fab30cc42-192",
      ),
    );
  }
}
