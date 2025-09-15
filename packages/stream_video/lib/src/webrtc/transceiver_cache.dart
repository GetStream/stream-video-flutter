import 'package:collection/collection.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import '../sfu/data/models/sfu_publish_options.dart';
import '../sfu/data/models/sfu_track_type.dart';
import 'rtc_track/rtc_track.dart';

class TransceiverCache {
  TransceiverCache({
    required this.track,
    required this.publishOption,
    required this.transceiver,
  });

  RtcLocalTrack track;
  SfuPublishOptions publishOption;
  RTCRtpTransceiver transceiver;

  @override
  String toString() {
    return 'TransceiverCache{mediaTrackId: ${track.mediaTrack.id}, publishOption: ${publishOption.id},${publishOption.codec}, sender.track.enabled: ${transceiver.sender.track?.enabled}}';
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
  ) {
    _transceivers.add(
      TransceiverCache(
        track: track,
        publishOption: publishOption,
        transceiver: transceiver,
      ),
    );

    _transceiverOrder.add(transceiver);
  }

  /// Gets the transceiver for the given publish option.
  RTCRtpTransceiver? get(SfuPublishOptions publishOption) {
    return _findTransceiver(
      publishOption.trackType,
      publishOption.id,
    )?.transceiver;
  }

  /// Gets the last transceiver for the given track type and publish option id.
  RTCRtpTransceiver? getWith(SfuTrackType trackType, int id) {
    return _findTransceiver(trackType, id)?.transceiver;
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
