import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

import 'livestream_speakerphone_option.dart';

class LivestreamInfo extends StatelessWidget {
  const LivestreamInfo({
    Key? key,
    required this.call,
    required this.callState,
  }) : super(key: key);

  final Call call;
  final CallState callState;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withOpacity(0.4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                child: Text(
                  callState.isBackstage ? 'Backstage' : 'Live',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(
                Icons.remove_red_eye_outlined,
                color: Colors.white,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                callState.otherParticipants.length.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red,
                radius: 4.0,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '01:41',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              LivestreamSpeakerphoneOption(
                call: call,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.fullscreen,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
