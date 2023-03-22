class RtcPrintableStats {
  RtcPrintableStats({
    required this.local,
    required this.remote,
  });

  final String local;
  final String remote;

  @override
  String toString() {
    return 'RtcPrintableStats{local: $local, remote: $remote}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RtcPrintableStats &&
          runtimeType == other.runtimeType &&
          local == other.local &&
          remote == other.remote;

  @override
  int get hashCode => local.hashCode ^ remote.hashCode;
}
