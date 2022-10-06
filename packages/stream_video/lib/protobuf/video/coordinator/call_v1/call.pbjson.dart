///
//  Generated code. Do not modify.
//  source: video/coordinator/call_v1/call.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use callTypeDescriptor instead')
const CallType$json = const {
  '1': 'CallType',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'options', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallOptions', '10': 'options'},
    const {'1': 'created_at', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    const {'1': 'updated_at', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `CallType`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callTypeDescriptor = $convert.base64Decode('CghDYWxsVHlwZRISCgRuYW1lGAEgASgJUgRuYW1lEkcKB29wdGlvbnMYAiABKAsyLS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5DYWxsT3B0aW9uc1IHb3B0aW9ucxI5CgpjcmVhdGVkX2F0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');
@$core.Deprecated('Use callDescriptor instead')
const Call$json = const {
  '1': 'Call',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'type'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'id'},
    const {'1': 'call_cid', '3': 3, '4': 1, '5': 9, '10': 'callCid'},
    const {'1': 'created_by_user_id', '3': 4, '4': 1, '5': 9, '8': const {}, '10': 'createdByUserId'},
    const {'1': 'custom_json', '3': 5, '4': 1, '5': 12, '10': 'customJson'},
    const {'1': 'options', '3': 6, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallOptions', '10': 'options'},
    const {'1': 'created_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    const {'1': 'updated_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `Call`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callDescriptor = $convert.base64Decode('CgRDYWxsEhsKBHR5cGUYASABKAlCB/pCBHICEAFSBHR5cGUSFwoCaWQYAiABKAlCB/pCBHICEAFSAmlkEhkKCGNhbGxfY2lkGAMgASgJUgdjYWxsQ2lkEjQKEmNyZWF0ZWRfYnlfdXNlcl9pZBgEIAEoCUIH+kIEcgIQAVIPY3JlYXRlZEJ5VXNlcklkEh8KC2N1c3RvbV9qc29uGAUgASgMUgpjdXN0b21Kc29uEkcKB29wdGlvbnMYBiABKAsyLS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5DYWxsT3B0aW9uc1IHb3B0aW9ucxI5CgpjcmVhdGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');
@$core.Deprecated('Use callDetailsDescriptor instead')
const CallDetails$json = const {
  '1': 'CallDetails',
  '2': const [
    const {'1': 'options', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallOptions', '10': 'options'},
    const {'1': 'member_user_ids', '3': 2, '4': 3, '5': 9, '10': 'memberUserIds'},
    const {'1': 'members', '3': 3, '4': 3, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails.MembersEntry', '10': 'members'},
  ],
  '3': const [CallDetails_MembersEntry$json],
};

@$core.Deprecated('Use callDetailsDescriptor instead')
const CallDetails_MembersEntry$json = const {
  '1': 'MembersEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.member_v1.Member', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `CallDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callDetailsDescriptor = $convert.base64Decode('CgtDYWxsRGV0YWlscxJHCgdvcHRpb25zGAEgASgLMi0uc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNhbGxfdjEuQ2FsbE9wdGlvbnNSB29wdGlvbnMSJgoPbWVtYmVyX3VzZXJfaWRzGAIgAygJUg1tZW1iZXJVc2VySWRzElQKB21lbWJlcnMYAyADKAsyOi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5DYWxsRGV0YWlscy5NZW1iZXJzRW50cnlSB21lbWJlcnMaZgoMTWVtYmVyc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EkAKBXZhbHVlGAIgASgLMiouc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLm1lbWJlcl92MS5NZW1iZXJSBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use callOptionsDescriptor instead')
const CallOptions$json = const {
  '1': 'CallOptions',
  '2': const [
    const {'1': 'recording', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.RecordingOptions', '10': 'recording'},
    const {'1': 'broadcasting', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.BroadcastingOptions', '10': 'broadcasting'},
  ],
};

/// Descriptor for `CallOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callOptionsDescriptor = $convert.base64Decode('CgtDYWxsT3B0aW9ucxJQCglyZWNvcmRpbmcYASABKAsyMi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5SZWNvcmRpbmdPcHRpb25zUglyZWNvcmRpbmcSWQoMYnJvYWRjYXN0aW5nGAIgASgLMjUuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNhbGxfdjEuQnJvYWRjYXN0aW5nT3B0aW9uc1IMYnJvYWRjYXN0aW5n');
@$core.Deprecated('Use recordingOptionsDescriptor instead')
const RecordingOptions$json = const {
  '1': 'RecordingOptions',
  '2': const [
    const {'1': 'enabled', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'enabled', '17': true},
  ],
  '8': const [
    const {'1': '_enabled'},
  ],
};

/// Descriptor for `RecordingOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordingOptionsDescriptor = $convert.base64Decode('ChBSZWNvcmRpbmdPcHRpb25zEh0KB2VuYWJsZWQYASABKAhIAFIHZW5hYmxlZIgBAUIKCghfZW5hYmxlZA==');
@$core.Deprecated('Use broadcastingOptionsDescriptor instead')
const BroadcastingOptions$json = const {
  '1': 'BroadcastingOptions',
  '2': const [
    const {'1': 'enabled', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'enabled', '17': true},
  ],
  '8': const [
    const {'1': '_enabled'},
  ],
};

/// Descriptor for `BroadcastingOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastingOptionsDescriptor = $convert.base64Decode('ChNCcm9hZGNhc3RpbmdPcHRpb25zEh0KB2VuYWJsZWQYASABKAhIAFIHZW5hYmxlZIgBAUIKCghfZW5hYmxlZA==');
