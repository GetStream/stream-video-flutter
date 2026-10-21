import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;
import 'package:webrtc_interface/webrtc_interface.dart';

class RTCRtpParametersWeb {
  static RTCRtpParameters fromJsObject(web.RTCRtpParameters object) {
    final transactionId =
        object.getProperty<JSString?>('transactionId'.toJS)?.toDart;
    return RTCRtpParameters(
        transactionId: transactionId,
        rtcp: transactionId != null
            ? RTCRTCPParametersWeb.fromJsObject(object.rtcp)
            : null,
        headerExtensions: headerExtensionsFromJsObject(object),
        encodings: encodingsFromJsObject(object),
        codecs: codecsFromJsObject(object));
  }

  static List<RTCHeaderExtension> headerExtensionsFromJsObject(
      web.RTCRtpParameters object) {
    return object.headerExtensions.toDart.map((e) {
      final map = (e as JSObject).dartify() as Map;
      if (map.containsKey('id')) {
        map['id'] = (map['id'] as num).toInt();
      }
      return RTCHeaderExtension.fromMap(map);
    }).toList();
  }

  static List<RTCRtpEncoding> encodingsFromJsObject(JSObject object) {
    var encodings = object.hasProperty('encodings'.toJS).toDart
        ? object.getProperty<JSArray>('encodings'.toJS).toDart
        : [];
    var list = <RTCRtpEncoding>[];
    encodings.forEach((e) {
      list.add(RTCRtpEncodingWeb.fromJsObject(e));
    });
    return list;
  }

  static List<RTCRTPCodec> codecsFromJsObject(JSObject object) {
    var encodings = object.hasProperty('codecs'.toJS).toDart
        ? object.getProperty<JSArray>('codecs'.toJS).toDart
        : [];
    var list = <RTCRTPCodec>[];
    encodings.forEach((e) {
      list.add(RTCRTPCodecWeb.fromJsObject(e));
    });
    return list;
  }
}

class RTCRTCPParametersWeb {
  static RTCRTCPParameters fromJsObject(web.RTCRtcpParameters object) {
    return RTCRTCPParameters.fromMap(
        {'cname': object.cname, 'reducedSize': object.reducedSize});
  }
}

class RTCHeaderExtensionWeb {
  static RTCHeaderExtension fromJsObject(
      web.RTCRtpHeaderExtensionParameters object) {
    return RTCHeaderExtension.fromMap(
        {'uri': object.uri, 'id': object.id, 'encrypted': object.encrypted});
  }
}

class RTCRtpEncodingWeb {
  static RTCRtpEncoding fromJsObject(web.RTCRtpEncodingParameters object) {
    return RTCRtpEncoding.fromMap({
      'rid': object.getProperty<JSString?>('rid'.toJS).dartify(),
      'active': object.active,
      'maxBitrate': object.getProperty<JSNumber?>('maxBitrate'.toJS)?.toDartInt,
      'maxFramerate':
          object.getProperty<JSNumber?>('maxFramerate'.toJS)?.toDartInt,
      'minBitrate': object.getProperty<JSNumber?>('minBitrate'.toJS)?.toDartInt,
      'numTemporalLayers':
          object.getProperty<JSNumber?>('numTemporalLayers'.toJS)?.toDartInt,
      'scaleResolutionDownBy': object
          .getProperty<JSNumber?>('scaleResolutionDownBy'.toJS)
          ?.toDartDouble,
      'ssrc': object.getProperty<JSNumber?>('ssrc'.toJS)?.toDartInt,
      'priority': object.getProperty<JSString?>('priority'.toJS)?.toDart,
      'networkPriority':
          object.getProperty<JSString?>('networkPriority'.toJS)?.toDart,
      'scalabilityMode':
          object.getProperty<JSString?>('scalabilityMode'.toJS)?.toDart,
    });
  }
}

class RTCRTPCodecWeb {
  static RTCRTPCodec fromJsObject(web.RTCRtpCodecParameters object) {
    return RTCRTPCodec.fromMap({
      'payloadType': object.payloadType,
      'name': object.getProperty<JSString?>('name'.toJS)?.toDart,
      'kind': object.getProperty<JSString?>('kind'.toJS)?.toDart,
      'clockRate': object.clockRate,
      'numChannels':
          object.getProperty<JSNumber?>('numChannels'.toJS)?.toDartInt,
      'parameters': object.getProperty<JSObject?>('parameters'.toJS)?.dartify(),
    });
  }
}
