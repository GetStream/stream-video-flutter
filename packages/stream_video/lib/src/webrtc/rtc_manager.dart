import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../open_api/video/coordinator/api.dart';
import '../disposable.dart';
import '../errors/video_error_composer.dart';
import '../logger/impl/tagged_logger.dart';
import '../logger/stream_log.dart';
import '../models/models.dart';
import '../platform_detector/platform_detector.dart';
import '../sfu/data/models/sfu_model_parser.dart';
import '../sfu/data/models/sfu_publish_options.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../sfu/data/models/sfu_video_sender.dart';
import '../utils/extensions.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import 'codecs_helper.dart' as codecs;
import 'codecs_helper.dart';
import 'media/media_constraints.dart';
import 'model/rtc_audio_bitrate_preset.dart';
import 'model/rtc_tracks_info.dart';
import 'model/rtc_video_dimension.dart';
import 'model/rtc_video_encoding.dart';
import 'model/rtc_video_parameters.dart';
import 'peer_connection.dart';
import 'peer_type.dart';
import 'rtc_media_device/rtc_media_device.dart';
import 'rtc_parser.dart';
import 'rtc_track/rtc_track.dart';
import 'transceiver_cache.dart';

/// {@template OnLocalTrackMuted}
/// Callback for when a local track is muted.
/// {@endtemplate}
typedef OnLocalTrackMuted = void Function(RtcLocalTrack track, bool muted);

/// {@template OnLocalTrackPublished}
/// Called when a local track is published.
/// {@endtemplate}
typedef OnLocalTrackPublished = void Function(RtcLocalTrack track);

/// {@template OnRemoteTrackPublished}
/// Called when a subscriber track is received.
/// {@endtemplate}
typedef OnRemoteTrackReceived = void Function(
  StreamPeerConnection pc,
  RtcRemoteTrack track,
);

const _tag = 'SV:RtcManager';

class RtcManager extends Disposable {
  RtcManager({
    required this.sessionId,
    required this.callCid,
    required this.publisherId,
    required this.publisher,
    required this.subscriber,
    required this.publishOptions,
  }) {
    subscriber.onTrack = _onRemoteTrack;
  }

  final _logger = taggedLogger(tag: _tag);

  final String sessionId;
  final StreamCallCid callCid;
  final String? publisherId;
  final StreamPeerConnection? publisher;
  final StreamPeerConnection subscriber;

  final transceiversManager = TransceiverManager();
  List<SfuPublishOptions> publishOptions;

  final tracks = < /*trackId*/ String, RtcTrack>{};

  set onPublisherIceCandidate(OnIceCandidate? cb) {
    publisher?.onIceCandidate = cb;
  }

  set onSubscriberIceCandidate(OnIceCandidate? cb) {
    subscriber.onIceCandidate = cb;
  }

  set onSubscriberIssue(OnIssue? cb) {
    subscriber.onIssue = cb;
  }

  set onPublisherIssue(OnIssue? cb) {
    publisher?.onIssue = cb;
  }

  set onRenegotiationNeeded(OnRenegotiationNeeded? cb) {
    publisher?.onRenegotiationNeeded = cb;
  }

  OnLocalTrackMuted? onLocalTrackMuted;
  OnLocalTrackPublished? onLocalTrackPublished;
  OnRemoteTrackReceived? onRemoteTrackReceived;

  /// Returns a generic sdp.
  static Future<String> getGenericSdp(
    rtc.TransceiverDirection direction,
  ) async {
    final tempPC = await rtc.createPeerConnection({});

    await tempPC.addTransceiver(
      kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: rtc.RTCRtpTransceiverInit(direction: direction),
    );

    await tempPC.addTransceiver(
      kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: rtc.RTCRtpTransceiverInit(direction: direction),
    );

    final offer = await tempPC.createOffer();
    final sdp = offer.sdp;

    await tempPC.dispose();
    return sdp!;
  }

  Future<String?> onSubscriberOffer(String offerSdp) async {
    final result = await subscriber.setRemoteOffer(offerSdp);
    if (result.isFailure) return null;

    final rtcAnswer = await subscriber.createAnswer();
    return rtcAnswer.getDataOrNull()?.sdp;
  }

  Future<Result<None>> onRemoteIceCandidate({
    required StreamPeerType peerType,
    required String iceCandidate,
  }) async {
    final candidate = RtcIceCandidateParser.fromJsonString(iceCandidate);
    if (peerType == StreamPeerType.publisher) {
      return publisher?.addIceCandidate(candidate) ??
          Result.error('no publisher created');
    } else if (peerType == StreamPeerType.subscriber) {
      return subscriber.addIceCandidate(candidate);
    }
    return Result.error('unexpected peerType: $peerType');
  }

