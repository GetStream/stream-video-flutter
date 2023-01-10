class SfuCodec {
  SfuCodec({
    required this.payloadType,
    required this.name,
    required this.fmtpLine,
    required this.clockRate,
    required this.encodingParameters,
    required this.feedbacks,
  });

  final int payloadType;
  final String name;
  final String fmtpLine;
  final int clockRate;
  final String encodingParameters;
  final List<String> feedbacks;

  @override
  String toString() {
    return 'SfuCodec{payloadType: $payloadType, name: $name, '
        'fmtpLine: $fmtpLine, clockRate: $clockRate, '
        'encodingParameters: $encodingParameters, feedbacks: $feedbacks}';
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
          encodingParameters == other.encodingParameters &&
          feedbacks == other.feedbacks;

  @override
  int get hashCode =>
      payloadType.hashCode ^
      name.hashCode ^
      fmtpLine.hashCode ^
      clockRate.hashCode ^
      encodingParameters.hashCode ^
      feedbacks.hashCode;
}
