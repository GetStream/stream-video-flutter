import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:meta/meta.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/envelopes.pb.dart'
    as rpc;
import 'package:stream_video/protobuf/video/coordinator/edge_v1/edge.pb.dart'
    as edge;
import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart'
    as sfu_events;
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as signal;
import 'package:stream_video/src/call/transport.dart';
import 'package:stream_video/src/core/utils.dart';
import 'package:stream_video/src/event_emitter.dart';
import 'package:stream_video/src/events.dart';
import 'package:stream_video/src/extensions.dart';
import 'package:stream_video/src/internal/events.dart';
import 'package:stream_video/src/logger/logger.dart';
import 'package:stream_video/src/models/call_configuration.dart';
import 'package:stream_video/src/options.dart';
import 'package:stream_video/src/participant/local.dart';
import 'package:stream_video/src/participant/participant.dart';
import 'package:stream_video/src/participant/participant_info.dart';
import 'package:stream_video/src/participant/remote.dart';
import 'package:stream_video/src/sfu-client/rtc/codecs.dart' as codecs;
import 'package:stream_video/src/sfu-client/sfu_client.dart';
import 'package:stream_video/src/stream_video.dart';
import 'package:stream_video/src/types/other.dart';

const _timeoutDuration = Duration(seconds: 30);

/// Represents a [Call] in which you can connect to.
class Call with EventEmittable<CallEvent> {
  /// Creates a new [Call] instance from a [CallConfiguration].
  Call({
    required this.callConfiguration,
    StreamVideo? client,
  })  : callOptions = callConfiguration.callOptions,
        _streamVideoClient = client ?? StreamVideo.instance;

  /// Creates a new [Call] instance if the call already created.
  Call.fromDetails({
    required this.callId,
    required this.callType,
    required this.credentials,
    required StreamVideo client,
    this.callOptions = const CallOptions(),
  }) : _streamVideoClient = client {
    _initialiseCall(credentials: credentials);
  }

  // Determines whether the call is initialised.
  bool _initialised = false;
  void _initialiseCall({required edge.Credentials credentials}) {
    final url = credentials.server.url;
    final token = credentials.token;
    sfuClient = SfuClient(
      url: url,
      token: token,
    );

    _startListeningSfuEvents();

    _initialised = true;
  }

  late final CallConfiguration callConfiguration;
  late final StreamVideo _streamVideoClient;

  late final String callId;
  late final String callType;
  String get callCid => '$callType:$callId';
  late final edge.Credentials credentials;
  final CallOptions callOptions;

  late final SfuClient sfuClient;

  @internal
  Transport? publisher;

  @internal
  Transport? subscriber;

  ConnectionState get connectionState => sfuClient.connectionState;

  /// map of SID to RemoteParticipant
  Map<String, RemoteParticipant> get participants => _participants;
  final _participants = <String, RemoteParticipant>{};

  /// The current local participant
  LocalParticipant? get localParticipant => _localParticipant;
  LocalParticipant? _localParticipant;

  /// The current dominant speaker in the call.
  Participant? get dominantSpeaker => _dominantSpeaker;
  Participant? _dominantSpeaker;

  Future<rpc.CallEnvelope> create() {
    return _streamVideoClient.createCall(
      type: callConfiguration.type,
      id: callConfiguration.id,
      participantIds: callConfiguration.participantIds,
      ringing: callConfiguration.ringing,
    );
  }

  Future<rpc.CallEnvelope> getOrCreate() {
    return _streamVideoClient.getOrCreateCall(
      type: callConfiguration.type,
      id: callConfiguration.id,
      participantIds: callConfiguration.participantIds,
      ringing: callConfiguration.ringing,
    );
  }

  Future<void> disconnect() async {
    // clean up RemoteParticipants
    for (final participant in [...participants.values]) {
      // RemoteParticipant is responsible for disposing resources
      await participant.dispose();
    }
    _participants.clear();

    // clean up LocalParticipant
    await localParticipant?.dispose();

    // reset dominant speaker
    _dominantSpeaker = null;

    // dispose events
    events.dispose();

    await publisher?.dispose();
    publisher = null;

    await subscriber?.dispose();
    subscriber = null;

    await sfuClient.disconnect();

    _streamVideoClient.updateCallStateDisconnected(this);
  }

