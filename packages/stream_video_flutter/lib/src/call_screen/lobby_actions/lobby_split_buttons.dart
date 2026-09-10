import 'package:flutter/widgets.dart';

import '../../../stream_video_flutter.dart';

/// The lobby's microphone split button: [StreamMicrophoneSplitButton] driven
/// by the lobby's own controller.
///
/// Exists so a preset can list it without wiring anything up. In a call reach
/// for [StreamMicrophoneSplitButton] instead, whose default constructor takes
/// the call and needs no wiring either.
class StreamLobbyMicrophoneSplitButton extends StatelessWidget {
  /// Creates a new instance of [StreamLobbyMicrophoneSplitButton].
  const StreamLobbyMicrophoneSplitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);

    return StreamMicrophoneSplitButton.withDevices(
      devices: controller.devices,
      enabled: controller.microphoneEnabled,
      unavailable: controller.microphoneUnavailable,
      // Badged either way, but only a device the platform does not report at
      // all is unpressable: retrying is what clears a failed open.
      onPressed: controller.microphoneMissing
          ? null
          : controller.toggleMicrophone,
    );
  }
}

/// The lobby's camera split button. See [StreamLobbyMicrophoneSplitButton].
class StreamLobbyCameraSplitButton extends StatelessWidget {
  /// Creates a new instance of [StreamLobbyCameraSplitButton].
  const StreamLobbyCameraSplitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);

    return StreamCameraSplitButton.withDevices(
      devices: controller.devices,
      enabled: controller.cameraEnabled,
      unavailable: controller.cameraUnavailable,
      onPressed: controller.cameraMissing ? null : controller.toggleCamera,
    );
  }
}
