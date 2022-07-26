import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

class VideoView extends StatefulWidget {
  final RoomParticipant participant;

  VideoView(this.participant);

  @override
  State<StatefulWidget> createState() {
    return _VideoViewState();
  }
}

class _VideoViewState extends State<VideoView> {
  VideoTrackPublication? videoPub;

  @override
  void initState() {
    super.initState();
    widget.participant.addListener(this._onParticipantChanged);
    // trigger initial change
    _onParticipantChanged();
  }

  @override
  void dispose() {
    widget.participant.removeListener(this._onParticipantChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant VideoView oldWidget) {
    oldWidget.participant.removeListener(_onParticipantChanged);
    widget.participant.addListener(_onParticipantChanged);
    _onParticipantChanged();
    super.didUpdateWidget(oldWidget);
  }

  void _onParticipantChanged() {
    var subscribedVideos = widget.participant.videoTracks.where((pub) {
      return pub.kind == StreamTrackType.VIDEO &&
          !pub.isScreenShare &&
          pub.subscribed;
    });

    setState(() {
      if (subscribedVideos.length > 0) {
        var videoPub = subscribedVideos.first;
        // when muted, show placeholder
        if (!videoPub.muted) {
          this.videoPub = videoPub;
          return;
        }
      }
      this.videoPub = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    //   if (videoPub != null) {
    //     return StreamVideoTrackRenderer(videoPub.track);
    //   } else {
    //     return Container(
    //       color: Colors.grey,
    //     );
    //   }
    // }
  }
}
