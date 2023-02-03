import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import 'call_screen_v2.dart';
import 'login_screen_v2.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
      ),
    );
}

int _homeSeq = 1;

class HomeScreenV2 extends StatefulWidget {
  const HomeScreenV2({super.key});

  static const routeName = '/v2/home';

  @override
  State<HomeScreenV2> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenV2> {
  final StreamVideoV2 _streamVideo = StreamVideoV2.instance;
  late final currentUser = _streamVideo.currentUser!;

  final _logger = taggedLogger(tag: 'HomeScreen-${_homeSeq++}');

  @override
  void initState() {
    super.initState();
    _logger.d(() => '[initState] no args');
    _streamVideo.onCallCreated = (data) {
      _logger.d(() => '[onCallCreated] data: $data');
      if (data.ringing) {
        final call = CallV2.fromCreated(data: data);
        Navigator.of(context).pushReplacementNamed(
          CallScreenV2.routeName,
          arguments: call,
        );
      }
    };
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d(() => '[dispose] no args');
    _streamVideo.onCallCreated = null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: avatarBuilder(context, currentUser),
          ),
          centerTitle: true,
          title: const Text('Call Details'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Start a call'),
              Tab(text: 'Join a call'),
            ],
            labelStyle: TextStyle(fontSize: 16),
          ),
        ),
        body: TabBarView(
          children: [
            StartCallScreen(client: _streamVideo),
            JoinCallScreen(client: _streamVideo),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await _streamVideo.disconnectUser();
    Navigator.of(context).pushReplacementNamed(
      LoginScreenV2.routeName,
    );
  }
}

class StartCallScreen extends StatefulWidget {
  const StartCallScreen({
    super.key,
    required this.client,
  });

  final StreamVideoV2 client;

  @override
  State<StartCallScreen> createState() => _StartCallScreenState();
}

class _StartCallScreenState extends State<StartCallScreen>
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
              currentUserId: widget.client.currentUser!.id,
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
      showSnackBar(
        context: context,
        message: 'Call ID is empty',
      );

      return debugPrint('Call ID is empty');
    }

    setState(() => _callInProgress = true);

    final callCid = StreamCallCid.from(type: 'default', id: callId);
    final result = await widget.client.createCall(
      cid: callCid,
      ringing: _ringingCall,
      participantIds: [
        for (final user in _selectedUsers) user.id,
      ],
    );

    result.when(
      success: (data) {
        setState(() => _callInProgress = false);

        final call = CallV2.fromCreated(data: data);
        Navigator.of(context).pushReplacementNamed(
          CallScreenV2.routeName,
          arguments: call,
        );
      },
      failure: (error) {
        setState(() => _callInProgress = false);

        showSnackBar(
          context: context,
          message: error.message,
        );

        debugPrint('Error starting: ${error.message}');
        if (error.stackTrace != null) debugPrint(error.stackTrace.toString());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class JoinCallScreen extends StatefulWidget {
  const JoinCallScreen({
    super.key,
    required this.client,
  });

  final StreamVideoV2 client;

  @override
  State<JoinCallScreen> createState() => _JoinCallScreenState();
}

class _JoinCallScreenState extends State<JoinCallScreen> {
  final _callIdController = TextEditingController();

  bool _callInProgress = false;

  @override
  void dispose() {
    _callIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          CallIdTextField(
            controller: _callIdController,
          ),
          const SizedBox(height: 24),
          if (_callInProgress)
            const CircularProgressIndicator(
              strokeWidth: 2,
            )
          else
            ElevatedButton(
              onPressed: _joinCall,
              child: const Text('Join call'),
            ),
        ],
      ),
    );
  }

  Future<void> _joinCall() async {
    final callId = _callIdController.text;
    if (callId.isEmpty) {
      showSnackBar(
        context: context,
        message: 'Call ID is empty',
      );

      return debugPrint('Call ID is empty');
    }

    setState(() => _callInProgress = true);

    final callCid = StreamCallCid.from(type: 'default', id: callId);
    final result = await widget.client.getOrCreateCall(cid: callCid);

    result.when(
      success: (data) {
        final call = CallV2.fromCreated(data: data.data);

        Navigator.of(context).pushReplacementNamed(
          CallScreenV2.routeName,
          arguments: call,
        );
      },
      failure: (error) {
        setState(() => _callInProgress = false);

        showSnackBar(
          context: context,
          message: error.message,
        );

        debugPrint('Error joining: ${error.message}');
        if (error.stackTrace != null) debugPrint(error.stackTrace.toString());
      },
    );
  }
}

class CallIdTextField extends StatelessWidget {
  const CallIdTextField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(),
        labelText: 'Enter call id',
        // suffix button to generate a random call id
        suffixIcon: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            // generate a 10 character nanoId for call id
            final callId = nanoid(10);
            controller.value = TextEditingValue(
              text: callId,
              selection: TextSelection.collapsed(offset: callId.length),
            );
          },
        ),
      ),
    );
  }
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
            leading: avatarBuilder(context, user),
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

/// Generates a nanoId of given length
String nanoid(int length) {
  final random = math.Random.secure();
  final values = List<int>.generate(length, (index) => random.nextInt(256));
  return base64Url.encode(values);
}
