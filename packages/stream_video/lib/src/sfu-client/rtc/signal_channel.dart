import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_events/events.pb.dart';

typedef OnMessage = void Function(SfuEvent); //SfuEvent

Future<RTCDataChannel> createSignalChannel({
  required String label,
  required RTCPeerConnection pc,
  required OnMessage onEventReceived,
}) async {
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
    if (!message.isBinary) {
      print("This socket only accepts exchanging binary data");
    }

    final receivedEvent = SfuEvent.fromBuffer(message.binary);

    onEventReceived(receivedEvent);
  };

  return signal;
}
