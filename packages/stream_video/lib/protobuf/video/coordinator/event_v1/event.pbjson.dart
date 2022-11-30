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
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
  ],
};

/// Descriptor for `RecordingStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordingStartedDescriptor = $convert.base64Decode('ChBSZWNvcmRpbmdTdGFydGVkEkQKBGNhbGwYASABKAsyJi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5DYWxsQgj6QgWKAQIQAVIEY2FsbBJaCgxjYWxsX2RldGFpbHMYAiABKAsyLS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5DYWxsRGV0YWlsc0II+kIFigECEAFSC2NhbGxEZXRhaWxz');
@$core.Deprecated('Use recordingStoppedDescriptor instead')
const RecordingStopped$json = const {
  '1': 'RecordingStopped',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
  ],
};

/// Descriptor for `RecordingStopped`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordingStoppedDescriptor = $convert.base64Decode('ChBSZWNvcmRpbmdTdG9wcGVkEkQKBGNhbGwYASABKAsyJi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5DYWxsQgj6QgWKAQIQAVIEY2FsbBJaCgxjYWxsX2RldGFpbHMYAiABKAsyLS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5DYWxsRGV0YWlsc0II+kIFigECEAFSC2NhbGxEZXRhaWxz');
@$core.Deprecated('Use userUpdatedDescriptor instead')
const UserUpdated$json = const {
  '1': 'UserUpdated',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'userId'},
  ],
};

/// Descriptor for `UserUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userUpdatedDescriptor = $convert.base64Decode('CgtVc2VyVXBkYXRlZBIgCgd1c2VyX2lkGAEgASgJQgf6QgRyAhABUgZ1c2VySWQ=');
@$core.Deprecated('Use broadcastStartedDescriptor instead')
const BroadcastStarted$json = const {
  '1': 'BroadcastStarted',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
  ],
};

/// Descriptor for `BroadcastStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastStartedDescriptor = $convert.base64Decode('ChBCcm9hZGNhc3RTdGFydGVkEkQKBGNhbGwYASABKAsyJi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5DYWxsQgj6QgWKAQIQAVIEY2FsbBJaCgxjYWxsX2RldGFpbHMYAiABKAsyLS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5DYWxsRGV0YWlsc0II+kIFigECEAFSC2NhbGxEZXRhaWxz');
@$core.Deprecated('Use broadcastEndedDescriptor instead')
const BroadcastEnded$json = const {
  '1': 'BroadcastEnded',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
  ],
};

/// Descriptor for `BroadcastEnded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastEndedDescriptor = $convert.base64Decode('Cg5Ccm9hZGNhc3RFbmRlZBJECgRjYWxsGAEgASgLMiYuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNhbGxfdjEuQ2FsbEII+kIFigECEAFSBGNhbGwSWgoMY2FsbF9kZXRhaWxzGAIgASgLMi0uc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNhbGxfdjEuQ2FsbERldGFpbHNCCPpCBYoBAhABUgtjYWxsRGV0YWlscw==');
@$core.Deprecated('Use callMembersCreatedDescriptor instead')
const CallMembersCreated$json = const {
  '1': 'CallMembersCreated',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
    const {'1': 'ringing', '3': 3, '4': 1, '5': 8, '10': 'ringing'},
  ],
};

/// Descriptor for `CallMembersCreated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callMembersCreatedDescriptor = $convert.base64Decode('ChJDYWxsTWVtYmVyc0NyZWF0ZWQSRAoEY2FsbBgBIAEoCzImLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxCCPpCBYoBAhABUgRjYWxsEloKDGNhbGxfZGV0YWlscxgCIAEoCzItLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxEZXRhaWxzQgj6QgWKAQIQAVILY2FsbERldGFpbHMSGAoHcmluZ2luZxgDIAEoCFIHcmluZ2luZw==');
@$core.Deprecated('Use callMembersUpdatedDescriptor instead')
const CallMembersUpdated$json = const {
  '1': 'CallMembersUpdated',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
  ],
};

