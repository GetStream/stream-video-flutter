import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../app_config.dart';
import '../../utils.dart';
import 'call_text_field.dart';

class StartCallTab extends StatefulWidget {
  const StartCallTab({
    super.key,
    required this.onNavigateToCall,
  });

  final void Function(Call call, {CallConnectOptions options}) onNavigateToCall;

  @override
  State<StartCallTab> createState() => _StartCallTabState();
}

class _StartCallTabState extends State<StartCallTab>
    with AutomaticKeepAliveClientMixin {
  final _callIdController = TextEditingController();

  final _selectedUsers = <UserInfo>{};

  bool _callInProgress = false;
  bool _ringingCall = true;

  @override
  void dispose() {
    _callIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          CallIdTextField(controller: _callIdController),
          const SizedBox(height: 24),
          const Text(
            'Select participants',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ParticipantsList(
              currentUserId: StreamVideo.instance.currentUser!.id,
              onSelectionChanged: (selectedUsers) {
                setState(() {
                  _selectedUsers.clear();
                  _selectedUsers.addAll(selectedUsers);
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          if (_callInProgress)
            const CircularProgressIndicator(
              strokeWidth: 2,
            )
          else
            Column(
              children: [
                Row(
                  children: [
                    const Text('Ringing', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 16),
                    Switch(
                      value: _ringingCall,
                      onChanged: (bool value) {
                        setState(() {
                          _ringingCall = !_ringingCall;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _startCall,
                  child: const Text('Start call'),
                ),
              ],
            )
        ],
      ),
    );
  }

  Future<void> _startCall() async {
    final callId = _callIdController.text;
    if (callId.isEmpty) {
      context.showSnackBar('Call ID is empty');
    }

    setState(() => _callInProgress = true);

    final call = StreamVideo.instance.makeCall(type: 'default', id: callId);
    final result = await call.getOrCreate(
      ringing: _ringingCall,
      memberIds: [
        for (final user in _selectedUsers) user.id,
      ],
    );

    result.when(
      success: (data) {
        setState(() => _callInProgress = false);

        if (_ringingCall) {
          widget.onNavigateToCall(call);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamLobbyView(
                call: call,
                onJoinCallPressed: (options) {
                  Navigator.of(context).pop();
                  widget.onNavigateToCall(call, options: options);
                },
              ),
            ),
          );
        }
      },
      failure: (error) {
        setState(() => _callInProgress = false);

        context.showSnackBar(error.message);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ParticipantsList extends StatefulWidget {
  const ParticipantsList({
    super.key,
    required this.currentUserId,
    this.onSelectionChanged,
  });

  final String currentUserId;
  final void Function(Set<UserInfo>)? onSelectionChanged;

  @override
  State<ParticipantsList> createState() => _ParticipantsListState();
}

class _ParticipantsListState extends State<ParticipantsList> {
  final _selectedUsers = <UserInfo>{};

  @override
  Widget build(BuildContext context) {
    final users = sampleUsers;

    final remainingUsers = [
      ...users.where(
        (user) => user.userInfo.id != widget.currentUserId,
      )
    ];

    return ListView.separated(
      shrinkWrap: true,
      itemCount: remainingUsers.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final user = remainingUsers[index].userInfo;

        final name = user.name;

        final isSelected = _selectedUsers.contains(user);

        void onChanged(bool? selected) {
          if (selected == null) return;
          setState(() {
            if (selected) {
              _selectedUsers.add(user);
            } else {
              _selectedUsers.remove(user);
            }
          });
          widget.onSelectionChanged?.call(_selectedUsers);
        }

        return InkWell(
          onTap: () => onChanged(!isSelected),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: StreamUserAvatar(user: user),
            title: Text(name),
            trailing: Checkbox(
              value: isSelected,
              onChanged: onChanged,
            ),
          ),
        );
      },
    );
  }
}