  Future<Call> connect({
    ConnectOptions options = const ConnectOptions(),
  }) async {
    if (!_initialised) {
      final result = await _streamVideoClient.joinCall(
        type: callConfiguration.type,
        id: callConfiguration.id,
        callOptions: callConfiguration.callOptions,
      );

      callId = result.callId;
      callType = result.callType;
      credentials = result.credentials;

      _initialiseCall(credentials: credentials);
    }

    logger.info('Joining call $callType:$callId');

    await sfuClient.connect();

    final genericSdp = await codecs.getGenericSdp(
      direction: rtc.TransceiverDirection.RecvOnly,
    );

    sfuClient.send(
      request: sfu_events.SfuRequest(
        joinRequest: sfu_events.JoinRequest(
          token: credentials.token,
          sessionId: sfuClient.sessionId,
          subscriberSdp: genericSdp,
        ),
      ),
    );

    // Waiting for the join response event.
    final joinResponseEvent =
        await sfuClient.events.waitFor<SFUJoinResponseEvent>(
      duration: _timeoutDuration,
    );

    final joinResponse = joinResponseEvent.response;
    await _handleConnected(response: joinResponse, options: options);

    logger.fine('Call Connect completed');

    _streamVideoClient.updateCallStateConnected(this);

    return this;
  }

  Future<void> _createPeerConnections(RTCConfiguration configuration) async {
    if (publisher != null || subscriber != null) {
      logger.warning('Already configured');
      return;
    }

    publisher = await Transport.create(configuration: configuration);
    subscriber = await Transport.create(configuration: configuration);

    publisher?.pc.onIceCandidate = (candidate) {
      logger.fine('Publisher onIceCandidate: $candidate');

      final iceCandidate = json.encode(candidate.toMap());
      sfuClient.iceTrickle(
        iceCandidate: iceCandidate,
        peerType: sfu_models.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED,
      );
    };

    publisher?.pc.onIceConnectionState = (state) {
      logger.info('Publisher ICE connection state: $state');
    };

    subscriber?.pc.onIceCandidate = (candidate) {
      logger.info('Subscriber onIceCandidate: $candidate');

      final iceCandidate = json.encode(candidate.toMap());
      sfuClient.iceTrickle(
        iceCandidate: iceCandidate,
        peerType: sfu_models.PeerType.PEER_TYPE_SUBSCRIBER,
      );
    };

    subscriber?.pc.onIceConnectionState = (state) {
      logger.info('Subscriber ICE connection state: $state');
    };

    publisher?.pc.onConnectionState = (state) {
      logger.info('Publisher connection state: $state');
    };

    subscriber?.pc.onConnectionState = (state) {
      logger.info('Subscriber connection state: $state');
    };

    subscriber?.pc.onTrack = _onSubscriberTrack;

    publisher?.pc.onRenegotiationNeeded = _onPublisherNegotiationNeeded;

    sfuClient.events.on<SFUSubscriberOfferEvent>((data) async {
      final offer = data.offer;
      logger.info('Subscriber offer: $offer');

      await subscriber!.setRemoteDescription(
        rtc.RTCSessionDescription(offer.sdp, 'offer'),
      );

      final answer = await subscriber!.createAnswer();
      await sfuClient.sendAnswer(
        sdp: answer.sdp!,
        peerType: sfu_models.PeerType.PEER_TYPE_SUBSCRIBER,
      );
    });
  }

