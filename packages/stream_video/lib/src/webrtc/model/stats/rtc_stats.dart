import 'package:equatable/equatable.dart';

class RtcStats {
  RtcStats({
    required this.local,
    required this.remote,
  });

  final String local;
  final String remote;

  @override
  String toString() {
    return 'RtcStats{local: $local, remote: $remote}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RtcStats &&
          runtimeType == other.runtimeType &&
          local == other.local &&
          remote == other.remote;

  @override
  int get hashCode => local.hashCode ^ remote.hashCode;
}
