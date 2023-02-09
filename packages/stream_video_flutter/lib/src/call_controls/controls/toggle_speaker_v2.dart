import 'dart:async';

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../call_controls_v2.dart';

const deviceIdSpeaker = 'speaker';
const deviceIdEarpiece = 'earpiece';

class ToggleSpeakerV2 extends StatefulWidget {
  const ToggleSpeakerV2({
    super.key,
    this.icon = Icons.volume_up_rounded,
    this.inactiveIcon = Icons.volume_off_rounded,
  });

  final IconData icon;
  final IconData inactiveIcon;

  @override
  State<ToggleSpeakerV2> createState() => _ToggleSpeakerStateV2();
}

class _ToggleSpeakerStateV2 extends State<ToggleSpeakerV2> {
  Iterable<MediaDevice>? _audioOutputs;

  Future<void> _toggleSpeaker({bool enabled = false}) async {
    final newAudio = _audioOutputs?.firstWhere((audioOut) {
      if (enabled) return audioOut.deviceId == deviceIdSpeaker;
      return audioOut.deviceId == deviceIdEarpiece;
    });

    if (newAudio == null) return;
    return Hardware.instance.selectAudioOutput(newAudio);
  }

  void _onDeviceChange(List<MediaDevice> devices) {
    final audioOutputs = devices.where((it) => it.kind == 'audiooutput');
    setState(() => _audioOutputs = audioOutputs);
  }

  StreamSubscription<List<MediaDevice>>? _deviceChangeSubscription;

  @override
  void initState() {
    super.initState();
    Hardware.instance.enumerateDevices().then(_onDeviceChange);
    _deviceChangeSubscription =
        Hardware.instance.onDeviceChange.stream.listen(_onDeviceChange);
  }

  @override
  void dispose() {
    _deviceChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSpeakerEnabled =
        Hardware.instance.selectedAudioOutput?.deviceId == deviceIdSpeaker;
    return CallControlOption(
      icon: isSpeakerEnabled ? Icon(widget.icon) : Icon(widget.inactiveIcon),
      onPressed: () async {
        try {
          // Enable/disable the speaker.
          await _toggleSpeaker(enabled: !isSpeakerEnabled);
          setState(() {});
        } catch (_) {}
      },
    );
  }
}
