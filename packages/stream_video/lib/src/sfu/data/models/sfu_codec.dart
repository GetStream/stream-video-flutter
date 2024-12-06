import 'package:meta/meta.dart';

@immutable
class SfuCodec {
  const SfuCodec({
    required this.mimeType,
    required this.scalabilityMode,
    required this.fmtp,
  });

  final String mimeType;
  final String scalabilityMode;
  final String fmtp;

  @override
  String toString() {
    return 'SfuCodec{mimeType: $mimeType, scalabilityMode: $scalabilityMode, fmtp: $fmtp}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SfuCodec &&
          runtimeType == other.runtimeType &&
          mimeType == other.mimeType &&
          scalabilityMode == other.scalabilityMode &&
          fmtp == other.fmtp;

  @override
  int get hashCode =>
      mimeType.hashCode ^ scalabilityMode.hashCode ^ fmtp.hashCode;
}
