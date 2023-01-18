import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../../../../protobuf/video/sfu/event/events.pb.dart' as sfu_events;
import '../../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../../disposable.dart';
import '../../../logger/stream_logger.dart';
import '../../action/user_action.dart';
import '../../errors/video_error.dart';
import '../../errors/video_error_composer.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../sfu/data/models/sfu_model_mapper_extensions.dart';
import '../../sfu/data/models/sfu_model_parser.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../../sfu/sfu_client.dart';
import '../../sfu/sfu_client_impl.dart';
import '../../sfu/ws/sfu_event_listener.dart';
import '../../sfu/ws/sfu_ws.dart';
import '../../shared_emitter.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../utils/result_converters.dart';
import '../../webrtc/model/rtc_tracks_info.dart';
import '../../webrtc/model/rtc_video_dimension.dart';
import '../../webrtc/peer_connection.dart';
import '../../webrtc/peer_type.dart';
import '../../webrtc/rtc_manager.dart';
import '../../webrtc/rtc_manager_factory.dart';
import '../../webrtc/rtc_track.dart';
import 'call_session_config.dart';

class CallSession extends Disposable with SfuEventListener {
  CallSession({
    required this.callCid,
    required this.sessionId,
    required this.config,
  })  : sfuClient = SfuClientImpl(
          baseUrl: config.sfuUrl,
          authToken: config.sfuToken,
        ),
        sfuWS = SfuWebSocket(
          sfuUrl: config.sfuUrl,
          sessionId: sessionId,
        ),
        rtcManagerFactory = RtcManagerFactory(
          sessionId: sessionId,
          callCid: callCid,
          configuration: config.rtcConfig,
        );

  final _logger = taggedLogger(tag: 'SV:CallSession');

  final String callCid;
  final String sessionId;
  final CallSessionConfig config;
  final SfuClientV2 sfuClient;
  final SfuWebSocket sfuWS;
  final RtcManagerFactory rtcManagerFactory;
  late final RtcManager rtcManager;

  SharedEmitter<SfuEventV2> get events => _events;
  final _events = MutableSharedEmitterImpl<SfuEventV2>();

  Future<Result<bool>> start() async {
    try {
      sfuWS.addEventListener(this);
      await sfuWS.connect();
      final genericSdp = await RtcManager.getGenericSdp();

      sfuWS.send(
        sfu_events.SfuRequest(
          joinRequest: sfu_events.JoinRequest(
            token: config.sfuToken,
            sessionId: sessionId,
            subscriberSdp: genericSdp,
          ),
        ),
      );

      final event = await _events.waitFor<SfuJoinResponseEvent>(
        timeLimit: const Duration(seconds: 30),
      );

      // TODO: Update participants from the event.callState

      rtcManager = await rtcManagerFactory.makeRtcManager(publisherId: '')
        ..onPublisherIceCandidate = _onLocalIceCandidate
        ..onSubscriberIceCandidate = _onLocalIceCandidate
        ..onPublisherTrackMuted = _onPublisherTrackMuted
        ..onPublisherNegotiationNeeded = _onPublisherNegotiationNeeded;

      return true.toSuccess();
    } catch (e, stk) {
      _logger.e(() => '[establish] failed: $e');
      return VideoErrors.compose(e, stk).toFailure();
    }
  }

  @override
  Future<void> dispose() async {
    sfuWS.removeEventListener(this);
    await sfuWS.disconnect();
    await rtcManager.dispose();
    return await super.dispose();
  }

  Future<Result<None>> apply(UserAction action) async {
    if (action is SetCameraEnabled) {
      return _onSetCameraEnabled(action.enabled);
    } else if (action is SetMicrophoneEnabled) {
      return _onSetMicrophoneEnabled(action.enabled);
    } else if (action is SetScreenShareEnabled) {
      return _onSetScreenShareEnabled(action.enabled);
    }

    return None().toSuccess();
  }

  @override
  void onSfuError(VideoError error) {
    // TODO: implement onError
  }

  @override
  void onSfuEvent(SfuEventV2 event) async {
    _events.emit(event);

    if (event is SfuSubscriberOfferEvent) {
      await _onSubscriberOffer(event);
    } else if (event is SfuIceTrickleEvent) {
      await _onRemoteIceCandidate(event);
    }
  }

  Future<void> _onSubscriberOffer(SfuSubscriberOfferEvent event) async {
    final offerSdp = event.sdp;
    _logger.i(() => '[onSfuSubscriberOfferEvent] event: $event');
    final answerSdp = await rtcManager.onSubscriberOffer(offerSdp);
    if (answerSdp == null) return;

    await sfuClient.sendAnswer(
      sfu.SendAnswerRequest(
        sdp: answerSdp,
        peerType: sfu_models.PeerType.PEER_TYPE_SUBSCRIBER,
      ),
    );
  }

  Future<void> _onRemoteIceCandidate(SfuIceTrickleEvent event) async {
    _logger.d(() => '[onRemoteIceCandidate] event: $event');
    rtcManager.onRemoteIceCandidate(
      peerType: event.peerType,
      iceCandidate: event.iceCandidate,
    );
  }

  void _onLocalIceCandidate(
    StreamPeerConnection pc,
    rtc.RTCIceCandidate candidate,
  ) {
    _logger.d(
      () => '[onLocalIceCandidate] type: ${pc.type}, candidate: $candidate',
    );

    final encodedIceCandidate = json.encode(candidate.toMap());
    final peerType = pc.type == StreamPeerType.publisher
        ? sfu_models.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED
        : sfu_models.PeerType.PEER_TYPE_SUBSCRIBER;

    sfuClient.sendIceCandidate(
      sfu_models.ICETrickle(
        peerType: peerType,
        sessionId: sessionId,
        iceCandidate: encodedIceCandidate,
      ),
    );
  }

