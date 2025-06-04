import 'package:equatable/equatable.dart';

import '../../platform_detector/platform_detector.dart';

enum RtcMediaDeviceKind {
  audioInput('audioinput'),
  audioOutput('audiooutput'),
  videoInput('videoinput'),
  unknown('unknown');

  const RtcMediaDeviceKind(this.alias);

  factory RtcMediaDeviceKind.fromAlias(String? alias) {
    return RtcMediaDeviceKind.values.firstWhere(
      (it) => it.alias == alias,
      orElse: () => RtcMediaDeviceKind.unknown,
    );
  }

  final String alias;

  @override
  String toString() => alias;
}

class RtcMediaDevice with EquatableMixin {
  const RtcMediaDevice({
    required this.id,
    required this.label,
    required this.kind,
    this.groupId,
  });

  final String id;
  final String label;
  final String? groupId;
  final RtcMediaDeviceKind kind;

  @override
  String toString() {
    return 'RtcMediaDevice{id: $id, label: $label, groupId: $groupId, kind: $kind}';
  }

  @override
  List<Object?> get props => [id, kind, groupId, label];

  /// The set of external audio ports that are considered external outputs
  static const Set<String> iOSExternalPorts = {
    'bluetoothA2DP',
    'bluetoothLE',
    'bluetoothHFP',
    'carAudio',
    'headphones',
  };

  /// The set of external audio device types that are considered external outputs
  static const Set<String> androidExternalAudioDeviceType = {
    'bluetooth',
    'wired-headset',
  };

  /// Whether this device represents an external audio output.
  /// Checks if the device label contains any of the external port types.
  bool get isExternal {
    if (groupId == null) {
      return false;
    }

    if (CurrentPlatform.isIos) {
      return iOSExternalPorts.any(
        (port) => groupId!.toLowerCase().contains(
              port.toLowerCase(),
            ),
      );
    } else if (CurrentPlatform.isAndroid) {
      return androidExternalAudioDeviceType.any(
        (type) => groupId!.toLowerCase().contains(
              type.toLowerCase(),
            ),
      );
    } else {
      return groupId!.toLowerCase().contains('bluetooth');
    }
  }

  bool get isSpeaker => id.toLowerCase() == 'speaker';

  bool get isEarpiece => id.toLowerCase() == 'earpiece';
}