  void _onRemoteTrack(StreamPeerConnection pc, rtc.RTCTrackEvent event) {
    _logger.d(
      () => '[onRemoteTrack] event.streams.length: ${event.streams.length}',
    );

    final stream = event.streams.firstOrNull;
    if (stream == null) {
      _logger.w(() => '[onRemoteTrack] stream is null');
      return;
    }
    _logger.v(() => '[onRemoteTrack] stream.id: ${stream.id}');

    event.track.onEnded = () {
      _logger.w(() => '[onRemoteTrack] #onTrackEnded; no args');
    };
    stream.onRemoveTrack = (_) {
      _logger.w(() => '[onRemoteTrack] #onRemoveTrack; no args');
    };

    final track = event.track;
    final transceiver = event.transceiver;

    final idParts = stream.id.split(':');
    final trackId = idParts[0];
    final trackType = idParts[1];

    final remoteTrack = RtcRemoteTrack(
      trackIdPrefix: trackId,
      trackType: SfuTrackTypeParser.parseSfuName(trackType),
      mediaTrack: track,
      mediaStream: stream,
      transceiver: transceiver,
    );

    onRemoteTrackReceived?.call(pc, remoteTrack);
    tracks[remoteTrack.trackId] = remoteTrack;
    _logger.v(() => '[onRemoteTrack] published: ${remoteTrack.trackId}');
  }

  Future<void> unpublishTrack({required String trackId}) async {
    final publishedTrack = tracks.remove(trackId);

    if (publishedTrack == null) {
      _logger.w(() => '[unpublishTrack] rejected (track not found): $trackId');
      return;
    }

    await publishedTrack.stop();

    if (publishedTrack is RtcRemoteTrack) {
      final sender = publishedTrack.transceiver?.sender;

      if (sender != null) {
        try {
          await publisher?.pc.removeTrack(sender);
        } catch (e) {
          _logger.w(() => '[unpublishTrack] removeTrack failed: $e');
        }
      }
    } else if (publishedTrack is RtcLocalTrack) {
      for (final publishOption in publishOptions) {
        if (publishOption.trackType != publishedTrack.trackType) continue;

        final transceiver = transceiversManager.get(publishOption);

        try {
          if (transceiver != null) {
            await publisher?.pc.removeTrack(transceiver.sender);
          }
        } catch (e) {
          _logger.w(() => '[unpublishTrack] removeTrack failed: $e');
        }
      }
    }
  }

  bool isPublishing(SfuTrackType trackType) {
    for (final item in transceiversManager.items()) {
      if (item.publishOption.trackType != trackType) continue;

      final track = item.transceiver.sender.track;
      if (track == null) continue;

      if (track.enabled) return true;
    }

    return false;
  }

  Future<void> onPublishOptionsChanged(
    List<SfuPublishOptions> publishOptions,
  ) async {
    _logger.i(
      () => '[onPublishOptionsChanged] publishOptions: $publishOptions}',
    );

    _logger.v(
      () =>
          '[onPublishOptionsChanged] should publish in CODECS: ${publishOptions.map((e) => e.codec.name).join(', ')}',
    );

    this.publishOptions = publishOptions;

    for (final publishOption in publishOptions) {
      final trackType = publishOption.trackType;

      if (!isPublishing(trackType)) {
        _logger.v(
          () =>
              '[onPublishOptionsChanged] ignoring codec: ${publishOption.codec.name} for track type: $trackType - track is not publishing',
        );
        continue;
      }

      if (transceiversManager.has(publishOption)) {
        _logger.v(
          () =>
              '[onPublishOptionsChanged] already publishing in ${publishOption.codec.name} for $trackType',
        );
        continue;
      }

      final item = transceiversManager.find(
        (t) =>
            t.publishOption.trackType == trackType &&
            t.transceiver.sender.track != null,
      );

      if (item == null) {
        continue;
      }

      _logger.v(
        () =>
            '[onPublishOptionsChanged] adding transceiver for: $trackType with codec: ${publishOption.codec.name}',
      );

      // take the track from the existing transceiver for the same track type,
      // and publish it with the new publish options
      final result = await _addTransceiver(item.track, publishOption);

      if (result is Success) {
        final localTrack = tracks[item.track.trackId] as RtcLocalTrack?;
        if (localTrack != null) {
          tracks[item.track.trackId] = localTrack.copyWith(
            clonedTracks: [
              ...localTrack.clonedTracks,
              result.getDataOrNull()!.mediaTrack,
            ],
          );
        }
      }
    }

    for (final item in transceiversManager.items().toList()) {
      final publishOption = item.publishOption;
      final hasPublishOption = publishOptions.any(
        (option) =>
            option.id == publishOption.id &&
            option.trackType == publishOption.trackType,
      );

      if (hasPublishOption) continue;

      _logger.v(
        () =>
            '[onPublishOptionsChanged] stop publishing and remove transceiver for: ${item.track.trackType} with codec: ${publishOption.codec.name}',
      );

      // it is safe to stop the track here, it is a clone
      await item.transceiver.sender.track?.stop();
      await item.transceiver.sender.replaceTrack(null);
    }
  }

