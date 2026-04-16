import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class CallEgress with EquatableMixin {
  const CallEgress({
    this.broadcasting = false,
    this.hlsPlaylistUrl,
    this.hlsStatus,
    this.compositeRecordingStatus,
    this.frameRecordingStatus,
    this.individualRecordingStatus,
    this.rawRecordingStatus,
    this.rtmps = const [],
  });

  final bool broadcasting;
  final String? hlsPlaylistUrl;
  final String? hlsStatus;
  final String? compositeRecordingStatus;
  final String? frameRecordingStatus;
  final String? individualRecordingStatus;
  final String? rawRecordingStatus;
  final List<CallEgressRtmp> rtmps;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
    broadcasting,
    hlsPlaylistUrl,
    hlsStatus,
    compositeRecordingStatus,
    frameRecordingStatus,
    individualRecordingStatus,
    rawRecordingStatus,
    rtmps,
  ];

  /// Returns a copy of this [CallEgress] with the given fields
  /// replaced with the new values.
  CallEgress copyWith({
    bool? broadcasting,
    String? hlsPlaylistUrl,
    String? hlsStatus,
    String? compositeRecordingStatus,
    String? frameRecordingStatus,
    String? individualRecordingStatus,
    String? rawRecordingStatus,
    List<CallEgressRtmp>? rtmps,
  }) {
    return CallEgress(
      broadcasting: broadcasting ?? this.broadcasting,
      hlsPlaylistUrl: hlsPlaylistUrl ?? this.hlsPlaylistUrl,
      hlsStatus: hlsStatus ?? this.hlsStatus,
      compositeRecordingStatus:
          compositeRecordingStatus ?? this.compositeRecordingStatus,
      frameRecordingStatus: frameRecordingStatus ?? this.frameRecordingStatus,
      individualRecordingStatus:
          individualRecordingStatus ?? this.individualRecordingStatus,
      rawRecordingStatus: rawRecordingStatus ?? this.rawRecordingStatus,
      rtmps: rtmps ?? this.rtmps,
    );
  }
}

/// Describes an RTMP destination to start broadcasting to.
class StreamRtmpBroadcastRequest with EquatableMixin {
  const StreamRtmpBroadcastRequest({
    required this.name,
    required this.streamUrl,
    this.streamKey,
    this.quality,
  });

  /// A unique-within-call name for the broadcast destination.
  final String name;

  /// Target RTMP server URL.
  final String streamUrl;

  /// Optional stream key appended to [streamUrl].
  final String? streamKey;

  /// Optional quality override. When omitted, the call's RTMP settings quality
  /// is used.
  final StreamVideoQuality? quality;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [name, streamUrl, streamKey, quality];
}

/// Quality preset for a video output (RTMP broadcast, HLS track, or call
/// recording). Mirrors the server-accepted alias values.
enum StreamVideoQuality {
  p360('360p'),
  p480('480p'),
  p720('720p'),
  p1080('1080p'),
  p1440('1440p'),
  portrait360x640('portrait-360x640'),
  portrait480x854('portrait-480x854'),
  portrait720x1280('portrait-720x1280'),
  portrait1080x1920('portrait-1080x1920'),
  portrait1440x2560('portrait-1440x2560');

  const StreamVideoQuality(this.alias);

  final String alias;

  static StreamVideoQuality? fromAlias(String alias) =>
      StreamVideoQuality.values.firstWhereOrNull((it) => it.alias == alias);
}

class CallEgressRtmp with EquatableMixin {
  const CallEgressRtmp({
    required this.name,
    this.streamKey,
    this.url,
  });

  final String name;

  final String? streamKey;

  final String? url;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [name, streamKey, url];

  /// Returns a copy of this [CallEgressRtmp] with the given fields
  /// replaced with the new values.
  CallEgressRtmp copyWith({
    String? name,
    String? streamKey,
    String? url,
  }) {
    return CallEgressRtmp(
      name: name ?? this.name,
      streamKey: streamKey ?? this.streamKey,
      url: url ?? this.url,
    );
  }
}