/// Descriptor for `CallMembersUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callMembersUpdatedDescriptor = $convert.base64Decode('ChJDYWxsTWVtYmVyc1VwZGF0ZWQSRAoEY2FsbBgBIAEoCzImLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxCCPpCBYoBAhABUgRjYWxsEloKDGNhbGxfZGV0YWlscxgCIAEoCzItLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxEZXRhaWxzQgj6QgWKAQIQAVILY2FsbERldGFpbHM=');
@$core.Deprecated('Use callMembersDeletedDescriptor instead')
const CallMembersDeleted$json = const {
  '1': 'CallMembersDeleted',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
  ],
};

/// Descriptor for `CallMembersDeleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callMembersDeletedDescriptor = $convert.base64Decode('ChJDYWxsTWVtYmVyc0RlbGV0ZWQSRAoEY2FsbBgBIAEoCzImLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxCCPpCBYoBAhABUgRjYWxsEloKDGNhbGxfZGV0YWlscxgCIAEoCzItLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxEZXRhaWxzQgj6QgWKAQIQAVILY2FsbERldGFpbHM=');
@$core.Deprecated('Use callCreatedDescriptor instead')
const CallCreated$json = const {
  '1': 'CallCreated',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
    const {'1': 'ringing', '3': 3, '4': 1, '5': 8, '10': 'ringing'},
  ],
};

/// Descriptor for `CallCreated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callCreatedDescriptor = $convert.base64Decode('CgtDYWxsQ3JlYXRlZBJECgRjYWxsGAEgASgLMiYuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNhbGxfdjEuQ2FsbEII+kIFigECEAFSBGNhbGwSWgoMY2FsbF9kZXRhaWxzGAIgASgLMi0uc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNhbGxfdjEuQ2FsbERldGFpbHNCCPpCBYoBAhABUgtjYWxsRGV0YWlscxIYCgdyaW5naW5nGAMgASgIUgdyaW5naW5n');
@$core.Deprecated('Use callUpdatedDescriptor instead')
const CallUpdated$json = const {
  '1': 'CallUpdated',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
  ],
};

/// Descriptor for `CallUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callUpdatedDescriptor = $convert.base64Decode('CgtDYWxsVXBkYXRlZBJECgRjYWxsGAEgASgLMiYuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNhbGxfdjEuQ2FsbEII+kIFigECEAFSBGNhbGwSWgoMY2FsbF9kZXRhaWxzGAIgASgLMi0uc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNhbGxfdjEuQ2FsbERldGFpbHNCCPpCBYoBAhABUgtjYWxsRGV0YWlscw==');
@$core.Deprecated('Use callEndedDescriptor instead')
const CallEnded$json = const {
  '1': 'CallEnded',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
  ],
};

/// Descriptor for `CallEnded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callEndedDescriptor = $convert.base64Decode('CglDYWxsRW5kZWQSRAoEY2FsbBgBIAEoCzImLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxCCPpCBYoBAhABUgRjYWxsEloKDGNhbGxfZGV0YWlscxgCIAEoCzItLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxEZXRhaWxzQgj6QgWKAQIQAVILY2FsbERldGFpbHM=');
@$core.Deprecated('Use callDeletedDescriptor instead')
const CallDeleted$json = const {
  '1': 'CallDeleted',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
  ],
};

/// Descriptor for `CallDeleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callDeletedDescriptor = $convert.base64Decode('CgtDYWxsRGVsZXRlZBJECgRjYWxsGAEgASgLMiYuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNhbGxfdjEuQ2FsbEII+kIFigECEAFSBGNhbGwSWgoMY2FsbF9kZXRhaWxzGAIgASgLMi0uc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNhbGxfdjEuQ2FsbERldGFpbHNCCPpCBYoBAhABUgtjYWxsRGV0YWlscw==');
@$core.Deprecated('Use callAcceptedDescriptor instead')
const CallAccepted$json = const {
  '1': 'CallAccepted',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
    const {'1': 'sender_user_id', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'senderUserId'},
  ],
};

