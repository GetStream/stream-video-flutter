import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;
import 'package:webrtc_interface/webrtc_interface.dart';

class RTCDataChannelWeb extends RTCDataChannel {
  RTCDataChannelWeb(this._jsDc) {
    stateChangeStream = _stateChangeController.stream;
    messageStream = _messageController.stream;

    _jsDc.onclose = (web.Event _) {
      _state = RTCDataChannelState.RTCDataChannelClosed;
      _stateChangeController.add(_state);
      onDataChannelState?.call(_state);
    }.toJS;

    _jsDc.onopen = (web.Event _) {
      _state = RTCDataChannelState.RTCDataChannelOpen;
      _stateChangeController.add(_state);
      onDataChannelState?.call(_state);
    }.toJS;

    _jsDc.onmessage = (web.MessageEvent event) {
      _parse(event.data.dartify()).then((msg) {
        _messageController.add(msg);
        onMessage?.call(msg);
      });
    }.toJS;

    _jsDc.onbufferedamountlow = (web.Event _) {
      onBufferedAmountLow?.call(bufferedAmount ?? 0);
    }.toJS;
  }

  final web.RTCDataChannel _jsDc;
  RTCDataChannelState _state = RTCDataChannelState.RTCDataChannelConnecting;

  @override
  RTCDataChannelState get state => _state;

  @override
  int? get id => _jsDc.id;

  @override
  String? get label => _jsDc.label;

  @override
  int? get bufferedAmount => _jsDc.bufferedAmount;

  @override
  Future<int> getBufferedAmount() async {
    return _jsDc.bufferedAmount;
  }

  @override
  int? get bufferedAmountLowThreshold => _jsDc.bufferedAmountLowThreshold;

  @override
  set bufferedAmountLowThreshold(int? bufferedAmountLowThreshold) {
    _jsDc.bufferedAmountLowThreshold = bufferedAmountLowThreshold ?? 0;
  }

  final _stateChangeController =
      StreamController<RTCDataChannelState>.broadcast(sync: true);
  final _messageController =
      StreamController<RTCDataChannelMessage>.broadcast(sync: true);

  Future<RTCDataChannelMessage> _parse(dynamic data) async {
    if (data is String) {
      return RTCDataChannelMessage(data);
    }
    if (data is ByteBuffer) {
      return RTCDataChannelMessage.fromBinary(data.asUint8List());
    } else if (data is web.Blob) {
      final arrayBuffer = await data.arrayBuffer().toDart;
      return RTCDataChannelMessage.fromBinary(arrayBuffer.toDart.asUint8List());
    }
    return RTCDataChannelMessage.fromBinary(Uint8List(0));
  }

  @override
  Future<void> send(RTCDataChannelMessage message) {
    if (!message.isBinary) {
      _jsDc.send(message.text.toJS);
    } else {
      _jsDc.send(message.binary.toJS);
    }
    return Future.value();
  }

  @override
  Future<void> close() {
    _jsDc.close();
    return Future.value();
  }
}
