///
//  Generated code. Do not modify.
//  source: video_models/models.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use codecDescriptor instead')
const Codec$json = const {
  '1': 'Codec',
  '2': const [
    const {'1': 'CODEC_H264_UNSPECIFIED', '2': 0},
    const {'1': 'CODEC_VP8', '2': 1},
    const {'1': 'CODEC_VP9', '2': 2},
  ],
};

/// Descriptor for `Codec`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List codecDescriptor = $convert.base64Decode('CgVDb2RlYxIaChZDT0RFQ19IMjY0X1VOU1BFQ0lGSUVEEAASDQoJQ09ERUNfVlA4EAESDQoJQ09ERUNfVlA5EAI=');
@$core.Deprecated('Use recordingStorageDescriptor instead')
const RecordingStorage$json = const {
  '1': 'RecordingStorage',
  '2': const [
    const {'1': 'RECORDING_STORAGE_S3_UNSPECIFIED', '2': 0},
  ],
};

/// Descriptor for `RecordingStorage`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List recordingStorageDescriptor = $convert.base64Decode('ChBSZWNvcmRpbmdTdG9yYWdlEiQKIFJFQ09SRElOR19TVE9SQUdFX1MzX1VOU1BFQ0lGSUVEEAA=');
@$core.Deprecated('Use edgeDescriptor instead')
const Edge$json = const {
  '1': 'Edge',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'name'},
    const {'1': 'latency_url', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'latencyUrl'},
  ],
};

