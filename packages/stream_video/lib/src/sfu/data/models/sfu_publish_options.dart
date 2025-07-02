import '../../../webrtc/model/rtc_video_dimension.dart';
import 'sfu_codec.dart';
import 'sfu_track_type.dart';

class SfuPublishOptions {
  SfuPublishOptions({
    required this.id,
    required this.codec,
    required this.trackType,
    this.videoDimension,
    this.maxSpatialLayers,
    this.maxTemporalLayers,
    this.bitrate,
    this.fps,
    this.useSingleLayer = false,
  });

  /// The unique identifier for the publish request.
  /// - This `id` is assigned exclusively by the SFU. Any `id` set by the client
  ///   in the `PublishOption` will be ignored and overwritten by the SFU.
  /// - The primary purpose of this `id` is to uniquely identify each publish
  ///   request, even in scenarios where multiple publish requests for the same
  ///   `track_type` and `codec` are active simultaneously.
  ///   For example:
  ///     - A user may publish two tracks of the same type (e.g., video) and codec
  ///       (e.g., VP9) concurrently.
  /// - This uniqueness ensures that individual requests can be managed
  ///   independently. For instance, an `id` is critical when stopping a specific
  ///   publish request without affecting others.
  final int id;

  /// The maximum number of spatial layers to send.
  /// - For SVC (e.g., VP9), spatial layers downscale by a factor of 2:
  ///   - 1 layer: full resolution
  ///   - 2 layers: full resolution + half resolution
  ///   - 3 layers: full resolution + half resolution + quarter resolution
  /// - For non-SVC codecs (e.g., VP8/H264), this determines the number of
  ///   encoded resolutions (e.g., quarter, half, full) sent for simulcast.
  final int? maxSpatialLayers;

  /// The maximum number of temporal layers for scalable video coding (SVC).
  /// Temporal layers allow varying frame rates for different bandwidths.
  final int? maxTemporalLayers;

  /// The target bitrate for the published track, in bits per second.
  final int? bitrate;

  /// The target frames per second (FPS) for video encoding.
  final int? fps;

  /// The dimensions of the video (e.g., width and height in pixels).
  /// Spatial layers are based on this base resolution. For example, if the base
  /// resolution is 1280x720:
  /// - Full resolution (1 layer) = 1280x720
  /// - Half resolution (2 layers) = 640x360
  /// - Quarter resolution (3 layers) = 320x180
  final RtcVideoDimension? videoDimension;

  /// The codec to be used for encoding the track (e.g., VP8, VP9, H264).
  final SfuCodec codec;

  /// The type of the track being published (e.g., video, screenshare).
  final SfuTrackType trackType;

  /// If true, instructs the publisher to send only the highest available simulcast layer,
  /// disabling all lower layers. This applies to simulcast encodings.
  /// For SVC codecs, prefer using the L1T3 (single spatial, 3 temporal layers) mode instead.
  final bool useSingleLayer;

  @override
  String toString() {
    return 'SfuPublishOptions{id: $id, codec: $codec, trackType: $trackType, videoDimension: $videoDimension, maxSpatialLayers: $maxSpatialLayers, maxTemporalLayers: $maxTemporalLayers, bitrate: $bitrate, fps: $fps, useSingleLayer: $useSingleLayer}';
  }
}
