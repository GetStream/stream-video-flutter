import 'package:equatable/equatable.dart';

class CallEgress with EquatableMixin {
  const CallEgress({
    this.hlsPlaylistUrl,
    this.rtmps = const [],
  });

  final String? hlsPlaylistUrl;
  final List<CallEgressRtmp> rtmps;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [hlsPlaylistUrl];

  /// Returns a copy of this [CallEgress] with the given fields
  /// replaced with the new values.
  CallEgress copyWith({
    String? hlsPlaylistUrl,
    List<CallEgressRtmp>? rtmps,
  }) {
    return CallEgress(
      hlsPlaylistUrl: hlsPlaylistUrl ?? this.hlsPlaylistUrl,
      rtmps: rtmps ?? this.rtmps,
    );
  }
}

class CallEgressRtmp {
  const CallEgressRtmp({
    required this.name,
    required this.streamKey,
    required this.url,
  });

  final String name;

  final String streamKey;

  final String url;

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