/// Descriptor for `Edge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List edgeDescriptor = $convert.base64Decode('CgRFZGdlEhsKBG5hbWUYASABKAlCB/pCBHICEAFSBG5hbWUSKAoLbGF0ZW5jeV91cmwYAiABKAlCB/pCBHICEAFSCmxhdGVuY3lVcmw=');
@$core.Deprecated('Use edgeServerDescriptor instead')
const EdgeServer$json = const {
  '1': 'EdgeServer',
  '2': const [
    const {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
  ],
  '3': const [EdgeServer_Coordinates$json],
};

@$core.Deprecated('Use edgeServerDescriptor instead')
const EdgeServer_Coordinates$json = const {
  '1': 'Coordinates',
  '2': const [
    const {'1': 'lat', '3': 1, '4': 1, '5': 2, '10': 'lat'},
    const {'1': 'long', '3': 2, '4': 1, '5': 2, '10': 'long'},
  ],
};

/// Descriptor for `EdgeServer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List edgeServerDescriptor = $convert.base64Decode('CgpFZGdlU2VydmVyEhAKA3VybBgBIAEoCVIDdXJsGjMKC0Nvb3JkaW5hdGVzEhAKA2xhdBgBIAEoAlIDbGF0EhIKBGxvbmcYAiABKAJSBGxvbmc=');
@$core.Deprecated('Use latencyDescriptor instead')
const Latency$json = const {
  '1': 'Latency',
  '2': const [
    const {'1': 'measurements_seconds', '3': 1, '4': 3, '5': 2, '10': 'measurementsSeconds'},
  ],
};

/// Descriptor for `Latency`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List latencyDescriptor = $convert.base64Decode('CgdMYXRlbmN5EjEKFG1lYXN1cmVtZW50c19zZWNvbmRzGAEgAygCUhNtZWFzdXJlbWVudHNTZWNvbmRz');
@$core.Deprecated('Use fileDescriptor instead')
const File$json = const {
  '1': 'File',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'composite', '3': 2, '4': 1, '5': 8, '10': 'composite'},
    const {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'url', '3': 4, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `File`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileDescriptor = $convert.base64Decode('CgRGaWxlEhIKBHR5cGUYASABKAlSBHR5cGUSHAoJY29tcG9zaXRlGAIgASgIUgljb21wb3NpdGUSFwoHdXNlcl9pZBgDIAEoCVIGdXNlcklkEhAKA3VybBgEIAEoCVIDdXJs');
@$core.Deprecated('Use recordBroadcastDescriptor instead')
const RecordBroadcast$json = const {
  '1': 'RecordBroadcast',
  '2': const [
    const {'1': 'composite', '3': 1, '4': 1, '5': 8, '10': 'composite'},
    const {'1': 'files', '3': 2, '4': 3, '5': 11, '6': '.stream.video.File', '10': 'files'},
  ],
};

/// Descriptor for `RecordBroadcast`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordBroadcastDescriptor = $convert.base64Decode('Cg9SZWNvcmRCcm9hZGNhc3QSHAoJY29tcG9zaXRlGAEgASgIUgljb21wb3NpdGUSKAoFZmlsZXMYAiADKAsyEi5zdHJlYW0udmlkZW8uRmlsZVIFZmlsZXM=');
@$core.Deprecated('Use userDescriptor instead')
const User$json = const {
  '1': 'User',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'id'},
    const {'1': 'teams', '3': 2, '4': 3, '5': 9, '10': 'teams'},
    const {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
    const {'1': 'custom', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'custom'},
    const {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'profile_image_url', '3': 6, '4': 1, '5': 9, '10': 'profileImageUrl'},
    const {'1': 'created_at', '3': 7, '4': 1, '5': 9, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 8, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode('CgRVc2VyEhcKAmlkGAEgASgJQgf6QgRyAhABUgJpZBIUCgV0ZWFtcxgCIAMoCVIFdGVhbXMSEgoEcm9sZRgDIAEoCVIEcm9sZRIvCgZjdXN0b20YBCABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0UgZjdXN0b20SEgoEbmFtZRgFIAEoCVIEbmFtZRIqChFwcm9maWxlX2ltYWdlX3VybBgGIAEoCVIPcHJvZmlsZUltYWdlVXJsEh0KCmNyZWF0ZWRfYXQYByABKAlSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GAggASgJUgl1cGRhdGVkQXQ=');
@$core.Deprecated('Use userRequestDescriptor instead')
const UserRequest$json = const {
  '1': 'UserRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'id'},
    const {'1': 'teams', '3': 2, '4': 3, '5': 9, '10': 'teams'},
    const {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
    const {'1': 'custom', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'custom'},
    const {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'profile_image_url', '3': 6, '4': 1, '5': 9, '10': 'profileImageUrl'},
  ],
};

/// Descriptor for `UserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userRequestDescriptor = $convert.base64Decode('CgtVc2VyUmVxdWVzdBIXCgJpZBgBIAEoCUIH+kIEcgIQAVICaWQSFAoFdGVhbXMYAiADKAlSBXRlYW1zEhIKBHJvbGUYAyABKAlSBHJvbGUSLwoGY3VzdG9tGAQgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIGY3VzdG9tEhIKBG5hbWUYBSABKAlSBG5hbWUSKgoRcHJvZmlsZV9pbWFnZV91cmwYBiABKAlSD3Byb2ZpbGVJbWFnZVVybA==');
@$core.Deprecated('Use deviceDescriptor instead')
const Device$json = const {
  '1': 'Device',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'disabled', '3': 3, '4': 1, '5': 8, '10': 'disabled'},
    const {'1': 'disabled_reason', '3': 4, '4': 1, '5': 9, '10': 'disabledReason'},
    const {'1': 'push_provider_name', '3': 5, '4': 1, '5': 9, '10': 'pushProviderName'},
    const {'1': 'created_at', '3': 6, '4': 1, '5': 9, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 7, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Device`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceDescriptor = $convert.base64Decode('CgZEZXZpY2USFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEg4KAmlkGAIgASgJUgJpZBIaCghkaXNhYmxlZBgDIAEoCFIIZGlzYWJsZWQSJwoPZGlzYWJsZWRfcmVhc29uGAQgASgJUg5kaXNhYmxlZFJlYXNvbhIsChJwdXNoX3Byb3ZpZGVyX25hbWUYBSABKAlSEHB1c2hQcm92aWRlck5hbWUSHQoKY3JlYXRlZF9hdBgGIAEoCVIJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYByABKAlSCXVwZGF0ZWRBdA==');
@$core.Deprecated('Use deviceRequestDescriptor instead')
const DeviceRequest$json = const {
  '1': 'DeviceRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'disabled', '3': 3, '4': 1, '5': 8, '10': 'disabled'},
    const {'1': 'disabled_reason', '3': 4, '4': 1, '5': 9, '10': 'disabledReason'},
    const {'1': 'push_provider_name', '3': 5, '4': 1, '5': 9, '10': 'pushProviderName'},
  ],
};

/// Descriptor for `DeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceRequestDescriptor = $convert.base64Decode('Cg1EZXZpY2VSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIOCgJpZBgCIAEoCVICaWQSGgoIZGlzYWJsZWQYAyABKAhSCGRpc2FibGVkEicKD2Rpc2FibGVkX3JlYXNvbhgEIAEoCVIOZGlzYWJsZWRSZWFzb24SLAoScHVzaF9wcm92aWRlcl9uYW1lGAUgASgJUhBwdXNoUHJvdmlkZXJOYW1l');
@$core.Deprecated('Use recordingStorageOptionsDescriptor instead')
const RecordingStorageOptions$json = const {
  '1': 'RecordingStorageOptions',
  '2': const [
    const {'1': 'storage', '3': 2, '4': 1, '5': 14, '6': '.stream.video.RecordingStorage', '10': 'storage'},
    const {'1': 'access_key', '3': 3, '4': 1, '5': 9, '10': 'accessKey'},
    const {'1': 'secret_key', '3': 4, '4': 1, '5': 9, '10': 'secretKey'},
    const {'1': 'bucket_name', '3': 5, '4': 1, '5': 9, '10': 'bucketName'},
    const {'1': 'region', '3': 6, '4': 1, '5': 9, '10': 'region'},
    const {'1': 'path', '3': 7, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `RecordingStorageOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordingStorageOptionsDescriptor = $convert.base64Decode('ChdSZWNvcmRpbmdTdG9yYWdlT3B0aW9ucxI4CgdzdG9yYWdlGAIgASgOMh4uc3RyZWFtLnZpZGVvLlJlY29yZGluZ1N0b3JhZ2VSB3N0b3JhZ2USHQoKYWNjZXNzX2tleRgDIAEoCVIJYWNjZXNzS2V5Eh0KCnNlY3JldF9rZXkYBCABKAlSCXNlY3JldEtleRIfCgtidWNrZXRfbmFtZRgFIAEoCVIKYnVja2V0TmFtZRIWCgZyZWdpb24YBiABKAlSBnJlZ2lvbhISCgRwYXRoGAcgASgJUgRwYXRo');
@$core.Deprecated('Use rTMPOptionsDescriptor instead')
const RTMPOptions$json = const {
  '1': 'RTMPOptions',
  '2': const [
    const {'1': 'urls', '3': 1, '4': 3, '5': 9, '10': 'urls'},
  ],
};

/// Descriptor for `RTMPOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rTMPOptionsDescriptor = $convert.base64Decode('CgtSVE1QT3B0aW9ucxISCgR1cmxzGAEgAygJUgR1cmxz');
@$core.Deprecated('Use broadcastDescriptor instead')
const Broadcast$json = const {
  '1': 'Broadcast',
  '2': const [
    const {'1': 'rtmp', '3': 1, '4': 1, '5': 11, '6': '.stream.video.RTMPOptions', '10': 'rtmp'},
    const {'1': 'hls_url', '3': 2, '4': 1, '5': 9, '10': 'hlsUrl'},
  ],
};

/// Descriptor for `Broadcast`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastDescriptor = $convert.base64Decode('CglCcm9hZGNhc3QSLQoEcnRtcBgBIAEoCzIZLnN0cmVhbS52aWRlby5SVE1QT3B0aW9uc1IEcnRtcBIXCgdobHNfdXJsGAIgASgJUgZobHNVcmw=');
@$core.Deprecated('Use transcribeOptionsDescriptor instead')
const TranscribeOptions$json = const {
  '1': 'TranscribeOptions',
};

/// Descriptor for `TranscribeOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transcribeOptionsDescriptor = $convert.base64Decode('ChFUcmFuc2NyaWJlT3B0aW9ucw==');
@$core.Deprecated('Use callTypeDescriptor instead')
const CallType$json = const {
  '1': 'CallType',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'security', '3': 2, '4': 1, '5': 11, '6': '.stream.video.Security', '10': 'security'},
    const {'1': 'recording', '3': 4, '4': 1, '5': 8, '10': 'recording'},
    const {'1': 'hls_broadcast', '3': 5, '4': 1, '5': 8, '10': 'hlsBroadcast'},
    const {'1': 'transcribe', '3': 6, '4': 1, '5': 8, '10': 'transcribe'},
    const {'1': 'transcribe_options', '3': 7, '4': 1, '5': 11, '6': '.stream.video.TranscribeOptions', '10': 'transcribeOptions'},
    const {'1': 'created_at', '3': 8, '4': 1, '5': 9, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 9, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `CallType`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callTypeDescriptor = $convert.base64Decode('CghDYWxsVHlwZRISCgRuYW1lGAEgASgJUgRuYW1lEjIKCHNlY3VyaXR5GAIgASgLMhYuc3RyZWFtLnZpZGVvLlNlY3VyaXR5UghzZWN1cml0eRIcCglyZWNvcmRpbmcYBCABKAhSCXJlY29yZGluZxIjCg1obHNfYnJvYWRjYXN0GAUgASgIUgxobHNCcm9hZGNhc3QSHgoKdHJhbnNjcmliZRgGIAEoCFIKdHJhbnNjcmliZRJOChJ0cmFuc2NyaWJlX29wdGlvbnMYByABKAsyHy5zdHJlYW0udmlkZW8uVHJhbnNjcmliZU9wdGlvbnNSEXRyYW5zY3JpYmVPcHRpb25zEh0KCmNyZWF0ZWRfYXQYCCABKAlSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GAkgASgJUgl1cGRhdGVkQXQ=');
@$core.Deprecated('Use securityDescriptor instead')
const Security$json = const {
  '1': 'Security',
  '2': const [
    const {'1': 'hide_profile_pictures', '3': 1, '4': 1, '5': 8, '10': 'hideProfilePictures'},
    const {'1': 'share_screen', '3': 2, '4': 1, '5': 14, '6': '.stream.video.Security.IsAllowed', '10': 'shareScreen'},
    const {'1': 'rename_user', '3': 3, '4': 1, '5': 8, '10': 'renameUser'},
    const {'1': 'unmute', '3': 4, '4': 1, '5': 14, '6': '.stream.video.Security.IsAllowed', '10': 'unmute'},
    const {'1': 'start_video', '3': 5, '4': 1, '5': 14, '6': '.stream.video.Security.IsAllowed', '10': 'startVideo'},
    const {'1': 'screen_share', '3': 6, '4': 1, '5': 14, '6': '.stream.video.Security.IsAllowed', '10': 'screenShare'},
    const {'1': 'record', '3': 7, '4': 1, '5': 14, '6': '.stream.video.Security.IsAllowed', '10': 'record'},
    const {'1': 'broadcast', '3': 8, '4': 1, '5': 14, '6': '.stream.video.Security.IsAllowed', '10': 'broadcast'},
  ],
  '4': const [Security_IsAllowed$json],
};

@$core.Deprecated('Use securityDescriptor instead')
const Security_IsAllowed$json = const {
  '1': 'IsAllowed',
  '2': const [
    const {'1': 'IS_ALLOWED_YES_UNSPECIFIED', '2': 0},
    const {'1': 'IS_ALLOWED_NO', '2': 1},
    const {'1': 'IS_ALLOWED_REQUEST', '2': 2},
  ],
};

/// Descriptor for `Security`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List securityDescriptor = $convert.base64Decode('CghTZWN1cml0eRIyChVoaWRlX3Byb2ZpbGVfcGljdHVyZXMYASABKAhSE2hpZGVQcm9maWxlUGljdHVyZXMSQwoMc2hhcmVfc2NyZWVuGAIgASgOMiAuc3RyZWFtLnZpZGVvLlNlY3VyaXR5LklzQWxsb3dlZFILc2hhcmVTY3JlZW4SHwoLcmVuYW1lX3VzZXIYAyABKAhSCnJlbmFtZVVzZXISOAoGdW5tdXRlGAQgASgOMiAuc3RyZWFtLnZpZGVvLlNlY3VyaXR5LklzQWxsb3dlZFIGdW5tdXRlEkEKC3N0YXJ0X3ZpZGVvGAUgASgOMiAuc3RyZWFtLnZpZGVvLlNlY3VyaXR5LklzQWxsb3dlZFIKc3RhcnRWaWRlbxJDCgxzY3JlZW5fc2hhcmUYBiABKA4yIC5zdHJlYW0udmlkZW8uU2VjdXJpdHkuSXNBbGxvd2VkUgtzY3JlZW5TaGFyZRI4CgZyZWNvcmQYByABKA4yIC5zdHJlYW0udmlkZW8uU2VjdXJpdHkuSXNBbGxvd2VkUgZyZWNvcmQSPgoJYnJvYWRjYXN0GAggASgOMiAuc3RyZWFtLnZpZGVvLlNlY3VyaXR5LklzQWxsb3dlZFIJYnJvYWRjYXN0IlYKCUlzQWxsb3dlZBIeChpJU19BTExPV0VEX1lFU19VTlNQRUNJRklFRBAAEhEKDUlTX0FMTE9XRURfTk8QARIWChJJU19BTExPV0VEX1JFUVVFU1QQAg==');
@$core.Deprecated('Use participantDescriptor instead')
const Participant$json = const {
  '1': 'Participant',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    const {'1': 'online', '3': 3, '4': 1, '5': 8, '10': 'online'},
    const {'1': 'custom', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'custom'},
    const {'1': 'video', '3': 5, '4': 1, '5': 8, '10': 'video'},
    const {'1': 'audio', '3': 6, '4': 1, '5': 8, '10': 'audio'},
    const {'1': 'created_at', '3': 7, '4': 1, '5': 9, '8': const {}, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 8, '4': 1, '5': 9, '8': const {}, '10': 'updatedAt'},
  ],
};

/// Descriptor for `Participant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantDescriptor = $convert.base64Decode('CgtQYXJ0aWNpcGFudBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSEgoEcm9sZRgCIAEoCVIEcm9sZRIWCgZvbmxpbmUYAyABKAhSBm9ubGluZRIvCgZjdXN0b20YBCABKAsyFy5nb29nbGUucHJvdG9idWYuU3RydWN0UgZjdXN0b20SFAoFdmlkZW8YBSABKAhSBXZpZGVvEhQKBWF1ZGlvGAYgASgIUgVhdWRpbxImCgpjcmVhdGVkX2F0GAcgASgJQgf6QgRyAhABUgljcmVhdGVkQXQSJgoKdXBkYXRlZF9hdBgIIAEoCUIH+kIEcgIQAVIJdXBkYXRlZEF0');
@$core.Deprecated('Use participantRequestDescriptor instead')
const ParticipantRequest$json = const {
  '1': 'ParticipantRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    const {'1': 'custom', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'custom'},
    const {'1': 'created_at', '3': 4, '4': 1, '5': 9, '8': const {}, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 5, '4': 1, '5': 9, '8': const {}, '10': 'updatedAt'},
  ],
};

/// Descriptor for `ParticipantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantRequestDescriptor = $convert.base64Decode('ChJQYXJ0aWNpcGFudFJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhIKBHJvbGUYAiABKAlSBHJvbGUSLwoGY3VzdG9tGAMgASgLMhcuZ29vZ2xlLnByb3RvYnVmLlN0cnVjdFIGY3VzdG9tEiYKCmNyZWF0ZWRfYXQYBCABKAlCB/pCBHICEAFSCWNyZWF0ZWRBdBImCgp1cGRhdGVkX2F0GAUgASgJQgf6QgRyAhABUgl1cGRhdGVkQXQ=');
@$core.Deprecated('Use callStateDescriptor instead')
const CallState$json = const {
  '1': 'CallState',
  '2': const [
    const {'1': 'participants', '3': 1, '4': 3, '5': 11, '6': '.stream.video.Participant', '10': 'participants'},
  ],
};

/// Descriptor for `CallState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callStateDescriptor = $convert.base64Decode('CglDYWxsU3RhdGUSPQoMcGFydGljaXBhbnRzGAEgAygLMhkuc3RyZWFtLnZpZGVvLlBhcnRpY2lwYW50UgxwYXJ0aWNpcGFudHM=');
@$core.Deprecated('Use callDescriptor instead')
const Call$json = const {
  '1': 'Call',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'type'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'id'},
    const {'1': 'created_by_user_id', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'createdByUserId'},
    const {'1': 'custom', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Struct', '10': 'custom'},
    const {'1': 'created_at', '3': 5, '4': 1, '5': 9, '8': const {}, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 6, '4': 1, '5': 9, '8': const {}, '10': 'updatedAt'},
    const {'1': 'recording', '3': 7, '4': 1, '5': 8, '10': 'recording'},
    const {'1': 'broadcast', '3': 8, '4': 1, '5': 11, '6': '.stream.video.Broadcast', '10': 'broadcast'},
    const {'1': 'transcribe', '3': 9, '4': 1, '5': 8, '10': 'transcribe'},
    const {'1': 'transcribe_options', '3': 10, '4': 1, '5': 11, '6': '.stream.video.TranscribeOptions', '10': 'transcribeOptions'},
  ],
};

/// Descriptor for `Call`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callDescriptor = $convert.base64Decode('CgRDYWxsEhsKBHR5cGUYASABKAlCB/pCBHICEAFSBHR5cGUSFwoCaWQYAiABKAlCB/pCBHICEAFSAmlkEjQKEmNyZWF0ZWRfYnlfdXNlcl9pZBgDIAEoCUIH+kIEcgIQAVIPY3JlYXRlZEJ5VXNlcklkEi8KBmN1c3RvbRgEIAEoCzIXLmdvb2dsZS5wcm90b2J1Zi5TdHJ1Y3RSBmN1c3RvbRImCgpjcmVhdGVkX2F0GAUgASgJQgf6QgRyAhABUgljcmVhdGVkQXQSJgoKdXBkYXRlZF9hdBgGIAEoCUIH+kIEcgIQAVIJdXBkYXRlZEF0EhwKCXJlY29yZGluZxgHIAEoCFIJcmVjb3JkaW5nEjUKCWJyb2FkY2FzdBgIIAEoCzIXLnN0cmVhbS52aWRlby5Ccm9hZGNhc3RSCWJyb2FkY2FzdBIeCgp0cmFuc2NyaWJlGAkgASgIUgp0cmFuc2NyaWJlEk4KEnRyYW5zY3JpYmVfb3B0aW9ucxgKIAEoCzIfLnN0cmVhbS52aWRlby5UcmFuc2NyaWJlT3B0aW9uc1IRdHJhbnNjcmliZU9wdGlvbnM=');
