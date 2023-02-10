import 'dart:async';

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';
import '../call_control_option.dart';

const deviceIdSpeaker = 'speaker';
const deviceIdEarpiece = 'earpiece';

/// A widget that represents a call control option to toggle if the
/// speakerphone is on or off.
class ToggleSpeakerphoneOption extends StatefulWidget {
  /// Creates a new instance of [ToggleSpeakerphoneOption].
  const ToggleSpeakerphoneOption({
    super.key,
    this.enabledSpeakerphoneIcon = Icons.volume_up_rounded,
    this.disabledSpeakerphoneIcon = Icons.volume_off_rounded,
  });

  /// The icon that is shown when the speakerphone is enabled.
  final IconData enabledSpeakerphoneIcon;

  /// The icon that is shown when the speakerphone is disabled.
  final IconData disabledSpeakerphoneIcon;

  @override
  State<ToggleSpeakerphoneOption> createState() => _ToggleSpeakerState();
}

class _ToggleSpeakerState extends State<ToggleSpeakerphoneOption> {
  Iterable<MediaDevice>? _audioOutputs;
  StreamSubscription<List<MediaDevice>>? _deviceChangeSubscription;

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
    final enabled =
        Hardware.instance.selectedAudioOutput?.deviceId == deviceIdSpeaker;

    return CallControlOption(
      icon: enabled
          ? Icon(widget.enabledSpeakerphoneIcon)
          : Icon(widget.disabledSpeakerphoneIcon),
      onPressed: () async {
        try {
          // Enable/disable the speaker.
          await _toggleSpeaker(enabled: !enabled);
          setState(() {});
        } catch (_) {}
      },
    );
  }
}
