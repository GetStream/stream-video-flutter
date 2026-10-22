import 'dart:collection';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;
import 'package:webrtc_interface/webrtc_interface.dart';

import 'media_stream_track_impl.dart';
import 'rtc_rtp_parameters_impl.dart';

class RTCRtpReceiverWeb extends RTCRtpReceiver {
  RTCRtpReceiverWeb(this._jsRtpReceiver);

  /// private:
  final web.RTCRtpReceiver _jsRtpReceiver;

  @override
  Future<List<StatsReport>> getStats() async {
    final stats = await _jsRtpReceiver.getStats().toDart;
    final report = <StatsReport>[];
    stats.callMethodVarArgs('forEach'.toJS, [
      (JSObject value, JSAny key) {
        final map = value.dartify()! as LinkedHashMap<Object?, Object?>;
        final stats = <String, dynamic>{};
        for (final entry in map.entries) {
          stats[entry.key.toString()] = entry.value;
        }
        report.add(
          StatsReport(
            value.getProperty<JSString>('id'.toJS).toDart,
            value.getProperty<JSString>('type'.toJS).toDart,
            value.getProperty<JSNumber>('timestamp'.toJS).toDartDouble,
            stats,
          ),
        );
      }.toJS,
    ]);
    return report;
  }

  /// The WebRTC specification only defines RTCRtpParameters in terms of senders,
  /// but this API also applies them to receivers, similar to ORTC:
  /// http://ortc.org/wp-content/uploads/2016/03/ortc.html#rtcrtpparameters*.
  @override
  RTCRtpParameters get parameters {
    final parameters = _jsRtpReceiver.getParameters();
    return RTCRtpParametersWeb.fromJsObject(parameters);
  }

  @override
  MediaStreamTrack get track => MediaStreamTrackWeb(_jsRtpReceiver.track);

  @override
  String get receiverId => '${_jsRtpReceiver.hashCode}';

  web.RTCRtpReceiver get jsRtpReceiver => _jsRtpReceiver;
}
