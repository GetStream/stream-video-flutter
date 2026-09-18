import 'package:flutter/material.dart';
import '../../../stream_video_flutter.dart';

/// A call control that flips between the front and back camera.
class StreamFlipCameraButton extends StatelessWidget {
  /// Creates a new instance of [StreamFlipCameraButton].
  const StreamFlipCameraButton({
    super.key,
    required this.call,
    this.localParticipant,
    this.frontCameraIcon,
    this.backCameraIcon,
  });

  /// Represents a call.
  final Call call;

  /// The current local participant.
  /// If provided this [localParticipant] will be used, otherwise the localParticipant of the [call] will be used.
  final CallParticipantState? localParticipant;

  /// The icon that is shown when the front camera is active.
  ///
  /// Defaults to `context.streamIcons.cameraFlipFill`, as [backCameraIcon]
  /// does: one glyph covers both, since the button flips rather than toggles.
  final IconData? frontCameraIcon;

  /// The icon that is shown when the back camera is active.
  ///
  /// Defaults to `context.streamIcons.cameraFlipFill`. See [frontCameraIcon].
  final IconData? backCameraIcon;

  /// Whether the platform can switch between a front and a back camera.
  ///
  /// True on iOS and Android only. [Call.flipCamera] throws on web, and a
  /// desktop has no second camera to flip to, so a bar that offers the button
  /// elsewhere offers one that cannot work.
  ///
  /// The button still builds when it is asked to; leave it out of the bar
  /// instead:
  ///
  /// ```dart
  /// if (StreamFlipCameraButton.isSupported) StreamFlipCameraButton(call: call),
  /// ```
  static bool get isSupported => CurrentPlatform.isMobile;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;

    Widget buildContent(TrackState? trackState) {
      CameraPosition? position;
      if (trackState is LocalTrackState) {
        position = trackState.cameraPosition;
      }

      return CallControlButton(
        icon: Icon(
          position == CameraPosition.front
              ? frontCameraIcon ?? icons.cameraFlipFill
              : backCameraIcon ?? icons.cameraFlipFill,
        ),
        onPressed:
            trackState?.muted ==
                false //
            ? call.flipCamera
            : () {},
      );
    }

    if (localParticipant != null) {
      return buildContent(localParticipant!.videoTrack);
    }
    return PartialCallStateBuilder(
      call: call,
      selector: (state) => state.localParticipant?.videoTrack,
      builder: (_, trackState) => buildContent(trackState),
    );
  }
}

/// FlipCameraOption is [StreamFlipCameraButton] now.
@Deprecated(
  'FlipCameraOption is StreamFlipCameraButton now, matching the rest of the '
  'call controls. Will be removed in the next major version.',
)
typedef FlipCameraOption = StreamFlipCameraButton;
