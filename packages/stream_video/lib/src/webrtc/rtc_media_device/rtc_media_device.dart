import 'package:equatable/equatable.dart';

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
}
