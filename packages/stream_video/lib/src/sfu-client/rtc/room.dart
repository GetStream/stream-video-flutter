import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_models/models.pb.dart';
import 'package:stream_video/src/sfu-client/rpc/signal.dart';
import 'package:stream_video/src/sfu-client/rtc/codecs.dart';
import 'package:stream_video/src/sfu-client/rtc/publisher.dart';
import 'package:stream_video/src/sfu-client/rtc/signal_channel.dart';
import 'package:stream_video/src/sfu-client/rtc/subscriber.dart';

typedef HandleOnTrack = void Function(RTCTrackEvent);

class WebRTCClient {
  WebRTCClient(this.client, {HandleOnTrack? handleOnTrack})
      : _handleOnTrack = handleOnTrack;
  RTCPeerConnection? publisher;
  RTCPeerConnection? subscriber;
  RTCDataChannel? dataChannel;

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
    dataChannel = null;
    // this.dispatcher.offAll();
  }

  Future<CallState> join(MediaStream videoStream) async {
    if (subscriber != null) {
      subscriber!.close();
      subscriber = null;
    }
    //TODO:logger
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
    dataChannel = await createSignalChannel(
      label: 'signalling',
      pc: subscriber!,
      onEventReceived: (message) {
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

  Future<void> publish({
    required MediaStream audioStream,
    required MediaStream videoStream,
  }) async {
    if (publisher != null) {
      publisher!.close();
      publisher = null;
    }
    print('Setting up publisher');
    publisher = await createPublisher(
      sfuUrl: 'localhost',
      rpcClient: this.client,
    );
    final videoEncodings =
        (videoLayers != null && videoLayers!.isNotEmpty == true)
            ? videoLayers!.map((e) => e.encoding).toList()
            : defaultVideoPublishEncodings;

    final videoTracks = videoStream.getVideoTracks();
    final videoTransceiver = await publisher!.addTransceiver(
      track: videoTracks.first,
      kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: RTCRtpTransceiverInit(
        direction: TransceiverDirection.SendOnly,
        streams: [videoStream],
        sendEncodings: videoEncodings,
      ),
    );
    final audioTracks = audioStream.getAudioTracks();
    await publisher!.addTransceiver(
      track: audioTracks.first,
      kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: RTCRtpTransceiverInit(
        direction: TransceiverDirection.SendOnly,
        // streams: [audioStream],
      ),
    );
  }

  Future<bool> isPublishing(List<String> kinds) async {
    if (publisher == null) return false;
    final senders = await publisher!.getSenders();
    if (kinds.length == 0 && senders.length > 0) return true;
    return senders.any((s) => s.track != null && kinds.contains(s.track!.kind));
  }

  Future<MediaStream> changeInputDevice({
    required String kind,
    required String deviceId,
    Map<String, dynamic>? extras,
  }) async {
    if (publisher == null) {
      print(
        "Can't change input device without publish connection established: $kind $deviceId",
      );
      //TODO: throw error
    }

    //TODO: handle kind + extras

    var constraints = <String, dynamic>{};
    //   'audio': kind == "audioinput",
    //   'video': {
    //     'deviceId': {'exact': deviceId},
    //   }
    // };
    if (kind == 'audioinput') {
      constraints["audio"] = {
        // ...extras,
        "deviceId": deviceId,
      };
    } else if (kind == 'videoinput') {
      constraints["video"] = {
        // ...extras,
        "deviceId": deviceId,
      };
    }

    final mediaStream = await navigator.mediaDevices.getUserMedia(constraints);
    final newTracks = kind == 'videoinput'
        ? mediaStream.getVideoTracks()
        : mediaStream.getAudioTracks();
    final newTrack = newTracks.isEmpty ? null : newTracks.first;

    final senders = await publisher!.getSenders();
    final newSenders =
        senders.where((s) => s.track?.kind == newTrack?.kind).toList();
    if (newSenders.isEmpty ||
        newSenders.first.track == null ||
        newTrack == null) {
      print('No sender found for track kind $newTrack $kind $senders');
      //TODO: throw error
    }
    final sender = newSenders.first;
    sender.track!.stop(); // release old track
    await sender.replaceTrack(newTrack);

    return mediaStream; //
  }

  Future<String?> getActiveInputDeviceId(String kind) async {
    if (publisher == null) //TODO: throw error
      print(
          "Can't get active input device without publish connection established: $kind");
    final senders = await publisher!.getSenders();
    final sender = senders.firstWhere((s) => s.track?.kind == kind);
    return sender.track?.getConstraints()['deviceId'] as String?;
  }

  Future<List<StatsReport>?> getStats(StatKind kind) async {
    return kind == StatKind.publisher
        ? await publisher?.getStats()
        : await subscriber?.getStats();
  }

  Future<void> updatePublishQuality(List<String> enabledRids) async {
    final senders = await publisher?.getSenders();

    final videoSender = senders?.firstWhere((s) => s.track?.kind == 'video');
    if (videoSender == null) throw 'No video sender found';
    final params = await videoSender.parameters;
    var changed = false;
    params.encodings!.forEach((enc) {
      print("${enc.rid} ${enc.maxBitrate} ${enc.maxFramerate}");
      // flip 'active' flag only when necessary
      final shouldEnable = enabledRids.contains(enc.rid!);
      if (shouldEnable != enc.active) {
        enc.active = shouldEnable;
        changed = true;
      }
    });

    if (changed) {
      await videoSender.setParameters(params);
    }
  }
}

enum StatKind { sender, publisher }
