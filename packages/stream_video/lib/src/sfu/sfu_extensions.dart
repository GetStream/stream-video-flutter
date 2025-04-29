import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:sdp_transform/sdp_transform.dart';

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
    final parsedSdp = parse(sdp);

    return {
      'sdp': parsedSdp,
      'session_id': sessionId,
      'tracks': tracks.map((track) => track.toJson()).toList(),
    };
  }
}

extension ClientDetailsX on sfu_models.ClientDetails {
  Map<String, dynamic> toJson() {
    return {
      'sdk': sdk.toJson(),
      'os': os.toJson(),
      'browser': browser.toJson(),
      'device': device.toJson(),
    };
  }
}

extension SdkX on sfu_models.Sdk {
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'major': major,
      'minor': minor,
      'patch': patch,
    };
  }
}

extension OSX on sfu_models.OS {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
      'architecture': architecture,
    };
  }
}

extension BrowserX on sfu_models.Browser {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
    };
  }
}

extension DeviceX on sfu_models.Device {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
    };
  }
}

extension SendAnswerRequestX on sfu.SendAnswerRequest {
  Map<String, dynamic> toJson() {
    final parsedSdp = parse(sdp);
    return {
      'peer_type': peerType.toString(),
      'sdp': parsedSdp,
      'session_id': sessionId,
    };
  }
}

extension ICETrickleX on sfu_models.ICETrickle {
  Map<String, dynamic> toJson() {
    return {
      'peer_type': peerType.toString(),
      'ice_candidate': jsonDecode(iceCandidate),
      'session_id': sessionId,
    };
  }
}

extension ICERestartRequestX on sfu.ICERestartRequest {
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'peer_type': peerType.toString(),
    };
  }
}

extension UpdateMuteStatesRequestX on sfu.UpdateMuteStatesRequest {
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'mute_states': muteStates.map((state) => state.toJson()).toList(),
    };
  }
}

extension TrackMuteStateX on sfu.TrackMuteState {
  Map<String, dynamic> toJson() {
    return {
      'track_type': trackType.toString(),
      'muted': muted,
    };
  }
}

extension UpdateSubscriptionsRequestX on sfu.UpdateSubscriptionsRequest {
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'tracks': tracks.map((sub) => sub.toJson()).toList(),
    };
  }
}

extension TrackSubscriptionDetailsX on sfu.TrackSubscriptionDetails {
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'session_id': sessionId,
      'track_type': trackType.toString(),
      'dimension': dimension.toJson(),
    };
  }
}

extension VideoDimensionX on sfu_models.VideoDimension {
  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
    };
  }
}

extension StartNoiseCancellationRequestX on sfu.StartNoiseCancellationRequest {
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
    };
  }
}

extension StopNoiseCancellationRequestX on sfu.StopNoiseCancellationRequest {
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
    };
  }
}
