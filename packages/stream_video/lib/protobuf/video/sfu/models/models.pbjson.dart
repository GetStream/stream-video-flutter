///
//  Generated code. Do not modify.
//  source: video/sfu/models/models.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use peerTypeDescriptor instead')
const PeerType$json = const {
  '1': 'PeerType',
  '2': const [
    const {'1': 'PEER_TYPE_PUBLISHER_UNSPECIFIED', '2': 0},
    const {'1': 'PEER_TYPE_SUBSCRIBER', '2': 1},
  ],
};

/// Descriptor for `PeerType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List peerTypeDescriptor = $convert.base64Decode('CghQZWVyVHlwZRIjCh9QRUVSX1RZUEVfUFVCTElTSEVSX1VOU1BFQ0lGSUVEEAASGAoUUEVFUl9UWVBFX1NVQlNDUklCRVIQAQ==');
@$core.Deprecated('Use connectionQualityDescriptor instead')
const ConnectionQuality$json = const {
  '1': 'ConnectionQuality',
  '2': const [
    const {'1': 'CONNECTION_QUALITY_UNSPECIFIED', '2': 0},
    const {'1': 'CONNECTION_QUALITY_POOR', '2': 1},
    const {'1': 'CONNECTION_QUALITY_GOOD', '2': 2},
    const {'1': 'CONNECTION_QUALITY_EXCELLENT', '2': 3},
  ],
};

/// Descriptor for `ConnectionQuality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List connectionQualityDescriptor = $convert.base64Decode('ChFDb25uZWN0aW9uUXVhbGl0eRIiCh5DT05ORUNUSU9OX1FVQUxJVFlfVU5TUEVDSUZJRUQQABIbChdDT05ORUNUSU9OX1FVQUxJVFlfUE9PUhABEhsKF0NPTk5FQ1RJT05fUVVBTElUWV9HT09EEAISIAocQ09OTkVDVElPTl9RVUFMSVRZX0VYQ0VMTEVOVBAD');
@$core.Deprecated('Use videoQualityDescriptor instead')
const VideoQuality$json = const {
  '1': 'VideoQuality',
  '2': const [
    const {'1': 'VIDEO_QUALITY_LOW_UNSPECIFIED', '2': 0},
    const {'1': 'VIDEO_QUALITY_MID', '2': 1},
    const {'1': 'VIDEO_QUALITY_HIGH', '2': 2},
    const {'1': 'VIDEO_QUALITY_OFF', '2': 3},
  ],
};

/// Descriptor for `VideoQuality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List videoQualityDescriptor = $convert.base64Decode('CgxWaWRlb1F1YWxpdHkSIQodVklERU9fUVVBTElUWV9MT1dfVU5TUEVDSUZJRUQQABIVChFWSURFT19RVUFMSVRZX01JRBABEhYKElZJREVPX1FVQUxJVFlfSElHSBACEhUKEVZJREVPX1FVQUxJVFlfT0ZGEAM=');
@$core.Deprecated('Use trackTypeDescriptor instead')
const TrackType$json = const {
  '1': 'TrackType',
  '2': const [
    const {'1': 'TRACK_TYPE_UNSPECIFIED', '2': 0},
    const {'1': 'TRACK_TYPE_AUDIO', '2': 1},
    const {'1': 'TRACK_TYPE_VIDEO', '2': 2},
    const {'1': 'TRACK_TYPE_SCREEN_SHARE', '2': 3},
    const {'1': 'TRACK_TYPE_SCREEN_SHARE_AUDIO', '2': 4},
  ],
};