  Future<void> onPublishQualityChanged(
    SfuVideoSender videoSender,
    String? codecInUse,
  ) async {
    final enabledLayers = videoSender.layers.where((e) => e.active).toList();

    _logger.i(
      () =>
          '[onPublishQualityChanged] Update publish quality, requested layers by SFU: $enabledLayers',
    );

    final sender = transceiversManager
        .getWith(
          videoSender.trackType,
          videoSender.publishOptionId,
        )
        ?.sender;

    if (sender == null) {
      _logger.w(() => '[onPublishQualityChanged] no video sender found.');
      return;
    }

    final params = sender.parameters;
    if (params.encodings?.isEmpty ?? true) {
      _logger.w(
        () =>
            '[onPublishQualityChanged] No suitable video encoding quality found',
      );
      return;
    }

    final usesSvcCodec = codecInUse != null && codecs.isSvcCodec(codecInUse);

    _logger.i(
      () =>
          '[onPublishQualityChanged] Codec in use: $codecInUse, uses SVC: $usesSvcCodec',
    );

    var changed = false;
    for (final encoder in params.encodings!) {
      final layer = usesSvcCodec
          ? // for SVC, we only have one layer (q) and often rid is omitted
          enabledLayers.firstOrNull
          : // for non-SVC, we need to find the layer by rid (simulcast)
          enabledLayers.firstWhereOrNull((l) => l.name == encoder.rid) ??
              (params.encodings!.length == 1
                  ? enabledLayers.firstOrNull
                  : null);

      // flip 'active' flag only when necessary
      final shouldActivate = layer?.active ?? false;
      if (shouldActivate != encoder.active) {
        encoder.active = shouldActivate;
        changed = true;
      }

      // skip the rest of the settings if the layer is disabled or not found
      if (layer == null) continue;

      final scaleResolutionDownBy = layer.scaleResolutionDownBy;
      final maxBitrate = layer.maxBitrate;
      final maxFramerate = layer.maxFramerate;
      final scalabilityMode = layer.scalabilityMode;

      if (scaleResolutionDownBy >= 1 &&
          scaleResolutionDownBy != encoder.scaleResolutionDownBy) {
        encoder.scaleResolutionDownBy = scaleResolutionDownBy;
        changed = true;
      }
      if (maxBitrate > 0 && maxBitrate != encoder.maxBitrate) {
        encoder.maxBitrate = maxBitrate;
        changed = true;
      }
      if (maxFramerate > 0 && maxFramerate != encoder.maxFramerate) {
        encoder.maxFramerate = maxFramerate;
        changed = true;
      }
      if (scalabilityMode.isNotEmpty &&
          scalabilityMode != encoder.scalabilityMode) {
        encoder.scalabilityMode = scalabilityMode;
        changed = true;
      }
    }

    final activeLayers = params.encodings!.where((e) => e.active).toList();

    if (!changed) {
      _logger.i(
        () =>
            '[onPublishQualityChanged] Update publish quality, no change: ${activeLayers.map((e) => e.rid)}',
      );
      return;
    }

    await sender.setParameters(params);
    _logger.i(
      () =>
          '[onPublishQualityChanged] Update publish quality, enabled rids: ${activeLayers.map((e) => e.rid)}',
    );
  }

  @override
  Future<void> dispose() async {
    _logger.d(() => '[dispose] no args');
    for (final trackSid in [...tracks.keys]) {
      await unpublishTrack(trackId: trackSid);
    }

    tracks.clear();

    onLocalTrackMuted = null;
    onLocalTrackPublished = null;
    onRemoteTrackReceived = null;

    await publisher?.dispose();
    await subscriber.dispose();

    return super.dispose();
  }

  RtcTrack? getTrack(String trackId) {
    _logger.d(() => '[getTrack] trackId: $trackId');
    return tracks[trackId];
  }

  List<RtcTrack> getTracks(String trackIdPrefix) {
    return [
      ...tracks.values.where((track) {
        return track.trackIdPrefix == trackIdPrefix;
      }),
    ];
  }
}

extension PublisherRtcManager on RtcManager {
  List<RtcLocalTrack> getPublisherTracks() {
    return [...tracks.values.whereType<RtcLocalTrack>()];
  }

  List<RtcRemoteTrack> getSubscriberTracks() {
    return [...tracks.values.whereType<RtcRemoteTrack>()];
  }

  RtcLocalTrack? getPublisherTrackByType(SfuTrackType trackType) {
    final track = getPublisherTracks().firstWhereOrNull((track) {
      return track.trackType == trackType;
    });

    if (track == null) {
      _logger.w(() => '[getPublisherTrackByType] track not found: $trackType');
      return null;
    }

    return track;
  }

  String extractMid(
    rtc.RTCRtpTransceiver transceiver,
    int transceiverInitIndex,
    String? sdp,
  ) {
    if (transceiver.mid.isNotEmpty) return transceiver.mid;
    if (sdp == null) return '';

    final track = transceiver.sender.track;
    if (track == null) {
      return '';
    }

    final parsedSdp = parse(sdp);
    final media = (parsedSdp['media'] as List?)
        ?.cast<Map<String, dynamic>>()
        .reversed
        .firstWhereOrNull(
          (m) =>
              m['type'] == track.kind &&
              ((m['msid'] as String?)?.contains(track.id!) ?? true),
        );

    if (media != null && media['mid'] != null) return media['mid'].toString();
    if (transceiverInitIndex == -1) return '';
    return transceiverInitIndex.toString();
  }

  Future<List<RtcTrackInfo>> getAnnouncedTracks({
    String? sdp,
  }) async {
    final finalSdp = sdp ?? (await publisher?.pc.getLocalDescription())?.sdp;
    final infos = <RtcTrackInfo>[];

    for (final item in transceiversManager.items()) {
      if (item.transceiver.sender.track == null) continue;
      infos.add(_transceiverToTrackInfo(item, sdp: finalSdp));
    }

    return infos;
  }

