///
//  Generated code. Do not modify.
//  source: video/coordinator/edge_v1/edge.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use credentialsDescriptor instead')
const Credentials$json = const {
  '1': 'Credentials',
  '2': const [
    const {'1': 'server', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.edge_v1.EdgeServer', '8': const {}, '10': 'server'},
    const {'1': 'token', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'token'},
    const {'1': 'ice_servers', '3': 3, '4': 3, '5': 11, '6': '.stream.video.coordinator.edge_v1.ICEServer', '10': 'iceServers'},
  ],
};

/// Descriptor for `Credentials`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List credentialsDescriptor = $convert.base64Decode('CgtDcmVkZW50aWFscxJOCgZzZXJ2ZXIYASABKAsyLC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuZWRnZV92MS5FZGdlU2VydmVyQgj6QgWKAQIQAVIGc2VydmVyEh0KBXRva2VuGAIgASgJQgf6QgRyAhABUgV0b2tlbhJMCgtpY2Vfc2VydmVycxgDIAMoCzIrLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5lZGdlX3YxLklDRVNlcnZlclIKaWNlU2VydmVycw==');
@$core.Deprecated('Use latencyMeasurementsDescriptor instead')
const LatencyMeasurements$json = const {
  '1': 'LatencyMeasurements',
  '2': const [
    const {'1': 'measurements', '3': 1, '4': 3, '5': 11, '6': '.stream.video.coordinator.edge_v1.LatencyMeasurements.MeasurementsEntry', '10': 'measurements'},
  ],
  '3': const [LatencyMeasurements_MeasurementsEntry$json],
};

@$core.Deprecated('Use latencyMeasurementsDescriptor instead')
const LatencyMeasurements_MeasurementsEntry$json = const {
  '1': 'MeasurementsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.edge_v1.Latency', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `LatencyMeasurements`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List latencyMeasurementsDescriptor = $convert.base64Decode('ChNMYXRlbmN5TWVhc3VyZW1lbnRzEmsKDG1lYXN1cmVtZW50cxgBIAMoCzJHLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5lZGdlX3YxLkxhdGVuY3lNZWFzdXJlbWVudHMuTWVhc3VyZW1lbnRzRW50cnlSDG1lYXN1cmVtZW50cxpqChFNZWFzdXJlbWVudHNFbnRyeRIQCgNrZXkYASABKAlSA2tleRI/CgV2YWx1ZRgCIAEoCzIpLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5lZGdlX3YxLkxhdGVuY3lSBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use latencyDescriptor instead')
const Latency$json = const {
  '1': 'Latency',
  '2': const [
    const {'1': 'measurements_seconds', '3': 1, '4': 3, '5': 1, '10': 'measurementsSeconds'},
  ],
};

/// Descriptor for `Latency`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List latencyDescriptor = $convert.base64Decode('CgdMYXRlbmN5EjEKFG1lYXN1cmVtZW50c19zZWNvbmRzGAEgAygBUhNtZWFzdXJlbWVudHNTZWNvbmRz');
@$core.Deprecated('Use edgeDescriptor instead')
const Edge$json = const {
  '1': 'Edge',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'name'},
    const {'1': 'latency_url', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'latencyUrl'},
  ],
  '3': const [Edge_Coordinates$json],
};

@$core.Deprecated('Use edgeDescriptor instead')
const Edge_Coordinates$json = const {
  '1': 'Coordinates',
  '2': const [
    const {'1': 'lat', '3': 1, '4': 1, '5': 2, '10': 'lat'},
    const {'1': 'long', '3': 2, '4': 1, '5': 2, '10': 'long'},
  ],
};

/// Descriptor for `Edge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List edgeDescriptor = $convert.base64Decode('CgRFZGdlEhsKBG5hbWUYASABKAlCB/pCBHICEAFSBG5hbWUSKAoLbGF0ZW5jeV91cmwYAiABKAlCB/pCBHICEAFSCmxhdGVuY3lVcmwaMwoLQ29vcmRpbmF0ZXMSEAoDbGF0GAEgASgCUgNsYXQSEgoEbG9uZxgCIAEoAlIEbG9uZw==');
@$core.Deprecated('Use iCEServerDescriptor instead')
const ICEServer$json = const {
  '1': 'ICEServer',
  '2': const [
    const {'1': 'urls', '3': 1, '4': 3, '5': 9, '10': 'urls'},
    const {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'password', '3': 3, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `ICEServer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iCEServerDescriptor = $convert.base64Decode('CglJQ0VTZXJ2ZXISEgoEdXJscxgBIAMoCVIEdXJscxIaCgh1c2VybmFtZRgCIAEoCVIIdXNlcm5hbWUSGgoIcGFzc3dvcmQYAyABKAlSCHBhc3N3b3Jk');
@$core.Deprecated('Use edgeServerDescriptor instead')
const EdgeServer$json = const {
  '1': 'EdgeServer',
  '2': const [
    const {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    const {'1': 'edge_name', '3': 2, '4': 1, '5': 9, '10': 'edgeName'},
  ],
};

/// Descriptor for `EdgeServer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List edgeServerDescriptor = $convert.base64Decode('CgpFZGdlU2VydmVyEhAKA3VybBgBIAEoCVIDdXJsEhsKCWVkZ2VfbmFtZRgCIAEoCVIIZWRnZU5hbWU=');
