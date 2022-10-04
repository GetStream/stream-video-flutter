///
//  Generated code. Do not modify.
//  source: video/coordinator/event_v1/event.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use recordingStartedDescriptor instead')
const RecordingStarted$json = const {
  '1': 'RecordingStarted',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
  ],
};

/// Descriptor for `RecordingStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordingStartedDescriptor = $convert.base64Decode('ChBSZWNvcmRpbmdTdGFydGVkEhkKCGNhbGxfY2lkGAEgASgJUgdjYWxsQ2lk');
@$core.Deprecated('Use recordingStoppedDescriptor instead')
const RecordingStopped$json = const {
  '1': 'RecordingStopped',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
  ],
};

/// Descriptor for `RecordingStopped`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordingStoppedDescriptor = $convert.base64Decode('ChBSZWNvcmRpbmdTdG9wcGVkEhkKCGNhbGxfY2lkGAEgASgJUgdjYWxsQ2lk');
@$core.Deprecated('Use userUpdatedDescriptor instead')
const UserUpdated$json = const {
  '1': 'UserUpdated',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `UserUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userUpdatedDescriptor = $convert.base64Decode('CgtVc2VyVXBkYXRlZBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQ=');
@$core.Deprecated('Use broadcastStartedDescriptor instead')
const BroadcastStarted$json = const {
  '1': 'BroadcastStarted',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
  ],
};

/// Descriptor for `BroadcastStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastStartedDescriptor = $convert.base64Decode('ChBCcm9hZGNhc3RTdGFydGVkEhkKCGNhbGxfY2lkGAEgASgJUgdjYWxsQ2lk');
@$core.Deprecated('Use broadcastEndedDescriptor instead')
const BroadcastEnded$json = const {
  '1': 'BroadcastEnded',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
  ],
};

/// Descriptor for `BroadcastEnded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastEndedDescriptor = $convert.base64Decode('Cg5Ccm9hZGNhc3RFbmRlZBIZCghjYWxsX2NpZBgBIAEoCVIHY2FsbENpZA==');
@$core.Deprecated('Use callMembersUpdatedDescriptor instead')
const CallMembersUpdated$json = const {
  '1': 'CallMembersUpdated',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
  ],
};

/// Descriptor for `CallMembersUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callMembersUpdatedDescriptor = $convert.base64Decode('ChJDYWxsTWVtYmVyc1VwZGF0ZWQSGQoIY2FsbF9jaWQYASABKAlSB2NhbGxDaWQ=');
@$core.Deprecated('Use callMembersDeletedDescriptor instead')
const CallMembersDeleted$json = const {
  '1': 'CallMembersDeleted',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
  ],
};

/// Descriptor for `CallMembersDeleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callMembersDeletedDescriptor = $convert.base64Decode('ChJDYWxsTWVtYmVyc0RlbGV0ZWQSGQoIY2FsbF9jaWQYASABKAlSB2NhbGxDaWQ=');
@$core.Deprecated('Use callCreatedDescriptor instead')
const CallCreated$json = const {
  '1': 'CallCreated',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
  ],
};

/// Descriptor for `CallCreated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callCreatedDescriptor = $convert.base64Decode('CgtDYWxsQ3JlYXRlZBIZCghjYWxsX2NpZBgBIAEoCVIHY2FsbENpZA==');
@$core.Deprecated('Use callUpdatedDescriptor instead')
const CallUpdated$json = const {
  '1': 'CallUpdated',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
  ],
};

/// Descriptor for `CallUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callUpdatedDescriptor = $convert.base64Decode('CgtDYWxsVXBkYXRlZBIZCghjYWxsX2NpZBgBIAEoCVIHY2FsbENpZA==');
@$core.Deprecated('Use callStartedDescriptor instead')
const CallStarted$json = const {
  '1': 'CallStarted',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
  ],
};

/// Descriptor for `CallStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callStartedDescriptor = $convert.base64Decode('CgtDYWxsU3RhcnRlZBIZCghjYWxsX2NpZBgBIAEoCVIHY2FsbENpZA==');
@$core.Deprecated('Use callEndedDescriptor instead')
const CallEnded$json = const {
  '1': 'CallEnded',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
  ],
};

/// Descriptor for `CallEnded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callEndedDescriptor = $convert.base64Decode('CglDYWxsRW5kZWQSGQoIY2FsbF9jaWQYASABKAlSB2NhbGxDaWQ=');
@$core.Deprecated('Use callDeletedDescriptor instead')
const CallDeleted$json = const {
  '1': 'CallDeleted',
  '2': const [
    const {'1': 'call_cid', '3': 1, '4': 1, '5': 9, '10': 'callCid'},
  ],
};

/// Descriptor for `CallDeleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callDeletedDescriptor = $convert.base64Decode('CgtDYWxsRGVsZXRlZBIZCghjYWxsX2NpZBgBIAEoCVIHY2FsbENpZA==');