/// Descriptor for `CallAccepted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callAcceptedDescriptor = $convert.base64Decode('CgxDYWxsQWNjZXB0ZWQSRAoEY2FsbBgBIAEoCzImLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxCCPpCBYoBAhABUgRjYWxsEloKDGNhbGxfZGV0YWlscxgCIAEoCzItLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxEZXRhaWxzQgj6QgWKAQIQAVILY2FsbERldGFpbHMSLQoOc2VuZGVyX3VzZXJfaWQYAyABKAlCB/pCBHICEAFSDHNlbmRlclVzZXJJZA==');
@$core.Deprecated('Use callRejectedDescriptor instead')
const CallRejected$json = const {
  '1': 'CallRejected',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
    const {'1': 'sender_user_id', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'senderUserId'},
  ],
};

/// Descriptor for `CallRejected`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callRejectedDescriptor = $convert.base64Decode('CgxDYWxsUmVqZWN0ZWQSRAoEY2FsbBgBIAEoCzImLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxCCPpCBYoBAhABUgRjYWxsEloKDGNhbGxfZGV0YWlscxgCIAEoCzItLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jYWxsX3YxLkNhbGxEZXRhaWxzQgj6QgWKAQIQAVILY2FsbERldGFpbHMSLQoOc2VuZGVyX3VzZXJfaWQYAyABKAlCB/pCBHICEAFSDHNlbmRlclVzZXJJZA==');
@$core.Deprecated('Use callCancelledDescriptor instead')
const CallCancelled$json = const {
  '1': 'CallCancelled',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
    const {'1': 'sender_user_id', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'senderUserId'},
  ],
};

/// Descriptor for `CallCancelled`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callCancelledDescriptor = $convert.base64Decode('Cg1DYWxsQ2FuY2VsbGVkEkQKBGNhbGwYASABKAsyJi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5DYWxsQgj6QgWKAQIQAVIEY2FsbBJaCgxjYWxsX2RldGFpbHMYAiABKAsyLS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5DYWxsRGV0YWlsc0II+kIFigECEAFSC2NhbGxEZXRhaWxzEi0KDnNlbmRlcl91c2VyX2lkGAMgASgJQgf6QgRyAhABUgxzZW5kZXJVc2VySWQ=');
@$core.Deprecated('Use callCustomDescriptor instead')
const CallCustom$json = const {
  '1': 'CallCustom',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.Call', '8': const {}, '10': 'call'},
    const {'1': 'call_details', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.call_v1.CallDetails', '8': const {}, '10': 'callDetails'},
    const {'1': 'sender_user_id', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'senderUserId'},
    const {'1': 'type', '3': 4, '4': 1, '5': 9, '8': const {}, '10': 'type'},
    const {'1': 'data_json', '3': 5, '4': 1, '5': 12, '10': 'dataJson'},
  ],
};

/// Descriptor for `CallCustom`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callCustomDescriptor = $convert.base64Decode('CgpDYWxsQ3VzdG9tEkQKBGNhbGwYASABKAsyJi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5DYWxsQgj6QgWKAQIQAVIEY2FsbBJaCgxjYWxsX2RldGFpbHMYAiABKAsyLS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2FsbF92MS5DYWxsRGV0YWlsc0II+kIFigECEAFSC2NhbGxEZXRhaWxzEi0KDnNlbmRlcl91c2VyX2lkGAMgASgJQgf6QgRyAhABUgxzZW5kZXJVc2VySWQSGwoEdHlwZRgEIAEoCUIH+kIEcgIQAVIEdHlwZRIbCglkYXRhX2pzb24YBSABKAxSCGRhdGFKc29u');
