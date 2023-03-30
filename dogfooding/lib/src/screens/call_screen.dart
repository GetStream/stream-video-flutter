import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../utils/users_provider.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({
    super.key,
    required this.call,
  });

  final Call call;

  @override
  Widget build(BuildContext context) {
    return StreamUsersConfiguration(
      usersProvider: MockUsersProvider(),
      child: StreamCallContainer(
        call: call,
      ),
    );
  }
}
