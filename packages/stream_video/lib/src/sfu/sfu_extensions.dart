import 'package:collection/collection.dart';

import '../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../call_state.dart';
import '../models/models.dart';
import '../utils/string.dart';
import 'data/models/sfu_participant.dart';

extension SfuParticipantX on SfuParticipant {
  CallParticipantState toParticipantState(CallState state) {
    final isLocal =
        userId == state.currentUserId && sessionId == state.sessionId;
    final existing = state.callParticipants.firstWhereOrNull(
      (it) => it.userId == userId,
    );

    final existingName = existing?.name ?? '';
    final existingRoles = existing?.roles ?? [];
    final existingImage = existing?.image ?? '';

    return CallParticipantState(
      userId: userId,
      roles: roles.isNotEmpty ? roles : existingRoles,
      name: userName.ifEmpty(() => existingName),
      custom: custom,
      image: userImage.ifEmpty(() => existingImage),
      sessionId: sessionId,
      trackIdPrefix: trackLookupPrefix,
      publishedTracks: {
        for (final track in publishedTracks)
          track: TrackState.base(isLocal: isLocal),
      },
      isLocal: isLocal,
      isOnline: !isLocal,
      isSpeaking: isSpeaking,
      audioLevel: audioLevel,
      isDominantSpeaker: isDominantSpeaker,
    );
  }
}

extension TrackInfoX on sfu_models.TrackInfo {
  Map<String, dynamic> toJson() {
    return {
      'track_id': trackId,
      'track_type': trackType.toString(),
      'layers': layers.map((layer) => layer.toJson()).toList(),
      'mid': mid,
      'dtx': dtx,
      'stereo': stereo,
      'red': red,
      'muted': muted,
      'codec': codec.toJson(),
      'publish_option_id': publishOptionId,
    };
  }
}

extension VideoLayerX on sfu_models.VideoLayer {
  Map<String, dynamic> toJson() {
    return {
      'rid': rid,
      'video_dimension': {
        'width': videoDimension.width,
        'height': videoDimension.height,
      },
      'bitrate': bitrate,
      'fps': fps,
      'quality': quality.toString(),
    };
  }
}

extension CodecX on sfu_models.Codec {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fmtp': fmtp,
      'clock_rate': clockRate,
      'encoding_parameters': encodingParameters,
      'payload_type': payloadType,
    };
  }
}

extension SetPublisherRequestX on sfu.SetPublisherRequest {
  Map<String, dynamic> toJson() {
    return {
      'sdp': sdp,
      'session_id': sessionId,
      'tracks': tracks.map((track) => track.toJson()).toList(),
    };
  }
}
