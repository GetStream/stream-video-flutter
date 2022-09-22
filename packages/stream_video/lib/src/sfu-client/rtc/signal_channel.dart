import 'package:flutter_webrtc/flutter_webrtc.dart';

typedef OnMessage = void Function(dynamic); //SfuEvent

Future<RTCDataChannel> createSignalChannel(
    String label, RTCPeerConnection pc, OnMessage onMessage) async {
  var dataChannelDict = RTCDataChannelInit();
  dataChannelDict.binaryType = 'arraybuffer';
  final signal = await pc.createDataChannel(label, dataChannelDict);
  signal.onDataChannelState = (state) async {
    if (state == RTCDataChannelState.RTCDataChannelOpen) {
      print('Data channel is open');
      await signal.send(RTCDataChannelMessage('ss'));
    } else {
      print('Data channel is closed');
    }
  };

  signal.onMessage = (message) {
    //  const binaryData = new Uint8Array(e.data);
    //   const message = SfuEvent.fromBinary(binaryData);
    onMessage(message);
  };

  return signal;
}