  Future<void> _handleConnected({
    required sfu_events.JoinResponse response,
    ConnectOptions options = const ConnectOptions(),
  }) async {
    // Creating the peer connections.
    await _createPeerConnections(_connectionConfig);

    final callState = response.callState;
    final sfuParticipants = callState.participants;

    final localSfuParticipant = sfuParticipants.firstWhereOrNull(
      (it) => it.sessionId == sfuClient.sessionId,
    );

    if (localSfuParticipant == null) {
      throw Exception('Local participant not found');
    }

    // Creating the local participant.
    _localParticipant ??= LocalParticipant(
      call: this,
      info: ParticipantInfo.fromSfu(localSfuParticipant),
    );

    final audio = options.microphone;
    if (audio.enabled) {
      final track = audio.track;
      if (track != null) {
        await _localParticipant!.publishAudioTrack(track);
      } else {
        await _localParticipant!.setMicrophoneEnabled();
      }
    }

    final video = options.camera;
    if (video.enabled) {
      final track = video.track;
      if (track != null) {
        await _localParticipant!.publishVideoTrack(track);
      } else {
        await _localParticipant!.setCameraEnabled();
      }
    }

    final screen = options.screenShare;
    if (screen.enabled) {
      final track = screen.track;
      if (track != null) {
        await _localParticipant!.publishVideoTrack(track);
      } else {
        await _localParticipant!.setScreenShareEnabled();
      }
    }

    final otherParticipants = sfuParticipants.where(
      (it) => it.sessionId != sfuClient.sessionId,
    );

    // Adding the remote participants.
    for (final sfuParticipant in otherParticipants) {
      final info = ParticipantInfo.fromSfu(sfuParticipant);
      logger.fine(
        'Creating RemoteParticipant: ${info.sessionId}(${info.userId}) '
        'tracks:${info.publishedTracks}',
      );
      _getOrCreateRemoteParticipant(sessionId: info.sessionId, info: info);
    }
  }

  RemoteParticipant _getOrCreateRemoteParticipant({
    required String sessionId,
    ParticipantInfo? info,
  }) {
    print('PublishedTracks: ${info?.publishedTracks.length}');

    return _participants.update(
      sessionId,
      (participant) {
        if (info != null) {
          participant.updateInfo(info);
        }
        return participant;
      },
      ifAbsent: () {
        if (info == null) {
          throw Exception(
            'Participant info is required in order to create a new participant',
          );
        }
        return RemoteParticipant(
          call: this,
          info: info,
        );
      },
    );
  }

  Future<signal.UpdateSubscriptionsResponse> updateTrackSubscription({
    required signal.TrackSubscriptionDetails track,
    required bool subscribe,
  }) {
    final tracks = <String, signal.TrackSubscriptionDetails>{};
    for (final participant in [...participants.values]) {
      final subscribedTracks = participant.subscribedTracks;
      print('SubscribedTracks: ${subscribedTracks.length}');
      for (final track in subscribedTracks) {
        final detail = signal.TrackSubscriptionDetails(
          userId: participant.userId,
          sessionId: participant.sessionId,
          trackType: track.type,
        );

        final videoDimension = track.videoDimension;
        if (videoDimension != null) {
          detail.dimension = sfu_models.VideoDimension(
            width: videoDimension.width,
            height: videoDimension.height,
          );
        }

        tracks[detail.trackDetailId] = detail;
      }
    }

    print(
      'Before Updating Tracks subscription: ${tracks.values.map((e) => e)}',
    );

    if (subscribe) {
      tracks[track.trackDetailId] = track;
    } else {
      tracks.remove(track.trackDetailId);
    }

    print('Updating Tracks subscription: ${tracks.values.map((e) => e)}');

    return sfuClient.updateSubscriptions(tracks: [...tracks.values]);
  }

  void _onSubscriberTrack(rtc.RTCTrackEvent event) async {
    logger.fine('[WebRTC] pc.onTrack');

    final stream = event.streams.firstOrNull;
    logger.shout('onTrack: ${stream?.id}');
    if (stream == null) {
      // we need the stream to get the track's id
      logger.severe('received track without mediaStream');
      return;
    }

    // doesn't get called reliably
    event.track.onEnded = () {
      logger.fine('[WebRTC] track.onEnded');
    };

    // doesn't get called reliably
    stream.onRemoveTrack = (_) {
      logger.fine('[WebRTC] stream.onRemoveTrack');
    };

    if (connectionState == ConnectionState.reconnecting ||
        connectionState == ConnectionState.connecting) {
      final track = event.track;
      final receiver = event.receiver;
      sfuClient.events.on<ConnectionStateUpdatedEvent>((event) async {
        Timer(const Duration(milliseconds: 10), () {
          _onSubscriberTrackAdded(
            track: track,
            stream: stream,
            receiver: receiver,
          );
        });
      });
      return;
    }

    if (connectionState == ConnectionState.disconnected) {
      return logger.warning('skipping incoming track after Call disconnected');
    }

    return _onSubscriberTrackAdded(
      track: event.track,
      stream: stream,
      receiver: event.receiver,
    );
  }

