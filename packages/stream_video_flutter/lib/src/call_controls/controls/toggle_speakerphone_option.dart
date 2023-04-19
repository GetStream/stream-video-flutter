import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

// These are eyeballed device IDs for the speaker and earpiece.
// based on Android and iOS enumerated devices.
const deviceIdSpeaker = 'speaker';
const deviceIdEarpiece = 'earpiece';

/// A widget that represents a call control option to toggle if the
/// speakerphone is on or off.
///
/// This widget is only available on Android and iOS.
class ToggleSpeakerphoneOption extends StatefulWidget {
  /// Creates a new instance of [ToggleSpeakerphoneOption].
  const ToggleSpeakerphoneOption({
    super.key,
    required this.call,
    this.enabledSpeakerphoneIcon = Icons.volume_up_rounded,
    this.disabledSpeakerphoneIcon = Icons.volume_off_rounded,
  });

  /// Represents a call.
  final Call call;

  /// The icon that is shown when the speakerphone is enabled.
  final IconData enabledSpeakerphoneIcon;

  /// The icon that is shown when the speakerphone is disabled.
  final IconData disabledSpeakerphoneIcon;

  @override
  State<ToggleSpeakerphoneOption> createState() => _ToggleSpeakerState();
}

class _ToggleSpeakerState extends State<ToggleSpeakerphoneOption> {
  final _deviceNotifier = RtcMediaDeviceNotifier.instance;
  StreamSubscription<List<RtcMediaDevice>>? _deviceChangeSubscription;

  var _audioOutputs = <RtcMediaDevice>[];

  Future<void> _setSpeakerphoneEnabled({bool enabled = false}) async {
    final audioOutputs = _audioOutputs;
    if (audioOutputs.isEmpty) return;

    var device = audioOutputs.firstWhereOrNull(
      (it) => it.id.equalsIgnoreCase(
        enabled ? deviceIdSpeaker : deviceIdEarpiece,
      ),
    );

    if (!enabled && device == null) {
      // In IOS, we don't have earpiece as a listed device. So we will try to
      // create a new device with the earpiece ID.
      if (CurrentPlatform.isIos) {
        device = const RtcMediaDevice(
          id: deviceIdEarpiece,
          kind: RtcMediaDeviceKind.audioOutput,
          label: 'Earpiece',
        );
      }
    }

    // If we don't have a device, we can't set it as the audio output.
    if (device == null) return;

    // Set the device as the current audio output.
    await widget.call.setAudioOutputDevice(device);
  }

  @override
  void initState() {
    super.initState();
    _deviceChangeSubscription =
        _deviceNotifier.onDeviceChange.listen((devices) {
      final audioOutputs = devices.where(
        (it) => it.kind == RtcMediaDeviceKind.audioOutput,
      );
      _audioOutputs = audioOutputs.toList();
    });
  }

  @override
  void dispose() {
    _deviceChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var enabled = false;

    final callState = widget.call.state.valueOrNull;
    final audioOutputDevice = callState?.audioOutputDevice;
    if (audioOutputDevice != null) {
      enabled = audioOutputDevice.id.equalsIgnoreCase(deviceIdSpeaker);
    }

    return CallControlOption(
      icon: enabled
          ? Icon(widget.enabledSpeakerphoneIcon)
          : Icon(widget.disabledSpeakerphoneIcon),
      onPressed: () async {
        try {
          // Enable/disable the speaker.
          await _setSpeakerphoneEnabled(enabled: !enabled);
        } catch (_) {}
      },
    );
  }
}

extension on String {
  bool equalsIgnoreCase(String other) => toUpperCase() == other.toUpperCase();
}
