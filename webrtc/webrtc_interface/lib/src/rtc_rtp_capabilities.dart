class RTCRtpCodecCapability {
  RTCRtpCodecCapability(
      {this.channels,
      required this.clockRate,
      required this.mimeType,
      this.sdpFmtpLine});
  factory RTCRtpCodecCapability.fromMap(Map<dynamic, dynamic> map) {
    return RTCRtpCodecCapability(
      channels: map['channels'],
      clockRate: map['clockRate'],
      mimeType: map['mimeType'],
      sdpFmtpLine: map['sdpFmtpLine'],
    );
  }
  num? channels;
  num clockRate;
  String mimeType;
  String? sdpFmtpLine;
  Map<String, dynamic> toMap() {
    return {
      if (channels != null) 'channels': channels,
      'clockRate': clockRate,
      'mimeType': mimeType,
      if (sdpFmtpLine != null) 'sdpFmtpLine': sdpFmtpLine,
    };
  }
}

class RTCRtpHeaderExtensionCapability {
  RTCRtpHeaderExtensionCapability(this.uri);
  factory RTCRtpHeaderExtensionCapability.fromMap(Map<dynamic, dynamic> map) {
    return RTCRtpHeaderExtensionCapability(map['uri']);
  }
  String uri;
  Map<dynamic, dynamic> toMap() {
    return {
      'uri': uri,
    };
  }
}

class RTCRtpCapabilities {
  RTCRtpCapabilities({this.codecs, this.headerExtensions, this.fecMechanisms});
  factory RTCRtpCapabilities.fromMap(Map<dynamic, dynamic> map) {
    var codecs = <RTCRtpCodecCapability>[];
    dynamic codecsMap = map['codecs'];
    codecsMap.forEach((params) {
      codecs.add(RTCRtpCodecCapability.fromMap(params));
    });
    var headerExtensions = <RTCRtpHeaderExtensionCapability>[];
    dynamic headerExtensionsMap = map['headerExtensions'];
    headerExtensionsMap.forEach((params) {
      headerExtensions.add(RTCRtpHeaderExtensionCapability.fromMap(params));
    });
    var fecMechanisms = <String>[];
    dynamic fecMechanismsMap = map['fecMechanisms'];
    fecMechanismsMap.forEach((params) {
      fecMechanisms.add(params);
    });
    return RTCRtpCapabilities(
        codecs: codecs,
        headerExtensions: headerExtensions,
        fecMechanisms: fecMechanisms);
  }
  List<RTCRtpCodecCapability>? codecs;
  List<RTCRtpHeaderExtensionCapability>? headerExtensions;
  List<String>? fecMechanisms;

  Map<String, dynamic> toMap() {
    return {
      'codecs': codecs?.map((e) => e.toMap()).toList(),
      'headerExtensions': headerExtensions?.map((e) => e.toMap()).toList(),
      if (fecMechanisms != null) 'fecMechanisms': fecMechanisms,
    };
  }
}