  Future<List<RtcTrackInfo>> getAnnouncedTracksForReconnect({
    String? sdp,
  }) async {
    final finalSdp = sdp ?? (await publisher?.pc.getLocalDescription())?.sdp;
    final infos = <RtcTrackInfo>[];

    for (final publishOption in publishOptions) {
      final item = transceiversManager.find(
        (c) =>
            c.publishOption.id == publishOption.id &&
            c.publishOption.trackType == publishOption.trackType,
      );

      if (item?.transceiver.sender.track == null) continue;
      infos.add(_transceiverToTrackInfo(item!, sdp: finalSdp));
    }

    return infos;
  }

  RtcTrackInfo _transceiverToTrackInfo(
    TransceiverCache transceiverCache, {
    String? sdp,
  }) {
    final track = transceiverCache.track;

    final transceiverInitialIndex =
        transceiversManager.indexOf(transceiverCache.transceiver);

    if (track is RtcLocalAudioTrack) {
      return RtcTrackInfo(
        trackId: track.mediaTrack.id,
        trackType: track.trackType,
        publishOptionId: transceiverCache.publishOption.id,
        mid: extractMid(
          transceiverCache.transceiver,
          transceiverInitialIndex,
          sdp,
        ),
        layers: [],
        codec: transceiverCache.publishOption.codec,
        muted: transceiverCache.transceiver.sender.track?.enabled ?? true,
      );
    } else if (track is RtcLocalVideoTrack) {
      final dimension = _getTrackDimension(track);

      final encodings = codecs.findOptimalVideoLayers(
        dimensions: _getTrackDimension(track),
        publishOptions: transceiverCache.publishOption,
      );

      return RtcTrackInfo(
        trackId: track.mediaTrack.id,
        trackType: track.trackType,
        publishOptionId: transceiverCache.publishOption.id,
        mid: extractMid(
          transceiverCache.transceiver,
          transceiverInitialIndex,
          sdp,
        ),
        codec: transceiverCache.publishOption.codec,
        muted: transceiverCache.transceiver.sender.track?.enabled ?? true,
        layers: encodings.map((it) {
          final scale = it.scaleResolutionDownBy ?? 1;
          return RtcVideoLayer(
            rid: it.rid ?? '',
            parameters: RtcVideoParameters(
              encoding: RtcVideoEncoding(
                maxBitrate: it.maxBitrate ?? 0,
                maxFramerate: it.maxFramerate ?? 0,
                quality: ridToVideoQuality(it.rid ?? ''),
              ),
              dimension: RtcVideoDimension(
                width: (dimension.width / scale).floor(),
                height: (dimension.height / scale).floor(),
              ),
            ),
          );
        }).toList(),
      );
    }

    throw UnimplementedError('Unsupported track type: ${track.runtimeType}');
  }

  RtcVideoQuality ridToVideoQuality(String rid) {
    switch (rid) {
      case 'q':
        return RtcVideoQuality.lowUnspecified;
      case 'h':
        return RtcVideoQuality.mid;
      default:
        return RtcVideoQuality.high; // default to HIGH
    }
  }

  /// Removes all tracks from the publisher with the given [trackIdPrefix].
  Future<void> removeSubscriber(String trackIdPrefix) async {
    final tracks = getTracks(trackIdPrefix);
    for (final track in tracks) {
      await unpublishTrack(trackId: track.trackId);
    }
  }

  Future<Result<RtcLocalTrack>> publishTrack(RtcLocalTrack track) async {
    if (track is RtcLocalAudioTrack) return publishAudioTrack(track: track);
    if (track is RtcLocalVideoTrack) return publishVideoTrack(track: track);

    return Result.error('Unsupported track type: ${track.runtimeType}');
  }

  Future<Result<RtcLocalAudioTrack>> publishAudioTrack({
    required RtcLocalAudioTrack track,
    bool stopTrackOnMute = true,
  }) async {
    // Add publisherId to the trackIdPrefix if it's a local track.
    if (track.trackIdPrefix == kLocalTrackIdPrefix) {
      track = track.copyWith(trackIdPrefix: publisherId);
    }

    // Adding early as we need to access it in the onPublisherNegotiationNeeded
    // callback.
    _logger.i(() => '[publishAudioTrack] track: $track');
    tracks[track.trackId] = track;
    var updatedTrack = track.copyWith(stopTrackOnMute: stopTrackOnMute);

    final transceivers = <rtc.RTCRtpTransceiver>[];
    for (final option in publishOptions) {
      if (option.trackType != track.trackType) continue;

      final transceiverResult = await _addTransceiver(track, option);
      if (transceiverResult is Failure) return transceiverResult;
      transceivers.add(transceiverResult.getDataOrNull()!.transceiver);

      _logger.v(() => '[publishAudioTrack] transceiver: $transceiverResult');

      updatedTrack = updatedTrack.copyWith(
        clonedTracks: [
          ...updatedTrack.clonedTracks,
          transceiverResult.getDataOrNull()!.mediaTrack,
        ],
      );
    }

    // Notify listeners.
    onLocalTrackPublished?.call(updatedTrack);
    tracks[updatedTrack.trackId] = updatedTrack;

    return Result.success(updatedTrack);
  }

