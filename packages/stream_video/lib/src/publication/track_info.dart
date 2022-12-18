import 'package:stream_video/protobuf/video/sfu/models/models.pbserver.dart'
    as sfu;
import 'package:stream_video/src/types/video_dimensions.dart';

class TrackInfo {
  TrackInfo({
    required this.id,
    required this.type,
    this.videoDimension,
    this.dtx,
    this.videoLayers,
  });

  /// Returns a copy of this [TrackInfo] with the given fields replaced with the
  /// new values.
  TrackInfo copyWith({
    String? id,
    sfu.TrackType? type,
    VideoDimension? videoDimension,
    bool? dtx,
    List<sfu.VideoLayer>? videoLayers,
  }) {
    return TrackInfo(
      id: id ?? this.id,
      type: type ?? this.type,
      videoDimension: videoDimension ?? this.videoDimension,
      dtx: dtx ?? this.dtx,
      videoLayers: videoLayers ?? this.videoLayers,
    );
  }

  /// Returns a copy of this [TrackInfo] after merging the given [TrackInfo].
  TrackInfo merge(TrackInfo? other) {
    if (other == null) return this;
    return copyWith(
      id: other.id,
      type: other.type,
      videoDimension: other.videoDimension,
      dtx: other.dtx,
      videoLayers: other.videoLayers,
    );
  }

  /// The unique identifier of the track.
  final String id;

  /// The type of the track.
  final sfu.TrackType type;

  /// The video dimension of the track.
  final VideoDimension? videoDimension;

  final bool? dtx;

  /// The video layers of the track.
  final List<sfu.VideoLayer>? videoLayers;

  /// The unique identifier used to identify the track in the signaling layer.
  String get sid => '$id:$type';

  /// The video quality of the track based on the [videoDimension].
  sfu.VideoQuality get videoQuality {
    if (videoDimension == null) {
      return sfu.VideoQuality.VIDEO_QUALITY_UNSPECIFIED;
    }

    final width = videoDimension!.width;
    final height = videoDimension!.height;

    if (width >= 960 && height >= 540) {
      return sfu.VideoQuality.VIDEO_QUALITY_HIGH;
    } else if (width >= 640 && height >= 360) {
      return sfu.VideoQuality.VIDEO_QUALITY_MID;
    } else if (width >= 320 && height >= 180) {
      return sfu.VideoQuality.VIDEO_QUALITY_LOW_UNSPECIFIED;
    }

    return sfu.VideoQuality.VIDEO_QUALITY_UNSPECIFIED;
  }
}
