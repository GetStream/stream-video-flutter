///
//  Generated code. Do not modify.
//  source: video/coordinator/push_v1/push.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use pushProviderDescriptor instead')
const PushProvider$json = const {
  '1': 'PushProvider',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'disabled', '3': 2, '4': 1, '5': 8, '10': 'disabled'},
    const {
      '1': 'disabled_reason',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'disabledReason'
    },
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
    const {
      '1': 'apn',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.push_v1.ApnCredentials',
      '9': 0,
      '10': 'apn'
    },
    const {
      '1': 'firebase',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.push_v1.FirebaseCredentials',
      '9': 0,
      '10': 'firebase'
    },
    const {
      '1': 'huawei',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.push_v1.HuaweiCredentials',
      '9': 0,
      '10': 'huawei'
    },
    const {
      '1': 'xiaomi',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.push_v1.XiaomiCredentials',
      '9': 0,
      '10': 'xiaomi'
    },
  ],
  '8': const [
    const {'1': 'credentials'},
  ],
};

/// Descriptor for `PushProvider`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushProviderDescriptor = $convert.base64Decode(
    'CgxQdXNoUHJvdmlkZXISDgoCaWQYASABKAlSAmlkEhoKCGRpc2FibGVkGAIgASgIUghkaXNhYmxlZBInCg9kaXNhYmxlZF9yZWFzb24YAyABKAlSDmRpc2FibGVkUmVhc29uEjkKCmNyZWF0ZWRfYXQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdBJECgNhcG4YBiABKAsyMC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IucHVzaF92MS5BcG5DcmVkZW50aWFsc0gAUgNhcG4SUwoIZmlyZWJhc2UYByABKAsyNS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IucHVzaF92MS5GaXJlYmFzZUNyZWRlbnRpYWxzSABSCGZpcmViYXNlEk0KBmh1YXdlaRgIIAEoCzIzLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5wdXNoX3YxLkh1YXdlaUNyZWRlbnRpYWxzSABSBmh1YXdlaRJNCgZ4aWFvbWkYCSABKAsyMy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IucHVzaF92MS5YaWFvbWlDcmVkZW50aWFsc0gAUgZ4aWFvbWlCDQoLY3JlZGVudGlhbHM=');
@$core.Deprecated('Use apnCredentialsDescriptor instead')
const ApnCredentials$json = const {
  '1': 'ApnCredentials',
  '2': const [
    const {
      '1': 'certificate_p12',
      '3': 1,
      '4': 1,
      '5': 12,
      '10': 'certificateP12'
    },
    const {'1': 'topic', '3': 2, '4': 1, '5': 9, '10': 'topic'},
    const {'1': 'team_id', '3': 3, '4': 1, '5': 9, '10': 'teamId'},
  ],
};

/// Descriptor for `ApnCredentials`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List apnCredentialsDescriptor = $convert.base64Decode(
    'Cg5BcG5DcmVkZW50aWFscxInCg9jZXJ0aWZpY2F0ZV9wMTIYASABKAxSDmNlcnRpZmljYXRlUDEyEhQKBXRvcGljGAIgASgJUgV0b3BpYxIXCgd0ZWFtX2lkGAMgASgJUgZ0ZWFtSWQ=');
@$core.Deprecated('Use firebaseCredentialsDescriptor instead')
const FirebaseCredentials$json = const {
  '1': 'FirebaseCredentials',
  '2': const [
    const {'1': 'credentials', '3': 1, '4': 1, '5': 9, '10': 'credentials'},
  ],
};

/// Descriptor for `FirebaseCredentials`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List firebaseCredentialsDescriptor = $convert.base64Decode(
    'ChNGaXJlYmFzZUNyZWRlbnRpYWxzEiAKC2NyZWRlbnRpYWxzGAEgASgJUgtjcmVkZW50aWFscw==');
@$core.Deprecated('Use huaweiCredentialsDescriptor instead')
const HuaweiCredentials$json = const {
  '1': 'HuaweiCredentials',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'secret', '3': 2, '4': 1, '5': 9, '10': 'secret'},
  ],
};

/// Descriptor for `HuaweiCredentials`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List huaweiCredentialsDescriptor = $convert.base64Decode(
    'ChFIdWF3ZWlDcmVkZW50aWFscxIOCgJpZBgBIAEoCVICaWQSFgoGc2VjcmV0GAIgASgJUgZzZWNyZXQ=');
@$core.Deprecated('Use xiaomiCredentialsDescriptor instead')
const XiaomiCredentials$json = const {
  '1': 'XiaomiCredentials',
  '2': const [
    const {'1': 'package_name', '3': 1, '4': 1, '5': 9, '10': 'packageName'},
    const {'1': 'secret', '3': 2, '4': 1, '5': 9, '10': 'secret'},
  ],
};

/// Descriptor for `XiaomiCredentials`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List xiaomiCredentialsDescriptor = $convert.base64Decode(
    'ChFYaWFvbWlDcmVkZW50aWFscxIhCgxwYWNrYWdlX25hbWUYASABKAlSC3BhY2thZ2VOYW1lEhYKBnNlY3JldBgCIAEoCVIGc2VjcmV0');
@$core.Deprecated('Use deviceDescriptor instead')
const Device$json = const {
  '1': 'Device',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'disabled', '3': 3, '4': 1, '5': 8, '10': 'disabled'},
    const {
      '1': 'disabled_reason',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'disabledReason'
    },
    const {
      '1': 'push_provider_name',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'pushProviderName'
    },
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

/// Descriptor for `Device`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceDescriptor = $convert.base64Decode(
    'CgZEZXZpY2USFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEg4KAmlkGAIgASgJUgJpZBIaCghkaXNhYmxlZBgDIAEoCFIIZGlzYWJsZWQSJwoPZGlzYWJsZWRfcmVhc29uGAQgASgJUg5kaXNhYmxlZFJlYXNvbhIsChJwdXNoX3Byb3ZpZGVyX25hbWUYBSABKAlSEHB1c2hQcm92aWRlck5hbWUSOQoKY3JlYXRlZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');
@$core.Deprecated('Use deviceInputDescriptor instead')
const DeviceInput$json = const {
  '1': 'DeviceInput',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {
      '1': 'push_provider_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'pushProviderId'
    },
  ],
};

/// Descriptor for `DeviceInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceInputDescriptor = $convert.base64Decode(
    'CgtEZXZpY2VJbnB1dBIOCgJpZBgBIAEoCVICaWQSKAoQcHVzaF9wcm92aWRlcl9pZBgCIAEoCVIOcHVzaFByb3ZpZGVySWQ=');
