import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'call_participant.dart';

class CallParticipantView extends StatelessWidget {
  const CallParticipantView({
    super.key,
    required this.call,
    required this.participant,
  });

  final CallV2 call;
  final CallParticipantV2? participant;

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
    final state = participant.state;
    final trackStatus = state.published[SfuTrackType.video];
    if (trackStatus?.isPublished == true) {
      print('(D/SV:ParticipantView) [build] subscribeTo: $trackStatus');
      call.apply(
        SubscribeTrack(
          userId: state.userId,
          sessionId: state.sessionId,
          trackIdPrefix: state.trackIdPrefix,
          trackType: SfuTrackType.video,
          videoDimension: RtcVideoDimensionPresets.h720_43,
        ),
      );
    }
    final renderer = participant.renderer;
    final Widget videoView;
    if (renderer != null) {
      print('(D/SV:ParticipantView) [build] renderer: $renderer');
      videoView = MeasureSize(
        onChange: (Size size) {
          print('(V/SV:ParticipantView) [onChange] size: $size');
          call.apply(
            SubscribeTrack(
              userId: state.userId,
              sessionId: state.sessionId,
              trackIdPrefix: state.trackIdPrefix,
              trackType: renderer.trackType,
              videoDimension: RtcVideoDimension(
                width: size.width.toInt(),
                height: size.height.toInt(),
              ),
            ),
          );
        },
        child: rtc.RTCVideoView(
          renderer.videoRenderer,
          mirror: participant.state.isLocal,
        ),
      );
    } else {
      videoView = Container();
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        videoView,
        StreamUserAvatar(
          avatarTheme: const StreamAvatarTheme(
            constraints: BoxConstraints.tightFor(
              height: 100,
              width: 100,
            ),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          user: UserInfo(
            id: participant.state.userId,
            role: participant.state.role,
            imageUrl: participant.state.profileImageURL,
            name: participant.state.name,
          ),
        ),
      ],
    );
  }
}

typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSize extends SingleChildRenderObjectWidget {
  const MeasureSize({
    super.key,
    required this.onChange,
    required Widget super.child,
  });
  final OnWidgetSizeChange onChange;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }

  /* Do not need
  @override
  void updateRenderObject(
      BuildContext context, covariant MeasureSizeRenderObject renderObject) {
    renderObject.onChange = onChange;
  }*/
}

class MeasureSizeRenderObject extends RenderProxyBox {
  MeasureSizeRenderObject(this.onChange);
  final OnWidgetSizeChange onChange;
  Size? oldSize;

  @override
  void performLayout() {
    super.performLayout();

    final newSize = size;
    if (oldSize == newSize) {
      return;
    }
    oldSize = newSize;
    onChange(newSize);
  }
}
