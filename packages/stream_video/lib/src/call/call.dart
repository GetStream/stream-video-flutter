import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/protobuf/video/coordinator/edge_v1/edge.pb.dart';
import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart';
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart';
import 'package:stream_video/src/call/participants_controller.dart';
import 'package:stream_video/src/call/track_controller.dart';
import 'package:stream_video/src/core/logger/logger.dart';
import 'package:stream_video/src/core/platform_detector/platform_detector.dart';
import 'package:stream_video/src/core/utils/event_emitter.dart';
import 'package:stream_video/src/core/utils/utils.dart';
import 'package:stream_video/src/models/call_participant.dart';
import 'package:stream_video/src/options.dart';
import 'package:stream_video/src/sfu-client/rtc/codecs.dart' as codecs;
import 'package:stream_video/src/sfu-client/rtc/ice_trickle_buffer.dart';
import 'package:stream_video/src/sfu-client/rtc/publisher.dart';
import 'package:stream_video/src/sfu-client/rtc/subscriber.dart';
import 'package:stream_video/src/sfu-client/sfu_client.dart';
import 'package:stream_video/src/track/local/audio.dart';
import 'package:stream_video/src/track/local/local.dart';
import 'package:stream_video/src/track/local/video.dart';
import 'package:stream_video/src/track/options.dart';
import 'package:stream_video/src/track/remote/audio.dart';
import 'package:stream_video/src/track/remote/remote.dart';
import 'package:stream_video/src/track/remote/video.dart';
import 'package:stream_video/src/track/track.dart';
import 'package:stream_video/src/types/other.dart';

const _timeoutDuration = Duration(seconds: 30);

enum StatKind { sender, publisher }

class Call with EventEmitterMixin<SfuEvent> {
  /// Creates a new [Call] instance.
  Call({
    required this.cid,
    required this.credentials,
    this.callOptions = const CallOptions(),
    this.onCallConnected,
    this.onCallLeft,
  }) {
    final url = credentials.server.url;
    final token = credentials.token;
    _client = SfuClient(
      url: url,
      token: token,
    )
      ..listen((data) {
        final event = data.whichEventPayload();
        emitter.emit(event.name, data);
      })
      ..addListener(
        SfuEvent_EventPayload.iceTrickle.name,
        (payload) {
          final iceTrickle = payload.iceTrickle;
          logger.info('Received iceTrickle: $iceTrickle');
          _iceTrickleBuffer.push(iceTrickle);
        },
      )
      ..addListener(
        SfuEvent_EventPayload.participantJoined.name,
        (data) {
          final payload = data.participantJoined;
          final participant = CallParticipant.fromSfu(payload.participant);
          return _controller.participants.upsert(participant);
        },
      )
      ..addListener(
        SfuEvent_EventPayload.participantLeft.name,
        (data) {
          final payload = data.participantJoined;
          final participant = payload.participant;
          return _controller.participants.removeBySessionId(
            participant.sessionId,
          );
        },
      );
  }

  final String cid;
  final Credentials credentials;
  final CallOptions callOptions;

  final void Function(Call)? onCallConnected;
  final void Function(Call)? onCallLeft;

  late final SfuClient _client;

  rtc.RTCPeerConnection? _publisher;
  rtc.RTCPeerConnection? _subscriber;
  final _iceTrickleBuffer = IceTrickleBuffer();

  final _controller = _CallController();

  List<CallParticipant> get participants {
    return _controller.participants.value;
  }

  Stream<List<CallParticipant>> get participantsStream {
    return _controller.participants.stream;
  }

  LocalCallParticipant? get localParticipant {
    return _controller.participants.local;
  }

  List<CallParticipant> get remoteParticipants {
    return _controller.participants.remote;
  }

