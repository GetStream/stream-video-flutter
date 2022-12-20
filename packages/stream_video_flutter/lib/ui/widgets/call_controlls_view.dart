import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/theme/stream_controls_theme.dart';
import 'package:stream_video_flutter/theme/stream_video_theme.dart';
import 'package:stream_video_flutter/ui/widgets/common/control_buttons.dart';

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
  List<MediaDevice>? _videoOutputs;

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

  StreamControlsTheme getTheme() {
    final streamChatTheme = StreamVideoTheme.of(context);
    return widget.theme ?? streamChatTheme.controlsTheme;
  }

  void _loadDevices(List<MediaDevice> devices) async {
    _audioOutputs =
        devices.where((device) => device.kind == 'audiooutput').toList();
    _videoOutputs =
        devices.where((device) => device.kind == 'videooutput').toList();

    setState(() {});
  }

  /// Toggles speaker if another option is available. It should not be possible
  /// to call this function when only one option if available, Example: user
  /// is using the smartphone speaker without headphones.
  void _toggleSpeaker() async {
    var audioSelected = Hardware.instance.selectedAudioOutput?.deviceId;

    var newAudio = _audioOutputs
        ?.firstWhere((audioOut) => audioOut.deviceId != audioSelected);

    if (newAudio != null) {
      await Hardware.instance.selectAudioOutput(newAudio);
      setState(() {});
    }
  }

  void _toggleVideo() async {
    await participant.setCameraEnabled(enabled: !participant.isCameraEnabled);
    setState(() {});
  }

  void _toggleMic() async {
    await participant.setMicrophoneEnabled(
      enabled: !participant.isMicrophoneEnabled,
    );
    setState(() {});
  }

  bool isPhoneSpeakerSelected() {
    return Hardware.instance.selectedAudioOutput?.deviceId == "speaker";
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
    final result = await context.showDisconnectDialog();
    if (result == true) {
      await widget.call.disconnect();
      Navigator.of(context).pop();
    }
  }

  void _onChange(_) {
    // trigger refresh
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    participant.events.cancel(_onChange);
    _deviceChangeSubscription?.cancel();
    participant.unpublishAllTracks();
  }

  Widget toggleSpeakerButton() {
    return ControlToggleButton(
      getTheme().toggleSpeakerIconEnabled,
      getTheme().toggleSpeakerIconDisabled,
      isPhoneSpeakerSelected(),
      getTheme().getToggleSpeakerStyle(),
      _toggleSpeaker,
    );
  }

  Widget toggleVideoButton() {
    return ControlToggleButton(
      getTheme().toggleVideoIconEnabled,
      getTheme().toggleVideoIconDisabled,
      participant.isCameraEnabled,
      getTheme().getToggleVideoStyle(),
      _toggleVideo,
    );
  }

  Widget toggleMicButton() {
    return ControlToggleButton(
      getTheme().toggleMicIconEnabled,
      getTheme().toggleMicIconDisabled,
      participant.isMicrophoneEnabled,
      getTheme().getToggleMicStyle(),
      _toggleMic,
    );
  }

  Widget switchCameraButton() {
    return ControlButton(
      getTheme().switchCameraIcon,
      getTheme().getSwitchCameraStyle(),
      _switchCamera,
    );
  }

  Widget hangUpButton() {
    return ControlButton(
      getTheme().handUpCameraIcon,
      getTheme().getHangUpStyle(),
      _hangUp,
    );
  }

  ///Gets all the buttons. The buttons may change accordingly with the platform
  ///and resources available. Example: There's no swtich camera button for
  ///a chrome user.
  List<Widget> getButtons() {
    var widgetList = <Widget>[];

    bool isMobile = Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.android;

    if (isMobile && _audioOutputs?.length == 2) {
      widgetList.add(toggleSpeakerButton());
    }

    widgetList.add(toggleVideoButton());
    widgetList.add(toggleMicButton());

    if (isMobile && _videoOutputs?.length == 2) {
      widgetList.add(switchCameraButton());
    }

    widgetList.add(hangUpButton());

    return widgetList;
  }

  /// Buttons take all the space when in mobile, but in other platforms they
  /// take only a small space and don't expand without limit to avoid ungly
  /// UIs.
  WrapAlignment getButtonsAlignment() {
    if (isMobile) {
      return getTheme().buttonsAlignmentMobile;
    } else {
      return getTheme().buttonsAlignmentDesktop;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: getTheme().elevation,
      borderRadius: getTheme().borderRadius,
      child: Container(
        padding: getTheme().padding,
        decoration: BoxDecoration(borderRadius: getTheme().borderRadius),
        child: Wrap(
          alignment: getButtonsAlignment(),
          spacing: getTheme().buttonsSpacing,
          children: getButtons(),
        ),
      ),
    );
  }
}

extension on BuildContext {
  Future<bool?> showDisconnectDialog() {
    return showDialog<bool>(
      context: this,
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
