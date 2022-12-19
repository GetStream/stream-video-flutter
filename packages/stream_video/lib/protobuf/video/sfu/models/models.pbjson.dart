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
    const {'1': 'CONNECTION_QUALITY_BAD', '2': 1},
    const {'1': 'CONNECTION_QUALITY_POOR', '2': 2},
    const {'1': 'CONNECTION_QUALITY_GOOD', '2': 3},
  ],
};

/// Descriptor for `ConnectionQuality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List connectionQualityDescriptor = $convert.base64Decode('ChFDb25uZWN0aW9uUXVhbGl0eRIiCh5DT05ORUNUSU9OX1FVQUxJVFlfVU5TUEVDSUZJRUQQABIaChZDT05ORUNUSU9OX1FVQUxJVFlfQkFEEAESGwoXQ09OTkVDVElPTl9RVUFMSVRZX1BPT1IQAhIbChdDT05ORUNUSU9OX1FVQUxJVFlfR09PRBAD');
@$core.Deprecated('Use videoQualityDescriptor instead')
const VideoQuality$json = const {
  '1': 'VideoQuality',
  '2': const [
    const {'1': 'VIDEO_QUALITY_LOW', '2': 0},
    const {'1': 'VIDEO_QUALITY_MID', '2': 1},
    const {'1': 'VIDEO_QUALITY_HIGH', '2': 2},
    const {'1': 'VIDEO_QUALITY_OFF', '2': 3},
  ],
};

/// Descriptor for `VideoQuality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List videoQualityDescriptor = $convert.base64Decode('CgxWaWRlb1F1YWxpdHkSFQoRVklERU9fUVVBTElUWV9MT1cQABIVChFWSURFT19RVUFMSVRZX01JRBABEhYKElZJREVPX1FVQUxJVFlfSElHSBACEhUKEVZJREVPX1FVQUxJVFlfT0ZGEAM=');
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
    const {'1': 'ERROR_CODE_PARTICIPANT_NOT_FOUND', '2': 200},
    const {'1': 'ERROR_CODE_CALL_NOT_FOUND', '2': 300},
    const {'1': 'ERROR_CODE_INTERNAL_SERVER_ERROR', '2': 500},
  ],
};

/// Descriptor for `ErrorCode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List errorCodeDescriptor = $convert.base64Decode('CglFcnJvckNvZGUSGgoWRVJST1JfQ09ERV9VTlNQRUNJRklFRBAAEiYKIkVSUk9SX0NPREVfUFVCTElTSF9UUkFDS19OT1RfRk9VTkQQZBImCiJFUlJPUl9DT0RFX1BVQkxJU0hfVFJBQ0tTX01JU01BVENIEGUSKQolRVJST1JfQ09ERV9QVUJMSVNIX1RSQUNLX09VVF9PRl9PUkRFUhBmEjIKLkVSUk9SX0NPREVfUFVCTElTSF9UUkFDS19WSURFT19MQVlFUl9OT1RfRk9VTkQQZxIlCiBFUlJPUl9DT0RFX1BBUlRJQ0lQQU5UX05PVF9GT1VORBDIARIeChlFUlJPUl9DT0RFX0NBTExfTk9UX0ZPVU5EEKwCEiUKIEVSUk9SX0NPREVfSU5URVJOQUxfU0VSVkVSX0VSUk9SEPQD');
@$core.Deprecated('Use callStateDescriptor instead')
const CallState$json = const {
  '1': 'CallState',
  '2': const [
    const {'1': 'participants', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.models.Participant', '10': 'participants'},
  ],
};

/// Descriptor for `CallState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callStateDescriptor = $convert.base64Decode('CglDYWxsU3RhdGUSSAoMcGFydGljaXBhbnRzGAEgAygLMiQuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuUGFydGljaXBhbnRSDHBhcnRpY2lwYW50cw==');
@$core.Deprecated('Use participantDescriptor instead')
const Participant$json = const {
  '1': 'Participant',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'published_tracks', '3': 3, '4': 3, '5': 14, '6': '.stream.video.sfu.models.TrackType', '10': 'publishedTracks'},
    const {'1': 'joined_at', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'joinedAt'},
    const {'1': 'track_lookup_prefix', '3': 5, '4': 1, '5': 9, '10': 'trackLookupPrefix'},
  ],
};

/// Descriptor for `Participant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantDescriptor = $convert.base64Decode('CgtQYXJ0aWNpcGFudBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkEk0KEHB1Ymxpc2hlZF90cmFja3MYAyADKA4yIi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVscy5UcmFja1R5cGVSD3B1Ymxpc2hlZFRyYWNrcxI3Cglqb2luZWRfYXQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghqb2luZWRBdBIuChN0cmFja19sb29rdXBfcHJlZml4GAUgASgJUhF0cmFja0xvb2t1cFByZWZpeA==');
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
  ],
};

/// Descriptor for `TrackInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackInfoDescriptor = $convert.base64Decode('CglUcmFja0luZm8SGQoIdHJhY2tfaWQYASABKAlSB3RyYWNrSWQSQQoKdHJhY2tfdHlwZRgCIAEoDjIiLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlRyYWNrVHlwZVIJdHJhY2tUeXBlEjsKBmxheWVycxgFIAMoCzIjLnN0cmVhbS52aWRlby5zZnUubW9kZWxzLlZpZGVvTGF5ZXJSBmxheWVycxIQCgNtaWQYBiABKAlSA21pZA==');
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
  ],
};

/// Descriptor for `Error`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptor = $convert.base64Decode('CgVFcnJvchI2CgRjb2RlGAEgASgOMiIuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHMuRXJyb3JDb2RlUgRjb2RlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');
