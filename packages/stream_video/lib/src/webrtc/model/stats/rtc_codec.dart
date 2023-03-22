class RTCCodec {
  RTCCodec({
    this.id,
    this.type,
    this.timestamp,
    this.sdpFmtpLine,
    this.payloadType,
    this.transportId,
    this.mimeType,
    this.clockRate,
  });

  final String? id;
  final String? type;
  final double? timestamp;
  final String? sdpFmtpLine;
  final int? payloadType;
  final String? transportId;
  final String? mimeType;
  final int? clockRate;

  String? get codecId => id;

  static RTCCodec? fromJson(dynamic value) {
    if (value is Map) {
      return RTCCodec(
        id: value['id'],
        type: value['type'],
        timestamp: value['timestamp'],
        sdpFmtpLine: value['sdpFmtpLine'],
        payloadType: value['payloadType'],
        transportId: value['transportId'],
        mimeType: value['mimeType'],
        clockRate: value['clockRate'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'RTCCodec{id: $id, type: $type, timestamp: $timestamp, '
        'sdpFmtpLine: $sdpFmtpLine, payloadType: $payloadType, '
        'transportId: $transportId, mimeType: $mimeType, '
        'clockRate: $clockRate}';
  }
}