  Future<void> leave() async {
    await _subscriber?.close();
    _subscriber = null;

    // Un-publish all the local and remote participant tracks.
    await Future.wait([
      unpublishAllLocalTracks(),
      for (final participant in remoteParticipants)
        unpublishAllRemoteTracks(
          participantSessionId: participant.sessionId,
        ),
    ]);

    await _publisher?.close();
    _publisher = null;

    await _client.disconnect();
    await _controller.dispose();
    await _iceTrickleBuffer.dispose();

    onCallLeft?.call(this);
  }

  Future<Call> connect({
    ConnectOptions options = const ConnectOptions(),
  }) async {
    logger.info('Joining call $cid');

    await _client.connect();

    _subscriber = await createSubscriber(
      sfuClient: _client,
      configuration: _connectionConfig,
      onIceCandidates: _iceTrickleBuffer.onSubscriberCandidates,
      onTrack: _onTrack,
    );

    final results = await Future.wait([
      // audio
      codecs.getSenderCodecs(rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio),
      codecs.getReceiverCodecs(
        rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio,
        _subscriber,
      ),

      // video
      codecs.getSenderCodecs(rtc.RTCRtpMediaType.RTCRtpMediaTypeVideo),
      codecs.getReceiverCodecs(
        rtc.RTCRtpMediaType.RTCRtpMediaTypeVideo,
        _subscriber,
      ),
    ]);

    final audioEncodes = results[0];
    final audioDecodes = results[1];
    final videoEncodes = results[2];
    final videoDecodes = results[3];

    _client.send(
      request: SfuRequest(
        joinRequest: JoinRequest(
          publish: true,
          token: credentials.token,
          sessionId: _client.sessionId,
          codecSettings: CodecSettings(
            audio: AudioCodecs(
              encodes: audioEncodes,
              decodes: audioDecodes,
            ),
            video: VideoCodecs(
              encodes: videoEncodes,
              decodes: videoDecodes,
            ),
          ),
        ),
      ),
    );

    // Waiting for the join response event.
    final event = await _client.waitFor(
      event: SfuEvent_EventPayload.joinResponse.name,
      duration: _timeoutDuration,
    );

    final joinResponse = event.joinResponse;
    await _handleConnected(response: joinResponse, options: options);

    logger.fine('Call Connect completed');

    onCallConnected?.call(this);

    return this;
  }

  Future<void> _handleConnected({
    required JoinResponse response,
    ConnectOptions options = const ConnectOptions(),
  }) async {
    _publisher = await createPublisher(
      sfuClient: _client,
      configuration: _connectionConfig,
      onIceCandidates: _iceTrickleBuffer.onPublisherCandidates,
    );

    final ownSessionId = response.ownSessionId;
    final callState = response.callState;
    final sfuParticipants = callState.participants;

    // Updating all the participants first.
    _controller.participants.value = [
      ...sfuParticipants.map((it) {
        CallParticipant participant;
        if (it.sessionId == ownSessionId) {
          participant = LocalCallParticipant.fromSfu(it);
        } else {
          participant = CallParticipant.fromSfu(it);
        }

        return participant;
      }),
    ];

    final audio = options.microphone;
    if (audio.enabled) {
      final track = audio.track;
      if (track != null) {
        await publishLocalAudioTrack(track);
      } else {
        await setMicrophoneEnabled();
      }
    }

    final video = options.camera;
    if (video.enabled) {
      final track = video.track;
      if (track != null) {
        await publishLocalVideoTrack(track);
      } else {
        await setCameraEnabled();
      }
    }

    final screen = options.screenShare;
    if (screen.enabled) {
      final track = screen.track;
      if (track != null) {
        await publishLocalVideoTrack(track);
      } else {
        await setScreenShareEnabled();
      }
    }

    // Updating local participant tracks.
    _controller.participants.value = [
      ...participants.map((it) {
        if (it.isLocal) {
          return (it as LocalCallParticipant).copyWith(
            tracks: [
              ...?_controller.localTracks
                  .getTracksForSession(ownSessionId)
                  ?.values,
            ],
          );
        }
        return it;
      }),
    ];
  }

