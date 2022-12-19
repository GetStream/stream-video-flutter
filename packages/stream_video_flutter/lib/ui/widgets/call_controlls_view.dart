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

  List<MediaDevice>? _audioInputs;
  List<MediaDevice>? _audioOutputs;
  List<MediaDevice>? _videoInputs;
  MediaDevice? _selectedVideoInput;

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
    _audioInputs =
        devices.where((device) => device.kind == 'audioinput').toList();
    _audioOutputs =
        devices.where((device) => device.kind == 'audiooutput').toList();
    _videoInputs =
        devices.where((device) => device.kind == 'videoinput').toList();
    _selectedVideoInput = _videoInputs?.first;
    setState(() {});
  }

  void _toggleSound() async {
    await participant.setMicrophoneEnabled(enabled: true);
    setState(() {});
  }

  void _toggleVideo() async {
    await participant.setCameraEnabled(enabled: true);
    setState(() {});
  }

  void _toggleMic() async {
    await participant.setMicrophoneEnabled(enabled: true);
    setState(() {});
  }

  void _selectAudioOutput(MediaDevice device) async {
    await Hardware.instance.selectAudioOutput(device);
    setState(() {});
  }

  void _selectAudioInput(MediaDevice device) async {
    await Hardware.instance.selectAudioInput(device);
    setState(() {});
  }

  void _selectVideoInput(MediaDevice device) async {
    final track = participant.videoTracks.firstOrNull?.track;
    if (track == null) return; //Log error here or make this state unclickable
    if (_selectedVideoInput?.deviceId != device.deviceId) {
      await track.switchCamera(device.deviceId);
      _selectedVideoInput = device;
      setState(() {});
    }
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
      // print('could not restart track: $error');
      return;
    }
  }

  void _disconnect() async {
    final result = await context.showDisconnectDialog();
    if (result == true) await widget.call.disconnect();
  }

  void _unpublishAll() async {
    final result = await context.showUnPublishDialog();
    // if (result == true) await participant.unpublishAllTracks();
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          toggleSoundButton(),
          toggleVideoButton(),
          toggleMicButton(),
          switchCameraButton(),
          hangUpButton(),
        ],
      ),
    );
  }

  Widget toggleSoundButton() {
    return ControlToggleButton(
      Icons.volume_up,
      Icons.volume_off,
      participant.isMicrophoneEnabled,
      participant.isMuted,
      _toggleSound,
    );
  }

  Widget toggleVideoButton() {
    return ControlToggleButton(
      Icons.video_camera_front,
      Icons.video_camera_front_outlined, //Find a icon from video cancellation
      participant.isMicrophoneEnabled,
      participant.isMuted,
      _toggleVideo,
    );
  }

  Widget toggleMicButton() {
    return ControlToggleButton(
      Icons.mic,
      Icons.mic_off,
      participant.isMicrophoneEnabled,
      participant.isMuted,
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
}

extension on BuildContext {
  Future<bool?> showUnPublishDialog() => showDialog<bool>(
    context: this,
    builder: (ctx) => AlertDialog(
      title: const Text('UnPublish'),
      content:
      const Text('Would you like to un-publish your Camera & Mic ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('NO'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('YES'),
        ),
      ],
    ),
  );

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