  void _onSubscriberTrackAdded({
    required rtc.MediaStreamTrack track,
    required rtc.MediaStream stream,
    rtc.RTCRtpReceiver? receiver,
  }) async {
    logger.fine('OnTrackAdded trackSid:${track.id}');

    final idParts = stream.id.split(':');
    final trackId = idParts[0];
    final trackKind = idParts[1];
    final trackSid = '$trackId:$trackKind';

    final participant = participants.values.firstWhereOrNull((it) {
      return it.trackLookupPrefix == trackId;
    });

    try {
      if (participant == null) {
        throw Exception('Participant not found for trackSid: $trackSid');
      }

      await participant.addSubscribedMediaTrack(
        mediaTrack: track,
        stream: stream,
        trackSid: trackSid,
        receiver: receiver,
      );
    } on TrackSubscriptionExceptionEvent catch (event) {
      logger.severe('addSubscribedMediaTrack() throwed ${event}');
      [participant?.call.events, participant?.events].emit(event);
    } catch (exception) {
      // We don't want to pass up any exception so catch everything here.
      logger.warning(
        'Unknown exception on addSubscribedMediaTrack() $exception',
      );
    }
  }

  void _onPublisherNegotiationNeeded() async {
    logger.info('Publisher onRenegotiationNeeded');

    final offer = await publisher!.createOffer();

    final tracks = [
      ...localParticipant!.trackPublications.values.map((it) {
        final info = it.info;
        final track = it.track?.mediaStreamTrack;
        final transceiver = it.track?.transceiver;
        return sfu_models.TrackInfo(
          trackId: track?.id,
          trackType: info.type,
          mid: transceiver?.mid,
          layers: info.videoLayers,
        );
      }),
    ];

    print('Publishing tracks: ${tracks.map((it) => it)}');

    final response = await sfuClient.setPublisher(
      sdp: offer.sdp!,
      tracks: tracks,
    );

    await publisher!.setRemoteDescription(
      rtc.RTCSessionDescription(response.sdp, 'answer'),
    );
  }

  RTCConfiguration get _connectionConfig {
    final config = rtcConfigurationFromICEServers(credentials.iceServers);
    return config ?? defaultRtcConfiguration(credentials.server.url);
  }