  Future<rtc.MediaStream> changeInputDevice({
    required rtc.RTCRtpMediaType kind,
    required String deviceId,
    Map<String, dynamic> extras = const {},
  }) async {
    if (_publisher == null) {
      throw StateError('Call must be joined before changing input device');
    }

    logger.info('Changing input device for $kind to $deviceId');

    final constraints = {...extras};
    if (kind == rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio) {
      constraints['audio'] = {
        'deviceId': deviceId,
      };
    } else if (kind == rtc.RTCRtpMediaType.RTCRtpMediaTypeVideo) {
      constraints['video'] = {
        'deviceId': deviceId,
      };
    }

    final mediaStream =
        await rtc.navigator.mediaDevices.getUserMedia(constraints);
    final newTrack = kind == rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio
        ? mediaStream.getAudioTracks().first
        : mediaStream.getVideoTracks().first;

    final senders = await _publisher!.getSenders();
    final sender = senders.firstWhereOrNull(
      (it) => it.track?.kind == newTrack.kind,
    );

    if (sender == null || sender.track == null) {
      throw "Can't find a sender for $newTrack with $kind";
    }

    await sender.track!.stop(); // release old track
    await sender.replaceTrack(newTrack);

    return mediaStream;
  }

  /// Update track subscription configuration for one or more participants.
  ///
  /// You have to create a subscription for each participant you want to receive
  /// any kind of track.
  Future<UpdateSubscriptionsResponse> updateSubscriptionsPartial(
    Map<String, TrackSize?> changes,
  ) {
    logger.info('Updating subscriptions for $changes');

    _controller.participants.value = [
      ...participants.map((it) {
        final change = changes[it.sessionId];

        if (change == null) return it;
        return it.copyWith(trackSize: change);
      }),
    ];

    return updateSubscriptions(participants);
  }

  Future<UpdateSubscriptionsResponse> updateSubscriptions(
    List<CallParticipant> participants,
  ) {
    final subscriptions = <String, TrackSize>{};
    for (final participant in participants) {
      // TODO: Don't update for current user.
      if (participant.trackSize != null) {
        subscriptions[participant.id] = participant.trackSize!;
      }
    }

    return _client.updateSubscriptions(subscriptions: subscriptions);
  }

  Future<String?> getActiveInputDeviceId({
    required TrackType kind,
  }) async {
    if (_publisher == null) {
      throw StateError('Call must be joined before getting input device id');
    }

    logger.info('Getting active input device id for $kind');

    final senders = await _publisher!.getSenders();
    final sender = senders.firstWhereOrNull((it) {
      return it.track?.kind == kind.toRtcTrackKind();
    });

    final deviceId = sender?.track?.getSettings()['deviceId'] as String?;
    return deviceId;
  }

  Future<List<rtc.StatsReport>?> getStats({
    required StatKind kind,
    rtc.MediaStreamTrack? selector,
  }) async {
    logger.info('Getting stats for $kind');

    switch (kind) {
      case StatKind.sender:
        return _subscriber?.getStats(selector);
      case StatKind.publisher:
        return _publisher?.getStats(selector);
    }
  }

  Future<UpdateMuteStateResponse> updateMuteState({
    required TrackType trackType,
    required bool muted,
  }) async {
    if (_publisher == null) {
      throw StateError('Call must be joined before updating mute state');
    }

    logger.info('Updating mute state for $trackType to $muted');

    final senders = await _publisher!.getSenders();
    final sender = senders.firstWhereOrNull((it) {
      return it.track?.kind == trackType.toRtcTrackKind();
    });

    if (sender == null || sender.track == null) {
      throw "Can't find a sender for $trackType";
    }

    sender.track!.enabled = !muted;

    switch (trackType) {
      case TrackType.audio:
        return _client.updateAudioMuteState(muted: muted);
      case TrackType.video:
        return _client.updateVideoMuteState(muted: muted);
    }
  }

