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
  });

  RtcLocalTrack track;
  SfuPublishOptions publishOption;
  RTCRtpTransceiver transceiver;
  RtcTrackPublishOptions trackPublishOptions;

  /// Whether the SFU has acknowledged this transceiver through a completed
  /// publisher negotiation.
  bool negotiated;

  /// The mid announced in the last negotiation the SFU acknowledged.
  String? negotiatedMid;

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

class TransceiverManager {
  final List<TransceiverCache> _transceivers = [];
  final List<TrackLayersCache> _layers = [];

  /// An array maintaining the order how transceivers were added to the peer connection.
  final List<RTCRtpTransceiver> _transceiverOrder = [];

  /// Adds a transceiver to the cache.
  void add(
    RtcLocalTrack track,
    SfuPublishOptions publishOption,
    RTCRtpTransceiver transceiver,
    RtcTrackPublishOptions trackPublishOptions,
  ) {
    _transceivers.add(
      TransceiverCache(
        track: track,
        publishOption: publishOption,
        transceiver: transceiver,
        trackPublishOptions: trackPublishOptions,
      ),
    );

    _transceiverOrder.add(transceiver);
  }

  /// Gets the transceiver for the given publish option.
  TransceiverCache? get(SfuPublishOptions publishOption) {
    return _findTransceiver(
      publishOption.trackType,
      publishOption.id,
    );
  }

  /// Gets the last transceiver for the given track type and publish option id.
  RTCRtpTransceiver? getWith(SfuTrackType trackType, int publishOptionId) {
    return _findTransceiver(trackType, publishOptionId)?.transceiver;
  }

  /// Updates the cached bundle for the given publish option.
  void update(
    SfuPublishOptions publishOption, {
    RtcLocalTrack? track,
    RtcTrackPublishOptions? trackPublishOptions,
  }) {
    final bundle = get(publishOption);
    if (bundle == null) return;
    if (track != null) bundle.track = track;
    if (trackPublishOptions != null) {
      bundle.trackPublishOptions = trackPublishOptions;
    }
  }

  /// Checks if the cache has the given publish option.
  bool has(SfuPublishOptions publishOption) {
    return get(publishOption) != null;
  }

  /// Finds the first transceiver that satisfies the given predicate.
  TransceiverCache? find(bool Function(TransceiverCache) predicate) {
    return _transceivers.firstWhereOrNull(predicate);
  }

  Iterable<TransceiverCache> findAll(
    bool Function(TransceiverCache) predicate,
  ) {
    return _transceivers.where(predicate);
  }

  Iterable<RTCRtpTransceiver> getTransceiversForTrack(String trackId) {
    return findAll((t) => t.track.trackId == trackId).map((t) => t.transceiver);
  }

  /// Provides all the items in the cache.
  List<TransceiverCache> items() {
    return _transceivers;
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

  /// Init index of the transceiver in the cache.
  int indexOf(RTCRtpTransceiver transceiver) {
    return _transceiverOrder.indexOf(transceiver);
  }

  /// Gets cached video layers for the given track.
  List<RTCRtpEncoding>? getLayers(SfuPublishOptions publishOption) {
    final entry = _layers.firstWhereOrNull(
      (item) =>
          item.publishOption.id == publishOption.id &&
          item.publishOption.trackType == publishOption.trackType,
    );

    return entry?.layers;
  }

  /// Sets the video layers for the given track.
  void setLayers(SfuPublishOptions publishOption, List<RTCRtpEncoding> layers) {
    final entry = _findLayer(publishOption.trackType, publishOption.id);
    if (entry != null) {
      entry.layers = layers;
    } else {
      _layers.add(
        TrackLayersCache(publishOption: publishOption, layers: layers),
      );
    }
  }

  TransceiverCache? _findTransceiver(
    SfuTrackType trackType,
    int publishOptionId,
  ) {
    return _transceivers.firstWhereOrNull(
      (item) =>
          item.publishOption.id == publishOptionId &&
          item.publishOption.trackType == trackType,
    );
  }

  TrackLayersCache? _findLayer(
    SfuTrackType trackType,
    int publishOptionId,
  ) {
    return _layers.firstWhereOrNull(
      (item) =>
          item.publishOption.id == publishOptionId &&
          item.publishOption.trackType == trackType,
    );
  }
}
