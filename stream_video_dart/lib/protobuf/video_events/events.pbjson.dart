///
//  Generated code. Do not modify.
//  source: video_events/events.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use callRingingDescriptor instead')
const CallRinging$json = const {
  '1': 'CallRinging',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `CallRinging`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callRingingDescriptor = $convert.base64Decode('CgtDYWxsUmluZ2luZxImCgRjYWxsGAEgASgLMhIuc3RyZWFtLnZpZGVvLkNhbGxSBGNhbGw=');
@$core.Deprecated('Use callCreatedDescriptor instead')
const CallCreated$json = const {
  '1': 'CallCreated',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `CallCreated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callCreatedDescriptor = $convert.base64Decode('CgtDYWxsQ3JlYXRlZBImCgRjYWxsGAEgASgLMhIuc3RyZWFtLnZpZGVvLkNhbGxSBGNhbGw=');
@$core.Deprecated('Use callUpdatedDescriptor instead')
const CallUpdated$json = const {
  '1': 'CallUpdated',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `CallUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callUpdatedDescriptor = $convert.base64Decode('CgtDYWxsVXBkYXRlZBImCgRjYWxsGAEgASgLMhIuc3RyZWFtLnZpZGVvLkNhbGxSBGNhbGw=');
@$core.Deprecated('Use callEndedDescriptor instead')
const CallEnded$json = const {
  '1': 'CallEnded',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `CallEnded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callEndedDescriptor = $convert.base64Decode('CglDYWxsRW5kZWQSJgoEY2FsbBgBIAEoCzISLnN0cmVhbS52aWRlby5DYWxsUgRjYWxs');
@$core.Deprecated('Use callDeletedDescriptor instead')
const CallDeleted$json = const {
  '1': 'CallDeleted',
  '2': const [
    const {'1': 'call', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Call', '10': 'call'},
  ],
};

/// Descriptor for `CallDeleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callDeletedDescriptor = $convert.base64Decode('CgtDYWxsRGVsZXRlZBImCgRjYWxsGAEgASgLMhIuc3RyZWFtLnZpZGVvLkNhbGxSBGNhbGw=');
@$core.Deprecated('Use userUpdatedDescriptor instead')
const UserUpdated$json = const {
  '1': 'UserUpdated',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.stream.video.User', '10': 'user'},
  ],
};

/// Descriptor for `UserUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userUpdatedDescriptor = $convert.base64Decode('CgtVc2VyVXBkYXRlZBImCgR1c2VyGAEgASgLMhIuc3RyZWFtLnZpZGVvLlVzZXJSBHVzZXI=');
@$core.Deprecated('Use participantInvitedDescriptor instead')
const ParticipantInvited$json = const {
  '1': 'ParticipantInvited',
  '2': const [
    const {'1': 'participant', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantInvited`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantInvitedDescriptor = $convert.base64Decode('ChJQYXJ0aWNpcGFudEludml0ZWQSOwoLcGFydGljaXBhbnQYASABKAsyGS5zdHJlYW0udmlkZW8uUGFydGljaXBhbnRSC3BhcnRpY2lwYW50');
@$core.Deprecated('Use participantUpdatedDescriptor instead')
const ParticipantUpdated$json = const {
  '1': 'ParticipantUpdated',
  '2': const [
    const {'1': 'participant', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantUpdatedDescriptor = $convert.base64Decode('ChJQYXJ0aWNpcGFudFVwZGF0ZWQSOwoLcGFydGljaXBhbnQYASABKAsyGS5zdHJlYW0udmlkZW8uUGFydGljaXBhbnRSC3BhcnRpY2lwYW50');
@$core.Deprecated('Use participantDeletedDescriptor instead')
const ParticipantDeleted$json = const {
  '1': 'ParticipantDeleted',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `ParticipantDeleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantDeletedDescriptor = $convert.base64Decode('ChJQYXJ0aWNpcGFudERlbGV0ZWQSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklk');
@$core.Deprecated('Use participantJoinedDescriptor instead')
const ParticipantJoined$json = const {
  '1': 'ParticipantJoined',
  '2': const [
    const {'1': 'participant', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantJoined`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantJoinedDescriptor = $convert.base64Decode('ChFQYXJ0aWNpcGFudEpvaW5lZBI7CgtwYXJ0aWNpcGFudBgBIAEoCzIZLnN0cmVhbS52aWRlby5QYXJ0aWNpcGFudFILcGFydGljaXBhbnQ=');
@$core.Deprecated('Use participantLeftDescriptor instead')
const ParticipantLeft$json = const {
  '1': 'ParticipantLeft',
  '2': const [
    const {'1': 'participant', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Participant', '10': 'participant'},
  ],
};

/// Descriptor for `ParticipantLeft`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantLeftDescriptor = $convert.base64Decode('Cg9QYXJ0aWNpcGFudExlZnQSOwoLcGFydGljaXBhbnQYASABKAsyGS5zdHJlYW0udmlkZW8uUGFydGljaXBhbnRSC3BhcnRpY2lwYW50');
@$core.Deprecated('Use broadcastStartedDescriptor instead')
const BroadcastStarted$json = const {
  '1': 'BroadcastStarted',
  '2': const [
    const {'1': 'broadcast', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Broadcast', '10': 'broadcast'},
  ],
};

/// Descriptor for `BroadcastStarted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastStartedDescriptor = $convert.base64Decode('ChBCcm9hZGNhc3RTdGFydGVkEjUKCWJyb2FkY2FzdBgBIAEoCzIXLnN0cmVhbS52aWRlby5Ccm9hZGNhc3RSCWJyb2FkY2FzdA==');
@$core.Deprecated('Use broadcastEndedDescriptor instead')
const BroadcastEnded$json = const {
  '1': 'BroadcastEnded',
  '2': const [
    const {'1': 'broadcast', '3': 1, '4': 1, '5': 11, '6': '.stream.video.Broadcast', '10': 'broadcast'},
  ],
};

/// Descriptor for `BroadcastEnded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List broadcastEndedDescriptor = $convert.base64Decode('Cg5Ccm9hZGNhc3RFbmRlZBI1Cglicm9hZGNhc3QYASABKAsyFy5zdHJlYW0udmlkZW8uQnJvYWRjYXN0Uglicm9hZGNhc3Q=');
