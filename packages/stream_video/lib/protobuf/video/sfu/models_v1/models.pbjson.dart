///
//  Generated code. Do not modify.
//  source: video/sfu/models_v1/models.proto
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
    const {'1': 'CONNECTION_QUALITY_BAD_UNSPECIFIED', '2': 0},
    const {'1': 'CONNECTION_QUALITY_POOR', '2': 1},
    const {'1': 'CONNECTION_QUALITY_GOOD', '2': 2},
  ],
};

/// Descriptor for `ConnectionQuality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List connectionQualityDescriptor = $convert.base64Decode('ChFDb25uZWN0aW9uUXVhbGl0eRImCiJDT05ORUNUSU9OX1FVQUxJVFlfQkFEX1VOU1BFQ0lGSUVEEAASGwoXQ09OTkVDVElPTl9RVUFMSVRZX1BPT1IQARIbChdDT05ORUNUSU9OX1FVQUxJVFlfR09PRBAC');
@$core.Deprecated('Use videoQualityDescriptor instead')
const VideoQuality$json = const {
  '1': 'VideoQuality',
  '2': const [
    const {'1': 'VIDEO_QUALITY_LOW_UNSPECIFIED', '2': 0},
    const {'1': 'VIDEO_QUALITY_MID', '2': 1},
    const {'1': 'VIDEO_QUALITY_HIGH', '2': 2},
  ],
};

/// Descriptor for `VideoQuality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List videoQualityDescriptor = $convert.base64Decode('CgxWaWRlb1F1YWxpdHkSIQodVklERU9fUVVBTElUWV9MT1dfVU5TUEVDSUZJRUQQABIVChFWSURFT19RVUFMSVRZX01JRBABEhYKElZJREVPX1FVQUxJVFlfSElHSBAC');
@$core.Deprecated('Use callStateDescriptor instead')
const CallState$json = const {
  '1': 'CallState',
  '2': const [
    const {'1': 'participants', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.models_v1.Participant', '10': 'participants'},
  ],
};

/// Descriptor for `CallState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callStateDescriptor = $convert.base64Decode('CglDYWxsU3RhdGUSSwoMcGFydGljaXBhbnRzGAEgAygLMicuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHNfdjEuUGFydGljaXBhbnRSDHBhcnRpY2lwYW50cw==');
@$core.Deprecated('Use callDescriptor instead')
const Call$json = const {
  '1': 'Call',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'created_at', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
  ],
};

/// Descriptor for `Call`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callDescriptor = $convert.base64Decode('CgRDYWxsEg4KAmlkGAEgASgJUgJpZBI5CgpjcmVhdGVkX2F0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0');
@$core.Deprecated('Use participantDescriptor instead')
const Participant$json = const {
  '1': 'Participant',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'video', '3': 3, '4': 1, '5': 8, '10': 'video'},
    const {'1': 'audio', '3': 4, '4': 1, '5': 8, '10': 'audio'},
    const {'1': 'connected_at', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'connectedAt'},
  ],
};

