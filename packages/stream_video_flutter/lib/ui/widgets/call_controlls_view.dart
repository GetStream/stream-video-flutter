import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/ui/widgets/common/control_buttons.dart';

const borderRadiusTop = 20.0;

class CallControlsView extends StatefulWidget {
  const CallControlsView(
    this.call,
    this.participant, {
    Key? key,
  }) : super(key: key);

  final Call call;
  final LocalParticipant participant;

  @override
  State<CallControlsView> createState() => _CallControlsViewState();
}

class _CallControlsViewState extends State<CallControlsView> {
  Call get call => widget.call;

  CameraPosition position = CameraPosition.front;

  List<MediaDevice>? _audioOutputs;

  StreamSubscription? _deviceChangeSubscription;

  LocalParticipant get participant => widget.participant;

  @override
  void initState() {
    super.initState();
    _deviceChangeSubscription =
        Hardware.instance.onDeviceChange.stream.listen(_loadDevices);
    Hardware.instance.enumerateDevices().then(_loadDevices);
  }

  void _loadDevices(List<MediaDevice> devices) async {
    _audioOutputs =
        devices.where((device) => device.kind == 'audiooutput').toList();

    setState(() {});
  }

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

  void _disconnect() async {
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
    participant.events.cancel(_onChange);
    _deviceChangeSubscription?.cancel();
    super.dispose();
  }

  Widget toggleSoundButton() {
    return ControlToggleButton(
      Icons.volume_up,
      Icons.volume_up_outlined,
      isPhoneSpeakerSelected(),
      _toggleSpeaker,
    );
  }

  Widget toggleVideoButton() {
    return ControlToggleButton(
      Icons.video_camera_front,
      Icons.video_camera_front_outlined, //Find a icon from video cancellation
      participant.isCameraEnabled,
      _toggleVideo,
    );
  }

  Widget toggleMicButton() {
    return ControlToggleButton(
      Icons.mic,
      Icons.mic_off,
      participant.isMicrophoneEnabled,
      _toggleMic,
    );
  }

  Widget switchCameraButton() {
    return ControlButton(
      Icons.flip_camera_ios,
      _switchCamera,
      backgroundColor: Colors.white,
      iconColor: Colors.black,
    );
  }

  Widget hangUpButton() {
    return ControlButton(
      Icons.phone,
      _disconnect,
      backgroundColor: Colors.red,
      iconColor: Colors.white,
    );
  }

  List<Widget> getButtons() {
    var widgetList = <Widget>[];

    bool isMobile = Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.android;

    if (isMobile && _audioOutputs?.length == 2) {
      widgetList.add(toggleSoundButton());
    }

    widgetList.add(toggleVideoButton());
    widgetList.add(toggleMicButton());

    if (isMobile) {
      widgetList.add(switchCameraButton());
    }

    widgetList.add(hangUpButton());

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(borderRadiusTop),
        topRight: Radius.circular(borderRadiusTop),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadiusTop),
            topRight: Radius.circular(borderRadiusTop),
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
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
