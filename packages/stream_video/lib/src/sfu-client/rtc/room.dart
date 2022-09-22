import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stream_video/src/sfu-client/rpc/signal.dart';
import 'package:stream_video/src/sfu-client/rtc/subscriber.dart';

class RTCRoom {
  RTCRoom(this.client);
  RTCPeerConnection? publisher;
  RTCPeerConnection? subscriber;

  final SfuSignalingClient client;

  leave() async {
    await subscriber?.close();
    subscriber = null;
    final senders = await publisher?.getSenders();
    senders?.forEach((sender) async {
      await publisher?.removeTrack(sender);
    });
    await publisher?.close();
    publisher = null;
    // this.dispatcher.offAll();
  }

  join(MediaStream? videoStream) async {
    if (subscriber != null) {
      subscriber!.close();
      subscriber = null;
    }
    print('Setting up subscriber');
    subscriber = await createSubscriber(
      sfuUrl: 'localhost',
      rpcClient: this.client,
      // dispatcher: this.dispatcher,
      onTrack: (e) {
        print('Got remote track:${e.track}');
        // this.handleOnTrack?.(e);
      },
    );
  }
}
