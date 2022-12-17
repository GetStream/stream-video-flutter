///
//  Generated code. Do not modify.
//  source: video/coordinator/broadcast_v1/broadcast.proto
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
final $typed_data.Uint8List codecDescriptor = $convert.base64Decode(
    'CgVDb2RlYxIaChZDT0RFQ19IMjY0X1VOU1BFQ0lGSUVEEAASDQoJQ09ERUNfVlA4EAESDQoJQ09ERUNfVlA5EAI=');
@$core.Deprecated('Use rTMPOptionsDescriptor instead')
const RTMPOptions$json = const {
  '1': 'RTMPOptions',
  '2': const [
    const {'1': 'urls', '3': 1, '4': 3, '5': 9, '10': 'urls'},
  ],
};

/// Descriptor for `RTMPOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rTMPOptionsDescriptor =
    $convert.base64Decode('CgtSVE1QT3B0aW9ucxISCgR1cmxzGAEgAygJUgR1cmxz');
@$core.Deprecated('Use broadcastDescriptor instead')
const Broadcast$json = const {
  '1': 'Broadcast',
  '2': const [
    const {
      '1': 'rtmp',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.stream.video.coordinator.broadcast_v1.RTMPOptions',
      '10': 'rtmp'
    },
    const {'1': 'hls_url', '3': 2, '4': 1, '5': 9, '10': 'hlsUrl'},
  ],
};

/// Descriptor for `Broadcast`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastDescriptor = $convert.base64Decode(
    'CglCcm9hZGNhc3QSRgoEcnRtcBgBIAEoCzIyLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5icm9hZGNhc3RfdjEuUlRNUE9wdGlvbnNSBHJ0bXASFwoHaGxzX3VybBgCIAEoCVIGaGxzVXJs');
