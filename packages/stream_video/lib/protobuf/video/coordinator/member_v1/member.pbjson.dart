///
//  Generated code. Do not modify.
//  source: video/coordinator/member_v1/member.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use memberDescriptor instead')
const Member$json = const {
  '1': 'Member',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'callCid'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'userId'},
    const {'1': 'role', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'role'},
    const {'1': 'custom_json', '3': 4, '4': 1, '5': 12, '10': 'customJson'},
    const {'1': 'created_at', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    const {'1': 'updated_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `Member`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memberDescriptor = $convert.base64Decode('CgZNZW1iZXISIgoIY2FsbF9jaWQYASABKAlCB/pCBHICEAFSB2NhbGxDaWQSIAoHdXNlcl9pZBgCIAEoCUIH+kIEcgIQAVIGdXNlcklkEhsKBHJvbGUYAyABKAlCB/pCBHICEAFSBHJvbGUSHwoLY3VzdG9tX2pzb24YBCABKAxSCmN1c3RvbUpzb24SOQoKY3JlYXRlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');
