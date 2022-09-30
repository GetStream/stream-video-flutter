import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_events/events.pb.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_models/models.pb.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_signal_rpc/signal.pb.dart';
import 'package:stream_video/src/models/call_participant.dart';
import 'package:stream_video/src/sfu-client/rpc/signal.dart';
import 'package:stream_video/src/sfu-client/rtc/codecs.dart';
import 'package:stream_video/src/state/state.dart';
import 'package:stream_video/stream_video.dart';

typedef OnEventReceived = void Function(SfuEvent); //SfuEvent

typedef OnTrack = void Function(RTCTrackEvent);

extension VideoParticipantX on Participant {
  CallParticipant toCallParticipant(bool showTrack) {
    return CallParticipant(
      id: user.id,
      role: role,
      name: user.name.isEmpty ? user.id : user.name,
      profileImageURL: user.imageUrl,
      isOnline: online,
      hasVideo: video,
      hasAudio: audio,
      showTrack: showTrack,
    );
  }
}

class WebRTCClient {
  WebRTCClient(
    this.client, {
    required this.state,
    required this.sfuUrl,
  });
  RTCPeerConnection? publisher;
  RTCPeerConnection? subscriber;
  RTCDataChannel? signalChannel;
  final ClientState state;
  final String sfuUrl;
  List<OptimalVideoLayer>? videoLayers;
  final SfuSignalingClient client;

  final _participantsThreshold = 4;
  Future<RTCPeerConnection> createPublisher() async {
    final configuration = {
      'iceServers': [
        {
          'urls': 'stun:stun.l.google.com:19302',
        },
        {
          'urls': "turn:${sfuUrl}:3478",
          'username': 'video',
          'credential': 'video',
        },
      ],
    };
    final publisher = await createPeerConnection(configuration);
    publisher.onIceCandidate = (candidate) async {
      await client.sendCandidate(
        publisher: true,
        candidate: candidate.candidate,
        sdpMid: candidate.sdpMid,
        sdpMLineIndex: candidate.sdpMLineIndex,
        // usernameFragment: candidate.use as String?,
      );
    };
    publisher.onRenegotiationNeeded = () async {
      final offer = await publisher.createOffer();
      await publisher.setLocalDescription(offer);
      final sfu = await client.setPublisher(
        sdp: offer.sdp,
      );

      await publisher
          .setRemoteDescription(RTCSessionDescription(sfu.sdp, 'answer'));
    };
    return publisher;
  }

  Future<RTCPeerConnection> createSubscriber({
    OnTrack? onTrack,
  }) async {
    final config = {
      'iceServers': [
        {
          'urls': 'stun:stun.l.google.com:19302',
        },
        {
          'urls': 'turn:${sfuUrl}:3478',
          'username': 'video',
          'credential': 'video',
        },
      ],
    };
    final subscriber = await createPeerConnection(config);
    subscriber.onIceCandidate = (candidate) async {
      await client.sendCandidate(
        //  sessionId: rpcClient.sessionId,
        publisher: false,
        candidate: candidate.candidate,
        sdpMid: candidate.sdpMid, // ?? undefined,
        sdpMLineIndex: candidate.sdpMLineIndex, //?? undefined,
        // usernameFragment: candidate.usernameFragment?? undefined,
      );
    };
    subscriber.onTrack = onTrack;
    state.sfu.on<SubscriberOfferEvent>((event) async {
      print("Received subscriberOffer event.payload");

      await subscriber.setRemoteDescription(
        RTCSessionDescription(event.payload.sdp, 'offer'),
      );
      final answer = await subscriber.createAnswer();
      await subscriber.setLocalDescription(answer);
      client.sendAnswer(
        peerType: PeerType.SUBSCRIBER,
        sdp: answer.sdp ?? '',
      );
    });

    return subscriber;
  }

  Future<RTCDataChannel> createSignalChannel({
    required String label,
    required RTCPeerConnection pc,
    required OnEventReceived onEventReceived,
  }) async {
    var dataChannelDict = RTCDataChannelInit();
    dataChannelDict.binaryType = 'arraybuffer';
    final signal = await pc.createDataChannel(label, dataChannelDict);
    //TODO: get rid of js callback hell
    signal.onDataChannelState = (state) async {
      if (state == RTCDataChannelState.RTCDataChannelOpen) {
        print('Data channel is open');
        await signal.send(RTCDataChannelMessage('ss'));
      } else {
        print('Data channel is closed');
      }
    };
    //TODO: get rid of js callback hell
    signal.onMessage = (message) {
      if (!message.isBinary) {
        print("This socket only accepts exchanging binary data");
      }

      final receivedEvent = SfuEvent.fromBuffer(message.binary);

      onEventReceived(receivedEvent);
    };

    return signal;
  }