  Future<bool> updatePublishQuality({required List<String> enabledRids}) async {
    logger.info('Updating publish quality for $enabledRids');

    final senders = await _publisher?.getSenders();
    final videoSender = senders?.firstWhere((s) => s.track?.kind == 'video');

    if (videoSender == null) throw 'No video sender found';

    final params = videoSender.parameters;

    var changed = false;
    for (final encoding in params.encodings!) {
      // flip 'active' flag only when necessary
      final shouldEnable = enabledRids.contains(encoding.rid);
      if (shouldEnable != encoding.active) {
        encoding.active = shouldEnable;
        changed = true;
      }
    }

    if (changed) {
      return videoSender.setParameters(params);
    }

    return false;
  }

  void _onTrack(rtc.RTCTrackEvent event) async {
    logger.fine('[WebRTC] pc.onTrack');

    final stream = event.streams.firstOrNull;
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

    await Future.delayed(const Duration(seconds: 6));

    // if (_client.connectionState == ConnectionState.reconnecting ||
    //     _client.connectionState == ConnectionState.connecting) {
    //   final track = event.track;
    //   final receiver = event.receiver;
    //
    //   events.on<EngineConnectionStateUpdatedEvent>((event) async {
    //     Timer(const Duration(milliseconds: 10), () {
    //       events.emit(EngineTrackAddedEvent(
    //         track: track,
    //         stream: stream,
    //         receiver: receiver,
    //       ));
    //     });
    //   });
    //   return;
    // }

    if (_client.connectionState == ConnectionState.disconnected) {
      logger.warning('skipping incoming track after Room disconnected');
      return;
    }

    logger.fine('EngineTrackAddedEvent trackSid:${event.track.id}');

    final track = event.track;
    final idParts = stream.id.split(':');
    final trackLookupId = idParts.first;

    final participantToUpdate = participants.firstWhereOrNull((it) {
      return it.trackLookupPrefix == trackLookupId;
    });

    if (participantToUpdate == null) {
      return logger.warning('Participant not found for track $track');
    }

    try {
      if (trackLookupId.isEmpty) {
        return logger.warning('Track session id is empty');
      }

      await addSubscribedRemoteMediaTrack(
        track,
        stream,
        trackLookupId,
        participantToUpdate.sessionId,
      );

      _controller.participants.update(
        participantToUpdate.copyWith(
          tracks: [
            ...?_controller.remoteTracks
                .getTracksForSession(participantToUpdate.sessionId)
                ?.values,
          ],
        ),
      );
    } catch (exception) {
      // We don't want to pass up any exception so catch everything here.
      return logger.warning(
        'Unknown exception on addSubscribedMediaTrack() $exception',
      );
    }
  }

  RTCConfiguration get _connectionConfig {
    final config = rtcConfigurationFromICEServers(credentials.iceServers);
    return config ?? defaultRtcConfiguration(credentials.server.url);
  }
}

class _CallController {
  final participants = CallParticipantsController();
  final localTracks = PublishedTracksController<LocalTrack>();
  final remoteTracks = PublishedTracksController<RemoteTrack>();

  Future<void> dispose() async {
    await participants.dispose();
    await localTracks.dispose();
    await remoteTracks.dispose();
  }
}

///
extension LocalTrackHandler on Call {
  /// Shortcut for publishing a [TrackSource.camera].
  Future<LocalTrack?> setCameraEnabled({bool enabled = true}) {
    return setSourceEnabled(source: TrackSource.camera, enabled: enabled);
  }

  /// Shortcut for publishing a [TrackSource.microphone].
  Future<LocalTrack?> setMicrophoneEnabled({bool enabled = true}) {
    return setSourceEnabled(source: TrackSource.microphone, enabled: enabled);
  }

  /// Shortcut for publishing a [TrackSource.screenShareVideo].
  Future<LocalTrack?> setScreenShareEnabled({
    bool enabled = true,
    bool? captureScreenAudio,
  }) {
    return setSourceEnabled(
      source: TrackSource.screenShareVideo,
      enabled: enabled,
      captureScreenAudio: captureScreenAudio,
    );
  }

