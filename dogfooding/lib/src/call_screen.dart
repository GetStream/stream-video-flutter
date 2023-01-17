import 'package:dogfooding/src/home_screen.dart';
import 'package:dogfooding/src/participants_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({Key? key, required this.call}) : super(key: key);

  final Call call;

  static const routeName = '/call';

  @override
  Widget build(BuildContext context) {
    navigateHome() {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }

    return StreamActiveCall(
      call: call,
      onBackPressed: navigateHome,
      onHangUp: navigateHome,
      onParticipantsTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StreamCallParticipantsInfoScreen(call: call),
          ),
        );
      },
      enableFloatingView: true,
    );
  }
}
