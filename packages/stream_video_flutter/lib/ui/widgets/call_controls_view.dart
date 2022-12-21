import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/theme/stream_controls_theme.dart';
import 'package:stream_video_flutter/theme/stream_video_theme.dart';
import 'package:stream_video_flutter/ui/widgets/common/control_buttons.dart';

const deviceIdSpeaker = "speaker";
const deviceIdEarpiece = "earpiece";

/// Widget with control commands for a Call. This Widget provide the UI and
/// logic to change audio input/output, video output, switch camera and hang up
/// accordingly with the platform using this Widget.
class CallControlsView extends StatefulWidget {
  const CallControlsView({
    Key? key,
    required this.call,
    required this.participant,
    this.theme,
  }) : super(key: key);

  final Call call;
  final LocalParticipant participant;

  final StreamControlsTheme? theme;

  @override
  State<CallControlsView> createState() => _CallControlsViewState();
}

class _CallControlsViewState extends State<CallControlsView> {
  Call get call => widget.call;

  CameraPosition position = CameraPosition.front;

  List<MediaDevice>? _audioOutputs;

  StreamSubscription? _deviceChangeSubscription;

  LocalParticipant get participant => widget.participant;

  bool get isMobile =>
      Theme.of(context).platform == TargetPlatform.iOS ||
      Theme.of(context).platform == TargetPlatform.android;

  @override
  void initState() {
    super.initState();
    _deviceChangeSubscription =
        Hardware.instance.onDeviceChange.stream.listen(_loadDevices);
    Hardware.instance.enumerateDevices().then(_loadDevices);
  }

  ///
  StreamControlsTheme _getTheme() {
    final streamVideoTheme = StreamVideoTheme.of(context);
    return widget.theme ?? streamVideoTheme.controlsTheme;
  }

  void _loadDevices(List<MediaDevice> devices) async {
    _audioOutputs =
        devices.where((device) => device.kind == 'audiooutput').toList();

    setState(() {});
  }

  /// Returns if the the speaker being used is the internal one.
  bool _isPhoneSpeakerSelected() {
    return Hardware.instance.selectedAudioOutput?.deviceId == deviceIdSpeaker;
  }

  /// Toggles speaker if another option is available. It should not be possible
  /// to call this function when only one option if available, Example: user
  /// is using the smartphone speaker without headphones.
  void _toggleSpeaker() async {
    var audioSelected = Hardware.instance.selectedAudioOutput?.deviceId;
    MediaDevice? newAudio;

    if (audioSelected == deviceIdSpeaker) {
      newAudio = _audioOutputs
          ?.firstWhere((audioOut) => audioOut.deviceId == deviceIdEarpiece);
    } else {
      newAudio = _audioOutputs
          ?.firstWhere((audioOut) => audioOut.deviceId == deviceIdSpeaker);
    }

    if (newAudio != null) {
      await Hardware.instance.selectAudioOutput(newAudio);
      setState(() {});
    }
  }

  ///Enables/Disables video
  void _toggleVideo() async {
    await participant.setCameraEnabled(enabled: !participant.isCameraEnabled);
    setState(() {});
  }

  ///Enables/Disables microfone
  void _toggleMic() async {
    await participant.setMicrophoneEnabled(
      enabled: !participant.isMicrophoneEnabled,
    );
    setState(() {});
  }

  /// Switch between front and back camera. It should not be possible to call
  /// this function when there are only 1 or no video tracks.
  void _switchCamera() async {
    //
    final track = participant.videoTracks.firstOrNull?.track;
    if (track == null) return;

    try {
      final newPosition = position.switched();
      await track.setCameraPosition(newPosition);
      setState(() {
        position = newPosition;
      });
    } catch (error) {
      return;
    }
  }

  /// Confirms disconnection. If result is true, disconnects and navigates back.
  void _hangUp() async {
    final result = await showDisconnectDialog(context);
    if (result == true) {
      await widget.call.disconnect();
      Navigator.of(context).pop();
    }
  }

  /// Triggers refresh
  void _onChange(_) {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    participant.events.cancel(_onChange);
    _deviceChangeSubscription?.cancel();
    participant.unpublishAllTracks();
  }

  @override
  Widget build(BuildContext context) {
    var theme = _getTheme();

    return Material(
      elevation: theme.elevation,
      borderRadius: theme.borderRadius,
      color: theme.bgColor,
      child: Container(
        padding: theme.padding,
        decoration: BoxDecoration(borderRadius: theme.borderRadius),
        child: ControlButtonWrapper(
          theme: theme,
          isPhoneSpeakerSelected: _isPhoneSpeakerSelected(),
          toggleSpeaker: _toggleSpeaker,
          toggleVideo: _toggleVideo,
          toggleMic: _toggleMic,
          switchCamera: _switchCamera,
          hangUp: _hangUp,
          participant: participant,
        ),
      ),
    );
  }

  Future<bool?> showDisconnectDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Disconnect'),
        content: const Text('Are you sure to disconnect?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );
  }
}