  Future<Result<RtcLocalVideoTrack>> publishVideoTrack({
    required RtcLocalVideoTrack track,
    bool stopTrackOnMute = true,
  }) async {
    // Add publisherId to the trackIdPrefix if it's a local track.
    if (track.trackIdPrefix == kLocalTrackIdPrefix) {
      track = track.copyWith(trackIdPrefix: publisherId);
    }

    // Adding early as we need to access it in the onPublisherNegotiationNeeded
    // callback.
    _logger.i(() => '[publishVideoTrack] track: $track');
    tracks[track.trackId] = track;
    var updatedTrack = track.copyWith(
      videoDimension: _getTrackDimension(track),
      stopTrackOnMute: stopTrackOnMute,
    );

    if (!publishOptions.any((o) => o.trackType == track.trackType)) {
      _logger.w(
        () =>
            '[publishVideoTrack] No publish options found for track type: ${track.trackType}',
      );
      return Result.error(
        'No publish options found for track type: ${track.trackType}',
      );
    }

    for (final option in publishOptions) {
      if (option.trackType != track.trackType) continue;

      final cashedTransceiver = transceiversManager.get(option);
      if (cashedTransceiver == null) {
        final transceiverResult = await _addTransceiver(track, option);
        if (transceiverResult is Failure) return transceiverResult;

        updatedTrack = updatedTrack.copyWith(
          clonedTracks: [
            ...updatedTrack.clonedTracks,
            transceiverResult.getDataOrNull()!.mediaTrack,
          ],
        );

        _logger
            .v(() => '[publishVideoTrack] new transceiver: $transceiverResult');
      } else {
        final previousTrack = cashedTransceiver.sender.track;

        // don't stop the track if we are re-publishing the same track
        if (previousTrack != null && previousTrack != track.mediaTrack) {
          await previousTrack.stop();
        }

        await cashedTransceiver.sender.replaceTrack(track.mediaTrack);

        _logger.v(
          () => '[publishVideoTrack] cached transceiver: $cashedTransceiver',
        );
      }
    }

    // Notify listeners.
    onLocalTrackPublished?.call(updatedTrack);
    tracks[updatedTrack.trackId] = updatedTrack;

    return Result.success(updatedTrack);
  }

  RtcVideoDimension _getTrackDimension(RtcLocalVideoTrack track) {
    var dimension = track.getVideoDimension();

    if (track.trackType == SfuTrackType.screenShare) {
      final physicalSize =
          WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;

      final screenDimension = RtcVideoDimension(
        width: physicalSize.width.toInt(),
        height: physicalSize.height.toInt(),
      );

      _logger.v(() => '[publishVideoTrack] screenDimension: $screenDimension');

      dimension = screenDimension;
    }

    return dimension;
  }

  /// In SVC, we need to send only one video encoding (layer).
  /// this layer will have the additional spatial and temporal layers
  /// defined via the scalabilityMode property.
  List<rtc.RTCRtpEncoding> toSvcEncodings(List<rtc.RTCRtpEncoding> layers) {
    // We take the `f` layer, and we rename it to `q`.
    return layers
        .where((layer) => layer.rid == 'f')
        .map(
          (layer) => rtc.RTCRtpEncoding(
            rid: 'q',
            active: layer.active,
            maxBitrate: layer.maxBitrate,
            maxFramerate: layer.maxFramerate,
            minBitrate: layer.minBitrate,
            numTemporalLayers: layer.numTemporalLayers,
            scaleResolutionDownBy: layer.scaleResolutionDownBy,
            ssrc: layer.ssrc,
            scalabilityMode: layer.scalabilityMode,
          ),
        )
        .toList();
  }

  Future<
      Result<
          ({
            rtc.RTCRtpTransceiver transceiver,
            rtc.MediaStreamTrack mediaTrack,
          })>> _addTransceiver(
    RtcLocalTrack track,
    SfuPublishOptions publishOptions,
  ) async {
    if (publisher == null) {
      return Result.error('Publisher is not created, cannot add transceiver');
    }

    Result<rtc.RTCRtpTransceiver>? transceiverResult;

    // create a clone of the track as otherwise the same trackId will
    // appear in the SDP in multiple transceivers
    final mediaTrackClone = await track.mediaTrack.clone();

    _logger.v(
      () =>
          '[addTransceiver] adding transceiver for: ${publishOptions.codec.name}, trackId: ${mediaTrackClone.id}',
    );

    if (track is RtcLocalAudioTrack) {
      transceiverResult = await publisher!.addAudioTransceiver(
        track: mediaTrackClone,
        encodings: [
          rtc.RTCRtpEncoding(rid: 'a', maxBitrate: AudioBitrate.music),
        ],
      );
    } else if (track is RtcLocalVideoTrack) {
      final videoEncodings = codecs.findOptimalVideoLayers(
        dimensions: _getTrackDimension(track),
        publishOptions: publishOptions,
      );

      final sendEncodings = isSvcCodec(publishOptions.codec.name)
          ? toSvcEncodings(videoEncodings)
          : videoEncodings;

      for (final encoding in sendEncodings) {
        _logger.v(() => '[addTransceiver] encoding: ${encoding.toMap()}');
      }

      transceiverResult = await publisher!.addVideoTransceiver(
        track: mediaTrackClone,
        encodings: sendEncodings,
      );
    } else {
      return Result.error('Unsupported track type: ${track.runtimeType}');
    }

    // Return early if the transceiver could not be added.
    if (transceiverResult is Failure) return transceiverResult;

    final transceiver = transceiverResult.getDataOrNull()!;
    transceiversManager.add(
      track.copyWith(mediaTrack: mediaTrackClone),
      publishOptions,
      transceiver,
    );

    return Result.success(
      (
        transceiver: transceiver,
        mediaTrack: mediaTrackClone,
      ),
    );
  }

