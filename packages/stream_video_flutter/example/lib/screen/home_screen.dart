import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../users_provider.dart';
import 'home_tabs/join_call_tab.dart';
import 'home_tabs/start_call_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StreamVideo _streamVideo = StreamVideo.instance;
  late final currentUser = _streamVideo.currentUser;

  StreamSubscription<Call>? _onIncomingCallSubscription;

  @override
  void initState() {
    super.initState();
    _onIncomingCallSubscription?.cancel();
    _onIncomingCallSubscription = _streamVideo.state.incomingCall.listen(
      _onNavigateToCall,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _onIncomingCallSubscription?.cancel();
    _onIncomingCallSubscription = null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: StreamUserAvatar(user: currentUser),
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
            StartCallTab(onNavigateToCall: _onNavigateToCall),
            JoinCallTab(onNavigateToCall: _onNavigateToCall),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await _streamVideo.disconnect();
    Navigator.of(context).pop();
  }

  void _onNavigateToCall(
    Call call, {
    CallConnectOptions options = const CallConnectOptions(),
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamUsersConfiguration(
          usersProvider: MockUsersProvider(),
          child: StreamCallContainer(
            call: call,
            callConnectOptions: options,
          ),
        ),
      ),
    );
  }
}