/// Descriptor for `TrackType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List trackTypeDescriptor = $convert.base64Decode('CglUcmFja1R5cGUSGgoWVFJBQ0tfVFlQRV9VTlNQRUNJRklFRBAAEhQKEFRSQUNLX1RZUEVfQVVESU8QARIUChBUUkFDS19UWVBFX1ZJREVPEAISGwoXVFJBQ0tfVFlQRV9TQ1JFRU5fU0hBUkUQAxIhCh1UUkFDS19UWVBFX1NDUkVFTl9TSEFSRV9BVURJTxAE');
@$core.Deprecated('Use errorCodeDescriptor instead')
const ErrorCode$json = const {
  '1': 'ErrorCode',
  '2': const [
    const {'1': 'ERROR_CODE_UNSPECIFIED', '2': 0},
    const {'1': 'ERROR_CODE_PUBLISH_TRACK_NOT_FOUND', '2': 100},
    const {'1': 'ERROR_CODE_PUBLISH_TRACKS_MISMATCH', '2': 101},
    const {'1': 'ERROR_CODE_PUBLISH_TRACK_OUT_OF_ORDER', '2': 102},
    const {'1': 'ERROR_CODE_PUBLISH_TRACK_VIDEO_LAYER_NOT_FOUND', '2': 103},
    const {'1': 'ERROR_CODE_LIVE_ENDED', '2': 104},
    const {'1': 'ERROR_CODE_PARTICIPANT_NOT_FOUND', '2': 200},
    const {'1': 'ERROR_CODE_PARTICIPANT_MIGRATING_OUT', '2': 201},
    const {'1': 'ERROR_CODE_PARTICIPANT_MIGRATION_FAILED', '2': 202},
    const {'1': 'ERROR_CODE_PARTICIPANT_MIGRATING', '2': 203},
    const {'1': 'ERROR_CODE_PARTICIPANT_RECONNECT_FAILED', '2': 204},
    const {'1': 'ERROR_CODE_PARTICIPANT_MEDIA_TRANSPORT_FAILURE', '2': 205},
    const {'1': 'ERROR_CODE_CALL_NOT_FOUND', '2': 300},
    const {'1': 'ERROR_CODE_REQUEST_VALIDATION_FAILED', '2': 400},
    const {'1': 'ERROR_CODE_UNAUTHENTICATED', '2': 401},
    const {'1': 'ERROR_CODE_PERMISSION_DENIED', '2': 403},
    const {'1': 'ERROR_CODE_TOO_MANY_REQUESTS', '2': 429},
    const {'1': 'ERROR_CODE_INTERNAL_SERVER_ERROR', '2': 500},
    const {'1': 'ERROR_CODE_SFU_SHUTTING_DOWN', '2': 600},
    const {'1': 'ERROR_CODE_SFU_FULL', '2': 700},
  ],
};

/// Descriptor for `ErrorCode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List errorCodeDescriptor = $convert.base64Decode('CglFcnJvckNvZGUSGgoWRVJST1JfQ09ERV9VTlNQRUNJRklFRBAAEiYKIkVSUk9SX0NPREVfUFVCTElTSF9UUkFDS19OT1RfRk9VTkQQZBImCiJFUlJPUl9DT0RFX1BVQkxJU0hfVFJBQ0tTX01JU01BVENIEGUSKQolRVJST1JfQ09ERV9QVUJMSVNIX1RSQUNLX09VVF9PRl9PUkRFUhBmEjIKLkVSUk9SX0NPREVfUFVCTElTSF9UUkFDS19WSURFT19MQVlFUl9OT1RfRk9VTkQQZxIZChVFUlJPUl9DT0RFX0xJVkVfRU5ERUQQaBIlCiBFUlJPUl9DT0RFX1BBUlRJQ0lQQU5UX05PVF9GT1VORBDIARIpCiRFUlJPUl9DT0RFX1BBUlRJQ0lQQU5UX01JR1JBVElOR19PVVQQyQESLAonRVJST1JfQ09ERV9QQVJUSUNJUEFOVF9NSUdSQVRJT05fRkFJTEVEEMoBEiUKIEVSUk9SX0NPREVfUEFSVElDSVBBTlRfTUlHUkFUSU5HEMsBEiwKJ0VSUk9SX0NPREVfUEFSVElDSVBBTlRfUkVDT05ORUNUX0ZBSUxFRBDMARIzCi5FUlJPUl9DT0RFX1BBUlRJQ0lQQU5UX01FRElBX1RSQU5TUE9SVF9GQUlMVVJFEM0BEh4KGUVSUk9SX0NPREVfQ0FMTF9OT1RfRk9VTkQQrAISKQokRVJST1JfQ09ERV9SRVFVRVNUX1ZBTElEQVRJT05fRkFJTEVEEJADEh8KGkVSUk9SX0NPREVfVU5BVVRIRU5USUNBVEVEEJEDEiEKHEVSUk9SX0NPREVfUEVSTUlTU0lPTl9ERU5JRUQQkwMSIQocRVJST1JfQ09ERV9UT09fTUFOWV9SRVFVRVNUUxCtAxIlCiBFUlJPUl9DT0RFX0lOVEVSTkFMX1NFUlZFUl9FUlJPUhD0AxIhChxFUlJPUl9DT0RFX1NGVV9TSFVUVElOR19ET1dOENgEEhgKE0VSUk9SX0NPREVfU0ZVX0ZVTEwQvAU=');
@$core.Deprecated('Use sdkTypeDescriptor instead')
const SdkType$json = const {
  '1': 'SdkType',
  '2': const [
    const {'1': 'SDK_TYPE_UNSPECIFIED', '2': 0},
    const {'1': 'SDK_TYPE_REACT', '2': 1},
    const {'1': 'SDK_TYPE_ANGULAR', '2': 2},
    const {'1': 'SDK_TYPE_ANDROID', '2': 3},
    const {'1': 'SDK_TYPE_IOS', '2': 4},
    const {'1': 'SDK_TYPE_FLUTTER', '2': 5},
    const {'1': 'SDK_TYPE_REACT_NATIVE', '2': 6},
    const {'1': 'SDK_TYPE_UNITY', '2': 7},
  ],
};