  Future<Result<RtcLocalTrack>> muteTrack({required String trackId}) async {
    final track = tracks[trackId];
    if (track == null) {
      _logger.w(() => 'muteTrack: track not found');
      return Result.error('Track not found');
    }

    if (track is! RtcLocalTrack) {
      _logger.w(() => 'muteTrack: track is not local');
      return Result.error('Track is not local');
    }

    track.disable();
    if (track.stopTrackOnMute) {
      // Releases the track and stops the permission indicator.
      await track.stop();
    }

    onLocalTrackMuted?.call(track, true);
    return Result.success(track);
  }

  Future<Result<RtcLocalTrack>> unmuteTrack({required String trackId}) async {
    final track = tracks[trackId];
    if (track == null) {
      _logger.w(() => 'unmuteTrack: track not found');
      return Result.error('Track not found');
    }

    if (track is! RtcLocalTrack) {
      _logger.w(() => 'unmuteTrack: track is not local');
      return Result.error('Track is not local');
    }

    // If the track was released before, restart it.
    if (track.stopTrackOnMute) {
      final transceivers =
          transceiversManager.getTransceiversForTrack(track.trackId).toList();

      final updatedTrack = await track.recreate(transceivers);
      tracks[trackId] = updatedTrack;
      onLocalTrackMuted?.call(updatedTrack, false);

      return Result.success(updatedTrack);
    }

    // Otherwise simply enable it again
    track.enable();
    onLocalTrackMuted?.call(track, false);

    return Result.success(track);
  }

