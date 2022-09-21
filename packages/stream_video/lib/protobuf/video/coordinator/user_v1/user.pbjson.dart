///
//  Generated code. Do not modify.
//  source: video/coordinator/user_v1/user.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use userDescriptor instead')
const User$json = const {
  '1': 'User',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'id'},
    const {'1': 'teams', '3': 2, '4': 3, '5': 9, '10': 'teams'},
    const {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
    const {'1': 'custom_json', '3': 4, '4': 1, '5': 12, '10': 'customJson'},
    const {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'image_url', '3': 6, '4': 1, '5': 9, '10': 'imageUrl'},
    const {'1': 'created_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    const {'1': 'updated_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode('CgRVc2VyEhcKAmlkGAEgASgJQgf6QgRyAhABUgJpZBIUCgV0ZWFtcxgCIAMoCVIFdGVhbXMSEgoEcm9sZRgDIAEoCVIEcm9sZRIfCgtjdXN0b21fanNvbhgEIAEoDFIKY3VzdG9tSnNvbhISCgRuYW1lGAUgASgJUgRuYW1lEhsKCWltYWdlX3VybBgGIAEoCVIIaW1hZ2VVcmwSOQoKY3JlYXRlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');
@$core.Deprecated('Use userInputDescriptor instead')
const UserInput$json = const {
  '1': 'UserInput',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    const {'1': 'teams', '3': 3, '4': 3, '5': 9, '10': 'teams'},
    const {'1': 'image_url', '3': 4, '4': 1, '5': 9, '10': 'imageUrl'},
    const {'1': 'custom_json', '3': 5, '4': 1, '5': 12, '10': 'customJson'},
  ],
};

/// Descriptor for `UserInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userInputDescriptor = $convert.base64Decode('CglVc2VySW5wdXQSEgoEbmFtZRgBIAEoCVIEbmFtZRISCgRyb2xlGAIgASgJUgRyb2xlEhQKBXRlYW1zGAMgAygJUgV0ZWFtcxIbCglpbWFnZV91cmwYBCABKAlSCGltYWdlVXJsEh8KC2N1c3RvbV9qc29uGAUgASgMUgpjdXN0b21Kc29u');
