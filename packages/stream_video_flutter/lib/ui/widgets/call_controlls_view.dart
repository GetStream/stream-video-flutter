import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/ui/widgets/common/control_toggle_button.dart';

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
    // _deviceChangeSubscription =
    //     Hardware.instance.onDeviceChange.stream.listen(_loadDevices);
    // Hardware.instance.enumerateDevices().then(_loadDevices);
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

  void _disableAudio() async {
    await participant.setMicrophoneEnabled(enabled: false);
  }

  void _enableAudio() async {
    await participant.setMicrophoneEnabled(enabled: true);
  }

  void _disableVideo() async {
    await participant.setCameraEnabled(enabled: false);
  }

  void _enableVideo() async {
    await participant.setCameraEnabled(enabled: true);
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

  void _toggleCamera() async {
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
    await widget.call.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          ControlToggleButton(
            Icons.mic_none_rounded,
            Icons.mic_off_rounded,
            participant,
          ),
          controlButton(),
          controlButton(),
          controlButton(),
          controlButton(),
        ],
      ),
    );
  }

  Widget controlButton() {
    return IconButton(
      icon: const Icon(Icons.close_rounded),
      onPressed: () => {},
    );
  }

  Widget muteButton() {
    return ControlToggleButton(
      Icons.mic_none_rounded,
      Icons.mic_off_rounded,
      participant,
    );
  }
}
