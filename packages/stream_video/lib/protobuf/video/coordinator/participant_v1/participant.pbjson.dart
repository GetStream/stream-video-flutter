///
//  Generated code. Do not modify.
//  source: video/coordinator/participant_v1/participant.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use participantDescriptor instead')
const Participant$json = const {
  '1': 'Participant',
  '2': const [
    const {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.user_v1.User',
      '10': 'user'
    },
    const {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    const {'1': 'online', '3': 3, '4': 1, '5': 8, '10': 'online'},
    const {'1': 'custom_json', '3': 4, '4': 1, '5': 12, '10': 'customJson'},
    const {'1': 'video', '3': 5, '4': 1, '5': 8, '10': 'video'},
    const {'1': 'audio', '3': 6, '4': 1, '5': 8, '10': 'audio'},
    const {
      '1': 'created_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    const {
      '1': 'updated_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `Participant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantDescriptor = $convert.base64Decode(
    'CgtQYXJ0aWNpcGFudBI6CgR1c2VyGAEgASgLMiYuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnVzZXJfdjEuVXNlclIEdXNlchISCgRyb2xlGAIgASgJUgRyb2xlEhYKBm9ubGluZRgDIAEoCFIGb25saW5lEh8KC2N1c3RvbV9qc29uGAQgASgMUgpjdXN0b21Kc29uEhQKBXZpZGVvGAUgASgIUgV2aWRlbxIUCgVhdWRpbxgGIAEoCFIFYXVkaW8SOQoKY3JlYXRlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');
@$core.Deprecated('Use participantRequestDescriptor instead')
const ParticipantRequest$json = const {
  '1': 'ParticipantRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    const {'1': 'custom_json', '3': 3, '4': 1, '5': 12, '10': 'customJson'},
    const {
      '1': 'created_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    const {
      '1': 'updated_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `ParticipantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantRequestDescriptor = $convert.base64Decode(
    'ChJQYXJ0aWNpcGFudFJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhIKBHJvbGUYAiABKAlSBHJvbGUSHwoLY3VzdG9tX2pzb24YAyABKAxSCmN1c3RvbUpzb24SOQoKY3JlYXRlZF9hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');
