import 'package:flutter/widgets.dart';

import '../../../stream_video_flutter.dart';

/// The lobby's microphone split button: [StreamMicrophoneSplitButton] driven
/// by the lobby's own controller.
///
/// Exists so a preset can list it without wiring anything up. Use
/// [StreamMicrophoneSplitButton] directly anywhere there is no
/// [StreamLobbyScope] — in a call, say.
class StreamLobbyMicrophoneSplitButton extends StatelessWidget {
  /// Creates a new instance of [StreamLobbyMicrophoneSplitButton].
  const StreamLobbyMicrophoneSplitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StreamLobbyScope.of(context);

    return StreamMicrophoneSplitButton(
      devices: controller.devices,
      enabled: controller.microphoneEnabled,
      unavailable: controller.microphoneUnavailable,
      onPressed: controller.toggleMicrophone,
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

    return StreamCameraSplitButton(
      devices: controller.devices,
      enabled: controller.cameraEnabled,
      unavailable: controller.cameraUnavailable,
      onPressed: controller.toggleCamera,
    );
  }
}