  /// A convenience method to publish a track for a specific [TrackSource].
  /// This is the recommended method to publish tracks.
  Future<LocalTrack?> setSourceEnabled({
    required TrackSource source,
    required bool enabled,
    bool? captureScreenAudio,
  }) async {
    logger.fine('setSourceEnabled(source: $source, enabled: $enabled)');
    final track = getPublishedLocalTrackBySource(source);
    if (track != null) {
      if (enabled) {
        await track.mute(muted: false);
      } else {
        if (source == TrackSource.screenShareVideo) {
          final trackSid = track.sid;
          if (trackSid != null) {
            await unpublishLocalTrack(trackSid: trackSid);
          }
        } else {
          await track.mute();
        }
      }
      return track;
    } else if (enabled) {
      if (source == TrackSource.camera) {
        final track = await LocalVideoTrack.createCameraTrack(
          callOptions.defaultCameraCaptureOptions,
        );
        return publishLocalVideoTrack(track);
      } else if (source == TrackSource.microphone) {
        final track = await LocalAudioTrack.create(
          callOptions.defaultAudioCaptureOptions,
        );
        return publishLocalAudioTrack(track);
      } else if (source == TrackSource.screenShareVideo) {
        // When capturing chrome table audio, we can't capture audio/video
        // track separately, it has to be returned once in getDisplayMedia,
        // so we publish it twice here, but only return videoTrack to user.
        if (captureScreenAudio != null) {
          final tracks = await LocalVideoTrack.createScreenShareTracksWithAudio(
            ScreenShareCaptureOptions(captureScreenAudio: captureScreenAudio),
          );
          LocalVideoTrack? videoTrack;
          for (final track in tracks) {
            if (track is LocalVideoTrack) {
              videoTrack = await publishLocalVideoTrack(track);
            } else if (track is LocalAudioTrack) {
              await publishLocalAudioTrack(track);
            }
          }

          // just return the video track.
          return videoTrack;
        }
        final track = await LocalVideoTrack.createScreenShareTrack(
          callOptions.defaultScreenShareCaptureOptions,
        );
        return publishLocalVideoTrack(track);
      }
    }
    return null;
  }

  Future<LocalVideoTrack> publishLocalVideoTrack(
    LocalVideoTrack track, {
    VideoPublishOptions? publishOptions,
  }) async {
    if (localVideoTracks.any((it) {
      return it.mediaStreamTrack.id == track.mediaStreamTrack.id;
    })) {
      throw Exception('Track already published');
    }

    // Use defaultPublishOptions if options is null
    publishOptions ??= callOptions.defaultVideoPublishOptions;

    // use constraints passed to getUserMedia by default
    var dimensions = track.currentOptions.params.dimensions;

    if (CurrentPlatform.isWeb) {
      // getSettings() is only implemented for Web
      try {
        // try to use getSettings for more accurate resolution
        final settings = track.mediaStreamTrack.getSettings();
        if (settings['width'] is int) {
          dimensions = dimensions.copyWith(width: settings['width'] as int);
        }
        if (settings['height'] is int) {
          dimensions = dimensions.copyWith(height: settings['height'] as int);
        }
      } catch (_) {
        logger.warning('Failed to call `mediaStreamTrack.getSettings()`');
      }
    }

    // Video encodings and simulcasts
    final encodings = codecs.computeVideoEncodings(
      isScreenShare: track.source == TrackSource.screenShareVideo,
      dimensions: dimensions,
      options: publishOptions,
    );

    // TODO: Publish layers to Signal
    final layers = codecs.computeVideoLayers(dimensions, encodings);

    await track.start();

    final transceiverInit = rtc.RTCRtpTransceiverInit(
      direction: rtc.TransceiverDirection.SendOnly,
      sendEncodings: encodings,
      streams: [track.mediaStream],
    );

    track.transceiver = await _publisher?.addTransceiver(
      track: track.mediaStreamTrack,
      kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: transceiverInit,
    );

    final sessionId = _client.sessionId;
    final trackLookupId = localParticipant!.trackLookupPrefix;
    track.sid = 'video:$trackLookupId';
    _controller.localTracks.add(sessionId, track);

    return track;
  }