/// Descriptor for `SdkType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sdkTypeDescriptor = $convert.base64Decode('CgdTZGtUeXBlEhgKFFNES19UWVBFX1VOU1BFQ0lGSUVEEAASEgoOU0RLX1RZUEVfUkVBQ1QQARIUChBTREtfVFlQRV9BTkdVTEFSEAISFAoQU0RLX1RZUEVfQU5EUk9JRBADEhAKDFNES19UWVBFX0lPUxAEEhQKEFNES19UWVBFX0ZMVVRURVIQBRIZChVTREtfVFlQRV9SRUFDVF9OQVRJVkUQBhISCg5TREtfVFlQRV9VTklUWRAH');
@$core.Deprecated('Use trackUnpublishReasonDescriptor instead')
const TrackUnpublishReason$json = const {
  '1': 'TrackUnpublishReason',
  '2': const [
    const {'1': 'TRACK_UNPUBLISH_REASON_UNSPECIFIED', '2': 0},
    const {'1': 'TRACK_UNPUBLISH_REASON_USER_MUTED', '2': 1},
    const {'1': 'TRACK_UNPUBLISH_REASON_PERMISSION_REVOKED', '2': 2},
    const {'1': 'TRACK_UNPUBLISH_REASON_MODERATION', '2': 3},
  ],
};

/// Descriptor for `TrackUnpublishReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List trackUnpublishReasonDescriptor = $convert.base64Decode('ChRUcmFja1VucHVibGlzaFJlYXNvbhImCiJUUkFDS19VTlBVQkxJU0hfUkVBU09OX1VOU1BFQ0lGSUVEEAASJQohVFJBQ0tfVU5QVUJMSVNIX1JFQVNPTl9VU0VSX01VVEVEEAESLQopVFJBQ0tfVU5QVUJMSVNIX1JFQVNPTl9QRVJNSVNTSU9OX1JFVk9LRUQQAhIlCiFUUkFDS19VTlBVQkxJU0hfUkVBU09OX01PREVSQVRJT04QAw==');
@$core.Deprecated('Use goAwayReasonDescriptor instead')
const GoAwayReason$json = const {
  '1': 'GoAwayReason',
  '2': const [
    const {'1': 'GO_AWAY_REASON_UNSPECIFIED', '2': 0},
    const {'1': 'GO_AWAY_REASON_SHUTTING_DOWN', '2': 1},
    const {'1': 'GO_AWAY_REASON_REBALANCE', '2': 2},
  ],
};

