import 'package:meta/meta.dart';

@immutable
class SfuCodec {
  const SfuCodec({
    required this.payloadType,
    required this.name,
    required this.fmtpLine,
    required this.clockRate,
    required this.encodingParameters,
  });

  final int payloadType;
  final String name;
  final String fmtpLine;
  final int clockRate;
  final String encodingParameters;

  @override
  String toString() {
    return 'SfuCodec{payloadType: $payloadType, name: $name, '
        'fmtpLine: $fmtpLine, clockRate: $clockRate, '
        'encodingParameters: $encodingParameters}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SfuCodec &&
          runtimeType == other.runtimeType &&
          payloadType == other.payloadType &&
          name == other.name &&
          fmtpLine == other.fmtpLine &&
          clockRate == other.clockRate &&
          encodingParameters == other.encodingParameters;

  @override
  int get hashCode =>
      payloadType.hashCode ^
      name.hashCode ^
      fmtpLine.hashCode ^
      clockRate.hashCode ^
      encodingParameters.hashCode;
}
