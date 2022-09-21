///
//  Generated code. Do not modify.
//  source: video/coordinator/edge_v1/edge.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use latencyEndpointDescriptor instead')
const LatencyEndpoint$json = const {
  '1': 'LatencyEndpoint',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    const {'1': 'proximity', '3': 3, '4': 1, '5': 1, '10': 'proximity'},
    const {'1': 'latency', '3': 4, '4': 1, '5': 1, '10': 'latency'},
  ],
};

/// Descriptor for `LatencyEndpoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List latencyEndpointDescriptor = $convert.base64Decode('Cg9MYXRlbmN5RW5kcG9pbnQSDgoCaWQYASABKAlSAmlkEhAKA3VybBgCIAEoCVIDdXJsEhwKCXByb3hpbWl0eRgDIAEoAVIJcHJveGltaXR5EhgKB2xhdGVuY3kYBCABKAFSB2xhdGVuY3k=');
@$core.Deprecated('Use serverDescriptor instead')
const Server$json = const {
  '1': 'Server',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `Server`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverDescriptor = $convert.base64Decode('CgZTZXJ2ZXISDgoCaWQYASABKAlSAmlkEhAKA3VybBgCIAEoCVIDdXJs');
@$core.Deprecated('Use credentialsDescriptor instead')
const Credentials$json = const {
  '1': 'Credentials',
  '2': const [
    const {'1': 'server', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.edge_v1.Server', '8': const {}, '10': 'server'},
    const {'1': 'token', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'token'},
  ],
};

/// Descriptor for `Credentials`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List credentialsDescriptor = $convert.base64Decode('CgtDcmVkZW50aWFscxJKCgZzZXJ2ZXIYASABKAsyKC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuZWRnZV92MS5TZXJ2ZXJCCPpCBYoBAhABUgZzZXJ2ZXISHQoFdG9rZW4YAiABKAlCB/pCBHICEAFSBXRva2Vu');
@$core.Deprecated('Use latencyMeasurementClaimDescriptor instead')
const LatencyMeasurementClaim$json = const {
  '1': 'LatencyMeasurementClaim',
  '2': const [
    const {'1': 'endpoints', '3': 1, '4': 3, '5': 11, '6': '.stream.video.coordinator.edge_v1.LatencyEndpoint', '10': 'endpoints'},
  ],
};

/// Descriptor for `LatencyMeasurementClaim`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List latencyMeasurementClaimDescriptor = $convert.base64Decode('ChdMYXRlbmN5TWVhc3VyZW1lbnRDbGFpbRJPCgllbmRwb2ludHMYASADKAsyMS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuZWRnZV92MS5MYXRlbmN5RW5kcG9pbnRSCWVuZHBvaW50cw==');
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
