///
//  Generated code. Do not modify.
//  source: video/coordinator/room_v1/room.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use roomTypeDescriptor instead')
const RoomType$json = const {
  '1': 'RoomType',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {
      '1': 'options',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.room_v1.RoomOptions',
      '10': 'options'
    },
    const {
      '1': 'created_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    const {
      '1': 'updated_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `RoomType`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomTypeDescriptor = $convert.base64Decode(
    'CghSb29tVHlwZRISCgRuYW1lGAEgASgJUgRuYW1lEkcKB29wdGlvbnMYAiABKAsyLS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3Iucm9vbV92MS5Sb29tT3B0aW9uc1IHb3B0aW9ucxI5CgpjcmVhdGVkX2F0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');
@$core.Deprecated('Use roomDescriptor instead')
const Room$json = const {
  '1': 'Room',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'type'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'id'},
    const {'1': 'room_rid', '3': 3, '4': 1, '5': 9, '10': 'roomRid'},
    const {
      '1': 'created_by_user_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '8': const {},
      '10': 'createdByUserId'
    },
    const {'1': 'custom_json', '3': 5, '4': 1, '5': 12, '10': 'customJson'},
    const {
      '1': 'created_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    const {
      '1': 'updated_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `Room`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomDescriptor = $convert.base64Decode(
    'CgRSb29tEhsKBHR5cGUYASABKAlCB/pCBHICEAFSBHR5cGUSFwoCaWQYAiABKAlCB/pCBHICEAFSAmlkEhkKCHJvb21fcmlkGAMgASgJUgdyb29tUmlkEjQKEmNyZWF0ZWRfYnlfdXNlcl9pZBgEIAEoCUIH+kIEcgIQAVIPY3JlYXRlZEJ5VXNlcklkEh8KC2N1c3RvbV9qc29uGAUgASgMUgpjdXN0b21Kc29uEjkKCmNyZWF0ZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');
@$core.Deprecated('Use roomOptionsDescriptor instead')
const RoomOptions$json = const {
  '1': 'RoomOptions',
  '2': const [
    const {
      '1': 'recording',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.room_v1.RecordingOptions',
      '10': 'recording'
    },
    const {
      '1': 'broadcasting',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.room_v1.BroadcastingOptions',
      '10': 'broadcasting'
    },
    const {
      '1': 'transcription',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.room_v1.TranscriptionOptions',
      '10': 'transcription'
    },
  ],
};

/// Descriptor for `RoomOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomOptionsDescriptor = $convert.base64Decode(
    'CgtSb29tT3B0aW9ucxJQCglyZWNvcmRpbmcYASABKAsyMi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3Iucm9vbV92MS5SZWNvcmRpbmdPcHRpb25zUglyZWNvcmRpbmcSWQoMYnJvYWRjYXN0aW5nGAIgASgLMjUuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnJvb21fdjEuQnJvYWRjYXN0aW5nT3B0aW9uc1IMYnJvYWRjYXN0aW5nElwKDXRyYW5zY3JpcHRpb24YAyABKAsyNi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3Iucm9vbV92MS5UcmFuc2NyaXB0aW9uT3B0aW9uc1INdHJhbnNjcmlwdGlvbg==');
@$core.Deprecated('Use recordingOptionsDescriptor instead')
const RecordingOptions$json = const {
  '1': 'RecordingOptions',
  '2': const [
    const {
      '1': 'enabled',
      '3': 1,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'enabled',
      '17': true
    },
  ],
  '8': const [
    const {'1': '_enabled'},
  ],
};

/// Descriptor for `RecordingOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordingOptionsDescriptor = $convert.base64Decode(
    'ChBSZWNvcmRpbmdPcHRpb25zEh0KB2VuYWJsZWQYASABKAhIAFIHZW5hYmxlZIgBAUIKCghfZW5hYmxlZA==');
@$core.Deprecated('Use broadcastingOptionsDescriptor instead')
const BroadcastingOptions$json = const {
  '1': 'BroadcastingOptions',
  '2': const [
    const {
      '1': 'enabled',
      '3': 1,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'enabled',
      '17': true
    },
  ],
  '8': const [
    const {'1': '_enabled'},
  ],
};

/// Descriptor for `BroadcastingOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastingOptionsDescriptor = $convert.base64Decode(
    'ChNCcm9hZGNhc3RpbmdPcHRpb25zEh0KB2VuYWJsZWQYASABKAhIAFIHZW5hYmxlZIgBAUIKCghfZW5hYmxlZA==');
@$core.Deprecated('Use transcriptionOptionsDescriptor instead')
const TranscriptionOptions$json = const {
  '1': 'TranscriptionOptions',
  '2': const [
    const {
      '1': 'enabled',
      '3': 1,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'enabled',
      '17': true
    },
  ],
  '8': const [
    const {'1': '_enabled'},
  ],
};

/// Descriptor for `TranscriptionOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transcriptionOptionsDescriptor = $convert.base64Decode(
    'ChRUcmFuc2NyaXB0aW9uT3B0aW9ucxIdCgdlbmFibGVkGAEgASgISABSB2VuYWJsZWSIAQFCCgoIX2VuYWJsZWQ=');
