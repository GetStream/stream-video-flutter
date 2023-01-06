///
//  Generated code. Do not modify.
//  source: video/coordinator/geofence_v1/geofence.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use geofenceTypeDescriptor instead')
const GeofenceType$json = const {
  '1': 'GeofenceType',
  '2': const [
    const {'1': 'GEOFENCE_TYPE_UNSPECIFIED', '2': 0},
    const {'1': 'GEOFENCE_TYPE_INCLUSION', '2': 1},
    const {'1': 'GEOFENCE_TYPE_EXCLUSION', '2': 2},
  ],
};

/// Descriptor for `GeofenceType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List geofenceTypeDescriptor = $convert.base64Decode('CgxHZW9mZW5jZVR5cGUSHQoZR0VPRkVOQ0VfVFlQRV9VTlNQRUNJRklFRBAAEhsKF0dFT0ZFTkNFX1RZUEVfSU5DTFVTSU9OEAESGwoXR0VPRkVOQ0VfVFlQRV9FWENMVVNJT04QAg==');
@$core.Deprecated('Use geofenceDescriptor instead')
const Geofence$json = const {
  '1': 'Geofence',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'name'},
    const {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.stream.video.coordinator.geofence_v1.GeofenceType', '10': 'type'},
    const {'1': 'country_codes', '3': 3, '4': 3, '5': 9, '10': 'countryCodes'},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `Geofence`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geofenceDescriptor = $convert.base64Decode('CghHZW9mZW5jZRIbCgRuYW1lGAEgASgJQgf6QgRyAhABUgRuYW1lEkYKBHR5cGUYAiABKA4yMi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuZ2VvZmVuY2VfdjEuR2VvZmVuY2VUeXBlUgR0eXBlEiMKDWNvdW50cnlfY29kZXMYAyADKAlSDGNvdW50cnlDb2RlcxIgCgtkZXNjcmlwdGlvbhgEIAEoCVILZGVzY3JpcHRpb24=');