  void _onPublisherTrackMuted(RtcLocalTrack track, bool muted) {
    _logger.d(() => '[onPublisherTrackMuted] track: $track');

    sfuClient.updateMuteState(
      sfu.UpdateMuteStatesRequest(
        sessionId: sessionId,
        muteStates: [
          sfu.TrackMuteState(
            trackType: track.trackType.toDTO(),
            muted: muted,
          )
        ],
      ),
    );
  }

  Future<void> _onPublisherNegotiationNeeded(StreamPeerConnection pc) async {
    _logger.d(
      () => '[onPubNegotiationNeeded] type: ${pc.type}',
    );

    final offer = await pc.createOffer();
    if (offer is! Success<rtc.RTCSessionDescription>) return;

    final tracksInfo = rtcManager.getPublisherTrackInfos();

    _logger.v(() => '[onPubNegotiationNeeded] tracksInfo: $tracksInfo');

    final pubResult = await sfuClient.setPublisher(
      sfu.SetPublisherRequest(
        sdp: offer.data.sdp,
        tracks: tracksInfo.toDTO(),
      ),
    );
    if (pubResult is! Success<sfu.SetPublisherResponse>) {
      _logger.w(
        () => '[onPubNegotiationNeeded] #setPublisher; failed: $pubResult',
      );
      return;
    }
    final ansResult = await pc.setRemoteAnswer(pubResult.data.sdp);
    if (ansResult is! Success<void>) {
      _logger.w(
        () => '[onPubNegotiationNeeded] #setRemoteAnswer; failed: $ansResult',
      );
    }
  }

  RtcTrack? getTrack(String trackId) {
    return rtcManager.getTrack(trackId);
  }

  Future<Result<None>> _onSetCameraEnabled(bool enabled) async {
    final track = await rtcManager.setCameraEnabled(enabled: enabled);
    if (track == null) return None().toFailure();
    return None().toSuccess();
  }

  Future<Result<None>> _onSetMicrophoneEnabled(bool enabled) async {
    final track = await rtcManager.setMicrophoneEnabled(enabled: enabled);
    if (track == null) return None().toFailure();
    return None().toSuccess();
  }

  Future<Result<None>> _onSetScreenShareEnabled(bool enabled) async {
    final track = await rtcManager.setScreenShareEnabled(enabled: enabled);
    if (track == null) return None().toFailure();
    return None().toSuccess();
  }
}

extension RtcTracksInfoMapper on List<RtcTrackInfo> {
  List<sfu_models.TrackInfo> toDTO() {
    return map((info) {
      return sfu_models.TrackInfo(
        trackId: info.trackId,
        trackType: info.trackType?.toDTO(),
        mid: info.mid,
        layers: info.layers?.map((layer) {
          return sfu_models.VideoLayer(
            rid: layer.rid,
            videoDimension: sfu_models.VideoDimension(
              width: layer.videoDimension?.width,
              height: layer.videoDimension?.height,
            ),
            bitrate: layer.bitrate,
          );
        }),
      );
    }).toList();
  }
}

extension RtcManagerTrackHelper on RtcManager {
  Future<RtcLocalTrack?> setCameraEnabled({bool enabled = true}) {
    return setTrackEnabled(
      trackType: SfuTrackType.video,
      enabled: enabled,
    );
  }

  Future<RtcLocalTrack?> setMicrophoneEnabled({bool enabled = true}) {
    return setTrackEnabled(
      trackType: SfuTrackType.audio,
      enabled: enabled,
    );
  }

  Future<RtcLocalTrack?> setScreenShareEnabled({bool enabled = true}) {
    return setTrackEnabled(
      trackType: SfuTrackType.screenShare,
      enabled: enabled,
    );
  }

  Future<RtcLocalTrack?> setTrackEnabled({
    required SfuTrackType trackType,
    required bool enabled,
  }) async {
    final track = getPublisherTracks().firstWhereOrNull(
      (track) => track.trackType == trackType,
    );

    // Track found, mute/unmute it.
    if (track != null) {
      if (enabled) {
        await unmuteTrack(trackSid: track.trackSid);
      } else {
        // ScreenShare cannot be muted, Un-publish instead
        if (trackType == SfuTrackType.screenShare) {
          await unpublishTrack(trackSid: track.trackSid);

          // Also un-publish the audio track if it was published
          final screenShareAudioTrack = getPublisherTracks().firstWhereOrNull(
            (track) => track.trackType == SfuTrackType.screenShareAudio,
          );
          if (screenShareAudioTrack != null) {
            await unpublishTrack(trackSid: screenShareAudioTrack.trackSid);
          }
        } else {
          await muteTrack(trackSid: track.trackSid);
        }
      }
      return track;
    }

    // Track not found, create a new one and publish it if enabled is true.
    if (enabled) {
      if (trackType == SfuTrackType.video) {
        final videoTrack = await createCameraTrack();
        return publishVideoTrack(track: videoTrack!);
      } else if (trackType == SfuTrackType.audio) {
        final audioTrack = await createAudioTrack();
        return publishAudioTrack(track: audioTrack!);
      } else if (trackType == SfuTrackType.screenShare) {
        final screenShareTrack = await createScreenShareTrack();
        return publishVideoTrack(track: screenShareTrack!);
      }
    }

    return null;
  }
}