  void _startListeningSfuEvents() {
    sfuClient.events
      ..on<ConnectionStateUpdatedEvent>(events.emit)
      ..on<SFUIceTrickleEvent>(
        (event) {
          final iceTrickle = event.iceTrickle;
          logger.info('Received iceTrickle: $iceTrickle');

          final iceCandidateJson = json.decode(iceTrickle.iceCandidate);
          final iceCandidate = rtc.RTCIceCandidate(
            iceCandidateJson['candidate'],
            iceCandidateJson['sdpMid'],
            iceCandidateJson['sdpMLineIndex'],
          );

          final peerType = iceTrickle.peerType;
          switch (peerType) {
            case sfu_models.PeerType.PEER_TYPE_SUBSCRIBER:
              subscriber?.addIceCandidate(iceCandidate);
              break;
            case sfu_models.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED:
              publisher?.addIceCandidate(iceCandidate);
              break;
          }
        },
      )
      ..on<SFUParticipantJoinedEvent>((event) {
        final joinedParticipant = event.participantJoined.participant;
        final participant = _getOrCreateRemoteParticipant(
          sessionId: joinedParticipant.sessionId,
          info: ParticipantInfo.fromSfu(joinedParticipant),
        );
        events.emit(ParticipantJoinedEvent(participant: participant));
      })
      ..on<SFUParticipantLeftEvent>((event) {
        final leftParticipant = event.participantLeft.participant;
        final participant = participants[leftParticipant.sessionId];

        if (participant == null) {
          return logger.warning(
            'Participant not found for sessionId: ${leftParticipant.sessionId}',
          );
        }

        participant.dispose();
        participants.remove(leftParticipant.sessionId);

        events.emit(ParticipantLeftEvent(participant: participant));
      })
      ..on<SFUTrackPublishedEvent>((event) {
        print('Track published: ${event.trackPublished}');

        final publishedTrack = event.trackPublished;

        // localParticipant & remote participants
        final allParticipants = <String, Participant>{
          if (localParticipant != null)
            localParticipant!.sessionId: localParticipant!,
          ...participants,
        };

        final participant = allParticipants[publishedTrack.sessionId];

        if (participant == null) {
          return logger.warning(
            'Participant not found for sessionId: ${publishedTrack.sessionId}',
          );
        }

        print('Participant: ${participant.runtimeType}');

        participant.updateInfo(participant.info.copyWith(
          publishedTracks: [
            ...{
              ...participant.info.publishedTracks,
              publishedTrack.type,
            },
          ],
        ));
      })
      ..on<SFUTrackUnpublishedEvent>((event) {
        print('Track unpublished: ${event.trackUnpublished}');

        final unpublishedTrack = event.trackUnpublished;

        // localParticipant & remote participants
        final allParticipants = <String, Participant>{
          if (localParticipant != null)
            localParticipant!.sessionId: localParticipant!,
          ...participants,
        };

        final participant = allParticipants[unpublishedTrack.sessionId];

        if (participant == null) {
          return logger.warning(
            'Participant not found for sessionId: ${unpublishedTrack.sessionId}',
          );
        }

        participant.updateInfo(participant.info.copyWith(
          publishedTracks: [
            ...participant.info.publishedTracks.where((it) {
              return it != unpublishedTrack.type;
            }),
          ],
        ));
      })
      ..on<SFUDominantSpeakerChangedEvent>((event) {
        final dominantSpeaker = event.dominantSpeakerChanged;

        // localParticipant & remote participants
        final allParticipants = <String, Participant>{
          if (localParticipant != null)
            localParticipant!.sessionId: localParticipant!,
          ...participants,
        };

        final participant = allParticipants[dominantSpeaker.sessionId];

        if (participant == null) {
          return logger.warning(
            'Participant not found for sessionId: ${dominantSpeaker.sessionId}',
          );
        }

        _dominantSpeaker = participant;
        events.emit(DominantSpeakerChangedEvent(speaker: participant));
      })
      ..on<SFUAudioLevelChangedEvent>((event) {
        final audioLevels = event.audioLevelChanged.audioLevels;

        // localParticipant & remote participants
        final allParticipants = <String, Participant>{
          if (localParticipant != null)
            localParticipant!.sessionId: localParticipant!,
          ...participants,
        };

        for (final audioLevel in audioLevels) {
          final participant = allParticipants[audioLevel.sessionId];

          if (participant == null) {
            logger.warning(
              'Participant not found for sessionId: ${audioLevel.sessionId}',
            );
            continue;
          }

          participant.audioLevel = audioLevel.level;
        }
      })
      ..on<SFUChangePublishQualityEvent>((event) {
        // TODO: Implement this
      })
      ..on<SFUConnectionQualityChangedEvent>((event) {
        final connectionQualityChanged = event.connectionQualityChanged;
        final participant = participants[connectionQualityChanged.sessionId];

        if (participant == null) {
          return logger.warning(
            'Participant not found for sessionId: ${connectionQualityChanged.sessionId}',
          );
        }

        final quality = connectionQualityChanged.connectionQuality;
        participant.connectionQuality = quality.toStreamConnectionQuality();
      });
  }
}

extension on signal.TrackSubscriptionDetails {
  /// Returns a unique string to identify this detail from the other details.
  String get trackDetailId {
    return '$userId-$sessionId-$trackType';
  }
}
