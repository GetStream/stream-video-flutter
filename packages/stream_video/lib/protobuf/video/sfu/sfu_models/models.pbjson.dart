///
//  Generated code. Do not modify.
//  source: video/sfu/sfu_models/models.proto
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
    const {'1': 'PUBLISHER', '2': 0},
    const {'1': 'SUBSCRIBER', '2': 1},
  ],
};

/// Descriptor for `PeerType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List peerTypeDescriptor = $convert.base64Decode('CghQZWVyVHlwZRINCglQVUJMSVNIRVIQABIOCgpTVUJTQ1JJQkVSEAE=');
@$core.Deprecated('Use connectionQualityDescriptor instead')
const ConnectionQuality$json = const {
  '1': 'ConnectionQuality',
  '2': const [
    const {'1': 'BAD', '2': 0},
    const {'1': 'POOR', '2': 1},
    const {'1': 'GOOD', '2': 2},
  ],
};

/// Descriptor for `ConnectionQuality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List connectionQualityDescriptor = $convert.base64Decode('ChFDb25uZWN0aW9uUXVhbGl0eRIHCgNCQUQQABIICgRQT09SEAESCAoER09PRBAC');
@$core.Deprecated('Use videoQualityDescriptor instead')
const VideoQuality$json = const {
  '1': 'VideoQuality',
  '2': const [
    const {'1': 'LOW', '2': 0},
    const {'1': 'MID', '2': 1},
    const {'1': 'HIGH', '2': 2},
  ],
};

