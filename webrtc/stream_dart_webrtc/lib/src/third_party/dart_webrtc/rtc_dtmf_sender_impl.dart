import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';
import 'package:web/web.dart' as web;

class RTCDTMFSenderWeb extends RTCDTMFSender {
  RTCDTMFSenderWeb(this._jsDtmfSender);
  final web.RTCDTMFSender _jsDtmfSender;

  @override
  Future<void> insertDTMF(
    String tones, {
    int duration = 100,
    int interToneGap = 70,
  }) async {
    return _jsDtmfSender.insertDTMF(tones, duration, interToneGap);
  }

  @override
  Future<bool> canInsertDtmf() async {
    return _jsDtmfSender.canInsertDTMF;
  }
}
