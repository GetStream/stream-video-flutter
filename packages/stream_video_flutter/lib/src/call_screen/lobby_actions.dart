import 'package:flutter/widgets.dart';

import '../../stream_video_flutter.dart';

/// Which controls a `StreamLobbyView` shows, in two lanes.
///
/// **Controls** are the icon buttons that turn the microphone and camera on
/// and off. **Settings** are the fields that pick which device to use. A lane
/// whose list is empty is not drawn at all, so a preset without device
/// pickers leaves no gap where the row would have been.
///
/// The widgets in both lanes read their state from `StreamLobbyScope`, which
/// is why they can be handed over as a plain list: nothing here needs wiring
/// up. That also means anything added through a preset's `extraControls` or
/// `extraSettings` can reach the lobby's controller the same way.
///
/// {@tool snippet}
///
/// ```dart
/// StreamLobbyView(
///   call: call,
///   onJoinCallPressed: join,
///   actions: LobbyActions.full(
///     extraControls: [const StreamLobbyParticipantsControl()],
///   ),
/// )
/// ```
/// {@end-tool}
@immutable
class LobbyActions {
  /// Shows exactly the lanes given, and nothing else.
  const LobbyActions.custom({
    this.controls = const [],
    this.settings = const [],
  });

  /// Microphone and camera toggles, and no device pickers.
  ///
  /// The default, and what a phone-sized lobby usually wants.
  LobbyActions.simple({
    List<Widget> extraControls = const [],
    List<Widget> extraSettings = const [],
  }) : controls = [
         const StreamLobbyMicrophoneToggle(),
         const StreamLobbyCameraToggle(),
         ...extraControls,
       ],
       settings = [...extraSettings];

  /// Microphone and camera toggles with a caret on each for picking the
  /// device, and no separate settings row.
  ///
  /// Fits a narrow lobby that still needs a device choice.
  LobbyActions.regular({
    List<Widget> extraControls = const [],
    List<Widget> extraSettings = const [],
  }) : controls = [
         const StreamLobbyMicrophoneSplitButton(),
         const StreamLobbyCameraSplitButton(),
         ...extraControls,
       ],
       settings = [...extraSettings];

  /// Microphone and camera toggles above a row of device fields.
  ///
  /// The roomiest preset, and the one the web design shows.
  LobbyActions.full({
    List<Widget> extraControls = const [],
    List<Widget> extraSettings = const [],
  }) : controls = [
         const StreamLobbyMicrophoneToggle(),
         const StreamLobbyCameraToggle(),
         ...extraControls,
       ],
       settings = [
         const StreamLobbyMicrophoneSelect(),
         const StreamLobbyCameraSelect(),
         ...extraSettings,
       ];

  /// The icon buttons that turn the microphone and camera on and off.
  final List<Widget> controls;

  /// The fields that pick which device to use.
  final List<Widget> settings;
}
