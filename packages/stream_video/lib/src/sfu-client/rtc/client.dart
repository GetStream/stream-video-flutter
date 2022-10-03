import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logging/logging.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_events/events.pb.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_models/models.pb.dart';
import 'package:stream_video/protobuf/video/sfu/sfu_signal_rpc/signal.pb.dart';
import 'package:stream_video/src/models/call_participant.dart';
import 'package:stream_video/src/models/video_options.dart';
import 'package:stream_video/src/sfu-client/rpc/signal.dart';
import 'package:stream_video/src/sfu-client/rtc/codecs.dart';
import 'package:stream_video/src/state/state.dart';
import 'package:stream_video/stream_video.dart';

typedef OnEventReceived = void Function(SfuEvent); //SfuEvent

typedef OnTrack = void Function(RTCTrackEvent);

typedef OnAddStream = void Function(MediaStream);
typedef OnRemoveStream = void Function(MediaStream);

extension VideoParticipantX on Participant {
  CallParticipant toCallParticipant([bool showTrack = false]) {
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
    this.signalService, {
    required this.state,
    this.logger,
    // required this.sfuUrl,
  });
  RTCPeerConnection? publisher;
  RTCPeerConnection? subscriber;
  RTCDataChannel? signalChannel;
  final ClientState state;
  final Logger? logger;
  // final String sfuUrl;
  List<OptimalVideoLayer>? videoLayers;
  final SignalService signalService;

  final _participantsThreshold = 4;

  static String sdpSemantics = 'unified-plan';
  Future<RTCPeerConnection> createPublisher() async {
    print("creating Publisher with configuration: $defaultConfig");
    final publisher = await createPeerConnection(defaultConfig);
    publisher.onIceCandidate = (candidate) async {
      await signalService.sendCandidate(
        publisher: true,
        candidate: candidate.candidate,
        sdpMid: candidate.sdpMid,
        sdpMLineIndex: candidate.sdpMLineIndex,
        token: _sfuToken,
        // usernameFragment: candidate.use as String?,
      );
    };
    publisher.onRenegotiationNeeded = () async {
      final offer = await publisher.createOffer();
      await publisher.setLocalDescription(offer);
      final sfu = await signalService.setPublisher(
          sdp: offer.sdp, token: Token(state.callState.sfuToken!));

      await publisher
          .setRemoteDescription(RTCSessionDescription(sfu.sdp, 'answer'));
    };
    return publisher;
  }

  Future<RTCPeerConnection> createSubscriber({
    // OnTrack? onTrack,
    OnAddStream? onAddStream,
    OnRemoveStream? onRemoveStream,
  }) async {
    print("creating subscriber with configuration: $defaultConfig");
    final subscriber = await createPeerConnection(defaultConfig);
    subscriber.onIceCandidate = (candidate) async {
      await signalService.sendCandidate(
        publisher: false,
        candidate: candidate.candidate,
        sdpMid: candidate.sdpMid, // ?? undefined,
        sdpMLineIndex: candidate.sdpMLineIndex, //?? undefined,
        // usernameFragment: candidate.usernameFragment?? undefined,
        token: Token(state.callState.sfuToken!),
      );
    };
    // subscriber.onTrack = onTrack;
    subscriber.onAddStream = onAddStream;
    subscriber.onRemoveStream = onRemoveStream;

    state.sfu.on<SubscriberOfferEvent>((event) async {
      logger?.info("Received subscriberOffer ${event.payload}");

      await subscriber.setRemoteDescription(
        RTCSessionDescription(event.payload.sdp, 'offer'),
      );
      final answer = await subscriber.createAnswer();
      await subscriber.setLocalDescription(answer);
      await signalService.sendAnswer(
        peerType: PeerType.SUBSCRIBER,
        sdp: answer.sdp ?? '',
        token: Token(state.callState.sfuToken!),
      );
    });

    return subscriber;
  }

