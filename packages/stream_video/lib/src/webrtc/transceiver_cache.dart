import 'package:collection/collection.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import '../sfu/data/models/sfu_publish_options.dart';
import '../sfu/data/models/sfu_track_type.dart';
import 'model/rtc_tracks_info.dart';
import 'rtc_track/rtc_track.dart';
import 'rtc_track/rtc_track_publish_options.dart';

class TransceiverCache {
  TransceiverCache({
    required this.track,
    required this.publishOption,
    required this.transceiver,
    required this.trackPublishOptions,
    this.negotiated = false,
    this.negotiatedMid,
  }) {
    rememberSentTrack(track);
  }

  RtcLocalTrack track;
  SfuPublishOptions publishOption;
  RTCRtpTransceiver transceiver;
  RtcTrackPublishOptions trackPublishOptions;

  /// Whether the SFU has acknowledged this transceiver through a completed
  /// publisher negotiation.
  bool negotiated;

  /// The mid announced in the last negotiation the SFU acknowledged.
  String? negotiatedMid;

  /// Every media track id this transceiver has sent, the current one included.
  final Set<String> sentTrackIds = {};

  /// Records [sentTrack]'s media id as one this transceiver has sent.
  void rememberSentTrack(RtcLocalTrack sentTrack) {
    final id = sentTrack.mediaTrack.id;
    if (id != null) sentTrackIds.add(id);
  }

  @override
  String toString() {
    return 'TransceiverCache{mediaTrackId: ${track.mediaTrack.id}, publishOption: ${publishOption.id},${publishOption.codec}, sender.track.enabled: ${transceiver.sender.track?.enabled}, negotiated: $negotiated, negotiatedMid: $negotiatedMid}';
  }
}

class TrackLayersCache {
  TrackLayersCache({required this.publishOption, required this.layers});

  SfuPublishOptions publishOption;
  List<RTCRtpEncoding> layers;
}

/// Represents the unique identity of a publisher sender for the SFU,
/// defined by a combination of `(trackType, publishOptionId)`.
typedef TransceiverKey = (SfuTrackType, int);

extension SfuPublishOptionsTransceiverKey on SfuPublishOptions {
  TransceiverKey get transceiverKey => (trackType, id);
}

class TransceiverManager {
  final Map<TransceiverKey, TransceiverCache> _transceivers = {};
  final Map<TransceiverKey, TrackLayersCache> _layers = {};

  /// Adds a transceiver to the cache.
  ///
  /// Returns false and leaves the cache untouched when an entry for the same
  /// `(trackType, publishOptionId)` already exists.
  bool add(
    RtcLocalTrack track,
    SfuPublishOptions publishOption,
    RTCRtpTransceiver transceiver,
    RtcTrackPublishOptions trackPublishOptions,
  ) {
    final key = publishOption.transceiverKey;
    if (_transceivers.containsKey(key)) return false;

    _transceivers[key] = TransceiverCache(
      track: track,
      publishOption: publishOption,
      transceiver: transceiver,
      trackPublishOptions: trackPublishOptions,
    );

    return true;
  }

  /// Gets the transceiver for the given publish option.
  TransceiverCache? get(SfuPublishOptions publishOption) {
    return _transceivers[publishOption.transceiverKey];
  }

  /// Gets the transceiver for the given track type and publish option id.
  RTCRtpTransceiver? getWith(SfuTrackType trackType, int publishOptionId) {
    return getBundleWith(trackType, publishOptionId)?.transceiver;
  }

  /// Gets the cached bundle for the given track type and publish option id.
  TransceiverCache? getBundleWith(
    SfuTrackType trackType,
    int publishOptionId,
  ) {
    return _transceivers[(trackType, publishOptionId)];
  }

  /// Updates the cached bundle for the given publish option.
  void update(
    SfuPublishOptions publishOption, {
    RtcLocalTrack? track,
    RtcTrackPublishOptions? trackPublishOptions,
  }) {
    final bundle = get(publishOption);
    if (bundle == null) return;
    if (track != null) {
      bundle.track = track;
      bundle.rememberSentTrack(track);
    }
    if (trackPublishOptions != null) {
      bundle.trackPublishOptions = trackPublishOptions;
    }
  }

  /// Removes and returns the cached bundle for the given publish option, or
  /// null when none exists. Any cached layers for the key go with it.
  TransceiverCache? remove(SfuPublishOptions publishOption) {
    final key = publishOption.transceiverKey;
    _layers.remove(key);
    return _transceivers.remove(key);
  }

  /// Checks if the cache has the given publish option.
  bool has(SfuPublishOptions publishOption) {
    return _transceivers.containsKey(publishOption.transceiverKey);
  }

  /// Finds the first transceiver that satisfies the given predicate.
  TransceiverCache? find(bool Function(TransceiverCache) predicate) {
    return _transceivers.values.firstWhereOrNull(predicate);
  }

  Iterable<TransceiverCache> findAll(
    bool Function(TransceiverCache) predicate,
  ) {
    return _transceivers.values.where(predicate);
  }

  Iterable<RTCRtpTransceiver> getTransceiversForTrack(String trackId) {
    return findAll((t) => t.track.trackId == trackId).map((t) => t.transceiver);
  }

  /// Provides all the items in the cache, in insertion order.
  List<TransceiverCache> items() {
    return _transceivers.values.toList();
  }

  /// Marks the cached transceivers that were part of [announced] as negotiated,
  /// i.e. acknowledged by the SFU after a completed negotiation.
  void markNegotiated(Iterable<RtcTrackInfo> announced) {
    for (final info in announced) {
      final item = find(
        (c) =>
            c.publishOption.id == info.publishOptionId &&
            c.publishOption.trackType == info.trackType &&
            (c.transceiver.sender.track?.id ?? c.track.mediaTrack.id) ==
                info.trackId,
      );

      if (item == null) continue;

      item.negotiated = true;

      final mid = info.mid;
      if (mid != null && mid.isNotEmpty) item.negotiatedMid = mid;
    }
  }

  /// Gets cached video layers for the given track.
  List<RTCRtpEncoding>? getLayers(SfuPublishOptions publishOption) {
    return _layers[publishOption.transceiverKey]?.layers;
  }

  /// Sets the video layers for the given track.
  void setLayers(SfuPublishOptions publishOption, List<RTCRtpEncoding> layers) {
    final entry = _layers[publishOption.transceiverKey];
    if (entry != null) {
      entry.layers = layers;
    } else {
      _layers[publishOption.transceiverKey] = TrackLayersCache(
        publishOption: publishOption,
        layers: layers,
      );
    }
  }
}