/// Descriptor for `Participant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantDescriptor = $convert.base64Decode('CgtQYXJ0aWNpcGFudBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkEhQKBXZpZGVvGAMgASgIUgV2aWRlbxIUCgVhdWRpbxgEIAEoCFIFYXVkaW8SPQoMY29ubmVjdGVkX2F0GAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILY29ubmVjdGVkQXQ=');
@$core.Deprecated('Use streamQualityDescriptor instead')
const StreamQuality$json = const {
  '1': 'StreamQuality',
  '2': const [
    const {'1': 'video_quality', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.models_v1.VideoQuality', '10': 'videoQuality'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `StreamQuality`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamQualityDescriptor = $convert.base64Decode('Cg1TdHJlYW1RdWFsaXR5Ek0KDXZpZGVvX3F1YWxpdHkYASABKA4yKC5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVsc192MS5WaWRlb1F1YWxpdHlSDHZpZGVvUXVhbGl0eRIXCgd1c2VyX2lkGAIgASgJUgZ1c2VySWQ=');
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
    const {'1': 'video_dimension', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models_v1.VideoDimension', '10': 'videoDimension'},
    const {'1': 'bitrate', '3': 4, '4': 1, '5': 13, '10': 'bitrate'},
  ],
};

/// Descriptor for `VideoLayer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoLayerDescriptor = $convert.base64Decode('CgpWaWRlb0xheWVyEhAKA3JpZBgBIAEoCVIDcmlkElMKD3ZpZGVvX2RpbWVuc2lvbhgCIAEoCzIqLnN0cmVhbS52aWRlby5zZnUubW9kZWxzX3YxLlZpZGVvRGltZW5zaW9uUg52aWRlb0RpbWVuc2lvbhIYCgdiaXRyYXRlGAQgASgNUgdiaXRyYXRl');
@$core.Deprecated('Use simulcastCodecInfoDescriptor instead')
const SimulcastCodecInfo$json = const {
  '1': 'SimulcastCodecInfo',
  '2': const [
    const {'1': 'mime_type', '3': 1, '4': 1, '5': 9, '10': 'mimeType'},
    const {'1': 'mid', '3': 2, '4': 1, '5': 9, '10': 'mid'},
    const {'1': 'cid', '3': 3, '4': 1, '5': 9, '10': 'cid'},
    const {'1': 'layers', '3': 4, '4': 3, '5': 11, '6': '.stream.video.sfu.models_v1.VideoLayer', '10': 'layers'},
  ],
};

/// Descriptor for `SimulcastCodecInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List simulcastCodecInfoDescriptor = $convert.base64Decode('ChJTaW11bGNhc3RDb2RlY0luZm8SGwoJbWltZV90eXBlGAEgASgJUghtaW1lVHlwZRIQCgNtaWQYAiABKAlSA21pZBIQCgNjaWQYAyABKAlSA2NpZBI+CgZsYXllcnMYBCADKAsyJi5zdHJlYW0udmlkZW8uc2Z1Lm1vZGVsc192MS5WaWRlb0xheWVyUgZsYXllcnM=');
@$core.Deprecated('Use codecDescriptor instead')
const Codec$json = const {
  '1': 'Codec',
  '2': const [
    const {'1': 'mime', '3': 1, '4': 1, '5': 9, '10': 'mime'},
    const {'1': 'fmtp_line', '3': 2, '4': 1, '5': 9, '10': 'fmtpLine'},
    const {'1': 'clock_rate', '3': 3, '4': 1, '5': 13, '10': 'clockRate'},
    const {'1': 'hw_accelerated', '3': 4, '4': 1, '5': 8, '10': 'hwAccelerated'},
  ],
};

/// Descriptor for `Codec`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List codecDescriptor = $convert.base64Decode('CgVDb2RlYxISCgRtaW1lGAEgASgJUgRtaW1lEhsKCWZtdHBfbGluZRgCIAEoCVIIZm10cExpbmUSHQoKY2xvY2tfcmF0ZRgDIAEoDVIJY2xvY2tSYXRlEiUKDmh3X2FjY2VsZXJhdGVkGAQgASgIUg1od0FjY2VsZXJhdGVk');
@$core.Deprecated('Use audioCodecsDescriptor instead')
const AudioCodecs$json = const {
  '1': 'AudioCodecs',
  '2': const [
    const {'1': 'encodes', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.models_v1.Codec', '10': 'encodes'},
    const {'1': 'decodes', '3': 2, '4': 3, '5': 11, '6': '.stream.video.sfu.models_v1.Codec', '10': 'decodes'},
  ],
};

/// Descriptor for `AudioCodecs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioCodecsDescriptor = $convert.base64Decode('CgtBdWRpb0NvZGVjcxI7CgdlbmNvZGVzGAEgAygLMiEuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHNfdjEuQ29kZWNSB2VuY29kZXMSOwoHZGVjb2RlcxgCIAMoCzIhLnN0cmVhbS52aWRlby5zZnUubW9kZWxzX3YxLkNvZGVjUgdkZWNvZGVz');
@$core.Deprecated('Use videoCodecsDescriptor instead')
const VideoCodecs$json = const {
  '1': 'VideoCodecs',
  '2': const [
    const {'1': 'encodes', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.models_v1.Codec', '10': 'encodes'},
    const {'1': 'decodes', '3': 2, '4': 3, '5': 11, '6': '.stream.video.sfu.models_v1.Codec', '10': 'decodes'},
  ],
};

/// Descriptor for `VideoCodecs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoCodecsDescriptor = $convert.base64Decode('CgtWaWRlb0NvZGVjcxI7CgdlbmNvZGVzGAEgAygLMiEuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHNfdjEuQ29kZWNSB2VuY29kZXMSOwoHZGVjb2RlcxgCIAMoCzIhLnN0cmVhbS52aWRlby5zZnUubW9kZWxzX3YxLkNvZGVjUgdkZWNvZGVz');
@$core.Deprecated('Use codecSettingsDescriptor instead')
const CodecSettings$json = const {
  '1': 'CodecSettings',
  '2': const [
    const {'1': 'audio', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.models_v1.AudioCodecs', '10': 'audio'},
    const {'1': 'video', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.models_v1.VideoCodecs', '10': 'video'},
    const {'1': 'layers', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.models_v1.VideoLayer', '10': 'layers'},
  ],
};

/// Descriptor for `CodecSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List codecSettingsDescriptor = $convert.base64Decode('Cg1Db2RlY1NldHRpbmdzEj0KBWF1ZGlvGAEgASgLMicuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHNfdjEuQXVkaW9Db2RlY3NSBWF1ZGlvEj0KBXZpZGVvGAIgASgLMicuc3RyZWFtLnZpZGVvLnNmdS5tb2RlbHNfdjEuVmlkZW9Db2RlY3NSBXZpZGVvEj4KBmxheWVycxgDIAMoCzImLnN0cmVhbS52aWRlby5zZnUubW9kZWxzX3YxLlZpZGVvTGF5ZXJSBmxheWVycw==');
