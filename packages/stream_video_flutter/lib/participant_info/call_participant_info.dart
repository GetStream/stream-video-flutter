import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/participant_info/model/call_participant_state.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class StreamCallParticipantInfoWidget extends StatelessWidget {
  final CallParticipantState participant;

  const StreamCallParticipantInfoWidget({
    super.key,
    required this.participant,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamUserAvatar(
              user: participant.user,
              avatarTheme: const StreamAvatarTheme(
                  initialsTextStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  constraints: BoxConstraints(
                    minHeight: 56,
                    minWidth: 56,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(32))),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  participant.user.name,
                  style: const TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                participant.videoAvailable
                    ? Icons.videocam_rounded
                    : Icons.videocam_off_rounded,
                color: participant.videoAvailable ? Colors.black54 : Colors.red,
                size: 32,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                participant.audioAvailable ? Icons.mic : Icons.mic_off,
                color: participant.audioAvailable ? Colors.black54 : Colors.red,
                size: 32,
              ),
            )
          ],
        ),
      ),
    );
  }
}
