import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_models/models.pb.dart';
import 'package:stream_video/src/sfu-client/rpc/signal.dart';
import 'package:stream_video/src/sfu-client/rtc/codecs.dart';
import 'package:stream_video/src/sfu-client/rtc/signal_channel.dart';
import 'package:stream_video/src/sfu-client/rtc/subscriber.dart';

typedef HandleOnTrack = void Function(RTCTrackEvent);

class RTCRoom {
  RTCRoom(this.client, {HandleOnTrack? handleOnTrack})
      : _handleOnTrack = handleOnTrack;
  RTCPeerConnection? publisher;
  RTCPeerConnection? subscriber;

  List<OptimalVideoLayer>? videoLayers;
  final SfuSignalingClient client;

  HandleOnTrack? _handleOnTrack;
  set handleOnTrack(HandleOnTrack? handleOnTrack) {
    _handleOnTrack = handleOnTrack;
  }

  HandleOnTrack? get handleOnTrack => _handleOnTrack;

  Future<void> leave() async {
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

  Future<CallState> join(MediaStream? videoStream) async {
    if (subscriber != null) {
      subscriber!.close();
      subscriber = null;
    }
    print('Setting up subscriber');
    subscriber = await createSubscriber(
      sfuUrl: 'localhost',
      rpcClient: client,
      // dispatcher: this.dispatcher,
      onTrack: (e) {
        print('Got remote track:${e.track}');
        _handleOnTrack?.call(e);
      },
    );
    await createSignalChannel(
      label: 'signalling',
      pc: subscriber!,
      onMessage: (message) {
        //TODO: handle this
        // print('Received event ${message.eventPayload}');
        // dispatcher.dispatch(message);
      },
    );
    final offer = await subscriber?.createOffer({});
    if (offer?.sdp == null) {
      throw 'Failed to configure protocol, null SDP';
    }
    await subscriber?.setLocalDescription(offer!);
    //check if publisher is null
    //if null throw error and say to call method punlish first
    // ignore: non_constant_identifier_names
    final audioEncode_audioDecode_videoEncode_videoDecode = await Future.wait([
      getSenderCodecs(RTCRtpMediaType.RTCRtpMediaTypeAudio, publisher!),
      getReceiverCodecs(RTCRtpMediaType.RTCRtpMediaTypeAudio, subscriber!),
      getSenderCodecs(RTCRtpMediaType.RTCRtpMediaTypeVideo, publisher!),
      getReceiverCodecs(RTCRtpMediaType.RTCRtpMediaTypeVideo, subscriber!),
    ]);
    final audioEncode = audioEncode_audioDecode_videoEncode_videoDecode[0];
    final audioDecode = audioEncode_audioDecode_videoEncode_videoDecode[1];
    final videoEncode = audioEncode_audioDecode_videoEncode_videoDecode[2];
    final videoDecode = audioEncode_audioDecode_videoEncode_videoDecode[3];
    videoLayers = videoStream != null
        ? findOptimalVideoLayers(videoStream)
        : defaultVideoLayers;
    final sfu = await client.join(
      subscriberSdpOffer: offer!.sdp,
      codecSettings: CodecSettings(
        audio: AudioCodecs(encode: audioEncode, decode: audioDecode),
        video: VideoCodecs(encode: videoEncode, decode: videoDecode),
        layers: videoLayers!.map(
          (layer) => VideoLayer(
            bitrate: layer.encoding.maxBitrate,
            videoDimension:
                VideoDimension(height: layer.height, width: layer.width),
          ),
        ),
      ),
    );
    subscriber!.setRemoteDescription(RTCSessionDescription(sfu.sdp, 'answer'));
    return sfu.callState;
  }
}