  Future<LocalAudioTrack> publishLocalAudioTrack(
    LocalAudioTrack track, {
    AudioPublishOptions? publishOptions,
  }) async {
    if (localAudioTracks.any((it) {
      return it.mediaStreamTrack.id == track.mediaStreamTrack.id;
    })) {
      throw Exception('Track already published');
    }

    // Use defaultPublishOptions if options is null
    publishOptions ??= callOptions.defaultAudioPublishOptions;

    await track.start();

    final transceiverInit = rtc.RTCRtpTransceiverInit(
      direction: rtc.TransceiverDirection.SendOnly,
      sendEncodings: [
        if (publishOptions.audioBitrate > 0)
          rtc.RTCRtpEncoding(maxBitrate: publishOptions.audioBitrate),
      ],
    );

    // addTransceiver cannot pass in a kind parameter due to a bug in
    // flutter-webrtc (web)
    track.transceiver = await _publisher?.addTransceiver(
      track: track.mediaStreamTrack,
      kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: transceiverInit,
    );

    final sessionId = _client.sessionId;
    final trackLookupId = localParticipant!.trackLookupPrefix;
    track.sid = 'audio:$trackLookupId';
    _controller.localTracks.add(sessionId, track);

    return track;
  }

  Future<void> unpublishLocalTrack({required String trackSid}) async {
    logger.finer('Unpublish track sessionId: $trackSid');

    final track = _controller.localTracks.remove(_client.sessionId, trackSid);

    if (track == null) return;

    if (callOptions.stopLocalTrackOnUnpublish) {
      await track.stop();
    }

    final sender = track.sender;
    if (sender != null) {
      try {
        await _publisher?.removeTrack(sender);
      } catch (_) {
        logger.warning('[$runtimeType] rtc.removeTrack() did throw $_');
      }
    }
  }

  /// Convenience method to unpublish all local tracks.
  Future<void> unpublishAllLocalTracks() async {
    final localTracks = _controller.localTracks.all(_client.sessionId);
    final trackSids = localTracks.keys.toSet();
    for (final sid in trackSids) {
      await unpublishLocalTrack(trackSid: sid);
    }
  }

  /// Convenience method to rePublish all local tracks.
  Future<void> rePublishAllLocalTracks() async {
    final tracks = [...localTracks];
    _controller.localTracks.clear();
    for (final track in tracks) {
      if (track is LocalAudioTrack) {
        await publishLocalAudioTrack(track);
      } else if (track is LocalVideoTrack) {
        await publishLocalVideoTrack(track);
      }
    }
  }

  /// A convenience property to get all local tracks.
  List<LocalTrack> get localTracks {
    return [..._controller.localTracks.all(_client.sessionId).values];
  }

  /// A convenience property to get all local video tracks.
  List<LocalVideoTrack> get localVideoTracks {
    return [..._controller.localTracks.video(_client.sessionId).values];
  }

  /// A convenience property to get all local audio tracks.
  List<LocalAudioTrack> get localAudioTracks {
    return [..._controller.localTracks.audio(_client.sessionId).values];
  }

  /// Tries to find a [TrackPublication] by its [TrackSource]. Otherwise, will
  /// return a compatible type of [TrackPublication] for the [TrackSource] specified.
  /// returns null when not found.
  LocalTrack? getPublishedLocalTrackBySource(TrackSource source) {
    if (source == TrackSource.unknown) return null;

    final publishedTracks = [...localTracks];
    // try to find by source
    final result = publishedTracks.firstWhereOrNull((e) => e.source == source);
    if (result != null) return result;
    // try to find by compatibility
    return publishedTracks
        .where((e) => e.source == TrackSource.unknown)
        .firstWhereOrNull((e) =>
            (source == TrackSource.microphone && e.kind == TrackType.audio) ||
            (source == TrackSource.camera &&
                e.kind == TrackType.video &&
                e.name != Track.screenShareName) ||
            (source == TrackSource.screenShareVideo &&
                e.kind == TrackType.video &&
                e.name == Track.screenShareName) ||
            (source == TrackSource.screenShareAudio &&
                e.kind == TrackType.audio &&
                e.name == Track.screenShareName));
  }
}

