import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class CallParticipantView extends StatelessWidget {
  const CallParticipantView({
    super.key,
    required this.call,
    required this.participant,
  });

  final CallV2 call;
  final CallParticipantStateV2? participant;

  @override
  Widget build(BuildContext context) {
    final participant = this.participant;
    print('(D/SV:ParticipantView) [build] participant: $participant');

    if (participant == null) {
      return Container(
        alignment: Alignment.center,
        child: const Text('Mock Participant'),
      );
    }

    return VideoTrackRenderer(
      call: call,
      participant: participant,
      placeholderBuilder: (context) => StreamUserAvatar(
        user: UserInfo(
          id: participant.userId,
          role: participant.role,
          name: participant.userId,
          imageUrl: participant.profileImageURL,
        ),
      ),
    );
    // final participant = this.participant;
    // print('(D/SV:ParticipantView) [build] participant: $participant');
    //
    // if (participant == null) {
    //   return Container(
    //     alignment: Alignment.center,
    //     child: const Text('Mock Participant'),
    //   );
    // }
    //
    // final videoTrack = call.getTrack(
    //   participant.trackIdPrefix,
    //   SfuTrackType.video,
    // );
    //
    // final view = SizeChangedLayoutNotifier(
    //   onSizeChanged: (size){},
    //   child: ,
    // );
    //
    // final videoTrackStatus = participant.publishedTracks[SfuTrackType.video];
    // Widget videoView;
    // if (videoTrackStatus == null) {
    //   videoView = StreamUserAvatar(
    //     user: UserInfo(
    //       id: participant.userId,
    //       role: participant.role,
    //       name: participant.userId,
    //       imageUrl: participant.profileImageURL,
    //     ),
    //   );
    // } else {
    //   if (participant.isLocal) {
    //     if (videoTrackStatus.isPublished) {
    //       final publishedVideoTrack = call.getTrack(
    //         participant.trackIdPrefix,
    //         SfuTrackType.video,
    //       );
    //     }
    //   } else {
    //     if (videoTrackStatus.isPublished) {
    //
    //     } else if ()
    //   }
    // }
    //
    // return Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     videoView,
    //     StreamUserAvatar(
    //       user: UserInfo(
    //         id: participant.userId,
    //         role: participant.role,
    //         name: participant.userId,
    //         imageUrl: participant.profileImageURL,
    //       ),
    //     ),
    //   ],
    // );

    // Widget videoView;
    // if (publishedVideoTrack != null) {
    //   videoView = rtc.RTCVideoView(
    //     publishedVideoTrack,
    //     mirror: participant.isLocal,
    //   );
    // } else {
    //   videoView = Container();
    // }
    //
    // // final state = participant.state;
    // // final trackStatus = state.published[SfuTrackType.video];
    // // if (trackStatus?.isPublished == true) {
    // //   print('(D/SV:ParticipantView) [build] subscribeTo: $trackStatus');
    // //   call.apply(
    // //     SubscribeTrack(
    // //       userId: state.userId,
    // //       sessionId: state.sessionId,
    // //       trackIdPrefix: state.trackIdPrefix,
    // //       trackType: SfuTrackType.video,
    // //       videoDimension: RtcVideoDimensionPresets.h720_43,
    // //     ),
    // //   );
    // // }
    //
    // final renderer = participant.renderer;
    // final Widget videoView;
    // if (renderer != null) {
    //   print('(D/SV:ParticipantView) [build] renderer: $renderer');
    //   videoView = SizeChangedLayoutNotifier(
    //     onSizeChanged: (Size size) {
    //       print('(V/SV:ParticipantView) [onChange] size: $size');
    //       call.apply(
    //         SubscribeTrack(
    //           userId: state.userId,
    //           sessionId: state.sessionId,
    //           trackIdPrefix: state.trackIdPrefix,
    //           trackType: renderer.trackType,
    //           videoDimension: RtcVideoDimension(
    //             width: size.width.toInt(),
    //             height: size.height.toInt(),
    //           ),
    //         ),
    //       );
    //     },
    //     child: rtc.RTCVideoView(
    //       renderer.videoRenderer,
    //       mirror: participant.state.isLocal,
    //     ),
    //   );
    // } else {
    //   videoView = Container();
    // }
  }
}