  Future<void> leave() async {
    await subscriber?.close();
    subscriber = null;
    final senders = await publisher?.getSenders();
    senders?.forEach((sender) async {
      await publisher?.removeTrack(sender);
    });
    await publisher?.close();
    publisher = null;
    signalChannel = null;
    // this.dispatcher.offAll();
  }

//TODO: call settings and video options
  Future<CallState> connect({MediaStream? videoStream}) async {
    //join in react
    if (subscriber != null) {
      subscriber!.close();
      subscriber = null;
    }
    //TODO:logger
    print('Setting up subscriber');
    subscriber = await createSubscriber(
      // dispatcher: this.dispatcher,
      onTrack: (e) {
        print('Got remote track:${e.track}');

        state.tracks.emitRemoteUpdated(e.track);
        // _handleOnTrack?.call(e);
      },
    );

    signalChannel = await createSignalChannel(
      label: 'signalling',
      pc: subscriber!,
      //TODO: get rid of js callback hell
      onEventReceived: (event) {
        handle(event);
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
    final participants = _loadParticipants(sfu);
    state.participants.emitNew(participants);
    subscriber!.setRemoteDescription(RTCSessionDescription(sfu.sdp, 'answer'));
    return sfu.callState;
  }

  Map<String, CallParticipant> _loadParticipants(JoinResponse sfu) {
    final participants = sfu.callState.participants;
    // For more than threshold participants, the activation of track is on view appearance.
    final showTrack = participants.length < _participantsThreshold;
    var temp = <String, CallParticipant>{};
    for (var participant in participants) {
      temp[participant.user.id] = participant.toCallParticipant(showTrack);
    }
    return temp;
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
    publisher = await createPublisher();
    final videoEncodings =
        (videoLayers != null && videoLayers!.isNotEmpty == true)
            ? videoLayers!.map((e) => e.encoding).toList()
            : defaultVideoPublishEncodings;

    final videoTracks = videoStream.getVideoTracks();
    //TODO: check if videoTracks is empty
    //if empty throw error
    // else videoTrack = videoTracks.first;
    //TODO: state.tracks.emitLocalUpdated(videoTrack);
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
    await sender.track!.stop(); // release old track
    await sender.replaceTrack(newTrack);

    return mediaStream;
  }

  Future<String?> getActiveInputDeviceId(String kind) async {
    if (publisher == null) //TODO: throw error
      print(
        "Can't get active input device without publish connection established: $kind",
      );
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

  void handle(SfuEvent event) {
    print("Received an event $event)");
    switch (event.whichEventPayload()) {
      case SfuEvent_EventPayload.participantJoined:
        {
          return _handleParticipantJoined(event.participantJoined);
        }
      case SfuEvent_EventPayload.participantLeft:
        {
          return _handleParticipantLeft(event.participantLeft);
        }
      case SfuEvent_EventPayload.subscriberOffer:
        {
          return _handleSubscriberOffer(event.subscriberOffer);
        }
      case SfuEvent_EventPayload.connectionQualityChanged:
        // TODO: Handle this case.
        break;
      case SfuEvent_EventPayload.audioLevelChanged:
        // TODO: Handle this case.
        break;
      case SfuEvent_EventPayload.subscriberCandidate:
        // TODO: Handle this case.
        break;
      case SfuEvent_EventPayload.publisherCandidate:
        // TODO: Handle this case.
        break;
      case SfuEvent_EventPayload.changePublishQuality:
        // TODO: Handle this case.
        break;
      case SfuEvent_EventPayload.localDeviceChange:
        // TODO: Handle this case.
        break;
      case SfuEvent_EventPayload.muteStateChanged:
        // TODO: Handle this case.
        break;
      case SfuEvent_EventPayload.videoQualityChanged:
        // TODO: Handle this case.
        break;

      case SfuEvent_EventPayload.dominantSpeakerChanged:
        // TODO: Handle this case.
        break;
      case SfuEvent_EventPayload.notSet:
        // TODO: Handle this case.
        break;
    }
  }

  void _handleParticipantJoined(ParticipantJoined payload) {
    final showTrack = (state.participants.count + 1) < _participantsThreshold;
    final participant = payload.participant.toCallParticipant(showTrack);

    state.participants.emitJoined(participant);
  }

  void _handleParticipantLeft(ParticipantLeft payload) {
    final participant = payload.participant.toCallParticipant(false);
    state.participants.emitLeft(participant);
  }

  void _handleSubscriberOffer(SubscriberOffer subscriberOffer) {
    state.sfu.emitSubscriberOffer(subscriberOffer);
  }
}

enum StatKind { sender, publisher }
