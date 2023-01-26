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
    if (participant == null) {
      return Container(
        alignment: Alignment.center,
        child: const Text('Mock Participant'),
      );
    }
    final renderer = participant.renderer;
    final Widget videoView;
    if (renderer != null) {
      videoView = MeasureSize(
        onChange: (Size size) {
          call.updateTrackSize(
            userId: participant.state.userId,
            trackType: renderer.trackType,
            width: size.width,
            height: size.height,
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

  @override
  void updateRenderObject(
      BuildContext context, covariant MeasureSizeRenderObject renderObject) {
    renderObject.onChange = onChange;
  }
}

class MeasureSizeRenderObject extends RenderProxyBox {
  MeasureSizeRenderObject(this.onChange);
  Size? oldSize;
  OnWidgetSizeChange onChange;

  @override
  void performLayout() {
    super.performLayout();

    var newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}
