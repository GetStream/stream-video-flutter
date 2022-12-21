import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

class ControlsWidget extends StatefulWidget {
  const ControlsWidget(
    this.call,
    this.participant, {
    Key? key,
    this.onHangUp,
  }) : super(key: key);

  final Call call;
  final LocalParticipant participant;
  final VoidCallback? onHangUp;

  @override
  State<StatefulWidget> createState() => _ControlsWidgetState();
}

class _ControlsWidgetState extends State<ControlsWidget> {
  Call get call => widget.call;

  CameraPosition position = CameraPosition.front;

  List<MediaDevice>? _audioInputs;
  List<MediaDevice>? _audioOutputs;
  List<MediaDevice>? _videoInputs;
  MediaDevice? _selectedVideoInput;

  StreamSubscription? _deviceChangeSubscription;

  LocalParticipant get participant => widget.participant;

  void _onChange(_) {
    // trigger refresh
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    participant.events.listen(_onChange);
    _deviceChangeSubscription = Hardware.instance.onDeviceChange.stream.listen(
      (devices) => _loadDevices(devices),
    );
    Hardware.instance.enumerateDevices().then(_loadDevices);
  }

  @override
  void dispose() {
    if (participant.events.mounted) {
      participant.events.cancel(_onChange);
    }
    _deviceChangeSubscription?.cancel();
    super.dispose();
  }

  void _loadDevices(List<MediaDevice> devices) async {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
    _audioOutputs = devices.where((d) => d.kind == 'audiooutput').toList();
    _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();
    _selectedVideoInput = _videoInputs?.first;
    setState(() {});
  }

  void _unpublishAll() async {
    final result = await context.showUnPublishDialog();
    if (result == true) await participant.unpublishAllTracks();
  }

  bool get isMuted => participant.isMuted;

  void _disableAudio() async {
    await participant.setMicrophoneEnabled(enabled: false);
  }

  Future<void> _enableAudio() async {
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
    if (track == null) return;
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
      print('could not restart track: $error');
      return;
    }
  }

  void _onTapDisconnect() async {
    final disconnectionConfirmed = await context.showDisconnectDialog();
    if (disconnectionConfirmed == true) {
      await widget.call.disconnect();
      widget.onHangUp?.call();
    }
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
        spacing: 5,
        runSpacing: 5,
        children: [
          IconButton(
            onPressed: _unpublishAll,
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Unpublish all',
          ),
          if (participant.isMicrophoneEnabled)
            PopupMenuButton<MediaDevice>(
              constraints: const BoxConstraints(minWidth: 200),
              icon: const Icon(Icons.settings_voice),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<MediaDevice>(
                    value: null,
                    onTap: isMuted ? _enableAudio : _disableAudio,
                    child: const ListTile(
                      leading: Icon(
                        Icons.mic_off,
                      ),
                      title: Text('Mute Microphone'),
                    ),
                  ),
                  if (_audioInputs != null)
                    ..._audioInputs!.map((device) {
                      return PopupMenuItem<MediaDevice>(
                        value: device,
                        child: ListTile(
                          leading: (device.deviceId ==
                                  Hardware
                                      .instance.selectedAudioInput?.deviceId)
                              ? const Icon(Icons.check_box_rounded)
                              : const Icon(Icons.crop_square_rounded),
                          title: Text(device.label),
                        ),
                        onTap: () => _selectAudioInput(device),
                      );
                    }).toList()
                ];
              },
            )
          else
            IconButton(
              onPressed: _enableAudio,
              icon: const Icon(Icons.mic_off_rounded),
              tooltip: 'un-mute audio',
            ),
          PopupMenuButton<MediaDevice>(
            constraints: const BoxConstraints(minWidth: 200),
            icon: const Icon(Icons.volume_up),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<MediaDevice>(
                  value: null,
                  child: ListTile(
                    leading: Icon(Icons.volume_up_rounded),
                    title: Text('Select Audio Output'),
                  ),
                ),
                if (_audioOutputs != null)
                  ..._audioOutputs!.map((device) {
                    return PopupMenuItem<MediaDevice>(
                      value: device,
                      child: ListTile(
                        leading: (device.deviceId ==
                                Hardware.instance.selectedAudioOutput?.deviceId)
                            ? const Icon(Icons.check_box_rounded)
                            : const Icon(Icons.crop_square_rounded),
                        title: Text(device.label),
                      ),
                      onTap: () => _selectAudioOutput(device),
                    );
                  }).toList()
              ];
            },
          ),
          if (participant.isCameraEnabled)
            PopupMenuButton<MediaDevice>(
              constraints: const BoxConstraints(minWidth: 200),
              icon: const Icon(Icons.videocam_rounded),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<MediaDevice>(
                    value: null,
                    onTap: _disableVideo,
                    child: const ListTile(
                      leading: Icon(Icons.videocam_off_rounded),
                      title: Text('Disable Camera'),
                    ),
                  ),
                  if (_videoInputs != null)
                    ..._videoInputs!.map((device) {
                      return PopupMenuItem<MediaDevice>(
                        value: device,
                        child: ListTile(
                          leading:
                              (device.deviceId == _selectedVideoInput?.deviceId)
                                  ? const Icon(Icons.check_box_rounded)
                                  : const Icon(Icons.crop_square_rounded),
                          title: Text(device.label),
                        ),
                        onTap: () => _selectVideoInput(device),
                      );
                    }).toList()
                ];
              },
            )
          else
            IconButton(
              onPressed: _enableVideo,
              icon: const Icon(Icons.videocam_off_rounded),
              tooltip: 'un-mute video',
            ),
          IconButton(
            icon: Icon(
              position == CameraPosition.back
                  ? Icons.camera_rear_rounded
                  : Icons.camera_front_rounded,
            ),
            onPressed: () => _toggleCamera(),
            tooltip: 'toggle camera',
          ),
          IconButton(
            onPressed: _onTapDisconnect,
            icon: const Icon(
              Icons.call_end_rounded,
              color: Colors.redAccent,
            ),
            tooltip: 'disconnect',
          ),
        ],
      ),
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