/// Descriptor for `GoAwayReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List goAwayReasonDescriptor = $convert.base64Decode('CgxHb0F3YXlSZWFzb24SHgoaR09fQVdBWV9SRUFTT05fVU5TUEVDSUZJRUQQABIgChxHT19BV0FZX1JFQVNPTl9TSFVUVElOR19ET1dOEAESHAoYR09fQVdBWV9SRUFTT05fUkVCQUxBTkNFEAI=');
@$core.Deprecated('Use callStateDescriptor instead')
const CallState$json = const {
  '1': 'CallState',
  '2': const [
    const {'1': 'participants', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.models.Participant', '10': 'participants'},
    const {'1': 'started_at', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'startedAt'},
    const {'1': 'participant_count', '3': 3, '4': 1, '5': 11, '6': '.stream.video.sfu.models.ParticipantCount', '10': 'participantCount'},
    const {'1': 'pins', '3': 4, '4': 3, '5': 11, '6': '.stream.video.sfu.models.Pin', '10': 'pins'},
  ],
};

/// Descriptor for `CallState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callStateDescriptor = $convert.base64Decode('CglDYWxsU3RhdGUSSAoMcGFydGljaXBhbnRzGAEgAygLMiQuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuUGFydGljaXBhbnRSDHBhcnRpY2lwYW50cxI5CgpzdGFydGVkX2F0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0ElYKEXBhcnRpY2lwYW50X2NvdW50GAMgASgLMikuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuUGFydGljaXBhbnRDb3VudFIQcGFydGljaXBhbnRDb3VudBIwCgRwaW5zGAQgAygLMhwuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuUGluUgRwaW5z');
@$core.Deprecated('Use participantCountDescriptor instead')
const ParticipantCount$json = const {
  '1': 'ParticipantCount',
  '2': const [
    const {'1': 'total', '3': 1, '4': 1, '5': 13, '10': 'total'},
    const {'1': 'anonymous', '3': 2, '4': 1, '5': 13, '10': 'anonymous'},
  ],
};

/// Descriptor for `ParticipantCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantCountDescriptor = $convert.base64Decode('ChBQYXJ0aWNpcGFudENvdW50EhQKBXRvdGFsGAEgASgNUgV0b3RhbBIcCglhbm9ueW1vdXMYAiABKA1SCWFub255bW91cw==');
@$core.Deprecated('Use pinDescriptor instead')
const Pin$json = const {
  '1': 'Pin',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `Pin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pinDescriptor = $convert.base64Decode('CgNQaW4SFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEh0KCnNlc3Npb25faWQYAiABKAlSCXNlc3Npb25JZA==');
@$core.Deprecated('Use participantDescriptor instead')
const Participant$json = const {
  '1': 'Participant',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'published_tracks', '3': 3, '4': 3, '5': 14, '6': '.stream.video.sfu.models.TrackType', '10': 'publishedTracks'},
    const {'1': 'joined_at', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'joinedAt'},
    const {'1': 'track_lookup_prefix', '3': 5, '4': 1, '5': 9, '10': 'trackLookupPrefix'},
    const {'1': 'connection_quality', '3': 6, '4': 1, '5': 14, '6': '.stream.video.sfu.models.ConnectionQuality', '10': 'connectionQuality'},
    const {'1': 'is_speaking', '3': 7, '4': 1, '5': 8, '10': 'isSpeaking'},
    const {'1': 'is_dominant_speaker', '3': 8, '4': 1, '5': 8, '10': 'isDominantSpeaker'},
    const {'1': 'audio_level', '3': 9, '4': 1, '5': 2, '10': 'audioLevel'},
    const {'1': 'name', '3': 10, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'image', '3': 11, '4': 1, '5': 9, '10': 'image'},
    const {'1': 'custom', '3': 12, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'custom'},
    const {'1': 'roles', '3': 13, '4': 3, '5': 9, '10': 'roles'},
  ],
};

/// Descriptor for `Participant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantDescriptor = $convert.base64Decode('CgtQYXJ0aWNpcGFudBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkEk0KEHB1Ymxpc2hlZF90cmFja3MYAyADKA4yIi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5UcmFja1R5cGVSD3B1Ymxpc2hlZFRyYWNrcxI3Cglqb2luZWRfYXQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghqb2luZWRBdBIuChN0cmFja19sb29rdXBfcHJlZml4GAUgASgJUhF0cmFja0xvb2t1cFByZWZpeBJZChJjb25uZWN0aW9uX3F1YWxpdHkYBiABKA4yKi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5Db25uZWN0aW9uUXVhbGl0eVIRY29ubmVjdGlvblF1YWxpdHkSHwoLaXNfc3BlYWtpbmcYByABKAhSCmlzU3BlYWtpbmcSLgoTaXNfZG9taW5hbnRfc3BlYWtlchgIIAEoCFIRaXNEb21pbmFudFNwZWFrZXISHwoLYXVkaW9fbGV2ZWwYCSABKAJSCmF1ZGlvTGV2ZWwSEgoEbmFtZRgKIAEoCVIEbmFtZRIUCgVpbWFnZRgLIAEoCVIFaW1hZ2USLwoGY3VzdG9tGAwgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIGY3VzdG9tEhQKBXJvbGVzGA0gAygJUgVyb2xlcw==');
@$core.Deprecated('Use streamQualityDescriptor instead')
const StreamQuality$json = const {
  '1': 'StreamQuality',
  '2': const [
    const {'1': 'video_quality', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.VideoQuality', '10': 'videoQuality'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `StreamQuality`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamQualityDescriptor = $convert.base64Decode('Cg1TdHJlYW1RdWFsaXR5EkoKDXZpZGVvX3F1YWxpdHkYASABKA4yJS5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5WaWRlb1F1YWxpdHlSDHZpZGVvUXVhbGl0eRIXCgd1c2VyX2lkGAIgASgJUgZ1c2VySWQ=');
@$core.Deprecated('Use videoDimensionDescriptor instead')
const VideoDimension$json = const {
  '1': 'VideoDimension',
  '2': const [
    const {'1': 'width', '3': 1, '4': 1, '5': 13, '10': 'width'},
    const {'1': 'height', '3': 2, '4': 1, '5': 13, '10': 'height'},
  ],
};

/// Descriptor for `VideoDimension`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoDimensionDescriptor = $convert.base64Decode('Cg5WaWRlb0RpbWVuc2lvbhIUCgV3aWR0aBgBIAEoDVIFd2lkdGgSFgoGaGVpZ2h0GAIgASgNUgZoZWlnaHQ=');
@$core.Deprecated('Use videoLayerDescriptor instead')
const VideoLayer$json = const {
  '1': 'VideoLayer',
  '2': const [
    const {'1': 'rid', '3': 1, '4': 1, '5': 9, '10': 'rid'},
    const {'1': 'video_dimension', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.VideoDimension', '10': 'videoDimension'},
    const {'1': 'bitrate', '3': 4, '4': 1, '5': 13, '10': 'bitrate'},
    const {'1': 'fps', '3': 5, '4': 1, '5': 13, '10': 'fps'},
    const {'1': 'quality', '3': 6, '4': 1, '5': 14, '6': '.stream.video.sfu.models.VideoQuality', '10': 'quality'},
  ],
};

/// Descriptor for `VideoLayer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoLayerDescriptor = $convert.base64Decode('CgpWaWRlb0xheWVyEhAKA3JpZBgBIAEoCVIDcmlkElAKD3ZpZGVvX2RpbWVuc2lvbhgCIAEoCzInLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlZpZGVvRGltZW5zaW9uUg52aWRlb0RpbWVuc2lvbhIYCgdiaXRyYXRlGAQgASgNUgdiaXRyYXRlEhAKA2ZwcxgFIAEoDVIDZnBzEj8KB3F1YWxpdHkYBiABKA4yJS5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5WaWRlb1F1YWxpdHlSB3F1YWxpdHk=');
@$core.Deprecated('Use codecDescriptor instead')
const Codec$json = const {
  '1': 'Codec',
  '2': const [
    const {'1': 'payload_type', '3': 1, '4': 1, '5': 13, '10': 'payloadType'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'fmtp_line', '3': 3, '4': 1, '5': 9, '10': 'fmtpLine'},
    const {'1': 'clock_rate', '3': 4, '4': 1, '5': 13, '10': 'clockRate'},
    const {'1': 'encoding_parameters', '3': 5, '4': 1, '5': 9, '10': 'encodingParameters'},
    const {'1': 'feedbacks', '3': 6, '4': 3, '5': 9, '10': 'feedbacks'},
  ],
};

/// Descriptor for `Codec`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List codecDescriptor = $convert.base64Decode('CgVDb2RlYxIhCgxwYXlsb2FkX3R5cGUYASABKA1SC3BheWxvYWRUeXBlEhIKBG5hbWUYAiABKAlSBG5hbWUSGwoJZm10cF9saW5lGAMgASgJUghmbXRwTGluZRIdCgpjbG9ja19yYXRlGAQgASgNUgljbG9ja1JhdGUSLwoTZW5jb2RpbmdfcGFyYW1ldGVycxgFIAEoCVISZW5jb2RpbmdQYXJhbWV0ZXJzEhwKCWZlZWRiYWNrcxgGIAMoCVIJZmVlZGJhY2tz');
@$core.Deprecated('Use iCETrickleDescriptor instead')
const ICETrickle$json = const {
  '1': 'ICETrickle',
  '2': const [
    const {'1': 'peer_type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.PeerType', '10': 'peerType'},
    const {'1': 'ice_candidate', '3': 2, '4': 1, '5': 9, '10': 'iceCandidate'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `ICETrickle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCETrickleDescriptor = $convert.base64Decode('CgpJQ0VUcmlja2xlEj4KCXBlZXJfdHlwZRgBIAEoDjIhLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlBlZXJUeXBlUghwZWVyVHlwZRIjCg1pY2VfY2FuZGlkYXRlGAIgASgJUgxpY2VDYW5kaWRhdGUSHQoKc2Vzc2lvbl9pZBgDIAEoCVIJc2Vzc2lvbklk');
@$core.Deprecated('Use trackInfoDescriptor instead')
const TrackInfo$json = const {
  '1': 'TrackInfo',
  '2': const [
    const {'1': 'track_id', '3': 1, '4': 1, '5': 9, '10': 'trackId'},
    const {'1': 'track_type', '3': 2, '4': 1, '5': 14, '6': '.stream.video.sfu.models.TrackType', '10': 'trackType'},
    const {'1': 'layers', '3': 5, '4': 3, '5': 11, '6': '.stream.video.sfu.models.VideoLayer', '10': 'layers'},
    const {'1': 'mid', '3': 6, '4': 1, '5': 9, '10': 'mid'},
    const {'1': 'dtx', '3': 7, '4': 1, '5': 8, '10': 'dtx'},
    const {'1': 'stereo', '3': 8, '4': 1, '5': 8, '10': 'stereo'},
    const {'1': 'red', '3': 9, '4': 1, '5': 8, '10': 'red'},
  ],
};

/// Descriptor for `TrackInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackInfoDescriptor = $convert.base64Decode('CglUcmFja0luZm8SGQoIdHJhY2tfaWQYASABKAlSB3RyYWNrSWQSQQoKdHJhY2tfdHlwZRgCIAEoDjIiLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlRyYWNrVHlwZVIJdHJhY2tUeXBlEjsKBmxheWVycxgFIAMoCzIjLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlZpZGVvTGF5ZXJSBmxheWVycxIQCgNtaWQYBiABKAlSA21pZBIQCgNkdHgYByABKAhSA2R0eBIWCgZzdGVyZW8YCCABKAhSBnN0ZXJlbxIQCgNyZWQYCSABKAhSA3JlZA==');
@$core.Deprecated('Use callDescriptor instead')
const Call$json = const {
  '1': 'Call',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'created_by_user_id', '3': 3, '4': 1, '5': 9, '10': 'createdByUserId'},
    const {'1': 'host_user_id', '3': 4, '4': 1, '5': 9, '10': 'hostUserId'},
    const {'1': 'custom', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'custom'},
    const {'1': 'created_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    const {'1': 'updated_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `Call`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callDescriptor = $convert.base64Decode('CgRDYWxsEhIKBHR5cGUYASABKAlSBHR5cGUSDgoCaWQYAiABKAlSAmlkEisKEmNyZWF0ZWRfYnlfdXNlcl9pZBgDIAEoCVIPY3JlYXRlZEJ5VXNlcklkEiAKDGhvc3RfdXNlcl9pZBgEIAEoCVIKaG9zdFVzZXJJZBIvCgZjdXN0b20YBSABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0UgZjdXN0b20SOQoKY3JlYXRlZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');
@$core.Deprecated('Use errorDescriptor instead')
const Error$json = const {
  '1': 'Error',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.ErrorCode', '10': 'code'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'should_retry', '3': 3, '4': 1, '5': 8, '10': 'shouldRetry'},
  ],
};

/// Descriptor for `Error`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptor = $convert.base64Decode('CgVFcnJvchI2CgRjb2RlGAEgASgOMiIuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuRXJyb3JDb2RlUgRjb2RlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2USIQoMc2hvdWxkX3JldHJ5GAMgASgIUgtzaG91bGRSZXRyeQ==');
@$core.Deprecated('Use clientDetailsDescriptor instead')
const ClientDetails$json = const {
  '1': 'ClientDetails',
  '2': const [
    const {'1': 'sdk', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Sdk', '10': 'sdk'},
    const {'1': 'os', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models.OS', '10': 'os'},
    const {'1': 'browser', '3': 3, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Browser', '10': 'browser'},
    const {'1': 'device', '3': 4, '4': 1, '5': 11, '6': '.stream.video.sfu.models.Device', '10': 'device'},
  ],
};

/// Descriptor for `ClientDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientDetailsDescriptor = $convert.base64Decode('Cg1DbGllbnREZXRhaWxzEi4KA3NkaxgBIAEoCzIcLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlNka1IDc2RrEisKAm9zGAIgASgLMhsuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuT1NSAm9zEjoKB2Jyb3dzZXIYAyABKAsyIC5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5Ccm93c2VyUgdicm93c2VyEjcKBmRldmljZRgEIAEoCzIfLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLkRldmljZVIGZGV2aWNl');
@$core.Deprecated('Use sdkDescriptor instead')
const Sdk$json = const {
  '1': 'Sdk',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models.SdkType', '10': 'type'},
    const {'1': 'major', '3': 2, '4': 1, '5': 9, '10': 'major'},
    const {'1': 'minor', '3': 3, '4': 1, '5': 9, '10': 'minor'},
    const {'1': 'patch', '3': 4, '4': 1, '5': 9, '10': 'patch'},
  ],
};

/// Descriptor for `Sdk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sdkDescriptor = $convert.base64Decode('CgNTZGsSNAoEdHlwZRgBIAEoDjIgLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlNka1R5cGVSBHR5cGUSFAoFbWFqb3IYAiABKAlSBW1ham9yEhQKBW1pbm9yGAMgASgJUgVtaW5vchIUCgVwYXRjaBgEIAEoCVIFcGF0Y2g=');
@$core.Deprecated('Use oSDescriptor instead')
const OS$json = const {
  '1': 'OS',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'architecture', '3': 3, '4': 1, '5': 9, '10': 'architecture'},
  ],
};

/// Descriptor for `OS`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oSDescriptor = $convert.base64Decode('CgJPUxISCgRuYW1lGAEgASgJUgRuYW1lEhgKB3ZlcnNpb24YAiABKAlSB3ZlcnNpb24SIgoMYXJjaGl0ZWN0dXJlGAMgASgJUgxhcmNoaXRlY3R1cmU=');
@$core.Deprecated('Use browserDescriptor instead')
const Browser$json = const {
  '1': 'Browser',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `Browser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List browserDescriptor = $convert.base64Decode('CgdCcm93c2VyEhIKBG5hbWUYASABKAlSBG5hbWUSGAoHdmVyc2lvbhgCIAEoCVIHdmVyc2lvbg==');
@$core.Deprecated('Use deviceDescriptor instead')
const Device$json = const {
  '1': 'Device',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `Device`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceDescriptor = $convert.base64Decode('CgZEZXZpY2USEgoEbmFtZRgBIAEoCVIEbmFtZRIYCgd2ZXJzaW9uGAIgASgJUgd2ZXJzaW9u');
@$core.Deprecated('Use callGrantsDescriptor instead')
const CallGrants$json = const {
  '1': 'CallGrants',
  '2': const [
    const {'1': 'can_publish_audio', '3': 1, '4': 1, '5': 8, '10': 'canPublishAudio'},
    const {'1': 'can_publish_video', '3': 2, '4': 1, '5': 8, '10': 'canPublishVideo'},
    const {'1': 'can_screenshare', '3': 3, '4': 1, '5': 8, '10': 'canScreenshare'},
  ],
};

/// Descriptor for `CallGrants`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callGrantsDescriptor = $convert.base64Decode('CgpDYWxsR3JhbnRzEioKEWNhbl9wdWJsaXNoX2F1ZGlvGAEgASgIUg9jYW5QdWJsaXNoQXVkaW8SKgoRY2FuX3B1Ymxpc2hfdmlkZW8YAiABKAhSD2NhblB1Ymxpc2hWaWRlbxInCg9jYW5fc2NyZWVuc2hhcmUYAyABKAhSDmNhblNjcmVlbnNoYXJl');