/// Descriptor for `VideoQuality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List videoQualityDescriptor = $convert.base64Decode('CgxWaWRlb1F1YWxpdHkSBwoDTE9XEAASBwoDTUlEEAESCAoESElHSBAC');
@$core.Deprecated('Use callStateDescriptor instead')
const CallState$json = const {
  '1': 'CallState',
  '2': const [
    const {'1': 'participants', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.Participant', '10': 'participants'},
  ],
};

/// Descriptor for `CallState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callStateDescriptor = $convert.base64Decode('CglDYWxsU3RhdGUSQQoMcGFydGljaXBhbnRzGAEgAygLMh0uc3RyZWFtLnZpZGVvLnNmdS5QYXJ0aWNpcGFudFIMcGFydGljaXBhbnRz');
@$core.Deprecated('Use callDescriptor instead')
const Call$json = const {
  '1': 'Call',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'created_by_user_id', '3': 3, '4': 1, '5': 9, '10': 'createdByUserId'},
    const {'1': 'host_user_id', '3': 4, '4': 1, '5': 9, '10': 'hostUserId'},
    const {'1': 'custom', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'custom'},
    const {'1': 'created_at', '3': 6, '4': 1, '5': 9, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 7, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Call`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callDescriptor = $convert.base64Decode('CgRDYWxsEhIKBHR5cGUYASABKAlSBHR5cGUSDgoCaWQYAiABKAlSAmlkEisKEmNyZWF0ZWRfYnlfdXNlcl9pZBgDIAEoCVIPY3JlYXRlZEJ5VXNlcklkEiAKDGhvc3RfdXNlcl9pZBgEIAEoCVIKaG9zdFVzZXJJZBIvCgZjdXN0b20YBSABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0UgZjdXN0b20SHQoKY3JlYXRlZF9hdBgGIAEoCVIJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYByABKAlSCXVwZGF0ZWRBdA==');
@$core.Deprecated('Use participantDescriptor instead')
const Participant$json = const {
  '1': 'Participant',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.User', '10': 'user'},
    const {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    const {'1': 'online', '3': 3, '4': 1, '5': 8, '10': 'online'},
    const {'1': 'custom', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'custom'},
    const {'1': 'video', '3': 5, '4': 1, '5': 8, '10': 'video'},
    const {'1': 'audio', '3': 6, '4': 1, '5': 8, '10': 'audio'},
    const {'1': 'created_at', '3': 7, '4': 1, '5': 9, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 8, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Participant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantDescriptor = $convert.base64Decode('CgtQYXJ0aWNpcGFudBIqCgR1c2VyGAEgASgLMhYuc3RyZWFtLnZpZGVvLnNmdS5Vc2VyUgR1c2VyEhIKBHJvbGUYAiABKAlSBHJvbGUSFgoGb25saW5lGAMgASgIUgZvbmxpbmUSLwoGY3VzdG9tGAQgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIGY3VzdG9tEhQKBXZpZGVvGAUgASgIUgV2aWRlbxIUCgVhdWRpbxgGIAEoCFIFYXVkaW8SHQoKY3JlYXRlZF9hdBgHIAEoCVIJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYCCABKAlSCXVwZGF0ZWRBdA==');
@$core.Deprecated('Use userDescriptor instead')
const User$json = const {
  '1': 'User',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'teams', '3': 2, '4': 3, '5': 9, '10': 'teams'},
    const {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
    const {'1': 'custom', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'custom'},
    const {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'image_url', '3': 6, '4': 1, '5': 9, '10': 'imageUrl'},
    const {'1': 'created_at', '3': 7, '4': 1, '5': 9, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 8, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode('CgRVc2VyEg4KAmlkGAEgASgJUgJpZBIUCgV0ZWFtcxgCIAMoCVIFdGVhbXMSEgoEcm9sZRgDIAEoCVIEcm9sZRIvCgZjdXN0b20YBCABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0UgZjdXN0b20SEgoEbmFtZRgFIAEoCVIEbmFtZRIbCglpbWFnZV91cmwYBiABKAlSCGltYWdlVXJsEh0KCmNyZWF0ZWRfYXQYByABKAlSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GAggASgJUgl1cGRhdGVkQXQ=');
@$core.Deprecated('Use streamQualityDescriptor instead')
const StreamQuality$json = const {
  '1': 'StreamQuality',
  '2': const [
    const {'1': 'video_quality', '3': 1, '4': 1, '5': 14, '6': '.stream.video.sfu.VideoQuality', '10': 'videoQuality'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `StreamQuality`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamQualityDescriptor = $convert.base64Decode('Cg1TdHJlYW1RdWFsaXR5EkMKDXZpZGVvX3F1YWxpdHkYASABKA4yHi5zdHJlYW0udmlkZW8uc2Z1LlZpZGVvUXVhbGl0eVIMdmlkZW9RdWFsaXR5EhcKB3VzZXJfaWQYAiABKAlSBnVzZXJJZA==');
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
    const {'1': 'video_dimension', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.VideoDimension', '10': 'videoDimension'},
    const {'1': 'bitrate', '3': 4, '4': 1, '5': 13, '10': 'bitrate'},
  ],
};

/// Descriptor for `VideoLayer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoLayerDescriptor = $convert.base64Decode('CgpWaWRlb0xheWVyEhAKA3JpZBgBIAEoCVIDcmlkEkkKD3ZpZGVvX2RpbWVuc2lvbhgCIAEoCzIgLnN0cmVhbS52aWRlby5zZnUuVmlkZW9EaW1lbnNpb25SDnZpZGVvRGltZW5zaW9uEhgKB2JpdHJhdGUYBCABKA1SB2JpdHJhdGU=');
@$core.Deprecated('Use simulcastCodecInfoDescriptor instead')
const SimulcastCodecInfo$json = const {
  '1': 'SimulcastCodecInfo',
  '2': const [
    const {'1': 'mime_type', '3': 1, '4': 1, '5': 9, '10': 'mimeType'},
    const {'1': 'mid', '3': 2, '4': 1, '5': 9, '10': 'mid'},
    const {'1': 'cid', '3': 3, '4': 1, '5': 9, '10': 'cid'},
    const {'1': 'layers', '3': 4, '4': 3, '5': 11, '6': '.stream.video.sfu.VideoLayer', '10': 'layers'},
  ],
};

/// Descriptor for `SimulcastCodecInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List simulcastCodecInfoDescriptor = $convert.base64Decode('ChJTaW11bGNhc3RDb2RlY0luZm8SGwoJbWltZV90eXBlGAEgASgJUghtaW1lVHlwZRIQCgNtaWQYAiABKAlSA21pZBIQCgNjaWQYAyABKAlSA2NpZBI0CgZsYXllcnMYBCADKAsyHC5zdHJlYW0udmlkZW8uc2Z1LlZpZGVvTGF5ZXJSBmxheWVycw==');
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
    const {'1': 'encode', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.Codec', '10': 'encode'},
    const {'1': 'decode', '3': 2, '4': 3, '5': 11, '6': '.stream.video.sfu.Codec', '10': 'decode'},
  ],
};

/// Descriptor for `AudioCodecs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioCodecsDescriptor = $convert.base64Decode('CgtBdWRpb0NvZGVjcxIvCgZlbmNvZGUYASADKAsyFy5zdHJlYW0udmlkZW8uc2Z1LkNvZGVjUgZlbmNvZGUSLwoGZGVjb2RlGAIgAygLMhcuc3RyZWFtLnZpZGVvLnNmdS5Db2RlY1IGZGVjb2Rl');
@$core.Deprecated('Use videoCodecsDescriptor instead')
const VideoCodecs$json = const {
  '1': 'VideoCodecs',
  '2': const [
    const {'1': 'encode', '3': 1, '4': 3, '5': 11, '6': '.stream.video.sfu.Codec', '10': 'encode'},
    const {'1': 'decode', '3': 2, '4': 3, '5': 11, '6': '.stream.video.sfu.Codec', '10': 'decode'},
  ],
};

/// Descriptor for `VideoCodecs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoCodecsDescriptor = $convert.base64Decode('CgtWaWRlb0NvZGVjcxIvCgZlbmNvZGUYASADKAsyFy5zdHJlYW0udmlkZW8uc2Z1LkNvZGVjUgZlbmNvZGUSLwoGZGVjb2RlGAIgAygLMhcuc3RyZWFtLnZpZGVvLnNmdS5Db2RlY1IGZGVjb2Rl');
@$core.Deprecated('Use codecSettingsDescriptor instead')
const CodecSettings$json = const {
  '1': 'CodecSettings',
  '2': const [
    const {'1': 'audio', '3': 1, '4': 1, '5': 11, '6': '.stream.video.sfu.AudioCodecs', '10': 'audio'},
    const {'1': 'video', '3': 2, '4': 1, '5': 11, '6': '.stream.video.sfu.VideoCodecs', '10': 'video'},
    const {'1': 'layers', '3': 3, '4': 3, '5': 11, '6': '.stream.video.sfu.VideoLayer', '10': 'layers'},
  ],
};

/// Descriptor for `CodecSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List codecSettingsDescriptor = $convert.base64Decode('Cg1Db2RlY1NldHRpbmdzEjMKBWF1ZGlvGAEgASgLMh0uc3RyZWFtLnZpZGVvLnNmdS5BdWRpb0NvZGVjc1IFYXVkaW8SMwoFdmlkZW8YAiABKAsyHS5zdHJlYW0udmlkZW8uc2Z1LlZpZGVvQ29kZWNzUgV2aWRlbxI0CgZsYXllcnMYAyADKAsyHC5zdHJlYW0udmlkZW8uc2Z1LlZpZGVvTGF5ZXJSBmxheWVycw==');
