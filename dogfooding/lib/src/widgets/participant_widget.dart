import 'package:dogfooding/src/widgets/no_video.dart';
import 'package:dogfooding/src/widgets/participant_info.dart';
import 'package:dogfooding/src/widgets/video_track_renderer.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

class ParticipantWidget extends StatefulWidget {
  const ParticipantWidget({
    Key? key,
    required this.track,
  }) : super(key: key);

  final ParticipantTrack track;

  @override
  State<ParticipantWidget> createState() => _ParticipantWidgetState();
}

class _ParticipantWidgetState extends State<ParticipantWidget> {
  VideoTrack? get videoTrack => widget.track.videoTrack;

  CallParticipant get participant => widget.track.participant;

  bool get isScreenShare => widget.track.isScreenShare;

  AudioTrack? get audioTrack {
    try {
      return participant.audioTracks?.first;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Stack(
        children: [
          // Video
          videoTrack != null && !videoTrack!.muted
              ? VideoTrackRenderer(
                  videoTrack!,
                  fit: rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                )
              : const NoVideoWidget(),

          Align(
            alignment: Alignment.bottomCenter,
            child: ParticipantInfoWidget(
              title: participant.name,
              audioAvailable: audioTrack != null && !audioTrack!.muted,
              isScreenShare: isScreenShare,
            ),
          ),
        ],
      ),
    );
  }
}
