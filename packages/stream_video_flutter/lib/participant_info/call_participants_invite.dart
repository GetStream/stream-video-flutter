import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/participant_info/call_participant_invite.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'call_participant_info.dart';

class StreamCallParticipantsInviteWidget extends StatefulWidget {
  StreamCallParticipantsInviteWidget({super.key, required this.call});

  static const routeName = '/call/participants/invite';

  final Call call;

  @override
  State<StreamCallParticipantsInviteWidget> createState() =>
      _StreamCallParticipantsInviteWidgetState();
}

class _StreamCallParticipantsInviteWidgetState
    extends State<StreamCallParticipantsInviteWidget> {
  final participants = _generateUserInfo();
  final selectedUsers = <String, UserInfo>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Participants'),
        actions: [
          Visibility(
              visible: selectedUsers.isNotEmpty,
              child: IconButton(
                  onPressed: () async {
                    await widget.call
                        .inviteUsers(selectedUsers.values.toList());
                    setState(() {
                      participants.removeWhere(
                          (user) => selectedUsers.containsKey(user.id));
                      selectedUsers.clear();
                    });
                  },
                  icon: const Icon(Icons.group_add)))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemBuilder: (context, index) {
                    final user = participants[index];
                    return StreamCallParticipantInviteWidget(
                      user: user,
                      selected: selectedUsers.containsKey(user.id),
                      onTap: () {
                        setState(() {
                          if (selectedUsers.containsKey(user.id)) {
                            selectedUsers.remove(user.id);
                          } else {
                            selectedUsers[user.id] = user;
                          }
                        });
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                        indent: 16,
                        height: 0,
                        color: Colors.grey,
                      ),
                  itemCount: participants.length)),
        ],
      ),
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
                "https://ca.slack-edge.com/T02RM6X6B-U034NG4FPNG-688fab30cc42-192"));
  }
}