  Future<Result<RtcLocalAudioTrack>> createAudioTrack({
    AudioConstraints constraints = const AudioConstraints(),
  }) async {
    _logger.d(() => '[createAudioTrack] constraints: ${constraints.toMap()}');

    if (publisher == null || publisherId == null) {
      return Result.error(
        'Publisher is not created, cannot create audio track',
      );
    }

    try {
      final audioTrack = await RtcLocalTrack.audio(
        trackIdPrefix: publisherId!,
        constraints: constraints,
      );

      return Result.success(audioTrack);
    } catch (e, stk) {
      _logger.e(() => '[createAudioTrack] rejected: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<RtcLocalCameraTrack>> createCameraTrack({
    CameraConstraints constraints = const CameraConstraints(),
  }) async {
    _logger.d(() => '[createCameraTrack] constraints: ${constraints.toMap()}');

    if (publisher == null || publisherId == null) {
      return Result.error(
        'Publisher is not created, cannot create camera track',
      );
    }

    try {
      final videoTrack = await RtcLocalTrack.camera(
        trackIdPrefix: publisherId!,
        constraints: constraints,
      );

      return Result.success(videoTrack);
    } catch (e, stk) {
      _logger.e(() => '[createCameraTrack] rejected: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<RtcLocalScreenShareTrack>> createScreenShareTrack({
    ScreenShareConstraints constraints = const ScreenShareConstraints(),
  }) async {
    _logger.d(
      () => '[createScreenShareTrack] constraints: ${constraints.toMap()}',
    );

    if (publisher == null || publisherId == null) {
      return Result.error(
        'Publisher is not created, cannot create screen share track',
      );
    }

    try {
      final screenShareTrack = await RtcLocalTrack.screenShare(
        trackIdPrefix: publisherId!,
        constraints: constraints,
      );

      return Result.success(screenShareTrack);
    } catch (e, stk) {
      _logger.e(() => '[createScreenShareTrack] rejected: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<RtcLocalCameraTrack>> setTrackFacingMode({
    required FacingMode facingMode,
  }) async {
    final track = getPublisherTrackByType(SfuTrackType.video);
    if (track == null) return Result.error('Track not found');

    if (track is! RtcLocalCameraTrack) {
      _logger.w(() => '[setTrackFacingMode] rejected (track is not camera)');
      return Result.error('Track is not camera');
    }

    final transceivers =
        transceiversManager.getTransceiversForTrack(track.trackId).toList();

    final updatedTrack = await track.recreate(
      transceivers,
      mediaConstraints: track.mediaConstraints.copyWith(
        facingMode: facingMode,
      ),
    );

    tracks[updatedTrack.trackId] = updatedTrack;
    return Result.success(updatedTrack);
  }
}

extension RtcManagerTrackHelper on RtcManager {
  Future<Result<RtcLocalCameraTrack>> flipCamera() async {
    if (CurrentPlatform.isWeb) {
      _logger.e(() => '[switchCamera] rejected (not supported on web)');
      return Result.error('Not supported on web');
    }

    final track = getPublisherTrackByType(SfuTrackType.video);
    if (track == null) {
      _logger.e(() => '[switchCamera] rejected (track is null)');
      return Result.error('Track is null');
    }

    if (track is! RtcLocalCameraTrack) {
      _logger.e(() => '[switchCamera] rejected (track is not camera)');
      return Result.error('Track is not camera');
    }

    final updatedTrack = await track.flipCamera();
    tracks[updatedTrack.trackId] = updatedTrack;

    return Result.success(updatedTrack);
  }

  Future<Result<RtcLocalCameraTrack>> setVideoInputDevice({
    required RtcMediaDevice device,
  }) async {
    final track = getPublisherTrackByType(SfuTrackType.video);
    if (track == null) {
      _logger.w(() => '[setCameraDeviceId] rejected (track is null)');
      return Result.error('Track is null');
    }

    if (track is! RtcLocalCameraTrack) {
      _logger.w(() => '[setCameraDeviceId] rejected (track is not camera)');
      return Result.error('Track is not camera');
    }

    final transceivers =
        transceiversManager.getTransceiversForTrack(track.trackId).toList();

    final updatedTrack = await track.selectVideoInput(device, transceivers);
    tracks[updatedTrack.trackId] = updatedTrack;

    return Result.success(updatedTrack);
  }

  Future<Result<RtcLocalAudioTrack>> setAudioInputDevice({
    required RtcMediaDevice device,
  }) async {
    final track = getPublisherTrackByType(SfuTrackType.audio);
    if (track == null) {
      _logger.w(() => '[setMicrophoneDeviceId] rejected (track is null)');
      return Result.error('Track is null');
    }

    if (track is! RtcLocalAudioTrack) {
      _logger.w(() => '[setMicrophoneDeviceId] rejected (track is not audio)');
      return Result.error('Track is not audio');
    }

    final transceivers =
        transceiversManager.getTransceiversForTrack(track.trackId).toList();

    final updatedTrack = await track.selectAudioInput(transceivers, device);
    tracks[updatedTrack.trackId] = updatedTrack;

    return Result.success(updatedTrack);
  }

  Future<Result<None>> setAudioOutputDevice({
    required RtcMediaDevice device,
  }) async {
    // Get all remote audio tracks.
    final audioTracks = tracks.values
        .whereType<RtcRemoteTrack>()
        .where((it) => it.trackType == SfuTrackType.audio);

    // If the platform is web, set the sink id for all remote audio tracks
    // to the selected device.
    if (CurrentPlatform.isWeb) {
      for (final audioTrack in audioTracks) {
        final updatedTrack = audioTrack.setSinkId(device.id);
        tracks[updatedTrack.trackId] = updatedTrack;
      }

      return const Result.success(none);
    }

    try {
      if (CurrentPlatform.isIos &&
          device.id.equalsIgnoreCase(
            AudioSettingsRequestDefaultDeviceEnum.speaker.value,
          )) {
        await setAppleAudioConfiguration(
          speakerOn: true,
        );
      } else {
        await setAppleAudioConfiguration();
      }

      // Change the audio output device for all remote audio tracks.
      await rtc.Helper.selectAudioOutput(device.id);
      for (final audioTrack in audioTracks) {
        final updatedTrack = audioTrack.copyWith(audioSinkId: device.id);
        tracks[updatedTrack.trackId] = updatedTrack;
      }

      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[setAudioOutputDevice] rejected: $e');
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  Future<Result<RtcLocalCameraTrack>> setCameraPosition({
    required CameraPosition cameraPosition,
  }) {
    final facingMode = cameraPosition.toFacingMode();
    return setTrackFacingMode(facingMode: facingMode);
  }

  Future<Result<RtcLocalTrack>> setCameraEnabled({
    bool enabled = true,
    CameraConstraints? constraints,
  }) {
    return _setTrackEnabled(
      trackType: SfuTrackType.video,
      enabled: enabled,
      constraints: constraints,
    );
  }

  Future<Result<RtcLocalTrack>> setMicrophoneEnabled({
    bool enabled = true,
    AudioConstraints? constraints,
  }) {
    return _setTrackEnabled(
      trackType: SfuTrackType.audio,
      enabled: enabled,
      constraints: constraints,
    );
  }

  Future<Result<RtcLocalTrack>> setScreenShareEnabled({
    bool enabled = true,
    ScreenShareConstraints? constraints,
  }) {
    return _setTrackEnabled(
      trackType: SfuTrackType.screenShare,
      enabled: enabled,
      constraints: constraints,
    );
  }

  Future<Result<RtcLocalTrack>> _setTrackEnabled({
    required SfuTrackType trackType,
    required bool enabled,
    MediaConstraints? constraints,
  }) async {
    final track = getPublisherTrackByType(trackType);

    // Track found, mute/unmute it.
    if (track != null) {
      if (enabled &&
          track is RtcLocalScreenShareTrack &&
          !track.compareScreenShareMode(constraints)) {
        return _createAndPublishTrack(
          trackType: trackType,
          constraints: constraints,
        );
      }

      final toggledTrack = await _toggleTrackMuteState(
        track: track,
        muted: !enabled,
      );

      return Result.success(toggledTrack);
    }

    // Track not found, create a new one and publish it if enabled is true.
    if (enabled) {
      return _createAndPublishTrack(
        trackType: trackType,
        constraints: constraints,
      );
    }

    // Track not found and enabled is false, return error.
    return Result.error('Track not found and enabled is false');
  }

  Future<RtcLocalTrack> _toggleTrackMuteState({
    required RtcLocalTrack track,
    required bool muted,
  }) async {
    if (muted) {
      await muteTrack(trackId: track.trackId);

      // If the track is a screen share track, mute the audio track as well.
      if (track.trackType == SfuTrackType.screenShare) {
        final screenShareAudioTrack = getPublisherTrackByType(
          SfuTrackType.screenShareAudio,
        );
        if (screenShareAudioTrack != null) {
          await muteTrack(trackId: screenShareAudioTrack.trackId);
        }
      }
    } else {
      await unmuteTrack(trackId: track.trackId);

      // If the track is a screen share track, unmute the audio track as well.
      if (track.trackType == SfuTrackType.screenShare) {
        final screenShareAudioTrack = getPublisherTrackByType(
          SfuTrackType.screenShareAudio,
        );
        if (screenShareAudioTrack != null) {
          await unmuteTrack(trackId: screenShareAudioTrack.trackId);
        }
      }
    }

    return track;
  }

  Future<Result<RtcLocalTrack>> _createAndPublishTrack({
    required SfuTrackType trackType,
    MediaConstraints? constraints,
  }) async {
    if (trackType == SfuTrackType.video) {
      if (constraints != null && constraints is! CameraConstraints) {
        final errorMessage =
            'Invalid media constraints type ${constraints.runtimeType}, $CameraConstraints expected';
        _logger.e(() => errorMessage);
        return Result.error(errorMessage);
      }

      final cameraTrackResult = await createCameraTrack(
        constraints:
            (constraints ?? const CameraConstraints()) as CameraConstraints,
      );
      return cameraTrackResult.fold(
        success: (it) => publishVideoTrack(track: it.data),
        failure: (it) => it,
      );
    } else if (trackType == SfuTrackType.audio) {
      if (constraints != null && constraints is! AudioConstraints) {
        final errorMessage =
            'Invalid media constraints type ${constraints.runtimeType}, $AudioConstraints expected';
        _logger.e(() => errorMessage);
        return Result.error(errorMessage);
      }

      final audioTrackResult = await createAudioTrack(
        constraints:
            (constraints ?? const AudioConstraints()) as AudioConstraints,
      );
      return audioTrackResult.fold(
        success: (it) => publishAudioTrack(track: it.data),
        failure: (it) => it,
      );
    } else if (trackType == SfuTrackType.screenShare) {
      if (constraints != null && constraints is! ScreenShareConstraints) {
        final errorMessage =
            'Invalid media constraints type ${constraints.runtimeType}, $ScreenShareConstraints expected';
        _logger.e(() => errorMessage);
        return Result.error(errorMessage);
      }

      final screenShareTrackResult = await createScreenShareTrack(
        constraints: (constraints ?? const ScreenShareConstraints())
            as ScreenShareConstraints,
      );
      return screenShareTrackResult.fold(
        success: (it) => publishVideoTrack(track: it.data),
        failure: (it) => it,
      );
    }

    _logger.e(() => 'Unsupported trackType $trackType');
    return Result.error('Unsupported trackType $trackType');
  }

  Future<Result<None>> setAppleAudioConfiguration({
    bool speakerOn = false,
  }) async {
    try {
      await rtc.Helper.setAppleAudioConfiguration(
        rtc.AppleAudioConfiguration(
          appleAudioMode: speakerOn
              ? rtc.AppleAudioMode.videoChat
              : rtc.AppleAudioMode.voiceChat,
          appleAudioCategory: rtc.AppleAudioCategory.playAndRecord,
          appleAudioCategoryOptions: {
            if (speakerOn) rtc.AppleAudioCategoryOption.defaultToSpeaker,
            rtc.AppleAudioCategoryOption.mixWithOthers,
            rtc.AppleAudioCategoryOption.allowBluetooth,
            rtc.AppleAudioCategoryOption.allowBluetoothA2DP,
            rtc.AppleAudioCategoryOption.allowAirPlay,
          },
        ),
      );
      return const Result.success(none);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }
}

extension on RtcLocalTrack<VideoConstraints> {
  RtcVideoDimension getVideoDimension() {
    // use constraints passed to getUserMedia by default
    var dimension = mediaConstraints.params.dimension;

    if (CurrentPlatform.isWeb) {
      // getSettings() is only implemented for Web
      try {
        // try to use getSettings for more accurate resolution
        final settings = mediaTrack.getSettings();
        streamLog.v(_tag, () => '[publishVideoTrack] settings: $settings');
        if (settings['width'] is int) {
          dimension = dimension.copyWith(width: settings['width'] as int);
        }
        if (settings['height'] is int) {
          dimension = dimension.copyWith(height: settings['height'] as int);
        }
      } catch (_) {
        streamLog.w(
          _tag,
          () => '[publishVideoTrack] `mediaStreamTrack.getSettings()` failed',
        );
      }
    }
    return dimension;
  }
}