///
extension RemoteTrackHandler on Call {
  /// A convenience property to get all remote tracks.
  List<RemoteTrack> get localTracks {
    return [..._controller.remoteTracks.all(_client.sessionId).values];
  }

  /// A convenience property to get all remote video tracks.
  List<RemoteVideoTrack> get localVideoTracks {
    return [..._controller.remoteTracks.video(_client.sessionId).values];
  }

  /// A convenience property to get all remote audio tracks.
  List<RemoteAudioTrack> get localAudioTracks {
    return [..._controller.remoteTracks.audio(_client.sessionId).values];
  }

  Future<void> addSubscribedRemoteMediaTrack(
    rtc.MediaStreamTrack mediaTrack,
    rtc.MediaStream stream,
    String trackLookupId,
    String participantSessionId, {
    rtc.RTCRtpReceiver? receiver,
  }) async {
    logger.fine('addSubscribedMediaTrack()');

    final trackKind = TrackType.fromRtcTrackKind(mediaTrack.kind);

    // Check if track type is supported, throw if not.
    if (![TrackType.audio, TrackType.video].contains(trackKind)) {
      throw Exception('Unsupported track kind: $trackKind');
    }

    // create Track
    final RemoteTrack track;
    if (trackKind == TrackType.video) {
      // video track
      track = RemoteVideoTrack(
        // TODO: Save and use the source from the SFU
        name: Track.cameraName,
        source: TrackSource.camera,
        mediaStream: stream,
        mediaStreamTrack: mediaTrack,
        receiver: receiver,
      );
    } else if (trackKind == TrackType.audio) {
      // audio track
      track = RemoteAudioTrack(
        // TODO: Save and use the source from the SFU
        name: Track.microphoneName,
        source: TrackSource.microphone,
        mediaStream: stream,
        mediaStreamTrack: mediaTrack,
        receiver: receiver,
      );
    } else {
      throw Exception('Unsupported track kind: $trackKind');
    }

    await track.start();
    track.sid = '${mediaTrack.kind}:$trackLookupId';
    _controller.remoteTracks.add(participantSessionId, track);
  }

  Future<void> removePublishedRemoteTrack({
    required String trackSid,
    required String participantSessionId,
  }) async {
    logger.finer('removePublishedTrack track sid: $trackSid');
    final track = _controller.remoteTracks.remove(
      participantSessionId,
      trackSid,
    );

    if (track == null) {
      return logger.warning('Track not found $trackSid');
    }

    await track.stop();
  }

  /// Convenience method to unpublish a remote track.
  Future<void> unpublishRemoteTrack({
    required String trackSessionId,
    required String participantSessionId,
  }) async {
    logger.finer('Unpublish remote track sessionId: $trackSessionId');
    final track = _controller.remoteTracks.remove(
      participantSessionId,
      trackSessionId,
    );

    if (track == null) return;

    if (callOptions.stopLocalTrackOnUnpublish) {
      await track.stop();
    }

    final sender = track.sender;
    if (sender != null) {
      try {
        await _publisher?.removeTrack(sender);
      } catch (_) {
        logger.warning('[$runtimeType] rtc.removeTrack() did throw $_');
      }
    }
  }

  /// Convenience method to unpublish all remote tracks.
  Future<void> unpublishAllRemoteTracks({
    required String participantSessionId,
  }) async {
    final tracks = _controller.remoteTracks.all(participantSessionId);
    final trackSids = tracks.keys.toSet();
    for (final sid in trackSids) {
      await unpublishRemoteTrack(
        trackSessionId: sid,
        participantSessionId: participantSessionId,
      );
    }
  }
}
