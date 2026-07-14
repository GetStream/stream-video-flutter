import 'package:equatable/equatable.dart';

class RtcPrintableStats extends Equatable {
  const RtcPrintableStats({
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
  List<Object?> get props => [local, remote];
}