  Map<String, Object> get defaultConfig => {
        'sdpSemantics': sdpSemantics,
        'iceServers': [
          {
            'urls': 'stun:stun.l.google.com:19302',
          },
          {
            'urls': "turn:http://192.168.1.17/3478",
            'username': 'video',
            'credential': 'video',
          },
        ],
      };

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
        logger?.info('Data channel is open');
        await signal.send(RTCDataChannelMessage('ss'));
      } else {
        logger?.info('Data channel is closed');
      }
    };
    //TODO: get rid of js callback hell
    signal.onMessage = (message) {
      if (!message.isBinary) {
        logger?.info("This socket only accepts exchanging binary data");
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
    // state.dispose();
    // this.dispatcher.offAll();
  }

//TODO: call settings and video options
  Future<CallState> connect({
    MediaStream? videoStream,
    required String callId,
    required StreamCallType callType,
    required String sfuUrl,
    required String sfuToken,
    required VideoOptions options,
  }) async {
    //join in react
    if (subscriber != null) {
      subscriber!.close();
      subscriber = null;
    }
    logger?.info("connect with sfuToken: $sfuToken and suUrl: $sfuUrl");
    state.callState = StreamCallState(
      callId: callId,
      callType: callType.rawType,
      sfuToken: sfuToken,
      sfuUrl: sfuUrl,
      userId: state.currentUser?.id,
    );
    //TODO:logger
    logger?.info('Setting up subscriber');
    subscriber = await createSubscriber(
      // onTrack: _handleOnTrack,
      onAddStream: _handleStreamAdded,
      onRemoveStream: _handleStreamRemoved,
    );

    signalChannel = await createSignalChannel(
      label: 'signalling',
      pc: subscriber!,
      //TODO: get rid of js callback hell
      onEventReceived: handleEvent,
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
      getSenderCodecs(RTCRtpMediaType.RTCRtpMediaTypeAudio, publisher),
      getReceiverCodecs(RTCRtpMediaType.RTCRtpMediaTypeAudio, subscriber),
      getSenderCodecs(RTCRtpMediaType.RTCRtpMediaTypeVideo, publisher),
      getReceiverCodecs(RTCRtpMediaType.RTCRtpMediaTypeVideo, subscriber),
    ]);
    final audioEncode = audioEncode_audioDecode_videoEncode_videoDecode[0];
    final audioDecode = audioEncode_audioDecode_videoEncode_videoDecode[1];
    final videoEncode = audioEncode_audioDecode_videoEncode_videoDecode[2];
    final videoDecode = audioEncode_audioDecode_videoEncode_videoDecode[3];
    videoLayers = videoStream != null
        ? findOptimalVideoLayers(videoStream)
        : defaultVideoLayers;
    final sfu = await signalService.join(
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
        token: Token(state.callState.sfuToken!));
    final participants = _loadParticipants(sfu);
    state.participants.emitNew(participants, state.currentUser!.id);
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
    required String sfuUrl,
  }) async {
    if (publisher != null) {
      publisher!.close();
      publisher = null;
    }
    logger?.info('Setting up publisher');
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
      logger?.warning(
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
      logger?.info('No sender found for track kind $newTrack $kind $senders');
      //TODO: throw error
    }
    final sender = newSenders.first;
    await sender.track!.stop(); // release old track
    await sender.replaceTrack(newTrack);

    return mediaStream;
  }

  Future<String?> getActiveInputDeviceId(String kind) async {
    if (publisher == null) //TODO: throw error
      logger?.warning(
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
      logger?.info("${enc.rid} ${enc.maxBitrate} ${enc.maxFramerate}");
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

  Token get _sfuToken => Token(state.callState.sfuToken!);
  String get _sfuUrl => state.callState.sfuUrl!;

  Future<void> disableAudio() async {
    await signalService.updateAudioMuteState(muted: true, token: _sfuToken);
  }

  Future<void> enableAudio() async {
    await signalService.updateAudioMuteState(muted: false, token: _sfuToken);
  }

  Future<void> disableVideo() async {
    await signalService.updateVideoMuteState(muted: false, token: _sfuToken);
  }

  Future<void> enableVideo() async {
    await signalService.updateVideoMuteState(muted: false, token: _sfuToken);
  }

  void handleEvent(SfuEvent event) {
    logger?.info("Received an event $event)");
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
        {
          return _handleConnectionQualityChanged(
            event.connectionQualityChanged,
          );
        }
      case SfuEvent_EventPayload.audioLevelChanged:
        {
          return _handleAudioLevelChanged(event.audioLevelChanged);
        }
      case SfuEvent_EventPayload.subscriberCandidate:
        {
          return _handleSubscriberCandidate(event.subscriberCandidate);
        }
      case SfuEvent_EventPayload.publisherCandidate:
        {
          return _handlePublisherCandidate(event.publisherCandidate);
        }
      case SfuEvent_EventPayload.changePublishQuality:
        {
          return _handleChangePublishQuality(event.changePublishQuality);
        }
      case SfuEvent_EventPayload.localDeviceChange:
        {
          return _handleLocalDeviceChange(event.localDeviceChange);
        }
      case SfuEvent_EventPayload.muteStateChanged:
        {
          return _handleMuteStateChanged(event.muteStateChanged);
        }
      case SfuEvent_EventPayload.videoQualityChanged:
        {
          return _handleVideoQualityChanged(event.videoQualityChanged);
        }

      case SfuEvent_EventPayload.dominantSpeakerChanged:
        {
          return _handleDominantSpeakerChanged(event.dominantSpeakerChanged);
        }
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

  void _handleStreamAdded(MediaStream stream) {
    state.participants.emitTrackUpdated(stream, stream.id);
  }

  void _handleStreamRemoved(MediaStream stream) {
    state.participants.emitTrackRemoved(stream.id);
  }

  void _handleOnTrack(RTCTrackEvent event) {
    logger?.info('Handling remote track event: ${event}');
//TODO: hmm maybe merge maybe this with state.participants.emitTrackUpdated
    state.tracks.emitRemoteUpdated(event.track);
  }

  void _handleConnectionQualityChanged(ConnectionQualityChanged event) {
    logger?.info('Received event ConnectionQualityChanged: ${event}');
  }

  void _handleAudioLevelChanged(AudioLevelChanged event) {
    logger?.info('Received event AudioLevelChanged: ${event}');
  }

  void _handleSubscriberCandidate(ICECandidateTrickle event) {
    logger?.info('Received event SubscriberCandidate: ${event}');
  }

  void _handlePublisherCandidate(ICECandidateTrickle event) {
    logger?.info('Received event PublisherCandidate: ${event}');
  }

  void _handleChangePublishQuality(ChangePublishQuality event) {
    logger?.info('Received event ChangePublishQuality: ${event}');
  }

  void _handleLocalDeviceChange(LocalDeviceChange event) {
    logger?.info('Received event LocalDeviceChange: ${event}');
  }

  void _handleMuteStateChanged(MuteStateChanged event) {
    logger?.info('Received event MuteStateChanged: ${event}');
  }

  void _handleVideoQualityChanged(VideoQualityChanged event) {
    logger?.info('Received event VideoQualityChanged: ${event}');
  }

  void _handleDominantSpeakerChanged(DominantSpeakerChanged event) {
    logger?.info('Received event DominantSpeakerChanged: ${event}');
  }
}

enum StatKind { sender, publisher }
