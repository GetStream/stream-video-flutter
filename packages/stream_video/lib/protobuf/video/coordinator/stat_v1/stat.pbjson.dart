///
//  Generated code. Do not modify.
//  source: video/coordinator/stat_v1/stat.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use mediaTypeDescriptor instead')
const MediaType$json = const {
  '1': 'MediaType',
  '2': const [
    const {'1': 'MEDIA_TYPE_UNSPECIFIED', '2': 0},
    const {'1': 'MEDIA_TYPE_AUDIO', '2': 1},
    const {'1': 'MEDIA_TYPE_VIDEO', '2': 2},
  ],
};

/// Descriptor for `MediaType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mediaTypeDescriptor = $convert.base64Decode('CglNZWRpYVR5cGUSGgoWTUVESUFfVFlQRV9VTlNQRUNJRklFRBAAEhQKEE1FRElBX1RZUEVfQVVESU8QARIUChBNRURJQV9UWVBFX1ZJREVPEAI=');
@$core.Deprecated('Use participantConnectedDescriptor instead')
const ParticipantConnected$json = const {
  '1': 'ParticipantConnected',
};

/// Descriptor for `ParticipantConnected`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantConnectedDescriptor = $convert.base64Decode('ChRQYXJ0aWNpcGFudENvbm5lY3RlZA==');
@$core.Deprecated('Use participantDisconnectedDescriptor instead')
const ParticipantDisconnected$json = const {
  '1': 'ParticipantDisconnected',
};

/// Descriptor for `ParticipantDisconnected`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List participantDisconnectedDescriptor = $convert.base64Decode('ChdQYXJ0aWNpcGFudERpc2Nvbm5lY3RlZA==');
@$core.Deprecated('Use muteStateChangedDescriptor instead')
const MuteStateChanged$json = const {
  '1': 'MuteStateChanged',
  '2': const [
    const {'1': 'media_type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.coordinator.stat_v1.MediaType', '10': 'mediaType'},
    const {'1': 'muted', '3': 2, '4': 1, '5': 8, '10': 'muted'},
  ],
};

/// Descriptor for `MuteStateChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List muteStateChangedDescriptor = $convert.base64Decode('ChBNdXRlU3RhdGVDaGFuZ2VkEkoKCm1lZGlhX3R5cGUYASABKA4yKy5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3Iuc3RhdF92MS5NZWRpYVR5cGVSCW1lZGlhVHlwZRIUCgVtdXRlZBgCIAEoCFIFbXV0ZWQ=');
@$core.Deprecated('Use freezeDescriptor instead')
const Freeze$json = const {
  '1': 'Freeze',
  '2': const [
    const {'1': 'media_type', '3': 1, '4': 1, '5': 14, '6': '.stream.video.coordinator.stat_v1.MediaType', '10': 'mediaType'},
    const {'1': 'peer_id', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'peerId'},
    const {'1': 'duration', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '10': 'duration'},
  ],
};

/// Descriptor for `Freeze`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List freezeDescriptor = $convert.base64Decode('CgZGcmVlemUSSgoKbWVkaWFfdHlwZRgBIAEoDjIrLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5zdGF0X3YxLk1lZGlhVHlwZVIJbWVkaWFUeXBlEiAKB3BlZXJfaWQYAiABKAlCB/pCBHICEAFSBnBlZXJJZBI1CghkdXJhdGlvbhgDIAEoCzIZLmdvb2dsZS5wcm90b2J1Zi5EdXJhdGlvblIIZHVyYXRpb24=');
@$core.Deprecated('Use telemetryEventDescriptor instead')
const TelemetryEvent$json = const {
  '1': 'TelemetryEvent',
  '2': const [
    const {'1': 'timestamp', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    const {'1': 'participant_connected', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.stat_v1.ParticipantConnected', '9': 0, '10': 'participantConnected'},
    const {'1': 'participant_disconnected', '3': 3, '4': 1, '5': 11, '6': '.stream.video.coordinator.stat_v1.ParticipantDisconnected', '9': 0, '10': 'participantDisconnected'},
    const {'1': 'mute_state_changed', '3': 4, '4': 1, '5': 11, '6': '.stream.video.coordinator.stat_v1.MuteStateChanged', '9': 0, '10': 'muteStateChanged'},
    const {'1': 'freeze', '3': 5, '4': 1, '5': 11, '6': '.stream.video.coordinator.stat_v1.Freeze', '9': 0, '10': 'freeze'},
  ],
  '8': const [
    const {'1': 'event'},
  ],
};

/// Descriptor for `TelemetryEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List telemetryEventDescriptor = $convert.base64Decode('Cg5UZWxlbWV0cnlFdmVudBI4Cgl0aW1lc3RhbXAYASABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl0aW1lc3RhbXASbQoVcGFydGljaXBhbnRfY29ubmVjdGVkGAIgASgLMjYuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnN0YXRfdjEuUGFydGljaXBhbnRDb25uZWN0ZWRIAFIUcGFydGljaXBhbnRDb25uZWN0ZWQSdgoYcGFydGljaXBhbnRfZGlzY29ubmVjdGVkGAMgASgLMjkuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnN0YXRfdjEuUGFydGljaXBhbnREaXNjb25uZWN0ZWRIAFIXcGFydGljaXBhbnREaXNjb25uZWN0ZWQSYgoSbXV0ZV9zdGF0ZV9jaGFuZ2VkGAQgASgLMjIuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnN0YXRfdjEuTXV0ZVN0YXRlQ2hhbmdlZEgAUhBtdXRlU3RhdGVDaGFuZ2VkEkIKBmZyZWV6ZRgFIAEoCzIoLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5zdGF0X3YxLkZyZWV6ZUgAUgZmcmVlemVCBwoFZXZlbnQ=');
@$core.Deprecated('Use callParticipantTimelineDescriptor instead')
const CallParticipantTimeline$json = const {
  '1': 'CallParticipantTimeline',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'sessionId'},
    const {'1': 'events', '3': 3, '4': 3, '5': 11, '6': '.stream.video.coordinator.stat_v1.TelemetryEvent', '10': 'events'},
  ],
};

/// Descriptor for `CallParticipantTimeline`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callParticipantTimelineDescriptor = $convert.base64Decode('ChdDYWxsUGFydGljaXBhbnRUaW1lbGluZRIgCgd1c2VyX2lkGAEgASgJQgf6QgRyAhABUgZ1c2VySWQSJgoKc2Vzc2lvbl9pZBgCIAEoCUIH+kIEcgIQAVIJc2Vzc2lvbklkEkgKBmV2ZW50cxgDIAMoCzIwLnN0cmVhbS52aWRlby5jb29yZGluYXRvci5zdGF0X3YxLlRlbGVtZXRyeUV2ZW50UgZldmVudHM=');
